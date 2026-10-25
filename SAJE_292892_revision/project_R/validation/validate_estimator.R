# validate_estimator.R: checks of the hand-written Callaway-Sant'Anna implementation (integrity Stage 2.5, failure
# modes "implementation bug" and "bug as insight"). Run from project_R/:  LANG=C.UTF-8 Rscript validation/validate_estimator.R
# Output: outputs/validation.csv
source("R/00_setup.R")
out <- list()

# ---- Check 1: one group-time cell recomputed by hand with lm() on the real data ----
source("R/01_data.R")
B_BOOT <- 2L; source("R/02_cs_did.R")
gt <- read.csv(file.path(OUT, "att_gt.csv"))
manual_cell <- function(y, g, t) {
  base <- g - 1
  w <- panel %>% filter(year %in% c(base, t)) %>% select(firm_id, year, G, country, industry_code, ln_asset, yv = all_of(y))
  b <- w %>% filter(year == base) %>% transmute(firm_id, G, country, industry_code, lnA_b = ln_asset, yb = yv)
  e <- w %>% filter(year == t) %>% transmute(firm_id, yt = yv)
  d <- inner_join(b, e, by = "firm_id") %>% filter(!is.na(yb), !is.na(yt), !is.na(lnA_b)) %>% mutate(dY = yt - yb)
  co <- d %>% filter(!is.finite(G)); tr <- d %>% filter(G == g)
  co$country <- factor(co$country, levels = sort(unique(panel$country)))
  co$industry_code <- factor(co$industry_code, levels = sort(unique(panel$industry_code)))
  tr$country <- factor(tr$country, levels = levels(co$country)); tr$industry_code <- factor(tr$industry_code, levels = levels(co$industry_code))
  m <- lm(dY ~ lnA_b + I(lnA_b^2) + country + industry_code, data = co)
  cf <- coef(m); cf[is.na(cf)] <- 0
  X <- model.matrix(~ lnA_b + I(lnA_b^2) + country + industry_code, data = tr)
  mean(tr$dY - drop(X %*% cf[colnames(X)]))
}
for (cell in list(c(2022, 2017), c(2022, 2024), c(2020, 2016), c(2021, 2023))) {
  for (y in c("ln_mtb", "ln_mcap")) {
    pipe <- gt$att[gt$outcome == y & gt$g == cell[1] & gt$t == cell[2]]
    man <- manual_cell(y, cell[1], cell[2])
    out[[length(out) + 1]] <- data.frame(check = "manual lm() equals pipeline ATT(g,t)", outcome = y, g = cell[1], t = cell[2],
                                         pipeline = pipe, manual = man, abs_diff = abs(pipe - man), pass = abs(pipe - man) < 1e-8)
  }
}

# ---- Check 2: Monte Carlo on synthetic panels with a known effect and a known pre-trend ----
simulate <- function(att, runup, seed) {
  set.seed(seed)
  nf <- 1500; yrs <- 2014:2024
  f <- data.frame(firm_id = 1:nf, country = sample(c("ID", "MY", "PH", "SG", "TH"), nf, TRUE),
                  industry_code = sample(c("industrials", "materials", "energy"), nf, TRUE), a0 = rnorm(nf, 18, 1.5))
  f$G <- ifelse(runif(nf) < 0.3, sample(2016:2023, nf, TRUE), Inf)
  p <- merge(f, data.frame(year = yrs)) %>% arrange(firm_id, year) %>% group_by(firm_id) %>%
    mutate(fe = rnorm(1), yv = fe + 0.02 * (year - 2014) * (a0 - 18) + rnorm(n(), 0, 0.1),
           e = year - G,
           yv = yv + ifelse(is.finite(G) & e >= 0, att, 0) +
             ifelse(is.finite(G) & e < 0 & e >= -5, runup * (e + 1) / 5, 0) +
             ifelse(is.finite(G) & e < -5, -runup * 4 / 5, 0),
           ln_asset = a0 + 0.01 * (year - 2014)) %>% ungroup()
  p %>% transmute(firm_id, year, country, industry_code, G, treated = is.finite(G), high0 = NA,
                  ln_mtb = yv, ln_mcap = yv, leverage = yv, ln_asset)
}
for (sc in list(c(0.10, 0, 1), c(0, 0.15, 2), c(0, 0, 3))) {
  panel <- simulate(sc[1], sc[2], sc[3]); B_BOOT <- 49L
  source("R/02_cs_did.R")
  r <- run_cs("ln_mtb", control = "never", covars = TRUE)
  s <- summ(r)
  pre5 <- s$est[s$term == "-5"]
  out[[length(out) + 1]] <- data.frame(check = sprintf("simulation: true ATT %.2f, true run-up %.2f", sc[1], sc[2]),
    outcome = "synthetic", g = NA, t = NA, pipeline = s$est[s$term == "post"], manual = sc[1],
    abs_diff = abs(s$est[s$term == "post"] - sc[1]),
    pass = abs(s$est[s$term == "post"] - sc[1]) < 3 * s$se[s$term == "post"] &
      abs(pre5 - (-sc[2] * 4 / 5)) < 3 * s$se[s$term == "-5"])
}
res <- bind_rows(out)
write_out(res, "validation.csv")
print(res)
cat(if (all(res$pass)) "ALL VALIDATION CHECKS PASS\n" else "VALIDATION FAILURE\n")
