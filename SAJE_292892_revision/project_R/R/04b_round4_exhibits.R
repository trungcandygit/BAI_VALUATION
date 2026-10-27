# 04b_round4_exhibits.R: exhibits for the round-4 exploratory analyses (03b_round4.R).
# Fig. 2 (main text): pre- and post-coverage paths by coverage wave. Table S7: alternative specifications, inference,
# and the purged initial-score split. Table S8: bridge from the static two-way fixed effects estimate. Fig. S2:
# MTB event-time paths under alternative covariate timing, support, and dating.

r4p <- read.csv(file.path(OUT, "r4_post.csv")); r4pre <- read.csv(file.path(OUT, "r4_pretrend_tests.csv"))
r4ev <- read.csv(file.path(OUT, "r4_event_profiles.csv")) %>% mutate(e = as.integer(term))
clb <- read.csv(file.path(OUT, "r4_cluster_bootstrap.csv")); clpre <- read.csv(file.path(OUT, "r4_cluster_pretrend.csv"))
h3r <- read.csv(file.path(OUT, "r4_h3_residual_score.csv")); br <- read.csv(file.path(OUT, "r4_twfe_bridge.csv"))
OUT2 <- c(ln_mtb = "ln(MTB)", ln_mcap = "ln(market cap)")

# Figures 2 and S2 are drawn by 06_figures_saje.R (one script owns each figure file).

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
  c("wave_MY_2021_22", "Malaysia, first recorded 2021–2022"), c("wave_TH_SG_2019_20", "Thailand and Singapore, 2019–2020"),
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
