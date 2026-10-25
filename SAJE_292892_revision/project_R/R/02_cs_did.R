# 02_cs_did.R: Callaway and Sant'Anna (2021) group-time ATT with outcome-regression adjustment,
# universal base period g-1, never-treated (or not-yet-treated) controls, and a firm-cluster bootstrap
# implemented through frequency weights (resampling firms with replacement).

FIRMS <- sort(unique(panel$firm_id))
NF    <- length(FIRMS)

# Bootstrap weight matrix: one column per replication, shared by every specification so that
# differences between specifications (e.g., high vs. low initial score) have a valid joint distribution.
set.seed(SEED)
WBOOT <- vapply(seq_len(B_BOOT), function(b) tabulate(sample.int(NF, NF, replace = TRUE), NF), integer(NF))

# Revision round 4: size quintile bins (breaks from the whole panel) as an alternative to the quadratic in size.
SIZE_BREAKS <- quantile(panel$ln_asset, c(0.2, 0.4, 0.6, 0.8), na.rm = TRUE, names = FALSE)

make_X <- function(df, covars) {
  if (isFALSE(covars)) return(matrix(1, nrow(df), 1, dimnames = list(NULL, "(Intercept)")))
  if (identical(covars, "bins")) {
    df$size_bin <- factor(findInterval(df$lnA_b, SIZE_BREAKS) + 1L, levels = 1:5)
    return(model.matrix(~ size_bin + factor(country, levels = sort(unique(panel$country))) +
                          factor(industry_code, levels = sort(unique(panel$industry_code))), data = df))
  }
  model.matrix(~ lnA_b + I(lnA_b^2) + factor(country, levels = sort(unique(panel$country))) +
                 factor(industry_code, levels = sort(unique(panel$industry_code))), data = df)
}

# Build all 2x2 cells (g, t) for outcome y.
build_cells <- function(y, control = c("never", "notyet"), covars = TRUE, drop_cohorts = NULL,
                        support = FALSE, placebo = FALSE, treated_subset = NULL, pregrowth = FALSE,
                        exclude_country = NULL, only_country = NULL, shift_G = 0,
                        size_lag = 0, keep_treated = NULL, trim_top = FALSE) {
  control <- match.arg(control)
  d <- panel %>% mutate(yv = .data[[y]], size_b = ln_asset) %>%
    select(firm_id, year, G, country, industry_code, size_b, yv, high0, ln_mcap)
  if (!is.null(exclude_country)) d <- d %>% filter(!(country %in% exclude_country))
  if (!is.null(only_country)) d <- d %>% filter(country %in% only_country)
  # Revision round 2 (R10): date treatment one year after the first recorded score (publication lag / backfilling).
  if (shift_G != 0) d <- d %>% mutate(G = ifelse(is.finite(G), G + shift_G, G)) %>% filter(!is.finite(G) | G <= max(year) + 1)
  if (placebo) {
    # Fake treatment three years before true coverage; keep only truly untreated years of treated firms.
    d <- d %>% filter(!is.finite(G) | year < G) %>% mutate(G = ifelse(is.finite(G), G - 3, G))
  }
  if (!is.null(drop_cohorts)) d <- d %>% filter(!(G %in% drop_cohorts))
  wide_y <- d %>% select(firm_id, year, yv)
  wide_a <- d %>% select(firm_id, year, size_b)
  info   <- d %>% distinct(firm_id, G, country, industry_code, high0)
  cohorts <- sort(unique(info$G[is.finite(info$G)]))
  cohorts <- cohorts[cohorts - (if (pregrowth) 3 else 1) >= min(d$year)]
  years <- sort(unique(d$year))
  cells <- list()
  for (g in cohorts) {
    base <- g - 1
    yb <- wide_y %>% filter(year == base, !is.na(yv)) %>% select(firm_id, yb = yv)
    # Revision round 4: size_lag > 0 measures the size covariate size_lag years before the base year.
    ab <- wide_a %>% filter(year == base - size_lag, !is.na(size_b)) %>% select(firm_id, lnA_b = size_b)
    if (pregrowth) {
      # Exploratory (revision round 1, RR-2): growth in log market capitalization from g-3 to g-1.
      m1 <- d %>% filter(year == base, !is.na(ln_mcap)) %>% select(firm_id, m1 = ln_mcap)
      m3 <- d %>% filter(year == base - 2, !is.na(ln_mcap)) %>% select(firm_id, m3 = ln_mcap)
      ab <- ab %>% inner_join(m1, by = "firm_id") %>% inner_join(m3, by = "firm_id") %>%
        mutate(pg = m1 - m3) %>% select(firm_id, lnA_b, pg)
    }
    for (t in setdiff(years, base)) {
      e <- t - g
      if (e < E_MIN || e > E_MAX) next
      if (placebo && e > 2) next
      yt <- wide_y %>% filter(year == t, !is.na(yv)) %>% select(firm_id, yt = yv)
      cd <- info %>% inner_join(yb, by = "firm_id") %>% inner_join(ab, by = "firm_id") %>%
        inner_join(yt, by = "firm_id") %>% mutate(dY = yt - yb)
      tr <- cd %>% filter(G == g)
      if (!is.null(treated_subset)) tr <- tr %>% filter(high0 == treated_subset)
      co <- if (control == "never") cd %>% filter(!is.finite(G)) else
        cd %>% filter(!is.finite(G) | (G > max(t, base) & G != g))
      if (support && nrow(tr) > 0) co <- co %>% filter(lnA_b >= quantile(tr$lnA_b, 0.10, names = FALSE))
      # Revision round 4: keep a subset of scored firms; trim scored firms above the 95th size percentile of controls.
      if (!is.null(keep_treated)) tr <- tr %>% filter(firm_id %in% keep_treated)
      if (trim_top && nrow(co) > 0) tr <- tr %>% filter(lnA_b <= quantile(co$lnA_b, 0.95, names = FALSE))
      if (nrow(tr) == 0 || nrow(co) < 30) next
      Xc <- make_X(co, covars); Xt <- make_X(tr, covars)
      if (pregrowth) { Xc <- cbind(Xc, pg = co$pg); Xt <- cbind(Xt, pg = tr$pg) }
      cells[[length(cells) + 1]] <- list(g = g, t = t, e = e,
        it = match(tr$firm_id, FIRMS), ic = match(co$firm_id, FIRMS),
        yt = tr$dY, yc = co$dY, Xt = Xt, Xc = Xc)
    }
  }
  cells
}

# ATT(g,t) for every cell given firm weights w (length NF).
cell_atts <- function(cells, w) {
  out <- matrix(NA_real_, length(cells), 2)
  for (k in seq_along(cells)) {
    cl <- cells[[k]]
    wt <- w[cl$it]; wc <- w[cl$ic]
    swt <- sum(wt)
    if (swt == 0 || sum(wc > 0) < ncol(cl$Xc)) next
    fit <- lm.wfit(cl$Xc, cl$yc, wc)
    b <- fit$coefficients; b[is.na(b)] <- 0
    pred <- drop(cl$Xt %*% b)
    out[k, ] <- c(sum(wt * (cl$yt - pred)) / swt, swt)
  }
  out
}

aggregate_cells <- function(cells, ca) {
  e <- vapply(cells, `[[`, numeric(1), "e")
  ev <- sapply(setdiff(E_MIN:E_MAX, -1L), function(k) {
    s <- which(e == k & !is.na(ca[, 1])); if (!length(s)) NA_real_ else sum(ca[s, 1] * ca[s, 2]) / sum(ca[s, 2])
  })
  names(ev) <- setdiff(E_MIN:E_MAX, -1L)
  post_max <- if (isTRUE(attr(cells, "placebo"))) 2L else POST_MAX
  s <- which(e >= 0 & e <= post_max & !is.na(ca[, 1]))
  c(post = sum(ca[s, 1] * ca[s, 2]) / sum(ca[s, 2]), ev)
}

# Full estimation with bootstrap. Returns point estimates and the bootstrap draws.
run_cs <- function(y, ..., W = WBOOT) {
  cells <- build_cells(y, ...)
  attr(cells, "placebo") <- isTRUE(list(...)$placebo)
  w1 <- rep(1L, NF)
  ca <- cell_atts(cells, w1)
  est <- aggregate_cells(cells, ca)
  # Draws are deterministic given WBOOT, so forking across cores does not change any output.
  draws <- do.call(rbind, parallel::mclapply(seq_len(ncol(W)), function(b)
    aggregate_cells(cells, cell_atts(cells, W[, b])), mc.cores = N_CORES))
  gt <- data.frame(g = vapply(cells, `[[`, numeric(1), "g"), t = vapply(cells, `[[`, numeric(1), "t"),
                   e = vapply(cells, `[[`, numeric(1), "e"), att = ca[, 1], n_treated = ca[, 2],
                   n_control = vapply(cells, function(z) length(z$ic), numeric(1)))
  list(est = est, draws = draws, gt = gt,
       n_treated_firms = length(unique(unlist(lapply(cells, `[[`, "it")))),
       n_control_firms = length(unique(unlist(lapply(cells, `[[`, "ic")))))
}

summ <- function(res, which = names(res$est)) {
  se <- apply(res$draws[, which, drop = FALSE], 2, sd, na.rm = TRUE)
  lo <- apply(res$draws[, which, drop = FALSE], 2, quantile, 0.025, na.rm = TRUE)
  hi <- apply(res$draws[, which, drop = FALSE], 2, quantile, 0.975, na.rm = TRUE)
  est <- res$est[which]
  data.frame(term = which, est = est, se = se, ci_lo = lo, ci_hi = hi,
             p = 2 * pnorm(-abs(est / se)), mde80 = 2.8 * se, row.names = NULL)
}

pretrend_wald <- function(res) {
  k <- as.character(PRE_TEST)
  k <- k[!is.na(res$est[k])]
  V <- cov(res$draws[, k, drop = FALSE], use = "complete.obs")
  b <- res$est[k]
  stat <- drop(t(b) %*% solve(V) %*% b)
  data.frame(event_times = paste(k, collapse = ";"), wald = stat, df = length(k),
             p = pchisq(stat, length(k), lower.tail = FALSE))
}

# Static two-way fixed effects benchmark (Goodman-Bacon, 2021 comparison), firm-clustered SEs.
run_twfe <- function(y) {
  d <- panel %>% mutate(D = as.numeric(is.finite(G) & year >= G)) %>%
    select(firm_id, year, yv = all_of(y), D) %>% filter(!is.na(yv))
  pd <- pdata.frame(as.data.frame(d), index = c("firm_id", "year"))
  m <- plm(yv ~ D, data = pd, model = "within", effect = "twoways")
  V <- vcovHC(m, method = "arellano", type = "HC1", cluster = "group")
  b <- coef(m)[["D"]]; se <- sqrt(V["D", "D"])
  data.frame(outcome = y, est = b, se = se, ci_lo = b - 1.96 * se, ci_hi = b + 1.96 * se,
             p = 2 * pnorm(-abs(b / se)), n_obs = nobs(m), n_firms = n_distinct(d$firm_id))
}

# Exploratory (revision round 1, RR-1): linear pre-trend extrapolation. A line through the event-time estimates for
# e = -5..-1 (with the base year e = -1 fixed at zero) is extrapolated to e = 0..3 and subtracted; the adjusted
# post-coverage average uses the same cell weights as the headline estimate. Inference reuses the bootstrap draws.
trend_adjust <- function(res) {
  w <- res$gt %>% filter(e >= 0, e <= POST_MAX, !is.na(att)) %>% group_by(e) %>% summarise(n = sum(n_treated))
  pre_e <- c(-5:-2, -1)
  adj <- function(v) {
    yv <- c(v[as.character(-5:-2)], 0)
    ok <- !is.na(yv)
    slope <- sum((pre_e[ok] + 1) * yv[ok]) / sum((pre_e[ok] + 1)^2)   # line through (−1, 0)
    post <- v[as.character(w$e)] - slope * (w$e + 1)
    c(post = sum(post * w$n) / sum(w$n), slope = slope)
  }
  est <- adj(res$est)
  dr <- t(apply(res$draws, 1, function(r) { names(r) <- colnames(res$draws); adj(r) }))
  list(est = est, draws = dr)
}

# Revision round 2: relative-magnitude sensitivity in the spirit of Rambachan and Roth (2023). Post-coverage violations
# of parallel trends may change from one year to the next by at most Mbar times the largest change between
# consecutive pre-coverage event-time estimates. The implied bias bound for event time e >= 0 is (e + 1) * Mbar * Dmax;
# the bound for the headline average uses the same weights as the headline estimate. The robust interval widens the
# bootstrap 95% interval by the bound. This is a conservative, simplified construction, not the exact HonestDiD
# confidence set.
rm_bounds <- function(res, Mbar = c(0, 0.25, 0.5, 1)) {
  w <- res$gt %>% filter(e >= 0, e <= POST_MAX, !is.na(att)) %>% group_by(e) %>% summarise(n = sum(n_treated))
  pre <- c(res$est[as.character(-5:-2)], `-1` = 0)
  dmax <- max(abs(diff(pre)), na.rm = TRUE)
  wbar <- sum((w$e + 1) * w$n) / sum(w$n)
  lo <- quantile(res$draws[, "post"], 0.025, names = FALSE); hi <- quantile(res$draws[, "post"], 0.975, names = FALSE)
  data.frame(Mbar = Mbar, dmax = dmax, bias_bound = Mbar * dmax * wbar, est = res$est[["post"]],
             robust_lo = lo - Mbar * dmax * wbar, robust_hi = hi + Mbar * dmax * wbar,
             includes_zero = (lo - Mbar * dmax * wbar) <= 0 & (hi + Mbar * dmax * wbar) >= 0)
}
