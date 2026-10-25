# 01_data.R: build the firm-year panel for the coverage-initiation design (pre-analysis plan, Section 2-3).
winsor <- function(x, p = c(0.01, 0.99)) {
  q <- quantile(x, p, na.rm = TRUE, names = FALSE, type = 7)
  pmin(pmax(x, q[1]), q[2])
}

raw <- read_excel(DATA_XLS)
raw <- raw %>% arrange(firm_id, year)

# Coverage timing: first year with a non-missing LSEG ESG score (G = Inf if never covered).
timing <- raw %>% group_by(firm_id) %>%
  summarise(G = if (any(!is.na(ESG_Score))) min(year[!is.na(ESG_Score)]) else Inf,
            n_cov = sum(!is.na(ESG_Score)),
            last_cov = if (any(!is.na(ESG_Score))) max(year[!is.na(ESG_Score)]) else NA_real_)

initial_score <- raw %>% inner_join(timing, by = "firm_id") %>% filter(year == G) %>%
  transmute(firm_id, score0 = ESG_Score)

panel_all <- raw %>%
  inner_join(timing, by = "firm_id") %>%
  left_join(initial_score, by = "firm_id") %>%
  filter(industry_code != "financials")

sample_flow <- tibble::tibble(
  step = c("Universe (all firms)", "Non-financial firms", "Covered from 2014 (dropped, no pre-period)",
           "Estimation firms", "  of which treated (first covered 2015-2024)", "  of which never covered"),
  firms = c(n_distinct(raw$firm_id), n_distinct(panel_all$firm_id),
            n_distinct(panel_all$firm_id[panel_all$G == 2014]),
            n_distinct(panel_all$firm_id[panel_all$G != 2014]),
            n_distinct(panel_all$firm_id[is.finite(panel_all$G) & panel_all$G > 2014]),
            n_distinct(panel_all$firm_id[!is.finite(panel_all$G)])),
  firm_years = c(nrow(raw), nrow(panel_all), sum(panel_all$G == 2014), sum(panel_all$G != 2014),
                 sum(is.finite(panel_all$G) & panel_all$G > 2014), sum(!is.finite(panel_all$G))))

panel <- panel_all %>% filter(G != 2014) %>%
  mutate(
    mtb_w   = winsor(ifelse(mtb > 0, mtb, NA)),
    mcap_w  = winsor(ifelse(marketcap > 0, marketcap, NA)),
    lev_w   = winsor(ifelse(asset > 0 & debt >= 0, debt / asset, NA)),
    asset_w = winsor(ifelse(asset > 0, asset, NA)),
    roa_w   = winsor(roa),
    ln_mtb   = log(mtb_w),
    ln_mcap  = log(mcap_w),
    leverage = lev_w,
    ln_asset = log(asset_w),
    treated  = is.finite(G)
  ) %>%
  select(firm_id, year, country, industry_code, G, score0, treated, ln_mtb, ln_mcap, leverage, ln_asset,
         mtb_w, mcap_w, lev_w, asset_w, roa_w)

# Initial-score split (H3): above vs. at-or-below the median initial score of the firm's cohort.
cohort_med <- panel %>% filter(treated) %>% distinct(firm_id, G, score0) %>%
  group_by(G) %>% mutate(high0 = score0 > median(score0)) %>% ungroup() %>% select(firm_id, high0)
panel <- panel %>% left_join(cohort_med, by = "firm_id")

# Firms whose coverage has a gap (a year without a score after the first score), among scored estimation firms.
n_cov_gap <- timing %>% filter(firm_id %in% panel$firm_id[panel$treated]) %>%
  filter(n_cov < last_cov - G + 1) %>% nrow()
write_out(data.frame(n_cov_gap = n_cov_gap), "coverage_gaps.csv")

cohort_sizes <- panel %>% filter(treated) %>% distinct(firm_id, G, country) %>%
  count(G, country) %>% pivot_wider(names_from = country, values_from = n, values_fill = 0) %>%
  mutate(total = rowSums(across(-G))) %>% arrange(G)

OUTCOMES <- c(ln_mtb = "ln(MTB)", ln_mcap = "ln(market cap)",
              leverage = "Leverage (ratio)", ln_asset = "ln(assets)")

write_out(sample_flow, "sample_flow.csv")
write_out(cohort_sizes, "cohort_sizes.csv")
cat("Panel:", nrow(panel), "firm-years;", n_distinct(panel$firm_id), "firms\n")
