# 04b_round4_exhibits.R: exhibits for the round-4 exploratory analyses (03b_round4.R).
# Fig. 2 (main text): pre- and post-coverage paths by coverage wave. Table S7: alternative specifications, inference,
# and the purged initial-score split. Table S8: bridge from the static two-way fixed effects estimate. Fig. S2:
# MTB event-time paths under alternative covariate timing, support, and dating.

r4p <- read.csv(file.path(OUT, "r4_post.csv")); r4pre <- read.csv(file.path(OUT, "r4_pretrend_tests.csv"))
r4ev <- read.csv(file.path(OUT, "r4_event_profiles.csv")) %>% mutate(e = as.integer(term))
clb <- read.csv(file.path(OUT, "r4_cluster_bootstrap.csv")); clpre <- read.csv(file.path(OUT, "r4_cluster_pretrend.csv"))
h3r <- read.csv(file.path(OUT, "r4_h3_residual_score.csv")); br <- read.csv(file.path(OUT, "r4_twfe_bridge.csv"))
OUT2 <- c(ln_mtb = "ln(MTB)", ln_mcap = "ln(market cap)")

# ---- Fig. 2: event-time paths by coverage wave (ln MTB and ln market cap) ----
WAVE_LAB <- c(wave_MY_2021_22 = "Malaysia, first scored 2021–2022", wave_TH_SG_2019_20 = "Thailand and Singapore, 2019–2020",
              wave_other = "All other cohorts")
wv <- r4ev %>% filter(spec %in% names(WAVE_LAB)) %>% select(outcome, spec, e, est, ci_lo, ci_hi)
wv <- bind_rows(wv, expand.grid(outcome = names(OUT2), spec = names(WAVE_LAB), e = -1L, stringsAsFactors = FALSE) %>%
                  mutate(est = 0, ci_lo = 0, ci_hi = 0)) %>%
  mutate(wave = factor(WAVE_LAB[spec], levels = WAVE_LAB), panel = factor(OUT2[outcome], levels = OUT2))
pd <- position_dodge(width = 0.5)
p2 <- ggplot(wv, aes(x = e, y = est, group = wave)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey40") +
  geom_vline(xintercept = -0.5, linetype = "dashed", linewidth = 0.3, colour = "grey40") +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi, linetype = wave), width = 0.3, linewidth = 0.35, position = pd) +
  geom_point(aes(shape = wave), size = 1.8, fill = "white", position = pd) +
  scale_shape_manual(values = c(16, 21, 17), name = NULL) +
  scale_linetype_manual(values = c("solid", "dotted", "dashed"), name = NULL) +
  scale_x_continuous(breaks = E_MIN:E_MAX, labels = function(x) sub("^-", "−", as.character(x))) +
  scale_y_continuous(labels = function(x) sub("^-", "−", as.character(x))) +
  facet_wrap(~ panel, ncol = 1, scales = "free_y") +
  labs(x = "Years relative to the first LSEG ESG score (base year = −1)", y = "Effect relative to base year (log points)") +
  theme_bw(base_size = 10, base_family = "sans") +
  theme(legend.position = "bottom", legend.direction = "vertical", panel.grid.minor = element_blank(),
        strip.background = element_rect(fill = "grey92"))
ggsave(file.path(FIG, "Fig2.eps"), p2, width = 6.5, height = 6, device = cairo_ps); strip_eps_date(file.path(FIG, "Fig2.eps"))
ggsave(file.path(FIG, "Fig2.png"), p2, width = 6.5, height = 6, dpi = 600)

# ---- Fig. S2: ln MTB paths under alternative specifications ----
ALT_LAB <- c(baseline = "Baseline", no_covariates = "No covariates", size_at_g3 = "Size measured at g − 3",
             trim_top_p95 = "Scored firms within control size range")
R10_LAB <- c(R10_shift1 = "Dated one year later", R10_size_at_g1 = "Dated one year later, size at original g − 1")
alt <- r4ev %>% filter(outcome == "ln_mtb", spec %in% c(names(ALT_LAB), names(R10_LAB))) %>%
  select(spec, e, est, ci_lo, ci_hi)
alt <- bind_rows(alt, data.frame(spec = c(names(ALT_LAB), names(R10_LAB)), e = -1L, est = 0, ci_lo = 0, ci_hi = 0)) %>%
  mutate(group = ifelse(spec %in% names(ALT_LAB), "A. First scored fiscal year as event", "B. Event dated one year later"),
         label = factor(c(ALT_LAB, R10_LAB)[spec], levels = c(ALT_LAB, R10_LAB)))
ps2 <- ggplot(alt, aes(x = e, y = est, group = label)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey40") +
  geom_vline(xintercept = -0.5, linetype = "dashed", linewidth = 0.3, colour = "grey40") +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi, linetype = label), width = 0.3, linewidth = 0.35, position = pd) +
  geom_point(aes(shape = label), size = 1.8, fill = "white", position = pd) +
  scale_shape_manual(values = c(16, 21, 17, 24, 15, 22), name = NULL) +
  scale_linetype_manual(values = c("solid", "dotted", "dashed", "dotdash", "solid", "dotted"), name = NULL) +
  scale_x_continuous(breaks = E_MIN:E_MAX, labels = function(x) sub("^-", "−", as.character(x))) +
  scale_y_continuous(labels = function(x) sub("^-", "−", as.character(x))) +
  facet_wrap(~ group, ncol = 1) +
  labs(x = "Years relative to the event (base year = −1)", y = "Effect on ln(MTB) relative to base year (log points)") +
  theme_bw(base_size = 10, base_family = "sans") +
  theme(legend.position = "bottom", legend.direction = "vertical", panel.grid.minor = element_blank(),
        strip.background = element_rect(fill = "grey92"))
ggsave(file.path(FIG, "FigIA2.eps"), ps2, width = 6.5, height = 7, device = cairo_ps); strip_eps_date(file.path(FIG, "FigIA2.eps"))
ggsave(file.path(FIG, "FigIA2.png"), ps2, width = 6.5, height = 7, dpi = 600)

# ---- Table S7: alternative specifications (ln MTB and ln market cap) ----
cell7 <- function(d) paste0(fmt(d$est), stars(d$p), " (", fmt(d$se), ")")
row7 <- function(label, post, prep) {
  out <- data.frame(Specification = label)
  for (y in names(OUT2)) {
    a <- post[post$outcome == y, ]; b <- prep[prep$outcome == y, ]
    out[[OUT2[[y]]]] <- if (nrow(a)) cell7(a) else ""
    out[[paste(OUT2[[y]], "pre-trend p")]] <- if (nrow(b)) fmtp(b$p) else ""
  }
  out
}
S7 <- list(
  c("no_covariates", "No covariates"), c("size_at_g3", "Size measured at g − 3"), c("size_bins", "Size quintile indicators"),
  c("trim_top_p95", "Scored firms within control size range"), c("R10_shift1", "Dated one year later (R10)"),
  c("R10_size_at_g1", "R10, size at original g − 1"), c("R12_shift2", "Dated two years later"),
  c("wave_MY_2021_22", "Malaysia, first scored 2021–2022"), c("wave_TH_SG_2019_20", "Thailand and Singapore, 2019–2020"),
  c("wave_other", "All other cohorts"), c("cohorts_to_2019", "Cohorts first scored by 2019"),
  c("cohorts_from_2020", "Cohorts first scored from 2020"))
t7 <- bind_rows(
  row7("Baseline", r4p[r4p$spec == "baseline", ], r4pre[r4pre$spec == "baseline", ]),
  row7("Baseline, market-by-industry cluster bootstrap", clb[clb$spec == "baseline" & clb$term == "post", ],
       clpre[clpre$spec == "baseline", ]),
  row7("R10, market-by-industry cluster bootstrap", clb[clb$spec == "R10_shift1" & clb$term == "post", ],
       clpre[clpre$spec == "R10_shift1", ]),
  bind_rows(lapply(S7, function(s) row7(s[2], r4p[r4p$spec == s[1], ], r4pre[r4pre$spec == s[1], ]))),
  row7("High residual initial score", h3r[h3r$group == "high_residual_score", ], h3r[0, ]),
  row7("Low residual initial score", h3r[h3r$group == "low_residual_score", ], h3r[0, ]),
  row7("High minus low", h3r[h3r$group == "difference_high_minus_low", ], h3r[0, ]))
names(t7) <- c("Specification", "ln(MTB)", "Pre-trend p", "ln(market cap)", "Pre-trend p ")
write.csv(t7, file.path(OUT, "tableIA7_formatted.csv"), row.names = FALSE)

# ---- Table S8: bridge from the static TWFE estimate to the heterogeneity-robust estimate ----
STEP <- c(`1_twfe_all_years` = "Static TWFE, all firm-years (R6)",
          `2_twfe_never_controls_window` = "Static TWFE, never-scored controls, event years −5 to 3",
          `3_cs_no_covariates` = "Heterogeneity-robust, no covariates (R2)", `4_cs_baseline` = "Heterogeneity-robust baseline")
t8 <- bind_rows(lapply(names(STEP), function(s) {
  out <- data.frame(Estimator = STEP[[s]])
  for (y in names(OUT2)) { d <- br[br$outcome == y & br$step == s, ]; out[[OUT2[[y]]]] <- cell7(d) }
  out }))
write.csv(t8, file.path(OUT, "tableIA8_formatted.csv"), row.names = FALSE)
