# 03c_saje.R: analyses for the Southeast Asian Journal of Economics revision (manuscript 292892, Reviewer A).
# All analyses are exploratory (not in the pre-analysis plan). Outputs carry the prefix s_.
# (a) R10 decomposition (comment 3): treatment date, reference period, covariate timing and estimation sample.
# (b) Common support (comment 4): retained vs excluded scored firms, size-adjustment variants, doubly robust estimator.
# (c) Missing MTB (comment 6): firm-years with and without MTB, sample-selection checks.
# (d) Implausible market capitalization (comment 6): internal-consistency flag and exclusion checks.
# (e) Composition of the pooled estimate (comment 7): weight of each market and coverage wave.
# (f) Publication dating by coverage wave (comments 1, 3, 7).
# Every estimate reuses WBOOT (firm bootstrap, fixed seed), so differences between rows have valid joint draws.

S_OUT <- c("ln_mtb", "ln_mcap")
CTRY <- sort(unique(panel$country)); INDS <- sort(unique(panel$industry_code))
tr_info <- panel %>% filter(treated) %>% distinct(firm_id, G, country)

# Covariate matrix: quadratic in base-year log assets (baseline), none, linear, cubic, or quintile bins.
make_X2 <- function(df, covars) {
  if (isFALSE(covars)) return(matrix(1, nrow(df), 1, dimnames = list(NULL, "(Intercept)")))
  fe <- "factor(country, levels = CTRY) + factor(industry_code, levels = INDS)"
  f <- switch(as.character(covars),
    "TRUE"  = paste("~ lnA_b + I(lnA_b^2) +", fe),
    linear  = paste("~ lnA_b +", fe),
    cubic   = paste("~ lnA_b + I(lnA_b^2) + I(lnA_b^3) +", fe),
    bins    = paste("~ size_bin +", fe))
  if (identical(covars, "bins")) df$size_bin <- factor(findInterval(df$lnA_b, SIZE_BREAKS) + 1L, levels = 1:5)
  model.matrix(as.formula(f), data = df)
}

# Cells (g, t) defined relative to the first recorded score year g. base_off and size_off are offsets from g
# (baseline: -1 and -1). common = TRUE keeps only firms observed at both g - 1 and g, so that the reference period can
# move without changing the firms. drop_flag removes firm-years flagged in (d). keep_firms restricts every firm.
build_cells2 <- function(y, covars = TRUE, base_off = -1L, size_off = -1L, common = FALSE, max_cohort = Inf,
                         trim_q = NULL, keep_treated = NULL, keep_firms = NULL, drop_fy = NULL, dr = FALSE,
                         data = panel) {
  d <- data %>% mutate(yv = .data[[y]], size_b = ln_asset) %>%
    select(firm_id, year, G, country, industry_code, size_b, yv)
  if (!is.null(drop_fy)) d <- d %>% mutate(yv = ifelse(paste(firm_id, year) %in% drop_fy, NA, yv))
  if (!is.null(keep_firms)) d <- d %>% filter(firm_id %in% keep_firms)
  wide_y <- d %>% select(firm_id, year, yv); wide_a <- d %>% select(firm_id, year, size_b)
  info <- d %>% distinct(firm_id, G, country, industry_code)
  cohorts <- sort(unique(info$G[is.finite(info$G)]))
  cohorts <- cohorts[cohorts - 1 >= min(d$year) & cohorts <= max_cohort]
  years <- sort(unique(d$year)); cells <- list()
  for (g in cohorts) {
    base <- g + base_off
    if (!(base %in% years)) next
    yb <- wide_y %>% filter(year == base, !is.na(yv)) %>% select(firm_id, yb = yv)
    if (common) {
      both <- wide_y %>% filter(year %in% c(g - 1, g), !is.na(yv)) %>% count(firm_id) %>% filter(n == 2)
      yb <- yb %>% filter(firm_id %in% both$firm_id)
    }
    ab <- wide_a %>% filter(year == g + size_off, !is.na(size_b)) %>% select(firm_id, lnA_b = size_b)
    for (t in setdiff(years, base)) {
      e <- t - g
      if (e < E_MIN || e > E_MAX) next
      yt <- wide_y %>% filter(year == t, !is.na(yv)) %>% select(firm_id, yt = yv)
      cd <- info %>% inner_join(yb, by = "firm_id") %>% inner_join(ab, by = "firm_id") %>%
        inner_join(yt, by = "firm_id") %>% mutate(dY = yt - yb)
      tr <- cd %>% filter(G == g); co <- cd %>% filter(!is.finite(G))
      if (!is.null(keep_treated)) tr <- tr %>% filter(firm_id %in% keep_treated)
      if (!is.null(trim_q) && nrow(co) > 0) tr <- tr %>% filter(lnA_b <= quantile(co$lnA_b, trim_q, names = FALSE))
      if (nrow(tr) == 0 || nrow(co) < 30) next
      cells[[length(cells) + 1]] <- list(g = g, t = t, e = e, it = match(tr$firm_id, FIRMS),
        ic = match(co$firm_id, FIRMS), yt = tr$dY, yc = co$dY, Xt = make_X2(tr, covars), Xc = make_X2(co, covars),
        ctry_t = tr$country, dr = dr)
    }
  }
  cells
}

# ATT(g,t) per cell; outcome regression (baseline) or doubly robust (Sant'Anna and Zhao, 2020) with a logit
# propensity score on the same covariates, odds weights capped at p = 0.99.
cell_atts2 <- function(cells, w) {
  out <- matrix(NA_real_, length(cells), 2)
  for (k in seq_along(cells)) {
    cl <- cells[[k]]; wt <- w[cl$it]; wc <- w[cl$ic]; swt <- sum(wt)
    if (swt == 0 || sum(wc > 0) < ncol(cl$Xc)) next
    b <- lm.wfit(cl$Xc, cl$yc, wc)$coefficients; b[is.na(b)] <- 0
    rt <- cl$yt - drop(cl$Xt %*% b); rc <- cl$yc - drop(cl$Xc %*% b)
    if (!cl$dr) { out[k, ] <- c(sum(wt * rt) / swt, swt); next }
    X <- rbind(cl$Xt, cl$Xc); D <- c(rep(1, nrow(cl$Xt)), rep(0, nrow(cl$Xc))); ww <- c(wt, wc)
    keep <- ww > 0
    fit <- suppressWarnings(glm.fit(X[keep, , drop = FALSE], D[keep], weights = ww[keep], family = binomial()))
    g1 <- fit$coefficients; g1[is.na(g1)] <- 0
    p <- pmin(plogis(drop(cl$Xc %*% g1)), 0.99); odds <- wc * p / (1 - p)
    out[k, ] <- c(sum(wt * rt) / swt - sum(odds * rc) / sum(odds), swt)
  }
  out
}

# Average over a window of event times [lo, hi] relative to g, weighting cells by scored firms (Eq. 6).
agg_win <- function(cells, ca, lo, hi) {
  e <- vapply(cells, `[[`, numeric(1), "e")
  s <- which(e >= lo & e <= hi & !is.na(ca[, 1]))
  if (!length(s)) return(NA_real_)
  sum(ca[s, 1] * ca[s, 2]) / sum(ca[s, 2])
}

CACHE <- file.path(OUT, "cache_saje"); dir.create(CACHE, showWarnings = FALSE)
run_win <- function(y, lo = 0L, hi = 3L, ..., W = WBOOT) {
  # Results are cached by their arguments and the bootstrap matrix, so an interrupted run resumes where it stopped.
  # The key also covers the data and the code of the estimator, so a changed input never returns a stale result.
  if (!exists("CACHE_SIG")) CACHE_SIG <<- list(unname(tools::md5sum(c("R/00_setup.R", "R/01_data.R", "R/02_cs_did.R"))),
    dim(panel), lapply(panel[vapply(panel, is.numeric, logical(1))], sum, na.rm = TRUE),
    lapply(list(make_X2, build_cells2, cell_atts2, agg_win, run_win_), deparse))
  tf <- tempfile(); saveRDS(list(y, lo, hi, list(...), dim(W), sum(W[1:50, 1:50]), CACHE_SIG), tf)
  ck <- file.path(CACHE, paste0(unname(tools::md5sum(tf)), ".rds")); unlink(tf)
  if (file.exists(ck)) return(readRDS(ck))
  res <- run_win_(y, lo, hi, ..., W = W); saveRDS(res, ck); res
}
run_win_ <- function(y, lo = 0L, hi = 3L, ..., W = WBOOT) {
  cells <- build_cells2(y, ...)
  cells <- cells[vapply(cells, function(cl) cl$e >= lo && cl$e <= hi, logical(1))]   # only cells in the window
  est <- agg_win(cells, cell_atts2(cells, rep(1L, NF)), lo, hi)
  draws <- unlist(parallel::mclapply(seq_len(ncol(W)), function(b)
    agg_win(cells, cell_atts2(cells, W[, b]), lo, hi), mc.cores = N_CORES))
  e <- vapply(cells, `[[`, numeric(1), "e"); s <- e >= lo & e <= hi
  list(est = est, draws = draws, cells = cells[s],
       n_treated_firms = length(unique(unlist(lapply(cells[s], `[[`, "it")))),
       n_control_firms = length(unique(unlist(lapply(cells[s], `[[`, "ic")))),
       n_cohorts = length(unique(vapply(cells[s], `[[`, numeric(1), "g"))))
}

row_of <- function(r, y, spec, ...) {
  se <- sd(r$draws, na.rm = TRUE)
  data.frame(outcome = y, spec = spec, est = r$est, se = se,
             ci_lo = quantile(r$draws, 0.025, na.rm = TRUE, names = FALSE),
             ci_hi = quantile(r$draws, 0.975, na.rm = TRUE, names = FALSE), p = 2 * pnorm(-abs(r$est / se)),
             n_treated_firms = r$n_treated_firms, n_control_firms = r$n_control_firms, n_cohorts = r$n_cohorts, ...)
}
diff_row <- function(a, b, y, spec) {
  dd <- a$est - b$est; dr <- a$draws - b$draws; se <- sd(dr, na.rm = TRUE)
  data.frame(outcome = y, spec = spec, est = dd, se = se, ci_lo = quantile(dr, 0.025, na.rm = TRUE, names = FALSE),
             ci_hi = quantile(dr, 0.975, na.rm = TRUE, names = FALSE), p = 2 * pnorm(-abs(dd / se)),
             n_treated_firms = NA, n_control_firms = NA, n_cohorts = NA)
}

# ---- (a) R10 decomposition ----
# A0 baseline; A1 baseline on the common sample; B1 window moved to event years 1-4 (reference g - 1);
# C1 reference period moved to g (= dating coverage one year later) with size still at g - 1; C2 size at g (R10 on the
# common sample); C3 R10 as published (all firms). Suffix _b: cohorts observed through event year 4 (g <= 2020).
dec_rows <- list(); dec_res <- list()
for (y in S_OUT) {
  cat("SAJE decomposition:", y, "\n")
  sp <- list(
    A0 = list(lo = 0, hi = 3), A1 = list(lo = 0, hi = 3, common = TRUE),
    B1 = list(lo = 1, hi = 4, common = TRUE), C1 = list(lo = 1, hi = 4, common = TRUE, base_off = 0),
    C2 = list(lo = 1, hi = 4, common = TRUE, base_off = 0, size_off = 0),
    C3 = list(lo = 1, hi = 4, base_off = 0, size_off = 0),
    A1_b = list(lo = 0, hi = 3, common = TRUE, max_cohort = 2020),
    B1_b = list(lo = 1, hi = 4, common = TRUE, max_cohort = 2020),
    C1_b = list(lo = 1, hi = 4, common = TRUE, base_off = 0, max_cohort = 2020),
    C2_b = list(lo = 1, hi = 4, common = TRUE, base_off = 0, size_off = 0, max_cohort = 2020))
  for (k in names(sp)) {
    r <- do.call(run_win, c(list(y = y), sp[[k]])); dec_res[[paste(y, k)]] <- r
    dec_rows[[paste(y, k)]] <- row_of(r, y, k)
  }
  R <- function(k) dec_res[[paste(y, k)]]
  dec_rows[[paste(y, "d_sample")]] <- diff_row(R("A1"), R("A0"), y, "d_sample_A1_A0")
  dec_rows[[paste(y, "d_window")]] <- diff_row(R("B1"), R("A1"), y, "d_window_B1_A1")
  dec_rows[[paste(y, "d_reference")]] <- diff_row(R("C1"), R("B1"), y, "d_reference_C1_B1")
  dec_rows[[paste(y, "d_size")]] <- diff_row(R("C2"), R("C1"), y, "d_size_C2_C1")
  dec_rows[[paste(y, "d_sample2")]] <- diff_row(R("C3"), R("C2"), y, "d_sample_C3_C2")
  dec_rows[[paste(y, "d_window_b")]] <- diff_row(R("B1_b"), R("A1_b"), y, "d_window_b")
  dec_rows[[paste(y, "d_reference_b")]] <- diff_row(R("C1_b"), R("B1_b"), y, "d_reference_b")
  dec_rows[[paste(y, "d_size_b")]] <- diff_row(R("C2_b"), R("C1_b"), y, "d_size_b")
}
write_out(bind_rows(dec_rows), "s_r10_decomposition.csv")

# Event-time paths on the common sample (reference g - 1 and reference g), for the reconciliation figure.
path_rows <- list()
for (y in S_OUT) for (bo in c(-1L, 0L)) {
  cells <- build_cells2(y, common = TRUE, base_off = bo, size_off = bo)
  ca <- cell_atts2(cells, rep(1L, NF))
  dr <- parallel::mclapply(seq_len(ncol(WBOOT)), function(b) cell_atts2(cells, WBOOT[, b])[, 1], mc.cores = N_CORES)
  e <- vapply(cells, `[[`, numeric(1), "e")
  for (k in sort(unique(e))) {
    s <- which(e == k & !is.na(ca[, 1])); if (!length(s)) next
    agg <- function(v) sum(v[s] * ca[s, 2]) / sum(ca[s, 2])
    dk <- vapply(dr, agg, numeric(1))
    path_rows[[paste(y, bo, k)]] <- data.frame(outcome = y, reference = ifelse(bo == -1L, "g-1", "g"), e = k,
      est = agg(ca[, 1]), se = sd(dk, na.rm = TRUE), ci_lo = quantile(dk, 0.025, na.rm = TRUE, names = FALSE),
      ci_hi = quantile(dk, 0.975, na.rm = TRUE, names = FALSE), scored_firms = sum(ca[s, 2]))
  }
}
write_out(bind_rows(path_rows), "s_common_paths.csv")

# ---- (b) Common support ----
sup_rows <- list(); sup_res <- list()
sup_specs <- list(
  baseline = list(), no_covariates = list(covars = FALSE), linear = list(covars = "linear"),
  cubic = list(covars = "cubic"), bins = list(covars = "bins"), size_g3 = list(size_off = -3L),
  trim90 = list(trim_q = 0.90), trim95 = list(trim_q = 0.95), trim99 = list(trim_q = 0.99),
  dr_trim95 = list(trim_q = 0.95, dr = TRUE), dr_trim90 = list(trim_q = 0.90, dr = TRUE))
for (y in S_OUT) for (k in names(sup_specs)) {
  cat("SAJE support:", y, k, "\n")
  r <- do.call(run_win, c(list(y = y), sup_specs[[k]])); sup_res[[paste(y, k)]] <- r
  sup_rows[[paste(y, k)]] <- row_of(r, y, k)
}
write_out(bind_rows(sup_rows), "s_support.csv")

# Retained vs excluded scored firms under the 95th-percentile restriction (ln MTB cells).
ret_ids <- FIRMS[unique(unlist(lapply(sup_res[["ln_mtb trim95"]]$cells, `[[`, "it")))]
all_ids <- FIRMS[unique(unlist(lapply(sup_res[["ln_mtb baseline"]]$cells, `[[`, "it")))]
exc_ids <- setdiff(all_ids, ret_ids)
base_tr <- panel %>% filter(treated, year == G - 1) %>% mutate(group = case_when(
  firm_id %in% ret_ids ~ "retained", firm_id %in% exc_ids ~ "excluded", TRUE ~ "not_in_mtb_estimate"))
ret_tab <- base_tr %>% filter(group != "not_in_mtb_estimate") %>% group_by(group) %>%
  summarise(firms = n(), med_assets_musd = median(asset_w, na.rm = TRUE) / 1e6,
            med_mcap_musd = median(mcap_w, na.rm = TRUE) / 1e6, med_mtb = median(mtb_w, na.rm = TRUE),
            mean_lev = mean(lev_w, na.rm = TRUE), mean_score0 = mean(score0, na.rm = TRUE),
            share_MY = mean(country == "MY"), share_TH = mean(country == "TH"), share_ID = mean(country == "ID"),
            share_SG = mean(country == "SG"), share_PH = mean(country == "PH"),
            share_cohort_le2020 = mean(G <= 2020), mean_cohort = mean(G))
nev_b <- panel %>% filter(!treated) %>% summarise(group = "never_scored_all_years", firms = n_distinct(firm_id),
  med_assets_musd = median(asset_w, na.rm = TRUE) / 1e6, med_mcap_musd = median(mcap_w, na.rm = TRUE) / 1e6,
  med_mtb = median(mtb_w, na.rm = TRUE), mean_lev = mean(lev_w, na.rm = TRUE))
write_out(bind_rows(ret_tab, nev_b), "s_support_retained.csv")

# Propensity-score overlap in the DR cells (share of scored firm-cells with p above 0.95; controls below 0.05).
ps_rows <- list()
for (k in c("dr_trim95", "dr_trim90")) {
  cells <- sup_res[[paste("ln_mtb", k)]]$cells; hi <- 0; nt <- 0; mx <- 0
  for (cl in cells) {
    X <- rbind(cl$Xt, cl$Xc); D <- c(rep(1, nrow(cl$Xt)), rep(0, nrow(cl$Xc)))
    g1 <- suppressWarnings(glm.fit(X, D, family = binomial()))$coefficients; g1[is.na(g1)] <- 0
    pt <- plogis(drop(cl$Xt %*% g1)); hi <- hi + sum(pt > 0.95); nt <- nt + length(pt); mx <- max(mx, pt)
  }
  ps_rows[[k]] <- data.frame(spec = k, scored_firm_cells = nt, share_p_above_095 = hi / nt, max_p = mx)
}
write_out(bind_rows(ps_rows), "s_support_pscore.csv")

# ---- (c) Missing MTB ----
raw_nf <- raw %>% filter(industry_code != "financials") %>% inner_join(timing %>% select(firm_id, G), by = "firm_id") %>%
  filter(G != 2014)
miss_src <- raw_nf %>% mutate(group = ifelse(is.finite(G), "scored", "never_scored"),
                              mtb_missing = is.na(mtb), mcap_obs = !is.na(marketcap) & marketcap > 0,
                              asset_obs = !is.na(asset) & asset > 0) %>%
  group_by(group) %>% summarise(firm_years = n(), share_mtb_missing = mean(mtb_missing),
    share_missing_with_mcap = mean(mcap_obs[mtb_missing]), share_missing_with_assets = mean(asset_obs[mtb_missing]),
    n_mtb_nonpositive = sum(!is.na(mtb) & mtb <= 0))
write_out(miss_src, "s_missing_source.csv")

# Firm-years with and without MTB, by group: size, leverage, market, year.
mcmp <- panel %>% mutate(group = ifelse(treated, "scored", "never_scored"), has_mtb = !is.na(ln_mtb)) %>%
  group_by(group, has_mtb) %>%
  summarise(firm_years = n(), firms = n_distinct(firm_id), med_assets_musd = median(asset_w, na.rm = TRUE) / 1e6,
            med_mcap_musd = median(mcap_w, na.rm = TRUE) / 1e6, mean_lev = mean(lev_w, na.rm = TRUE),
            share_lev_above_05 = mean(lev_w > 0.5, na.rm = TRUE), mean_roa = mean(roa_w, na.rm = TRUE),
            share_ID = mean(country == "ID"), share_MY = mean(country == "MY"), share_TH = mean(country == "TH"),
            share_SG = mean(country == "SG"), share_PH = mean(country == "PH"), mean_year = mean(year),
            share_with_mcap = mean(!is.na(mcap_w)), .groups = "drop")
write_out(mcmp, "s_missing_compare.csv")

# Scored firms that enter vs. do not enter the ln MTB estimate.
in_mtb <- FIRMS[unique(unlist(lapply(sup_res[["ln_mtb baseline"]]$cells, `[[`, "it")))]
ent <- panel %>% filter(treated, year == G - 1) %>% mutate(enters = firm_id %in% in_mtb) %>% group_by(enters) %>%
  summarise(firms = n(), med_assets_musd = median(asset_w, na.rm = TRUE) / 1e6,
            med_mcap_musd = median(mcap_w, na.rm = TRUE) / 1e6, share_MY = mean(country == "MY"), mean_cohort = mean(G))
write_out(ent, "s_missing_scored_entry.csv")

# Selection checks: (i) ln market cap estimated only on firm-years with an observed MTB ratio; (ii) ln MTB on firms
# whose MTB is observed in every year from g - 1 to g + 3 (scored) or 2014-2024 (controls, complete series).
mtb_fy <- panel %>% filter(!is.na(ln_mtb)) %>% transmute(k = paste(firm_id, year))
no_mtb_fy <- panel %>% filter(is.na(ln_mtb)) %>% transmute(k = paste(firm_id, year))
full_ctrl <- panel %>% filter(!treated) %>% group_by(firm_id) %>% summarise(ok = all(!is.na(ln_mtb)) & n() == 11) %>%
  filter(ok) %>% pull(firm_id)
full_tr <- panel %>% filter(treated, year >= G - 1, year <= pmin(G + 3, 2024)) %>% group_by(firm_id, G) %>%
  summarise(ok = all(!is.na(ln_mtb)) & n() == (pmin(first(G) + 3, 2024) - first(G) + 2), .groups = "drop") %>%
  filter(ok) %>% pull(firm_id)
miss_rows <- list()
r <- run_win("ln_mcap", drop_fy = no_mtb_fy$k); miss_rows$mcap_mtbsample <- row_of(r, "ln_mcap", "mcap_on_mtb_sample")
miss_rows$mcap_base <- row_of(sup_res[["ln_mcap baseline"]], "ln_mcap", "baseline")
r <- run_win("ln_mtb", keep_firms = c(full_ctrl, full_tr))
miss_rows$mtb_complete <- row_of(r, "ln_mtb", "complete_mtb_series")
r <- run_win("ln_mtb", keep_firms = c(panel$firm_id[!panel$treated], full_tr))
miss_rows$mtb_complete_tr <- row_of(r, "ln_mtb", "complete_mtb_scored_only")
write_out(bind_rows(miss_rows), "s_missing_checks.csv")

# ---- (d) Implausible market capitalization ----
# Flag: market capitalization divided by the MTB ratio gives the implied book equity, which cannot exceed total
# assets. Ratios between 1 and 2 can arise from measurement dates; an implied book equity above ten times total
# assets (an order of magnitude) indicates a unit or scale error. Flagged firm-years lose both market outcomes.
flag <- raw_nf %>% filter(!is.na(marketcap), !is.na(mtb), !is.na(asset), mtb > 0, asset > 0) %>%
  mutate(ratio = (marketcap / mtb) / asset, flag = ratio > 10, flag2 = ratio > 2)
flag_fy <- flag %>% filter(flag) %>% transmute(k = paste(firm_id, year), firm_id, year, country, G)
flag2_fy <- flag %>% filter(flag2) %>% transmute(k = paste(firm_id, year))
fsum <- function(d) summarise(d, checked = n(), flagged = sum(flag), flagged_scored = sum(flag & is.finite(G)),
  firms_flagged = n_distinct(firm_id[flag]), flagged_ratio2 = sum(flag2), ratio_1_2 = sum(ratio > 1 & ratio <= 2),
  ratio_2_10 = sum(ratio > 2 & ratio <= 10), max_mcap_busd = max(marketcap) / 1e9)
flag_sum <- bind_rows(flag %>% group_by(country) %>% fsum(), flag %>% fsum() %>% mutate(country = "All"))
write_out(flag_sum, "s_flag_summary.csv")
out_rows <- list()
for (y in S_OUT) {
  cat("SAJE outliers:", y, "\n")
  r <- run_win(y, drop_fy = flag_fy$k); out_rows[[paste(y, 1)]] <- row_of(r, y, "drop_flagged_firm_years")
  r <- run_win(y, keep_firms = setdiff(FIRMS, flag_fy$firm_id))
  out_rows[[paste(y, 2)]] <- row_of(r, y, "drop_flagged_firms")
  r <- run_win(y, drop_fy = flag2_fy$k); out_rows[[paste(y, 4)]] <- row_of(r, y, "drop_ratio2_firm_years")
  # Winsorization within market and year instead of the pooled sample (from the raw values).
  pw <- panel %>% select(-ln_mtb, -ln_mcap) %>%
    left_join(raw_nf %>% select(firm_id, year, mtb, marketcap), by = c("firm_id", "year")) %>%
    group_by(country, year) %>%
    mutate(ln_mtb = log(winsor(ifelse(mtb > 0, mtb, NA))), ln_mcap = log(winsor(ifelse(marketcap > 0, marketcap, NA)))) %>%
    ungroup()
  r <- run_win(y, data = pw); out_rows[[paste(y, 3)]] <- row_of(r, y, "winsor_market_year")
}
write_out(bind_rows(out_rows), "s_outliers.csv")

# ---- (e) Composition of the pooled estimate ----
cells <- sup_res[["ln_mtb baseline"]]$cells
comp <- bind_rows(lapply(cells, function(cl) data.frame(g = cl$g, e = cl$e, country = cl$ctry_t))) %>%
  mutate(wave = case_when(country == "MY" & g %in% 2021:2022 ~ "MY_2021_22",
                          country %in% c("TH", "SG") & g %in% 2019:2020 ~ "TH_SG_2019_20", TRUE ~ "other"))
comp_m <- comp %>% count(country) %>% mutate(weight = n / sum(n))
comp_w <- comp %>% count(wave) %>% mutate(weight = n / sum(n))
comp_y <- comp %>% count(year = g + e) %>% mutate(weight = n / sum(n))
write_out(bind_rows(comp_m %>% transmute(dim = "market", level = country, firm_cells = n, weight),
                    comp_w %>% transmute(dim = "wave", level = wave, firm_cells = n, weight),
                    comp_y %>% transmute(dim = "calendar_year", level = as.character(year), firm_cells = n, weight)),
          "s_weights.csv")

# ---- (f) Dating coverage one year later, by wave ----
wav_rows <- list()
wav_ids <- list(MY_2021_22 = tr_info$firm_id[tr_info$country == "MY" & tr_info$G %in% 2021:2022],
                TH_SG_2019_20 = tr_info$firm_id[tr_info$country %in% c("TH", "SG") & tr_info$G %in% 2019:2020])
wav_ids$other <- setdiff(tr_info$firm_id, unlist(wav_ids))
for (y in S_OUT) for (w in names(wav_ids)) {
  cat("SAJE wave R10:", y, w, "\n")
  r <- run_win(y, lo = 1, hi = 4, base_off = 0, size_off = 0, keep_treated = wav_ids[[w]])
  wav_rows[[paste(y, w)]] <- row_of(r, y, paste0("R10_", w))
  r <- run_win(y, lo = 0, hi = 3, keep_treated = wav_ids[[w]])
  wav_rows[[paste(y, w, "b")]] <- row_of(r, y, paste0("base_", w))
}
write_out(bind_rows(wav_rows), "s_waves_dating.csv")

# ---- (g) Cells in which a country or industry indicator has no control firm ----
# lm.wfit returns NA for such a coefficient and cell_atts2 sets it to zero, so scored firms with that indicator are
# predicted at the reference level. Counted for the baseline cells of event years 0 to 3.
na_rows <- list()
for (y in S_OUT) {
  cells <- build_cells2(y); cells <- cells[vapply(cells, function(cl) cl$e >= 0 && cl$e <= 3, logical(1))]
  hit <- vapply(cells, function(cl) {
    b <- lm.wfit(cl$Xc, cl$yc)$coefficients; na <- names(b)[is.na(b)]
    c(any(colSums(cl$Xt[, na, drop = FALSE]) > 0), sum(rowSums(cl$Xt[, na, drop = FALSE]) > 0), nrow(cl$Xt))
  }, numeric(3))
  na_rows[[y]] <- data.frame(outcome = y, cells = length(cells), cells_affected = sum(hit[1, ] > 0),
                             scored_firm_cells = sum(hit[3, ]), scored_firm_cells_affected = sum(hit[2, ]))
}
write_out(bind_rows(na_rows), "s_na_coefficients.csv")
