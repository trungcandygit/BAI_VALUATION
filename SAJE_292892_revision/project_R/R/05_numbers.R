# 05_numbers.R: every number quoted in the manuscript text, formatted once here (same rounding as the tables).
# Output: outputs/numbers.csv (key, value). The DOCX builder refuses any placeholder not found in this file.
ab <- c(ln_mtb = "mtb", ln_mcap = "mcap", leverage = "lev", ln_asset = "asset")
nums <- list()
put <- function(k, v) nums[[k]] <<- v
pct <- function(b) fmt(100 * (exp(b) - 1), 1)       # log points -> percent change
pp  <- function(b) fmt(100 * b, 1)                   # ratio -> percentage points

sf <- read.csv(file.path(OUT, "sample_flow.csv"))
put("n_universe_firms", fmtn(sf$firms[1])); put("n_universe_fy", fmtn(sf$firm_years[1]))
put("n_nonfin_firms", fmtn(sf$firms[2])); put("n_cov2014", fmtn(sf$firms[3]))
put("n_est_firms", fmtn(sf$firms[4])); put("n_est_fy", fmtn(sf$firm_years[4]))
put("n_treated_all", fmtn(sf$firms[5])); put("n_never", fmtn(sf$firms[6]))

put("n_cov_gap", fmtn(read.csv(file.path(OUT, "coverage_gaps.csv"))$n_cov_gap))
cs <- read.csv(file.path(OUT, "cohort_sizes.csv"))
put("n_coh_2020_2023", fmtn(sum(cs$total[cs$G %in% 2020:2023])))
put("pct_coh_2020_2023", fmt(100 * sum(cs$total[cs$G %in% 2020:2023]) / sum(cs$total), 1))
put("n_my_2021_2022", fmtn(sum(cs$MY[cs$G %in% 2021:2022])))
put("n_th_sg_2019_2020", fmtn(sum(cs$TH[cs$G %in% 2019:2020]) + sum(cs$SG[cs$G %in% 2019:2020])))
put("n_coh_min_year", as.character(min(cs$G))); put("n_coh_max_year", as.character(max(cs$G)))
put("n_coh_2023", fmtn(cs$total[cs$G == 2023]))   # round 4: firms first scored in 2023 (Table S2)

mt <- read.csv(file.path(OUT, "att_main.csv")); pre <- read.csv(file.path(OUT, "pretrend_tests.csv"))
for (i in seq_len(nrow(mt))) {
  a <- ab[[mt$outcome[i]]]
  put(paste0(a, "_att"), fmt(mt$est[i])); put(paste0(a, "_se"), fmt(mt$se[i]))
  put(paste0(a, "_lo"), fmt(mt$ci_lo[i])); put(paste0(a, "_hi"), fmt(mt$ci_hi[i]))
  put(paste0(a, "_p"), fmtp(mt$p[i])); put(paste0(a, "_pholm"), fmtp(mt$p_holm[i]))
  put(paste0(a, "_mde"), fmt(mt$mde80[i]))
  put(paste0(a, "_ntr"), fmtn(mt$n_treated_firms[i])); put(paste0(a, "_nco"), fmtn(mt$n_control_firms[i]))
  put(paste0(a, "_att_pct"), pct(mt$est[i])); put(paste0(a, "_mde_pct"), pct(mt$mde80[i]))
  put(paste0(a, "_lo_pct"), pct(mt$ci_lo[i])); put(paste0(a, "_hi_pct"), pct(mt$ci_hi[i]))
  put(paste0(a, "_att_pp"), pp(mt$est[i])); put(paste0(a, "_mde_pp"), pp(mt$mde80[i]))
  j <- which(pre$outcome == mt$outcome[i])
  put(paste0(a, "_pre_p"), fmtp(pre$p[j])); put(paste0(a, "_pre_wald"), fmt(pre$wald[j], 2))
}

ev <- read.csv(file.path(OUT, "event_study.csv"))
for (i in seq_len(nrow(ev))) {
  a <- ab[[ev$outcome[i]]]; e <- ev$term[i]; tag <- ifelse(e < 0, paste0("m", -e), as.character(e))
  put(paste0(a, "_e", tag), fmt(ev$est[i])); put(paste0(a, "_e", tag, "_se"), fmt(ev$se[i]))
  put(paste0(a, "_e", tag, "_lo"), fmt(ev$ci_lo[i])); put(paste0(a, "_e", tag, "_hi"), fmt(ev$ci_hi[i]))
  put(paste0(a, "_e", tag, "_p"), fmtp(ev$p[i])); put(paste0(a, "_e", tag, "_pct"), pct(ev$est[i]))
  put(paste0(a, "_e", tag, "_pp"), pp(ev$est[i]))
  if (e < 0) put(paste0(a, "_runup_", tag), pct(-ev$est[i]))   # growth from e to the base year -1
}

rb <- read.csv(file.path(OUT, "robustness.csv")); tw <- read.csv(file.path(OUT, "twfe_static.csv"))
for (i in seq_len(nrow(rb))) {
  a <- ab[[rb$outcome[i]]]; k <- sub("_.*", "", rb$spec[i])
  put(paste0(a, "_", k), fmt(rb$est[i])); put(paste0(a, "_", k, "_se"), fmt(rb$se[i]))
  put(paste0(a, "_", k, "_p"), fmtp(rb$p[i])); put(paste0(a, "_", k, "_pct"), pct(rb$est[i]))
  put(paste0(a, "_", k, "_lo"), fmt(rb$ci_lo[i])); put(paste0(a, "_", k, "_hi"), fmt(rb$ci_hi[i]))
}
for (i in seq_len(nrow(tw))) {
  a <- ab[[tw$outcome[i]]]
  put(paste0(a, "_R6"), fmt(tw$est[i])); put(paste0(a, "_R6_pct"), pct(tw$est[i])); put(paste0(a, "_R6_se"), fmt(tw$se[i])); put(paste0(a, "_R6_p"), fmtp(tw$p[i]))
}

rv <- read.csv(file.path(OUT, "robustness_revision.csv"))
for (i in seq_len(nrow(rv))) {
  a <- ab[[rv$outcome[i]]]; k <- sub("_.*", "", rv$spec[i])
  put(paste0(a, "_", k), fmt(rv$est[i])); put(paste0(a, "_", k, "_se"), fmt(rv$se[i]))
  put(paste0(a, "_", k, "_p"), fmtp(rv$p[i])); put(paste0(a, "_", k, "_pct"), pct(rv$est[i]))
  put(paste0(a, "_", k, "_lo"), fmt(rv$ci_lo[i])); put(paste0(a, "_", k, "_hi"), fmt(rv$ci_hi[i]))
  put(paste0(a, "_", k, "_lo_pct"), pct(rv$ci_lo[i])); put(paste0(a, "_", k, "_hi_pct"), pct(rv$ci_hi[i]))
  if (!is.na(rv$slope[i])) put(paste0(a, "_", k, "_slope"), fmt(rv$slope[i]))
  put(paste0(a, "_", k, "_ntr"), fmtn(rv$n_treated_firms[i]))
}
rv2 <- read.csv(file.path(OUT, "robustness_revision2.csv"))
for (i in seq_len(nrow(rv2))) {
  a <- ab[[rv2$outcome[i]]]; k <- sub("_.*", "", rv2$spec[i])
  put(paste0(a, "_", k), fmt(rv2$est[i])); put(paste0(a, "_", k, "_se"), fmt(rv2$se[i]))
  put(paste0(a, "_", k, "_p"), fmtp(rv2$p[i])); put(paste0(a, "_", k, "_pct"), pct(rv2$est[i]))
  put(paste0(a, "_", k, "_lo"), fmt(rv2$ci_lo[i])); put(paste0(a, "_", k, "_hi"), fmt(rv2$ci_hi[i]))
  put(paste0(a, "_", k, "_ntr"), fmtn(rv2$n_treated_firms[i]))
}
pm <- read.csv(file.path(OUT, "per_market.csv"))
for (i in seq_len(nrow(pm))) {
  a <- ab[[pm$outcome[i]]]
  put(paste0(a, "_pm_", pm$market[i]), fmt(pm$est[i])); put(paste0(a, "_pm_", pm$market[i], "_se"), fmt(pm$se[i]))
  put(paste0(a, "_pm_", pm$market[i], "_p"), fmtp(pm$p[i])); put(paste0(a, "_pm_", pm$market[i], "_ntr"), fmtn(pm$n_treated_firms[i]))
}
rmb <- read.csv(file.path(OUT, "rm_bounds.csv"))
for (i in seq_len(nrow(rmb))) {
  a <- ab[[rmb$outcome[i]]]; m <- gsub("\\.", "", formatC(rmb$Mbar[i], digits = 2, format = "f"))
  put(paste0(a, "_rm", m, "_lo"), fmt(rmb$robust_lo[i])); put(paste0(a, "_rm", m, "_hi"), fmt(rmb$robust_hi[i]))
  put(paste0(a, "_rm", m, "_lo_pct"), pct(rmb$robust_lo[i])); put(paste0(a, "_rm", m, "_hi_pct"), pct(rmb$robust_hi[i]))
  put(paste0(a, "_rm_dmax"), fmt(rmb$dmax[i]))
}
tot <- sum(cs$total)
put("n_my_treated", fmtn(sum(cs$MY))); put("pct_my_treated", fmt(100 * sum(cs$MY) / tot, 1))
put("n_th_treated", fmtn(sum(cs$TH))); put("pct_my_th_treated", fmt(100 * (sum(cs$MY) + sum(cs$TH)) / tot, 1))
put("n_sg_treated", fmtn(sum(cs$SG))); put("n_id_treated", fmtn(sum(cs$ID))); put("n_ph_treated", fmtn(sum(cs$PH)))
lm_ <- read.csv(file.path(OUT, "leave_one_market_out.csv"))
for (i in seq_len(nrow(lm_))) {
  a <- ab[[lm_$outcome[i]]]
  put(paste0(a, "_lomo_", lm_$excluded[i]), fmt(lm_$est[i])); put(paste0(a, "_lomo_", lm_$excluded[i], "_p"), fmtp(lm_$p[i]))
}
put("mtb_lomo_min", fmt(min(lm_$est[lm_$outcome == "ln_mtb"]))); put("mtb_lomo_max", fmt(max(lm_$est[lm_$outcome == "ln_mtb"])))
put("mtb_lomo_minp", fmtp(min(lm_$p[lm_$outcome == "ln_mtb"])))
ht <- read.csv(file.path(OUT, "heterogeneity_initial_score.csv"))
for (i in seq_len(nrow(ht))) {
  a <- ab[[ht$outcome[i]]]; g <- c(high_initial_score = "high", low_initial_score = "low",
                                  difference_high_minus_low = "diff")[[ht$group[i]]]
  put(paste0(a, "_", g), fmt(ht$est[i])); put(paste0(a, "_", g, "_se"), fmt(ht$se[i]))
  put(paste0(a, "_", g, "_p"), fmtp(ht$p[i])); put(paste0(a, "_", g, "_mde"), fmt(ht$mde80[i]))
  if (!is.na(ht$n_treated_firms[i])) put(paste0(a, "_", g, "_n"), fmtn(ht$n_treated_firms[i]))
}

t1 <- read.csv(file.path(OUT, "table1_raw.csv"))
key1 <- c("mtb", "mcap", "lev", "asset", "roa"); dig1 <- c(2, 1, 3, 1, 3)
for (i in seq_len(nrow(t1))) {
  put(paste0("t1_", key1[i], "_tr_mean"), fmt(t1$tr_mean[i], dig1[i])); put(paste0("t1_", key1[i], "_nv_mean"), fmt(t1$nv_mean[i], dig1[i]))
  put(paste0("t1_", key1[i], "_tr_med"), fmt(t1$tr_median[i], dig1[i])); put(paste0("t1_", key1[i], "_nv_med"), fmt(t1$nv_median[i], dig1[i]))
  put(paste0("t1_", key1[i], "_nd"), fmt(t1$norm_diff[i], 2))
}
put("t1_mcap_ratio_med", fmt(t1$tr_median[2] / t1$nv_median[2], 1))
put("t1_asset_ratio_med", fmt(t1$tr_median[4] / t1$nv_median[4], 1))
put("B_BOOT", fmtn(B_BOOT)); put("SEED", as.character(SEED))

# ---- Revision round 3 (Stage 3' re-review) ----
for (i in seq_len(nrow(rv2))) {
  a <- ab[[rv2$outcome[i]]]; k <- sub("_.*", "", rv2$spec[i])
  put(paste0(a, "_", k, "_nco"), fmtn(rv2$n_control_firms[i]))
  put(paste0(a, "_", k, "_lo_pct"), pct(rv2$ci_lo[i])); put(paste0(a, "_", k, "_hi_pct"), pct(rv2$ci_hi[i]))
}
put("n_R11_cohorts", fmtn(sum(cs$G <= 2021)))
r10p <- read.csv(file.path(OUT, "r10_pretrend_tests.csv"))
for (i in seq_len(nrow(r10p))) put(paste0(ab[[r10p$outcome[i]]], "_R10_pre_p"), fmtp(r10p$p[i]))
r10e <- read.csv(file.path(OUT, "r10_event_study.csv"))
for (i in seq_len(nrow(r10e))) {
  a <- ab[[r10e$outcome[i]]]; e <- r10e$term[i]; tag <- ifelse(e < 0, paste0("m", -e), as.character(e))
  put(paste0(a, "_R10_e", tag), fmt(r10e$est[i])); put(paste0(a, "_R10_e", tag, "_p"), fmtp(r10e$p[i]))
}
r10b <- read.csv(file.path(OUT, "r10_rm_bounds.csv"))
for (i in seq_len(nrow(r10b))) {
  a <- ab[[r10b$outcome[i]]]; m <- gsub("\\.", "", formatC(r10b$Mbar[i], digits = 2, format = "f"))
  put(paste0(a, "_R10_rm", m, "_lo"), fmt(r10b$robust_lo[i])); put(paste0(a, "_R10_rm", m, "_hi"), fmt(r10b$robust_hi[i]))
  put(paste0(a, "_R10_rm_dmax"), fmt(r10b$dmax[i]))
}
bd <- read.csv(file.path(OUT, "rm_breakdown.csv"))
for (i in seq_len(nrow(bd))) {
  a <- ab[[bd$outcome[i]]]; k <- if (bd$spec[i] == "baseline") "" else "_R10"
  put(paste0(a, k, "_bd0"), fmt(bd$Mbar_admit_zero[i], 2)); put(paste0(a, k, "_bd5"), fmt(bd$Mbar_admit_5pct[i], 2))
}
fe <- read.csv(file.path(OUT, "firms_by_event_time.csv"))
put("mtb_nfirms_e0", fmtn(fe$scored_firms[fe$e == 0])); put("mtb_nfirms_e3", fmtn(fe$scored_firms[fe$e == 3]))
put("mtb_nfirms_e4", fmtn(fe$scored_firms[fe$e == 4])); put("mtb_ncoh_e4", fmtn(fe$cohorts[fe$e == 4]))
so <- read.csv(file.path(OUT, "size_overlap.csv"))
put("pct_scored_above_p95", fmt(100 * so$share_scored_above_never_p95, 1))
put("pct_never_below_p10", fmt(100 * so$share_never_below_scored_p10, 1))
ae <- read.csv(file.path(OUT, "attrition_e3.csv"))
put("n_attr_base", fmtn(ae$n_base)); put("n_attr_e3", fmtn(ae$n_e3)); put("pct_attr_e3", fmt(100 * ae$share_e3, 1))
put("log105", fmt(log(1.05)))

# ---- Revision round 4 (exploratory; review after the desk rejection, 03b_round4.R) ----
r4tag <- c(baseline = "base", no_covariates = "nocov", size_at_g3 = "sizeg3", size_bins = "bins", trim_top_p95 = "trim",
           R10_shift1 = "R10", R10_size_at_g1 = "R10g1", R12_shift2 = "R12", wave_MY_2021_22 = "wMY",
           wave_TH_SG_2019_20 = "wTHSG", wave_other = "wOth", cohorts_to_2019 = "c19", cohorts_from_2020 = "c20")
r4p <- read.csv(file.path(OUT, "r4_post.csv"))
for (i in seq_len(nrow(r4p))) {
  k <- paste0(ab[[r4p$outcome[i]]], "_r4", r4tag[[r4p$spec[i]]])
  put(k, fmt(r4p$est[i])); put(paste0(k, "_se"), fmt(r4p$se[i])); put(paste0(k, "_p"), fmtp(r4p$p[i]))
  put(paste0(k, "_lo"), fmt(r4p$ci_lo[i])); put(paste0(k, "_hi"), fmt(r4p$ci_hi[i])); put(paste0(k, "_pct"), pct(r4p$est[i]))
  put(paste0(k, "_lo_pct"), pct(r4p$ci_lo[i])); put(paste0(k, "_hi_pct"), pct(r4p$ci_hi[i]))
  put(paste0(k, "_ntr"), fmtn(r4p$n_treated_firms[i]))
}
r4pre <- read.csv(file.path(OUT, "r4_pretrend_tests.csv"))
for (i in seq_len(nrow(r4pre))) put(paste0(ab[[r4pre$outcome[i]]], "_r4", r4tag[[r4pre$spec[i]]], "_pre_p"), fmtp(r4pre$p[i]))
r4ev <- read.csv(file.path(OUT, "r4_event_profiles.csv"))
for (i in seq_len(nrow(r4ev))) {
  e <- r4ev$term[i]; tag <- ifelse(e < 0, paste0("m", -e), as.character(e))
  k <- paste0(ab[[r4ev$outcome[i]]], "_r4", r4tag[[r4ev$spec[i]]], "_e", tag)
  put(k, fmt(r4ev$est[i])); put(paste0(k, "_p"), fmtp(r4ev$p[i]))
  if (e < 0) put(paste0(ab[[r4ev$outcome[i]]], "_r4", r4tag[[r4ev$spec[i]]], "_runup_", tag), pct(-r4ev$est[i]))
}
clb <- read.csv(file.path(OUT, "r4_cluster_bootstrap.csv")) %>% filter(term == "post")
for (i in seq_len(nrow(clb))) {
  k <- paste0(ab[[clb$outcome[i]]], "_cl", ifelse(clb$spec[i] == "baseline", "", "R10"))
  put(k, fmt(clb$est[i])); put(paste0(k, "_se"), fmt(clb$se[i])); put(paste0(k, "_p"), fmtp(clb$p[i]))
  put(paste0(k, "_lo"), fmt(clb$ci_lo[i])); put(paste0(k, "_hi"), fmt(clb$ci_hi[i]))
  put(paste0(k, "_lo_pct"), pct(clb$ci_lo[i])); put(paste0(k, "_hi_pct"), pct(clb$ci_hi[i]))
}
clpre <- read.csv(file.path(OUT, "r4_cluster_pretrend.csv"))
for (i in seq_len(nrow(clpre)))
  put(paste0(ab[[clpre$outcome[i]]], "_cl", ifelse(clpre$spec[i] == "baseline", "", "R10"), "_pre_p"), fmtp(clpre$p[i]))
put("n_clusters", fmtn(read.csv(file.path(OUT, "r4_waves.csv"))$n_clusters[1]))
ru <- read.csv(file.path(OUT, "r4_runup.csv"))
for (i in seq_len(nrow(ru))) {
  k <- paste0(ab[[ru$outcome[i]]], "_runup", ifelse(ru$bootstrap[i] == "firm", "", "_cl"))
  put(paste0(k, "_lo"), fmt(ru$runup_pct_lo[i], 1)); put(paste0(k, "_hi"), fmt(ru$runup_pct_hi[i], 1))
}
br <- read.csv(file.path(OUT, "r4_twfe_bridge.csv"))
for (i in seq_len(nrow(br))) {
  k <- paste0(ab[[br$outcome[i]]], "_bridge", substr(br$step[i], 1, 1))
  put(k, fmt(br$est[i])); put(paste0(k, "_p"), fmtp(br$p[i])); put(paste0(k, "_pct"), pct(br$est[i]))
}
h3r <- read.csv(file.path(OUT, "r4_h3_residual_score.csv"))
for (i in seq_len(nrow(h3r))) {
  g <- c(high_residual_score = "high", low_residual_score = "low", difference_high_minus_low = "diff")[[h3r$group[i]]]
  k <- paste0(ab[[h3r$outcome[i]]], "_h3r_", g)
  put(k, fmt(h3r$est[i])); put(paste0(k, "_se"), fmt(h3r$se[i])); put(paste0(k, "_p"), fmtp(h3r$p[i]))
  put(paste0(k, "_mde"), fmt(h3r$mde80[i]))
  if (!is.na(h3r$n_treated_firms[i])) put(paste0(k, "_n"), fmtn(h3r$n_treated_firms[i]))
}
hc <- read.csv(file.path(OUT, "r4_h3_score_size.csv"))
put("h3_cor_score_size", fmt(hc$cor_score_size, 2)); put("h3_r2_score", fmt(hc$r2_size_country_cohort, 2))
ms <- read.csv(file.path(OUT, "r4_missing_mtb.csv"))
put("pct_miss_mtb_scored", fmt(100 * ms$share_missing_ln_mtb[ms$group == "scored"], 1))
put("pct_miss_mtb_never", fmt(100 * ms$share_missing_ln_mtb[ms$group == "never_scored"], 1))
my <- read.csv(file.path(OUT, "r4_malaysia_never_scored.csv"))
put("n_my_never", fmtn(my$firms[my$group == "never_scored"]))
put("my_asset_ratio_med", fmt(exp(my$median_ln_asset[my$group == "scored"] - my$median_ln_asset[my$group == "never_scored"]), 1))
rbw <- read.csv(file.path(OUT, "r4_rebased_within_cohort.csv"))
for (i in seq_len(nrow(rbw))) put(paste0(ab[[rbw$outcome[i]]], "_reb_e", rbw$e[i]), fmt(rbw$rebased[i]))
wv <- read.csv(file.path(OUT, "r4_waves.csv"))
for (i in seq_len(nrow(wv))) put(paste0("n_", r4tag[[wv$wave[i]]]), fmtn(wv$firms[i]))

# Text form of every p-value: "= 0.xxx" or "< 0.001", so that "*p* {{key_txt}}" reads correctly.
for (k in grep("_p$|_pholm$|_pre_p$", names(nums), value = TRUE))
  put(paste0(k, "_txt"), ifelse(nums[[k]] == "<0.001", "< 0.001", paste("=", nums[[k]])))
numbers <- data.frame(key = names(nums), value = unlist(nums), row.names = NULL)
write.csv(numbers[order(numbers$key), ], file.path(OUT, "numbers.csv"), row.names = FALSE)
