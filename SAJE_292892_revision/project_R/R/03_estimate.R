# 03_estimate.R: main ATTs (H1, H2), event studies, pre-trend tests, robustness R1-R6, heterogeneity (H3).
main <- list(); main_rows <- list(); ev_rows <- list(); pre_rows <- list(); gt_rows <- list()
for (y in names(OUTCOMES)) {
  cat("Main:", y, "\n")
  r <- run_cs(y, control = "never", covars = TRUE)
  main[[y]] <- r
  s <- summ(r)
  main_rows[[y]] <- cbind(outcome = y, s[s$term == "post", ], n_treated_firms = r$n_treated_firms,
                          n_control_firms = r$n_control_firms)
  ev_rows[[y]] <- cbind(outcome = y, s[s$term != "post", ])
  pre_rows[[y]] <- cbind(outcome = y, pretrend_wald(r))
  gt_rows[[y]] <- cbind(outcome = y, r$gt)
}
main_tab <- bind_rows(main_rows)
# Holm adjustment across the three secondary outcomes (H2); the primary outcome is tested alone (H1).
sec <- main_tab$outcome != "ln_mtb"
main_tab$p_holm <- NA_real_
main_tab$p_holm[sec] <- p.adjust(main_tab$p[sec], method = "holm")
main_tab$p_holm[!sec] <- main_tab$p[!sec]
write_out(main_tab, "att_main.csv")
write_out(bind_rows(ev_rows), "event_study.csv")
write_out(bind_rows(pre_rows), "pretrend_tests.csv")
write_out(bind_rows(gt_rows), "att_gt.csv")

# Robustness (pre-analysis plan Section 5).
specs <- list(
  R1_notyet     = list(control = "notyet", covars = TRUE),
  R2_nocovars   = list(control = "never", covars = FALSE),
  R3_dropcovid  = list(control = "never", covars = TRUE, drop_cohorts = c(2020, 2021)),
  R4_support    = list(control = "never", covars = TRUE, support = TRUE),
  R5_placebo    = list(control = "never", covars = TRUE, placebo = TRUE))
rob_rows <- list()
for (y in names(OUTCOMES)) for (sp in names(specs)) {
  cat("Robustness:", y, sp, "\n")
  r <- do.call(run_cs, c(list(y = y), specs[[sp]]))
  s <- summ(r, "post")
  rob_rows[[paste(y, sp)]] <- cbind(outcome = y, spec = sp, s, n_treated_firms = r$n_treated_firms,
                                    n_control_firms = r$n_control_firms)
}
twfe_tab <- bind_rows(lapply(names(OUTCOMES), run_twfe))
rob_tab <- bind_rows(rob_rows)
write_out(rob_tab, "robustness.csv")
write_out(twfe_tab, "twfe_static.csv")

# Heterogeneity by initial ESG score (H3), same bootstrap draws for both groups.
het_rows <- list()
for (y in names(OUTCOMES)) {
  cat("Heterogeneity:", y, "\n")
  rh <- run_cs(y, control = "never", covars = TRUE, treated_subset = TRUE)
  rl <- run_cs(y, control = "never", covars = TRUE, treated_subset = FALSE)
  dd <- rh$est["post"] - rl$est["post"]
  dd_draws <- rh$draws[, "post"] - rl$draws[, "post"]
  se <- sd(dd_draws)
  het_rows[[y]] <- rbind(
    cbind(outcome = y, group = "high_initial_score", summ(rh, "post"), n_treated_firms = rh$n_treated_firms),
    cbind(outcome = y, group = "low_initial_score", summ(rl, "post"), n_treated_firms = rl$n_treated_firms),
    data.frame(outcome = y, group = "difference_high_minus_low", term = "post", est = dd, se = se,
               ci_lo = quantile(dd_draws, 0.025, names = FALSE), ci_hi = quantile(dd_draws, 0.975, names = FALSE),
               p = 2 * pnorm(-abs(dd / se)), mde80 = 2.8 * se, n_treated_firms = NA))
}
write_out(bind_rows(het_rows), "heterogeneity_initial_score.csv")

# ---- Revision round 1 (exploratory; deviations from the pre-analysis plan, see notes/AUDIT_LEDGER.md Iter 4) ----
rev_rows <- list(); lomo_rows <- list()
for (y in names(OUTCOMES)) {
  cat("Revision:", y, "\n")
  ta <- trend_adjust(main[[y]])
  s <- summ(list(est = ta$est, draws = ta$draws), "post")
  rev_rows[[paste(y, "R7")]] <- cbind(outcome = y, spec = "R7_trendadj", s, slope = ta$est[["slope"]],
                                      n_treated_firms = main[[y]]$n_treated_firms, n_control_firms = main[[y]]$n_control_firms)
  r8 <- run_cs(y, control = "never", covars = TRUE, pregrowth = TRUE)
  rev_rows[[paste(y, "R8")]] <- cbind(outcome = y, spec = "R8_pregrowth", summ(r8, "post"), slope = NA,
                                      n_treated_firms = r8$n_treated_firms, n_control_firms = r8$n_control_firms)
  for (cc in sort(unique(panel$country))) {
    rl <- run_cs(y, control = "never", covars = TRUE, exclude_country = cc)
    lomo_rows[[paste(y, cc)]] <- cbind(outcome = y, excluded = cc, summ(rl, "post"),
                                       n_treated_firms = rl$n_treated_firms, n_control_firms = rl$n_control_firms)
  }
}
lomo_tab <- bind_rows(lomo_rows)
rev_tab <- bind_rows(c(rev_rows, list(
  lomo_tab %>% filter(excluded == "MY") %>% mutate(spec = "R9_excludeMY", slope = NA) %>% select(-excluded))))
write_out(rev_tab, "robustness_revision.csv")
write_out(lomo_tab, "leave_one_market_out.csv")

# ---- Revision round 2 (exploratory; independent five-seat review, notes/AUDIT_LEDGER.md Iter 5) ----
rev2_rows <- list(); pm_rows <- list(); rm_rows <- list()
for (y in names(OUTCOMES)) {
  cat("Revision 2:", y, "\n")
  r10 <- run_cs(y, control = "never", covars = TRUE, shift_G = 1)
  rev2_rows[[paste(y, "R10")]] <- cbind(outcome = y, spec = "R10_shift1", summ(r10, "post"),
                                        n_treated_firms = r10$n_treated_firms, n_control_firms = r10$n_control_firms)
  r11 <- run_cs(y, control = "never", covars = TRUE, drop_cohorts = 2022:2024)
  rev2_rows[[paste(y, "R11")]] <- cbind(outcome = y, spec = "R11_balanced", summ(r11, "post"),
                                        n_treated_firms = r11$n_treated_firms, n_control_firms = r11$n_control_firms)
  for (cc in sort(unique(panel$country))) {
    rp <- run_cs(y, control = "never", covars = TRUE, only_country = cc)
    pm_rows[[paste(y, cc)]] <- cbind(outcome = y, market = cc, summ(rp, "post"),
                                     n_treated_firms = rp$n_treated_firms, n_control_firms = rp$n_control_firms)
  }
  rm_rows[[y]] <- cbind(outcome = y, rm_bounds(main[[y]]))
}
write_out(bind_rows(rev2_rows), "robustness_revision2.csv")
write_out(bind_rows(pm_rows), "per_market.csv")
write_out(bind_rows(rm_rows), "rm_bounds.csv")

# ---- Revision round 3 (exploratory; Stage 3' re-review, notes/re_review/phase2B_decision.md Section 8) ----
# (a) R10 diagnostics: event study, pre-trend test and relative-magnitude bounds with base year = first scored year.
# (b) Breakdown values of M-bar: the smallest M-bar at which the robust interval admits a +5% MTB change or any
#     positive effect. (c) Firms by event year. (d) Size overlap at g-1. (e) Attrition of scored firms by e = 3.
r10_ev <- list(); r10_pre <- list(); r10_rm <- list(); bd_rows <- list()
bd_one <- function(res, label, y) {
  b <- rm_bounds(res, Mbar = 1)
  unit <- b$bias_bound                     # bias bound per unit of M-bar
  hi <- b$robust_hi - unit                 # bootstrap upper limit
  data.frame(outcome = y, spec = label, ci_hi = hi, bias_per_Mbar = unit,
             Mbar_admit_zero = max(0, (0 - hi) / unit), Mbar_admit_5pct = max(0, (log(1.05) - hi) / unit))
}
for (y in names(OUTCOMES)) {
  cat("Revision 3:", y, "\n")
  r10 <- run_cs(y, control = "never", covars = TRUE, shift_G = 1)
  s10 <- summ(r10)
  r10_ev[[y]] <- cbind(outcome = y, s10[s10$term != "post", ])
  r10_pre[[y]] <- cbind(outcome = y, pretrend_wald(r10))
  r10_rm[[y]] <- cbind(outcome = y, rm_bounds(r10))
  bd_rows[[paste(y, "main")]] <- bd_one(main[[y]], "baseline", y)
  bd_rows[[paste(y, "R10")]] <- bd_one(r10, "R10_shift1", y)
}
write_out(bind_rows(r10_ev), "r10_event_study.csv")
write_out(bind_rows(r10_pre), "r10_pretrend_tests.csv")
write_out(bind_rows(r10_rm), "r10_rm_bounds.csv")
write_out(bind_rows(bd_rows), "rm_breakdown.csv")

# (c) Scored firms, cohorts, and control firms per cell by event year (ln MTB, baseline).
gtm <- main[["ln_mtb"]]$gt %>% filter(!is.na(att))
write_out(gtm %>% group_by(e) %>% summarise(scored_firms = sum(n_treated), cohorts = n_distinct(g),
                                            controls_min = min(n_control), controls_max = max(n_control)),
          "firms_by_event_time.csv")

# (d) Size overlap at g-1: scored firms' ln(total assets) against never-scored firms in the same calendar year.
nev_q <- panel %>% filter(!treated, !is.na(ln_asset)) %>% group_by(year) %>%
  summarise(q95 = quantile(ln_asset, 0.95, names = FALSE))
tr_b <- panel %>% filter(treated, year == G - 1, !is.na(ln_asset)) %>% left_join(nev_q, by = "year")
p10 <- quantile(tr_b$ln_asset, 0.10, names = FALSE)
write_out(data.frame(
  n_scored = nrow(tr_b),
  share_scored_above_never_p95 = mean(tr_b$ln_asset > tr_b$q95),
  share_never_below_scored_p10 = mean(panel$ln_asset[!panel$treated & !is.na(panel$ln_asset)] < p10)),
  "size_overlap.csv")

# (e) Attrition: scored firms in cohorts observed through e = 3 (G <= 2021) with ln MTB at g-1 and at g+3.
att_b <- panel %>% filter(treated, G <= 2021, year == G - 1, !is.na(ln_mtb)) %>% select(firm_id, G)
att_3 <- panel %>% filter(treated, year == G + 3, !is.na(ln_mtb)) %>% select(firm_id)
write_out(data.frame(n_base = nrow(att_b), n_e3 = sum(att_b$firm_id %in% att_3$firm_id),
                     share_e3 = mean(att_b$firm_id %in% att_3$firm_id)), "attrition_e3.csv")
