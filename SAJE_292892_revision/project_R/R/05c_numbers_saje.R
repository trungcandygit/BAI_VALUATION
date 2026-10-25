# 05c_numbers_saje.R: numbers quoted in the SAJE revision text that are not already in numbers.csv.
# Output: outputs/numbers_saje.csv (key, value). Keys start with "s_" so they cannot collide with numbers.csv.
fmt <- function(x, d = 3) ifelse(is.na(x), "", gsub("-", "−", formatC(x, digits = d, format = "f")))
fmtp <- function(p) ifelse(is.na(p), "", ifelse(p < 0.001, "<0.001", formatC(p, digits = 3, format = "f")))
fmtn <- function(x) formatC(x, format = "d", big.mark = ",")
pct <- function(b) fmt(100 * (exp(b) - 1), 1)
ab <- c(ln_mtb = "mtb", ln_mcap = "mcap")
nums <- list(); put <- function(k, v) { stopifnot(length(v) == 1); nums[[k]] <<- v }
rd <- function(f) read.csv(file.path(OUT, f), stringsAsFactors = FALSE)

est_keys <- function(d) for (i in seq_len(nrow(d))) {
  k <- paste0("s_", ab[[d$outcome[i]]], "_", d$spec[i])
  put(k, fmt(d$est[i])); put(paste0(k, "_se"), fmt(d$se[i])); put(paste0(k, "_p"), fmtp(d$p[i]))
  put(paste0(k, "_lo"), fmt(d$ci_lo[i])); put(paste0(k, "_hi"), fmt(d$ci_hi[i])); put(paste0(k, "_pct"), pct(d$est[i]))
  put(paste0(k, "_lo_pct"), pct(d$ci_lo[i])); put(paste0(k, "_hi_pct"), pct(d$ci_hi[i]))
  put(paste0(k, "_abs"), fmt(abs(d$est[i]))); put(paste0(k, "_declpct"), fmt(-100 * (exp(d$est[i]) - 1), 1))
  if (!is.na(d$n_treated_firms[i])) { put(paste0(k, "_ntr"), fmtn(d$n_treated_firms[i]))
    put(paste0(k, "_nco"), fmtn(d$n_control_firms[i])); put(paste0(k, "_ncoh"), fmtn(d$n_cohorts[i])) }
}
for (f in c("s_r10_decomposition.csv", "s_support.csv", "s_missing_checks.csv", "s_outliers.csv",
            "s_waves_dating.csv")) est_keys(rd(f))

dec <- rd("s_r10_decomposition.csv")
for (y in names(ab)) {   # share of the A0 to C3 gap explained by each step
  g <- function(s) dec$est[dec$outcome == y & dec$spec == s]
  tot <- g("C3") - g("A0")
  put(paste0("s_", ab[[y]], "_gap_total"), fmt(tot))
  for (s in c("d_sample_A1_A0", "d_window_B1_A1", "d_reference_C1_B1", "d_size_C2_C1", "d_sample_C3_C2"))
    put(paste0("s_", ab[[y]], "_", s, "_share"), fmt(100 * g(s) / tot, 0))
}
sup <- rd("s_support.csv"); ol <- rd("s_outliers.csv")
ff <- sup$est[sup$outcome == "ln_mtb" & sup$spec %in% c("baseline", "no_covariates", "linear", "cubic", "bins", "size_g3")]
put("s_mtb_ff_min", fmt(min(ff))); put("s_mtb_ff_max", fmt(max(ff)))
cv <- sup$est[sup$outcome == "ln_mcap" & sup$spec != "no_covariates"]
put("s_mcap_cov_min", fmt(min(cv))); put("s_mcap_cov_max", fmt(max(cv)))
oo <- ol$est[ol$outcome == "ln_mtb"]
put("s_mtb_out_min", fmt(min(oo))); put("s_mtb_out_max", fmt(max(oo)))
het <- rd("heterogeneity_initial_score.csv")
put("s_mtb_diff_mde_pct", fmt(100 * (exp(het$mde80[het$outcome == "ln_mtb" & het$group == "difference_high_minus_low"]) - 1), 1))
cp <- rd("s_common_paths.csv")
for (i in seq_len(nrow(cp))) {
  tag <- ifelse(cp$e[i] < 0, paste0("m", -cp$e[i]), as.character(cp$e[i]))
  k <- paste0("s_", ab[[cp$outcome[i]]], "_cp_", ifelse(cp$reference[i] == "g", "rg", "rgm1"), "_e", tag)
  put(k, fmt(cp$est[i])); put(paste0(k, "_lo"), fmt(cp$ci_lo[i])); put(paste0(k, "_hi"), fmt(cp$ci_hi[i]))
  put(paste0(k, "_abs"), fmt(abs(cp$est[i])))
}

ret <- rd("s_support_retained.csv")
for (g in c("retained", "excluded")) {
  x <- ret[ret$group == g, ]
  put(paste0("s_sup_", g, "_n"), fmtn(x$firms)); put(paste0("s_sup_", g, "_assets"), fmt(x$med_assets_musd, 1))
  put(paste0("s_sup_", g, "_mcap"), fmt(x$med_mcap_musd, 1)); put(paste0("s_sup_", g, "_mtb"), fmt(x$med_mtb, 2))
  put(paste0("s_sup_", g, "_my"), fmt(100 * x$share_MY, 1)); put(paste0("s_sup_", g, "_th"), fmt(100 * x$share_TH, 1))
  put(paste0("s_sup_", g, "_sg"), fmt(100 * x$share_SG, 1)); put(paste0("s_sup_", g, "_id"), fmt(100 * x$share_ID, 1))
  put(paste0("s_sup_", g, "_early"), fmt(100 * x$share_cohort_le2020, 1)); put(paste0("s_sup_", g, "_score"), fmt(x$mean_score0, 1))
}
ps <- rd("s_support_pscore.csv")
for (i in seq_len(nrow(ps))) { put(paste0("s_ps_", ps$spec[i], "_share95"), fmt(100 * ps$share_p_above_095[i], 1))
  put(paste0("s_ps_", ps$spec[i], "_max"), fmt(ps$max_p[i], 3)) }

ms <- rd("s_missing_source.csv")
for (g in c("scored", "never_scored")) {
  x <- ms[ms$group == g, ]
  put(paste0("s_miss_", g, "_share"), fmt(100 * x$share_mtb_missing, 1))
  put(paste0("s_miss_", g, "_withmcap"), fmt(100 * x$share_missing_with_mcap, 1))
  put(paste0("s_miss_", g, "_withassets"), fmt(100 * x$share_missing_with_assets, 1))
  put(paste0("s_miss_", g, "_nonpos"), fmtn(x$n_mtb_nonpositive))
}
mc <- rd("s_missing_compare.csv")
for (i in seq_len(nrow(mc))) {
  k <- paste0("s_mc_", mc$group[i], "_", ifelse(mc$has_mtb[i], "obs", "miss"))
  put(paste0(k, "_fy"), fmtn(mc$firm_years[i])); put(paste0(k, "_assets"), fmt(mc$med_assets_musd[i], 1))
  put(paste0(k, "_mcap"), fmt(mc$med_mcap_musd[i], 1)); put(paste0(k, "_lev"), fmt(mc$mean_lev[i]))
  put(paste0(k, "_lev05"), fmt(100 * mc$share_lev_above_05[i], 1)); put(paste0(k, "_id"), fmt(100 * mc$share_ID[i], 1))
  put(paste0(k, "_my"), fmt(100 * mc$share_MY[i], 1)); put(paste0(k, "_year"), fmt(mc$mean_year[i], 1))
}
en <- rd("s_missing_scored_entry.csv")
put("s_entry_in_n", fmtn(en$firms[en$enters])); put("s_entry_out_n", fmtn(en$firms[!en$enters]))
put("s_entry_in_assets", fmt(en$med_assets_musd[en$enters], 1)); put("s_entry_out_assets", fmt(en$med_assets_musd[!en$enters], 1))

fl <- rd("s_flag_summary.csv")
for (i in seq_len(nrow(fl))) {
  k <- paste0("s_flag_", fl$country[i])
  put(paste0(k, "_n"), fmtn(fl$flagged[i])); put(paste0(k, "_firms"), fmtn(fl$firms_flagged[i]))
  put(paste0(k, "_scored"), fmtn(fl$flagged_scored[i])); put(paste0(k, "_checked"), fmtn(fl$checked[i]))
  put(paste0(k, "_n2"), fmtn(fl$flagged_ratio2[i])); put(paste0(k, "_maxmcap"), fmt(fl$max_mcap_busd[i], 1))
}
fa <- fl[fl$country == "All", ]
put("s_flag_share_ID", fmt(100 * fl$flagged[fl$country == "ID"] / fa$flagged, 1))
put("s_flag_pct_checked", fmt(100 * fa$flagged / fa$checked, 2))

wt <- rd("s_weights.csv")
for (i in seq_len(nrow(wt))) put(paste0("s_w_", wt$dim[i], "_", wt$level[i]), fmt(100 * wt$weight[i], 1))
cy <- wt[wt$dim == "calendar_year", ]
put("s_w_years_2021_2024", fmt(100 * sum(cy$weight[as.integer(cy$level) >= 2021]), 1))
mw <- wt[wt$dim == "market", ]
put("s_w_my_th", fmt(100 * sum(mw$weight[mw$level %in% c("MY", "TH")]), 1))

for (k in grep("_p$", names(nums), value = TRUE))
  put(paste0(k, "_txt"), ifelse(nums[[k]] == "<0.001", "< 0.001", paste("=", nums[[k]])))
numbers <- data.frame(key = names(nums), value = unlist(nums), row.names = NULL)
write.csv(numbers[order(numbers$key), ], file.path(OUT, "numbers_saje.csv"), row.names = FALSE)
