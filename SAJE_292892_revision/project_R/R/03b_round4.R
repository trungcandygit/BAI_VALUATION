# 03b_round4.R: revision round 4 (exploratory; five-seat review after the desk rejection, notes/review_round2/,
# notes/AUDIT_LEDGER.md Iter 13). None of these analyses is in the pre-analysis plan. Outputs carry the prefix r4_.
# (a) Event-time profiles under alternative covariate timing and support, and by coverage wave.
# (b) Inference that resamples market-by-industry clusters instead of firms.
# (c) A bridge from the static two-way fixed effects estimate to the heterogeneity-robust estimate.
# (d) Initial-score heterogeneity with the score purged of size, country, and cohort.
# (e) Descriptive checks: missing MTB by group, never-scored Malaysian firms.

R4_OUT <- c("ln_mtb", "ln_mcap")

# Market-by-industry cluster bootstrap weights. A separate seed keeps the firm-level draws (WBOOT) unchanged.
firm_cl <- panel %>% arrange(firm_id, year) %>% group_by(firm_id) %>%
  summarise(cl = paste(first(country), first(industry_code)))
CL_ID <- match(firm_cl$cl[match(FIRMS, firm_cl$firm_id)], sort(unique(firm_cl$cl)))
NCL <- max(CL_ID)
set.seed(SEED + 4L)
WCL <- vapply(seq_len(B_BOOT), function(b) tabulate(sample.int(NCL, NCL, replace = TRUE), NCL)[CL_ID], integer(NF))

# Coverage waves (Table S2): Malaysian 2021-2022 cohorts; Thai and Singaporean 2019-2020 cohorts; all other cohorts.
tr_info <- panel %>% filter(treated) %>% distinct(firm_id, G, country)
WAVES <- list(
  wave_MY_2021_22   = tr_info$firm_id[tr_info$country == "MY" & tr_info$G %in% 2021:2022],
  wave_TH_SG_2019_20 = tr_info$firm_id[tr_info$country %in% c("TH", "SG") & tr_info$G %in% 2019:2020])
WAVES$wave_other <- setdiff(tr_info$firm_id, unlist(WAVES))
COHORT_SPLIT <- list(cohorts_to_2019 = tr_info$firm_id[tr_info$G <= 2019],
                     cohorts_from_2020 = tr_info$firm_id[tr_info$G >= 2020])

R4_SPECS <- c(
  list(
    baseline        = list(),
    no_covariates   = list(covars = FALSE),
    size_at_g3      = list(size_lag = 2),
    size_bins       = list(covars = "bins"),
    trim_top_p95    = list(trim_top = TRUE),
    R10_shift1      = list(shift_G = 1),
    R10_size_at_g1  = list(shift_G = 1, size_lag = 1),
    R12_shift2      = list(shift_G = 2)),
  lapply(c(WAVES, COHORT_SPLIT), function(ids) list(keep_treated = ids)))

r4_ev <- list(); r4_pre <- list(); r4_post <- list(); r4_res <- list()
for (y in R4_OUT) for (sp in names(R4_SPECS)) {
  cat("Round 4:", y, sp, "\n")
  r <- if (sp == "baseline") main[[y]] else
    do.call(run_cs, modifyList(list(y = y, control = "never", covars = TRUE), R4_SPECS[[sp]]))
  r4_res[[paste(y, sp)]] <- r
  s <- summ(r)
  r4_ev[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, s[s$term != "post", ])
  r4_pre[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, pretrend_wald(r))
  r4_post[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, s[s$term == "post", ],
                                   n_treated_firms = r$n_treated_firms, n_control_firms = r$n_control_firms)
}

# (b) Cluster bootstrap for the headline specification of every outcome and for R10.
cl_rows <- list(); cl_pre <- list(); cl_res <- list()
for (y in names(OUTCOMES)) for (sp in c("baseline", "R10_shift1")) {
  cat("Round 4 cluster bootstrap:", y, sp, "\n")
  r <- run_cs(y, control = "never", covars = TRUE, shift_G = if (sp == "R10_shift1") 1 else 0, W = WCL)
  cl_res[[paste(y, sp)]] <- r
  s <- summ(r)
  cl_rows[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, s, n_clusters = NCL)
  cl_pre[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, pretrend_wald(r))
}

# Cumulative run-up from e = -5 to the base year, in percent, with its bootstrap interval (firm and cluster draws).
runup_rows <- list()
for (y in R4_OUT) {
  for (b in c("firm", "cluster")) {
    dr <- if (b == "firm") main[[y]]$draws[, "-5"] else cl_res[[paste(y, "baseline")]]$draws[, "-5"]
    est <- main[[y]]$est[["-5"]]
    runup_rows[[paste(y, b)]] <- data.frame(outcome = y, bootstrap = b, est_e5 = est,
      runup_pct = 100 * (exp(-est) - 1),
      runup_pct_lo = 100 * (exp(-quantile(dr, 0.975, na.rm = TRUE, names = FALSE)) - 1),
      runup_pct_hi = 100 * (exp(-quantile(dr, 0.025, na.rm = TRUE, names = FALSE)) - 1))
  }
}

# (c) Bridge from the static TWFE estimate: same TWFE restricted to never-scored firms and scored firm-years in the
# event window -5..3 (no already-scored controls, no distant event years), then the heterogeneity-robust estimates.
run_twfe_window <- function(y) {
  d <- panel %>% filter(!treated | (year - G >= E_MIN & year - G <= POST_MAX)) %>%
    mutate(D = as.numeric(is.finite(G) & year >= G)) %>% select(firm_id, year, yv = all_of(y), D) %>% filter(!is.na(yv))
  pd <- pdata.frame(as.data.frame(d), index = c("firm_id", "year"))
  m <- plm(yv ~ D, data = pd, model = "within", effect = "twoways")
  V <- vcovHC(m, method = "arellano", type = "HC1", cluster = "group")
  b <- coef(m)[["D"]]; se <- sqrt(V["D", "D"])
  data.frame(est = b, se = se, ci_lo = b - 1.96 * se, ci_hi = b + 1.96 * se, p = 2 * pnorm(-abs(b / se)))
}
bridge_rows <- list()
for (y in R4_OUT) {
  tw <- twfe_tab[twfe_tab$outcome == y, ]
  tw2 <- run_twfe_window(y)
  nc <- summ(r4_res[[paste(y, "no_covariates")]], "post")
  bs <- summ(main[[y]], "post")
  bridge_rows[[y]] <- data.frame(outcome = y,
    step = c("1_twfe_all_years", "2_twfe_never_controls_window", "3_cs_no_covariates", "4_cs_baseline"),
    est = c(tw$est, tw2$est, nc$est, bs$est), se = c(tw$se, tw2$se, nc$se, bs$se),
    ci_lo = c(tw$ci_lo, tw2$ci_lo, nc$ci_lo, bs$ci_lo), ci_hi = c(tw$ci_hi, tw2$ci_hi, nc$ci_hi, bs$ci_hi),
    p = c(tw$p, tw2$p, nc$p, bs$p))
}

# (d) Initial score purged of size at g-1, country, and cohort; split at the median residual.
s0 <- panel %>% filter(treated, year == G - 1, !is.na(ln_asset)) %>% distinct(firm_id, G, country, score0, ln_asset)
s0$resid <- resid(lm(score0 ~ ln_asset + factor(country) + factor(G), data = s0))
hi_ids <- s0$firm_id[s0$resid > median(s0$resid)]; lo_ids <- s0$firm_id[s0$resid <= median(s0$resid)]
h3r_rows <- list()
for (y in names(OUTCOMES)) {
  cat("Round 4 residual-score split:", y, "\n")
  rh <- run_cs(y, control = "never", covars = TRUE, keep_treated = hi_ids)
  rl <- run_cs(y, control = "never", covars = TRUE, keep_treated = lo_ids)
  dd <- rh$est["post"] - rl$est["post"]; dd_draws <- rh$draws[, "post"] - rl$draws[, "post"]; se <- sd(dd_draws)
  h3r_rows[[y]] <- rbind(
    cbind(outcome = y, group = "high_residual_score", summ(rh, "post"), n_treated_firms = rh$n_treated_firms),
    cbind(outcome = y, group = "low_residual_score", summ(rl, "post"), n_treated_firms = rl$n_treated_firms),
    data.frame(outcome = y, group = "difference_high_minus_low", term = "post", est = dd, se = se,
               ci_lo = quantile(dd_draws, 0.025, names = FALSE), ci_hi = quantile(dd_draws, 0.975, names = FALSE),
               p = 2 * pnorm(-abs(dd / se)), mde80 = 2.8 * se, n_treated_firms = NA))
}
h3_corr <- data.frame(n = nrow(s0), cor_score_size = cor(s0$score0, s0$ln_asset),
                      r2_size_country_cohort = summary(lm(score0 ~ ln_asset + factor(country) + factor(G), data = s0))$r.squared)

# (e) Missing ln(MTB) by group; never-scored Malaysian firms against scored Malaysian firms.
miss <- panel %>% group_by(group = ifelse(treated, "scored", "never_scored")) %>%
  summarise(firm_years = n(), share_missing_ln_mtb = mean(is.na(ln_mtb)))
my <- panel %>% filter(country == "MY") %>% group_by(firm_id) %>%
  summarise(treated = first(treated), med_ln_asset = median(ln_asset, na.rm = TRUE)) %>%
  group_by(group = ifelse(treated, "scored", "never_scored")) %>%
  summarise(firms = n(), median_ln_asset = median(med_ln_asset, na.rm = TRUE))

# (f) Reconciliation of R10 with the baseline (R1-W1): baseline group-time effects re-based within each cohort to its
# first scored year, ATT(g, g + e) - ATT(g, g), aggregated with the scored-firm weights of Eq. (5).
reb_rows <- list()
for (y in R4_OUT) {
  reb_rows[[y]] <- main[[y]]$gt %>% filter(!is.na(att)) %>% group_by(g) %>%
    mutate(a0 = if (any(e == 0)) att[e == 0][1] else NA_real_) %>% ungroup() %>%
    filter(e >= 1, !is.na(a0)) %>% group_by(e) %>%
    summarise(rebased = sum((att - a0) * n_treated) / sum(n_treated), scored_firms = sum(n_treated),
              first_cohort = min(g), last_cohort = max(g)) %>% mutate(outcome = y, .before = 1)
}
write_out(bind_rows(reb_rows), "r4_rebased_within_cohort.csv")

write_out(bind_rows(r4_ev), "r4_event_profiles.csv")
write_out(bind_rows(r4_pre), "r4_pretrend_tests.csv")
write_out(bind_rows(r4_post), "r4_post.csv")
write_out(bind_rows(cl_rows), "r4_cluster_bootstrap.csv")
write_out(bind_rows(cl_pre), "r4_cluster_pretrend.csv")
write_out(bind_rows(runup_rows), "r4_runup.csv")
write_out(bind_rows(bridge_rows), "r4_twfe_bridge.csv")
write_out(bind_rows(h3r_rows), "r4_h3_residual_score.csv")
write_out(h3_corr, "r4_h3_score_size.csv")
write_out(miss, "r4_missing_mtb.csv")
write_out(my, "r4_malaysia_never_scored.csv")
write_out(data.frame(n_clusters = NCL, wave = names(WAVES), firms = lengths(WAVES)), "r4_waves.csv")
