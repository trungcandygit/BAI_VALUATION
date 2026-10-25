# 04_tables_figures.R: formatted exhibit tables (strings rounded here, once) and figures.
fmt <- function(x, d = 3) ifelse(is.na(x), "", gsub("-", "−", formatC(x, digits = d, format = "f")))
fmtp <- function(p) ifelse(is.na(p), "", ifelse(p < 0.001, "<0.001", formatC(p, digits = 3, format = "f")))
fmtn <- function(x) formatC(x, format = "d", big.mark = ",")
stars <- function(p) ifelse(is.na(p), "", ifelse(p < 0.01, "***", ifelse(p < 0.05, "**", ifelse(p < 0.10, "*", ""))))

strip_eps_date <- function(f) {   # remove the %%CreationDate comment so reruns are byte-identical
  x <- readLines(f, warn = FALSE); writeLines(x[!grepl("^%%CreationDate", x)], f)
}

# ---- Table 1: pre-coverage characteristics of treated firms vs. never-covered firm-years ----
t1_vars <- c(mtb_w = "Market-to-book ratio", mcap_m = "Market capitalization (USD million)",
             lev_w = "Book leverage", asset_m = "Total assets (USD million)", roa_w = "Return on assets")
pre_tr <- panel %>% filter(treated, year == G - 1)
nev    <- panel %>% filter(!treated)
prep <- function(d) d %>% mutate(mcap_m = mcap_w / 1e6, asset_m = asset_w / 1e6)
pre_tr <- prep(pre_tr); nev <- prep(nev)
t1 <- bind_rows(lapply(names(t1_vars), function(v) {
  a <- pre_tr[[v]]; b <- nev[[v]]
  data.frame(variable = t1_vars[[v]],
             tr_mean = mean(a, na.rm = TRUE), tr_median = median(a, na.rm = TRUE), tr_n = sum(!is.na(a)),
             nv_mean = mean(b, na.rm = TRUE), nv_median = median(b, na.rm = TRUE), nv_n = sum(!is.na(b)),
             norm_diff = (mean(a, na.rm = TRUE) - mean(b, na.rm = TRUE)) /
               sqrt((var(a, na.rm = TRUE) + var(b, na.rm = TRUE)) / 2))
}))
write_out(t1, "table1_raw.csv")
dig1 <- c(2, 1, 3, 1, 3)
t1_fmt <- data.frame(Variable = t1$variable,
  `Scored mean` = mapply(fmt, t1$tr_mean, dig1), `Scored median` = mapply(fmt, t1$tr_median, dig1),
  `Scored N` = fmtn(t1$tr_n),
  `Never-scored mean` = mapply(fmt, t1$nv_mean, dig1), `Never-scored median` = mapply(fmt, t1$nv_median, dig1),
  `Never-scored N` = fmtn(t1$nv_n), `Norm. diff.` = fmt(t1$norm_diff, 2), check.names = FALSE)
write.csv(t1_fmt, file.path(OUT, "table1_formatted.csv"), row.names = FALSE)

# ---- Table 2: main ATTs ----
pre <- read.csv(file.path(OUT, "pretrend_tests.csv"))
t2 <- main_tab %>% left_join(pre %>% select(outcome, pre_p = p), by = "outcome")
t2_fmt <- data.frame(Outcome = OUTCOMES[t2$outcome],
  ATT = fmt(t2$est), SE = fmt(t2$se),
  `95% CI` = paste0("[", fmt(t2$ci_lo), ", ", fmt(t2$ci_hi), "]"),
  `p-value` = fmtp(t2$p_holm), MDE = fmt(t2$mde80), `Pre-trend p` = fmtp(t2$pre_p),
  `Scored firms` = fmtn(t2$n_treated_firms), `Control firms` = fmtn(t2$n_control_firms), check.names = FALSE)
write.csv(t2_fmt, file.path(OUT, "table2_formatted.csv"), row.names = FALSE)

# ---- Table 3: robustness and heterogeneity (ATT_post, SE in parentheses) ----
rob <- read.csv(file.path(OUT, "robustness.csv")); tw <- read.csv(file.path(OUT, "twfe_static.csv"))
het <- read.csv(file.path(OUT, "heterogeneity_initial_score.csv"))
rv <- read.csv(file.path(OUT, "robustness_revision.csv"))
rv2 <- read.csv(file.path(OUT, "robustness_revision2.csv"))
cellv <- function(e, s, p) paste0(fmt(e), stars(p), " (", fmt(s), ")")
row_of <- function(label, d) {
  d <- d[match(names(OUTCOMES), d$outcome), ]
  as.data.frame(as.list(c(Specification = label, setNames(cellv(d$est, d$se, d$p), OUTCOMES))), check.names = FALSE)
}
t3 <- bind_rows(
  row_of("Baseline", main_tab),
  row_of("R1 Not-yet-scored in controls", rob[rob$spec == "R1_notyet", ]),
  row_of("R2 No covariates", rob[rob$spec == "R2_nocovars", ]),
  row_of("R3 No 2020–2021 cohorts", rob[rob$spec == "R3_dropcovid", ]),
  row_of("R4 Size-trimmed controls", rob[rob$spec == "R4_support", ]),
  row_of("R5 Placebo, 3 years early", rob[rob$spec == "R5_placebo", ]),
  row_of("R6 Two-way fixed effects", tw),
  row_of("R7 Pre-trend removed", rv[rv$spec == "R7_trendadj", ]),
  row_of("R8 Pre-coverage growth", rv[rv$spec == "R8_pregrowth", ]),
  row_of("R9 No Malaysia", rv[rv$spec == "R9_excludeMY", ]),
  row_of("R10 Dated 1 year later", rv2[rv2$spec == "R10_shift1", ]),
  row_of("R11 Cohorts to 2021", rv2[rv2$spec == "R11_balanced", ]),
  row_of("High initial score", het[het$group == "high_initial_score", ]),
  row_of("Low initial score", het[het$group == "low_initial_score", ]),
  row_of("High minus low", het[het$group == "difference_high_minus_low", ]))
write.csv(t3, file.path(OUT, "table3_formatted.csv"), row.names = FALSE)

# ---- Figure 1: event-study coefficients, four outcomes ----
ev <- read.csv(file.path(OUT, "event_study.csv")) %>% mutate(e = as.integer(term))
base <- expand.grid(outcome = names(OUTCOMES), e = -1L) %>% mutate(est = 0, ci_lo = 0, ci_hi = 0)
ev <- bind_rows(ev %>% select(outcome, e, est, ci_lo, ci_hi), base) %>%
  mutate(period = factor(ifelse(e < 0, "Before first score", "After first score"), levels = c("Before first score", "After first score")),
         panel = factor(OUTCOMES[outcome], levels = OUTCOMES))
p1 <- ggplot(ev, aes(x = e, y = est)) +
  geom_hline(yintercept = 0, linetype = "solid", linewidth = 0.3, colour = "grey40") +
  geom_vline(xintercept = -0.5, linetype = "dashed", linewidth = 0.3, colour = "grey40") +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi, linetype = period), width = 0.25, linewidth = 0.4) +
  geom_point(aes(shape = period), size = 2, fill = "white") +
  scale_shape_manual(values = c("Before first score" = 21, "After first score" = 16), name = NULL) +
  scale_linetype_manual(values = c("Before first score" = "dotted", "After first score" = "solid"), name = NULL) +
  scale_x_continuous(breaks = E_MIN:E_MAX, labels = function(x) sub("^-", "−", as.character(x))) +
  scale_y_continuous(labels = function(x) sub("^-", "−", as.character(x))) +
  facet_wrap(~ panel, ncol = 2, scales = "free_y") +
  labs(x = "Years relative to the first LSEG ESG score (base year = −1)",
       y = "Effect relative to base year (log points; leverage: ratio)") +
  theme_bw(base_size = 10, base_family = "sans") +
  theme(legend.position = "bottom", panel.grid.minor = element_blank(), strip.background = element_rect(fill = "grey92"))
ggsave(file.path(FIG, "Fig1.eps"), p1, width = 6.5, height = 5, device = cairo_ps); strip_eps_date(file.path(FIG, "Fig1.eps"))
ggsave(file.path(FIG, "Fig1.png"), p1, width = 6.5, height = 5, dpi = 600)

# ---- Supplemental Appendix figure: number of firms entering coverage by cohort ----
cs <- read.csv(file.path(OUT, "cohort_sizes.csv"))
pia <- ggplot(cs, aes(x = G, y = total)) + geom_col(fill = "grey60", colour = "black", width = 0.7) +
  scale_x_continuous(breaks = cs$G) +
  labs(x = "Year of first LSEG ESG score", y = "Number of non-financial firms") +
  theme_bw(base_size = 10) + theme(panel.grid.minor = element_blank())
ggsave(file.path(FIG, "FigIA1.eps"), pia, width = 6, height = 3.5, device = cairo_ps); strip_eps_date(file.path(FIG, "FigIA1.eps"))
ggsave(file.path(FIG, "FigIA1.png"), pia, width = 6, height = 3.5, dpi = 600)

# ---- Supplemental Appendix tables ----
lomo <- read.csv(file.path(OUT, "leave_one_market_out.csv"))
cn <- c(ID = "Indonesia", MY = "Malaysia", PH = "Philippines", SG = "Singapore", TH = "Thailand")
tia1 <- bind_rows(lapply(names(cn), function(cc) row_of(paste("Without", cn[[cc]]), lomo[lomo$excluded == cc, ])))
names(tia1)[1] <- "Sample"
write.csv(tia1, file.path(OUT, "tableIA1_formatted.csv"), row.names = FALSE)
csz <- read.csv(file.path(OUT, "cohort_sizes.csv"))
tia2 <- data.frame(`First score year` = csz$G, Indonesia = csz$ID, Malaysia = csz$MY, Philippines = csz$PH,
                   Singapore = csz$SG, Thailand = csz$TH, Total = csz$total, check.names = FALSE)
write.csv(tia2, file.path(OUT, "tableIA2_formatted.csv"), row.names = FALSE)

# Per-market estimates (Table IA3), sample sizes by outcome (Table IA4), relative-magnitude bounds (Table IA5)
pm <- read.csv(file.path(OUT, "per_market.csv"))
tia3 <- bind_rows(lapply(names(cn), function(cc) {
  r <- row_of(cn[[cc]], pm[pm$market == cc, ])
  r$`Scored firms` <- fmtn(pm$n_treated_firms[pm$market == cc & pm$outcome == "ln_mtb"]); r }))
names(tia3)[1] <- "Market"
write.csv(tia3, file.path(OUT, "tableIA3_formatted.csv"), row.names = FALSE)
ss <- bind_rows(lapply(names(OUTCOMES), function(y) {
  v <- panel[[y]]
  data.frame(Outcome = OUTCOMES[[y]],
             `Scored firm-years` = fmtn(sum(!is.na(v) & panel$treated)),
             `Scored firms` = fmtn(n_distinct(panel$firm_id[!is.na(v) & panel$treated])),
             `Never-scored firm-years` = fmtn(sum(!is.na(v) & !panel$treated)),
             `Never-scored firms` = fmtn(n_distinct(panel$firm_id[!is.na(v) & !panel$treated])),
             `Share missing` = fmt(mean(is.na(v)), 3), check.names = FALSE) }))
write.csv(ss, file.path(OUT, "tableIA4_formatted.csv"), row.names = FALSE)
rmb <- read.csv(file.path(OUT, "rm_bounds.csv"))
tia5 <- rmb %>% transmute(Outcome = OUTCOMES[outcome], `M-bar` = fmt(Mbar, 2), `Largest pre-period change` = fmt(dmax),
  `Bias bound` = fmt(bias_bound), `Robust 95% interval` = paste0("[", fmt(robust_lo), ", ", fmt(robust_hi), "]"))
names(tia5) <- c("Outcome", "M\u0304", "Max pre-period change", "Bias bound", "Robust 95% interval")
write.csv(tia5, file.path(OUT, "tableIA5_formatted.csv"), row.names = FALSE)

# Scored firms and control firms by event year for ln MTB (Table IA6)
fe <- read.csv(file.path(OUT, "firms_by_event_time.csv"))
tia6 <- data.frame(`Event year` = sub("^-", "−", as.character(fe$e)), `Scored firms` = fmtn(fe$scored_firms),
                   Cohorts = fmtn(fe$cohorts),
                   `Control firms (range)` = paste0(fmtn(fe$controls_min), "–", fmtn(fe$controls_max)),
                   check.names = FALSE)
write.csv(tia6, file.path(OUT, "tableIA6_formatted.csv"), row.names = FALSE)
