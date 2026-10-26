# 04c_saje_tables.R: formatted tables for the SAJE revision (strings rounded here, once). Reads the s_*.csv outputs.
fmt <- function(x, d = 3) ifelse(is.na(x), "", gsub("-", "−", formatC(x, digits = d, format = "f")))
fmtp <- function(p) ifelse(is.na(p), "", ifelse(p < 0.001, "<0.001", formatC(p, digits = 3, format = "f")))
fmtn <- function(x) formatC(x, format = "d", big.mark = ",")
fmtm <- function(x) gsub("-", "−", formatC(x, digits = 1, format = "f", big.mark = ","))   # amounts in USD million
stars <- function(p) ifelse(is.na(p), "", ifelse(p < 0.01, "***", ifelse(p < 0.05, "**", ifelse(p < 0.10, "*", ""))))
cellf <- function(d) ifelse(is.na(d$est), "", paste0(fmt(d$est), stars(d$p), " (", fmt(d$se), ")"))
rd <- function(f) read.csv(file.path(OUT, f), stringsAsFactors = FALSE)
pick <- function(d, y, s) d[d$outcome == y & d$spec == s, ]

# ---- Table 4: reconciling the two datings ----
dec <- rd("s_r10_decomposition.csv")
t4_rows <- list(
  c("A0", "(1) First recorded year g, reference g − 1, event years 0 to 3, all firms"),
  c("A1", "(2) As (1), firms observed in both g − 1 and g"),
  c("B1", "(3) As (2), event years 1 to 4"),
  c("C1", "(4) As (3), reference year g"),
  c("C2", "(5) As (4), size measured in g (one year later, same firms)"),
  c("C3", "(6) One year later, all firms (R10)"),
  c("A1_b", "(7) As (2), cohorts first recorded 2015 to 2020"),
  c("B1_b", "(8) As (3), cohorts first recorded 2015 to 2020"),
  c("C1_b", "(9) As (4), cohorts first recorded 2015 to 2020"),
  c("C2_b", "(10) As (5), cohorts first recorded 2015 to 2020"))
t4 <- do.call(rbind, lapply(t4_rows, function(r) {
  a <- pick(dec, "ln_mtb", r[1]); b <- pick(dec, "ln_mcap", r[1])
  data.frame(Specification = r[2], `ln(MTB)` = cellf(a), `ln(market cap)` = cellf(b),
             `Scored firms in averaged event years` = fmtn(a$n_treated_firms), check.names = FALSE)
}))
write.csv(t4, file.path(OUT, "tableSAJE4_formatted.csv"), row.names = FALSE)

# ---- Table 5: size adjustment and common support ----
sup <- rd("s_support.csv")
t5_rows <- list(
  c("baseline", "Baseline: quadratic in log total assets at g − 1"),
  c("no_covariates", "No covariates"),
  c("linear", "Linear in log total assets"),
  c("cubic", "Cubic in log total assets"),
  c("bins", "Size quintile indicators"),
  c("size_g3", "Quadratic, total assets at g − 3"),
  c("trim99", "Scored firms ≤ 99th percentile of controls"),
  c("trim95", "Scored firms ≤ 95th percentile of controls"),
  c("trim90", "Scored firms ≤ 90th percentile of controls"),
  c("dr_trim95", "Doubly robust, ≤ 95th percentile"),
  c("dr_trim90", "Doubly robust, ≤ 90th percentile"))
t5 <- do.call(rbind, lapply(t5_rows, function(r) {
  a <- pick(sup, "ln_mtb", r[1]); b <- pick(sup, "ln_mcap", r[1])
  data.frame(Specification = r[2], `ln(MTB)` = cellf(a), `ln(market cap)` = cellf(b),
             `Scored firms in averaged event years` = fmtn(a$n_treated_firms), check.names = FALSE)
}))
write.csv(t5, file.path(OUT, "tableSAJE5_formatted.csv"), row.names = FALSE)

# ---- Table 6: scored firms retained and excluded by the size-range restriction ----
ret <- rd("s_support_retained.csv")
r_ <- ret[ret$group == "retained", ]; e_ <- ret[ret$group == "excluded", ]; n_ <- ret[ret$group == "never_scored_all_years", ]
t6 <- data.frame(
  Characteristic = c("Firms", "Median total assets (USD million)", "Median market capitalization (USD million)",
                     "Median market-to-book ratio", "Mean book leverage", "Mean initial ESG score",
                     "Share Malaysian", "Share Thai", "Share Indonesian", "Share Singaporean", "Share Philippine",
                     "Share first recorded by 2020"),
  Retained = c(fmtn(r_$firms), fmtm(r_$med_assets_musd), fmtm(r_$med_mcap_musd), fmt(r_$med_mtb, 2),
               fmt(r_$mean_lev), fmt(r_$mean_score0, 1), fmt(r_$share_MY, 2), fmt(r_$share_TH, 2), fmt(r_$share_ID, 2),
               fmt(r_$share_SG, 2), fmt(r_$share_PH, 2), fmt(r_$share_cohort_le2020, 2)),
  Excluded = c(fmtn(e_$firms), fmtm(e_$med_assets_musd), fmtm(e_$med_mcap_musd), fmt(e_$med_mtb, 2),
               fmt(e_$mean_lev), fmt(e_$mean_score0, 1), fmt(e_$share_MY, 2), fmt(e_$share_TH, 2), fmt(e_$share_ID, 2),
               fmt(e_$share_SG, 2), fmt(e_$share_PH, 2), fmt(e_$share_cohort_le2020, 2)),
  `Never-scored (all years)` = c(fmtn(n_$firms), fmtm(n_$med_assets_musd), fmtm(n_$med_mcap_musd),
               fmt(n_$med_mtb, 2), fmt(n_$mean_lev), "", "", "", "", "", "", ""), check.names = FALSE)
write.csv(t6, file.path(OUT, "tableSAJE6_formatted.csv"), row.names = FALSE)

# ---- Table 7: missing MTB ratios and data errors ----
mc <- rd("s_missing_compare.csv"); ms <- rd("s_missing_source.csv")
grp <- function(g, h) mc[mc$group == g & mc$has_mtb == h, ]
cols <- list(c("scored", TRUE), c("scored", FALSE), c("never_scored", TRUE), c("never_scored", FALSE))
t7 <- data.frame(Characteristic = c("Firm-years", "Median total assets (USD million)",
  "Median market capitalization (USD million)", "Mean book leverage", "Share with leverage above 0.5",
  "Share Indonesian", "Share Malaysian", "Mean calendar year", "Share with market capitalization"))
nm <- c("Scored, MTB observed", "Scored, MTB missing", "Never-scored, MTB observed", "Never-scored, MTB missing")
for (k in seq_along(cols)) {
  x <- grp(cols[[k]][1], as.logical(cols[[k]][2]))
  t7[[nm[k]]] <- c(fmtn(x$firm_years), fmtm(x$med_assets_musd), fmtm(x$med_mcap_musd), fmt(x$mean_lev),
                   fmt(x$share_lev_above_05, 2), fmt(x$share_ID, 2), fmt(x$share_MY, 2), fmt(x$mean_year, 1),
                   fmt(x$share_with_mcap, 2))
}
write.csv(t7, file.path(OUT, "tableSAJE7_formatted.csv"), row.names = FALSE)

# ---- Table 8: selection and data-error checks ----
mk <- rd("s_missing_checks.csv"); ol <- rd("s_outliers.csv")
row8 <- function(lbl, a, b) data.frame(Specification = lbl, `ln(MTB)` = if (nrow(a)) cellf(a) else "",
  `ln(market cap)` = if (nrow(b)) cellf(b) else "",
  `Scored firms in averaged event years` = if (nrow(a)) fmtn(a$n_treated_firms) else if (nrow(b)) fmtn(b$n_treated_firms) else "",
  check.names = FALSE)
none <- mk[0, ]
t8 <- rbind(
  row8("Baseline", pick(sup, "ln_mtb", "baseline"), pick(sup, "ln_mcap", "baseline")),
  row8("Market capitalization on firm-years with an MTB ratio", none, pick(mk, "ln_mcap", "mcap_on_mtb_sample")),
  row8("Complete MTB series, scored and control firms", pick(mk, "ln_mtb", "complete_mtb_series"), none),
  row8("Complete MTB series, scored firms only", pick(mk, "ln_mtb", "complete_mtb_scored_only"), none),
  row8("Flagged firm-years removed", pick(ol, "ln_mtb", "drop_flagged_firm_years"), pick(ol, "ln_mcap", "drop_flagged_firm_years")),
  row8("Firms with any flagged year removed", pick(ol, "ln_mtb", "drop_flagged_firms"), pick(ol, "ln_mcap", "drop_flagged_firms")),
  row8("Firm-years with implied book equity above twice total assets removed", pick(ol, "ln_mtb", "drop_ratio2_firm_years"),
       pick(ol, "ln_mcap", "drop_ratio2_firm_years")),
  row8("Winsorized within market and year", pick(ol, "ln_mtb", "winsor_market_year"), pick(ol, "ln_mcap", "winsor_market_year")))
write.csv(t8, file.path(OUT, "tableSAJE8_formatted.csv"), row.names = FALSE)

# ---- Table S9: composition of the pooled estimate; Table S10: dating by wave ----
wt <- rd("s_weights.csv")
lab <- c(ID = "Indonesia", MY = "Malaysia", PH = "Philippines", SG = "Singapore", TH = "Thailand",
         MY_2021_22 = "Malaysian wave (first recorded 2021–2022)", TH_SG_2019_20 = "Thai and Singaporean wave (2019–2020)",
         other = "All other cohorts")
s9 <- wt %>% mutate(level = ifelse(dim == "calendar_year", paste("Calendar year", level), level)) %>%
  transmute(Group = ifelse(level %in% names(lab), lab[level], level), `Scored firm-cells` = fmtn(firm_cells),
            `Weight in the pooled estimate` = fmt(weight, 3))
write.csv(s9, file.path(OUT, "tableSAJES9_formatted.csv"), row.names = FALSE)
wv <- rd("s_waves_dating.csv")
s10 <- do.call(rbind, lapply(c("MY_2021_22", "TH_SG_2019_20", "other"), function(w) {
  data.frame(Wave = lab[[w]],
    `First recorded year, ln(MTB)` = cellf(pick(wv, "ln_mtb", paste0("base_", w))),
    `One year later, ln(MTB)` = cellf(pick(wv, "ln_mtb", paste0("R10_", w))),
    `First recorded year, ln(market cap)` = cellf(pick(wv, "ln_mcap", paste0("base_", w))),
    `One year later, ln(market cap)` = cellf(pick(wv, "ln_mcap", paste0("R10_", w))), check.names = FALSE)
}))
write.csv(s10, file.path(OUT, "tableSAJES10_formatted.csv"), row.names = FALSE)
