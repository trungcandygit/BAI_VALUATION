% Revised manuscript for the Southeast Asian Journal of Economics (manuscript 292892), first revision.
% Base text: manuscript.md as submitted (round 0). {+ ... +} marks text that is new or changed in this revision.
% Numbers are {{key}} placeholders from project_R/outputs/numbers.csv and numbers_saje.csv.
@@ title
Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets

@@ abstract
{+Most listed firms in Southeast Asia have no environmental, social, and governance (ESG) score, so investors who screen on scores cannot hold them. We ask which firms enter the London Stock Exchange Group (LSEG) ESG database and what happens to their valuation around entry. We compare {{n_treated_all}} non-financial firms in Indonesia, Malaysia, the Philippines, Singapore, and Thailand that received a first recorded score with {{n_never}} never-scored firms. Entry is selective. Scored firms are larger, and on average their market-to-book ratio had grown {{mtb_runup_m5}}% more than that of similar firms in the years before their first recorded score, a run-up not detected in a broad Malaysian wave. After entry, the valuation gap stops widening, but whether coverage itself changed valuations depends on when investors first saw the score and on untestable trend assumptions. Research and investment screens that compare rated with unrated firms should model who gets rated and when.+}

@@ keywords
ESG ratings, firm valuation, rating coverage, selection, Southeast Asia, sustainable finance

@@ jel
G14, G15, G32, M14, Q56

@@ ack_head
Acknowledgments

@@ ack_blind
{+We thank the editor and an anonymous referee for comments that substantially improved this paper.+}

@@ body
# 1. Introduction

Environmental, social, and governance (ESG) scores work as an entry ticket: a fund, index, or mandate that may hold only scored stocks cannot buy a firm that no provider covers. In five Southeast Asian equity markets, most listed firms had no score from the London Stock Exchange Group (LSEG) at any point between 2014 and 2024, and much of the academic evidence on ESG ratings uses LSEG data (Berg, Kölbel, et al., 2022; Dobrick et al., 2023). This paper asks which firms enter the scored universe and what happens to their market valuation around entry.

If a score makes a firm visible to more investors, its price should rise, because a wider investor base shares its risk (Merton, 1987); if the score also tells investors whether the firm is green or brown, prices should move in opposite directions for the two groups (Pástor et al., 2021; Pedersen et al., 2021). A provider, however, is likely to add a firm once it is large, liquid, and discloses enough to be scored, and its scores rise with firm size (Dobrick et al., 2023; Drempetic et al., 2020). If firms enter after a period of rising value, a comparison of scored and unscored firms credits the score with growth that came before it. Studies, mostly of U.S. firms, link coverage by more raters to fewer ESG violations (Tsang et al., 2024), lower emissions and more ownership by high-ESG institutions (Bikmetova & Pirinsky, 2026), and dividend increases (Tsang et al., 2025). None examines valuation in emerging markets, where most firms are unscored and coverage has expanded in waves.

We study Indonesia, Malaysia, the Philippines, Singapore, and Thailand. Of the {{n_treated_all}} non-financial firms whose first recorded LSEG score falls between {{n_coh_min_year}} and {{n_coh_max_year}}, {{n_coh_2020_2023}} had it in 2020 to 2023, and {{n_my_2021_2022}} were Malaysian firms first scored in 2021 or 2022. We compare them with {{n_never}} never-scored firms before and after each firm's first recorded score, the first fiscal year for which the database holds a score, using the estimator of Callaway and Sant'Anna (2021), which avoids the biases of two-way fixed effects regressions under staggered timing (Baker et al., 2022; Goodman-Bacon, 2021). The first recorded score is not necessarily the date on which investors could first see the score. A pre-analysis plan, committed before the estimation code, records the hypotheses, sample, estimator, and robustness checks; every later analysis is labeled exploratory.

The evidence has three parts. First, entry is selective. Scored firms are larger, and from five years before the first recorded score to the base year (the year before it) their market capitalization grew {{mcap_runup_m5}}% more than that of never-scored firms of similar size, country, and industry (95% interval {{mcap_runup_lo}}% to {{mcap_runup_hi}}%) and their market-to-book (MTB) ratio {{mtb_runup_m5}}% more ({{mtb_runup_lo}}% to {{mtb_runup_hi}}%). The run-up is large in the {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 and not detected in the {{n_wMY}} Malaysian firms first scored in 2021 and 2022, the largest wave in the data (95% interval {{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%). Second, after entry the MTB gap stops widening, but the data do not pin down a causal effect of coverage. Under parallel trends from the base year, the average change in log MTB over the first four years is {{mtb_att}} (95% interval {{mtb_lo}} to {{mtb_hi}}); dated one year later, when a score could first have been public, the change is {{mtb_R10_pct}}%. Most of this difference arises because the later dating measures valuations from the first recorded year, after the cohorts' own rise in that year, and the decline appears only in the waves that had a run-up. Third, a static two-way fixed effects regression on the same data attributes a {{mtb_R6_pct}}% MTB increase to coverage, which disappears once each cohort is compared with its own base year and base-year size is held fixed.

The paper makes three contributions. It documents selection into ESG rating coverage in Southeast Asian markets and adds valuation to the rating-coverage literature (Bikmetova & Pirinsky, 2026; Tsang et al., 2024, 2025). It shows why the valuation effect of coverage is hard to identify: entry follows growth and the recorded first score may precede publication. It also warns that comparisons of scored and unscored firms, and regressions that pool all years around entry, can attribute selection to the score.

# 2. Related Literature and Hypotheses

## 2.1. ESG Ratings as Information and Certification

ESG ratings can move prices when they change what investors know or which investors may hold a stock. MSCI downgrades are followed by lower ownership by U.S. funds with ESG mandates and a one-year abnormal return of approximately −2.37%, with weaker effects for upgrades (Berg, Heeb, et al., 2022), and calendar-time portfolios show a similar asymmetry (Shanaev & Ghimire, 2022). Publishing Morningstar sustainability ratings for mutual funds redirected fund flows (Hartzmark & Sussman, 2019).

Certification by inclusion in a sustainability index is the closest analog to a first score. Additions to the Dow Jones Sustainability Index have limited price effects relative to similar firms outside the index (Hawn et al., 2018), and a replication finds no price effect but more analyst following after addition (Durand et al., 2019). In sell-side research, losing analyst coverage lowers prices (Kelly & Ljungqvist, 2012), and the first report on a neglected stock raises its price when the report is favorable (Demiroglu & Ryngaert, 2010).

## 2.2. ESG Demand, Recognition, and Price Pressure

Two channels predict a valuation response to a first score. Under investor recognition, a stock known to few investors trades at a discount because a small group bears its idiosyncratic risk (Merton, 1987), so recognition predicts a gain for every newly scored firm; S&P 500 additions raise prices permanently, whereas deletions do not lower them permanently (Chen et al., 2004). Under ESG preferences, investors accept lower expected returns on assets they classify as sustainable (Pástor et al., 2021; Pedersen et al., 2021), so a first score predicts gains for firms revealed as green and losses for those revealed as brown, and a pooled average can be close to zero. Both channels work through who trades the stock, and on the Stock Exchange of Thailand local institutional investors adjust their trading to brokerage fees over the long run, whereas foreign and retail investors adjust in the short run (Sudsawasd & Sakdapat, 2026).

Demand shocks also shape realized prices before any rating event. The high realized returns of green assets reflect unexpected increases in ESG concerns rather than high expected returns (Pástor et al., 2022), and part of the price increase at S&P 500 inclusion reverses within weeks (Harris & Gurel, 1986; Shleifer, 1986). A run-up in value before coverage, followed by a flat path, is consistent with a demand shift that ended, with selection on growth, or with both.

## 2.3. Which Firms Providers Score

We expect providers to cover firms in the indices their clients track and firms that disclose enough to be scored, although our data omit the provider's coverage rules. Mandatory sustainability reporting increases the information available on listed firms (Krueger et al., 2024), and ownership shapes corporate social responsibility performance: among Vietnamese listed consumer-goods firms, outside our sample, foreign ownership is associated with higher corporate social responsibility scores, and state and family ownership with lower ones (Nguyen, 2025). The provider we study gives higher scores to larger firms (Dobrick et al., 2023; Drempetic et al., 2020) and has rewritten historical scores on a large scale (Berg et al., 2020). Providers disagree about the same firm (Berg, Kölbel, et al., 2022; Christensen et al., 2022), and the disagreement is priced (Avramov et al., 2022; Gibson Brandon et al., 2021). If providers select firms that have grown, a scored-unscored comparison mixes the effect of coverage with the growth that led to it.

## 2.4. Hypotheses

The pre-analysis plan states three hypotheses, all tested two-sided.

H~1~ (primary): The initiation of LSEG ESG coverage changes the log MTB ratio of scored firms relative to comparable never-scored firms. Recognition predicts an increase; preferences predict an increase for high-score firms and a decrease for low-score firms; selection predicts relative growth before coverage and, after it, no effect if the growth was permanent or a decline if it was transient.

H~2~ (secondary): Coverage changes log market capitalization, book leverage, and log total assets.

H~3~ (heterogeneity): The effect on log MTB differs between firms with initial scores above and below their cohort median. Only the preference channel depends on what the score says, so a difference would point toward it; the absence of a difference cannot rule it out.

Without ownership, fund holding, or trading data, we cannot observe the channels themselves; the data show whether entry follows relative growth, how the valuation gap evolves around entry, and whether that path differs with the initial score.

# 3. Data and Methods

## 3.1. Institutional Setting and Sample

The five markets introduced sustainability reporting rules at different times: Bursa Malaysia for financial years ending on or after December 31, 2016, phased in from the largest companies (Bursa Malaysia, 2015); Singapore, on a comply-or-explain basis, from financial years ending on or after December 31, 2017 (Singapore Exchange, 2016); the Philippines from the 2019 annual reports (Securities and Exchange Commission Philippines, 2019); Indonesia, under the original schedule of a 2017 regulation, from 2020 for listed companies other than small- and medium-asset issuers (Otoritas Jasa Keuangan, 2017); and Thailand in the 56-1 One Report from the fiscal year ending in 2021 (Tilleke & Gibbins, 2020). In Malaysia, FTSE Russell, another part of LSEG, scored only the constituents of the FTSE Bursa Malaysia EMAS index, about 30% of listed companies, until Bursa Malaysia and LSEG agreed in November 2022 to extend these scores to all Main and ACE Market companies (Bernama, 2022). The LSEG ESG score we study is a separate product, so our event is the initiation of LSEG ESG coverage, not a firm's first ESG rating of any kind. Coverage arrived in waves that follow no single reporting rule: {{n_th_sg_2019_2020}} first scores in Thailand and Singapore in 2019 and 2020, and {{n_my_2021_2022}} in Malaysia in 2021 and 2022 (Table S1 and Figure S1 of the supplementary material).

The data combine the annual LSEG ESG score (LSEG, 2025), not the controversy-adjusted combined score, with accounting and market data from Compustat Global (S&P Global Market Intelligence, 2025) for {{n_universe_firms}} listed firms, each with a row for every year from 2014 to 2024; rows before a firm lists carry no data. Every firm in the extract has data in 2024, so the sample conditions on survival to 2024, and without delisting data we cannot sign the resulting bias. Dropping financial firms leaves {{n_nonfin_firms}} firms. A firm's first recorded score year, g, is its first fiscal year with an LSEG ESG score, and its base year is g − 1. Only {{n_cov_gap}} of the {{n_treated_all}} scored firms have a later year without a score, so we treat coverage as permanent. Excluding the {{n_cov2014}} firms scored in 2014, which have no pre-coverage year, leaves {{n_est_firms}} firms with {{s_est_listed_fy}} listed firm-years ({{s_empty_rows}} rows precede listing): {{n_treated_all}} firms first scored between {{n_coh_min_year}} and {{n_coh_max_year}} ({{pct_my_treated}}% of them Malaysian) and {{n_never}} never-scored firms, which form the comparison group; Tables S2 and S3 of the supplementary material give the firm-years and firms behind each estimate. The source data contain no MTB ratio at or below zero, so firm-years with negative book equity appear as missing; log MTB ratios are missing for {{s_miss_never_scored_share}}% of never-scored and {{s_miss_scored_share}}% of scored listed firm-years.

## 3.2. Event Dating, Outcomes, and Recording Errors

The first recorded score may precede the year in which investors first see a score. The score for fiscal year g draws on reports published after that year ends, so it reaches investors in year g + 1 or later; the provider has rewritten historical scores on a large scale (Berg et al., 2020); scores for the five most recent fiscal years can change after publication (Sahin et al., 2023); and backfilling at entry would widen the gap. The first recorded score can therefore date entry too early but, unless the provider deleted an earlier score, not too late. Our extract holds each score by fiscal year, with no publication or update date, as it stood at download; that every scored firm still has a score in 2024 fits a download of the provider's current universe. LSEG distributes a point-in-time version of its ESG data that keeps values as they were published (LSEG, 2023), but our extract does not contain it. We therefore keep two concepts apart. The first recorded score is what we observe; publicly observable coverage begins at an unknown date from g + 1 onward. We report the valuation path with coverage dated at g, at g + 1, and at g + 2, and draw conclusions only where they hold across these datings.

The primary outcome is the natural logarithm of the MTB ratio. The secondary outcomes are log market capitalization, log total assets, and book leverage, total debt divided by total assets; without stock returns or shares outstanding, we treat market capitalization and total assets as measures of scale. Amounts are in U.S. dollars, winsorized at the 1st and 99th percentiles of the pooled sample. A few market capitalization records are implausibly large; one Indonesian firm is recorded at {{s_flag_ID_maxmcap}} billion U.S. dollars. Because market capitalization divided by the MTB ratio gives the implied book equity, which cannot exceed total assets, we flag firm-years in which the implied book equity exceeds ten times total assets: {{s_flag_All_n}} of {{s_flag_All_checked}} firm-years, {{s_flag_All_scored}} of them for scored firms. A lower threshold, a ratio above two, flags {{s_flag_All_n2}} firm-years.

## 3.3. Identification and Estimation

In the notation of Callaway and Sant'Anna (2021), let G~i~ be the first recorded score year of firm i, with G~i~ = ∞ if it is never scored, and let Y~i,t~(g) be the potential outcome of firm i in year t if it were first scored in year g. The group-time average treatment effect on the treated (ATT) is

$$latex \mathrm{ATT}(g,t)=\mathbb{E}\left[Y_{i,t}(g)-Y_{i,t}(\infty)\mid G_i=g\right] | (1)

We identify it under conditional parallel trends relative to the base year:

$$latex \mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=g\right]=\mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=\infty\right] | (2)

where X~i~ contains country and industry indicators and log total assets and its square, measured in the base year. Level differences between scored and never-scored firms do not violate this assumption, but a different growth path before coverage would. In the large Malaysian wave the pre-coverage estimates show no detectable run-up, so for these firms the assumption does not require a trend to stop; the run-up interval is wide, however ({{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%), and the wave split is exploratory. If the provider adds firms once they cross a size or visibility threshold, conditioning on base-year size compares firms on the same side of it. Against this, if part of a run-up was transitory, scored firms would have fallen back even without a score, and the estimates would understate any effect of coverage. We therefore treat the post-coverage estimates as conditional on parallel trends and give most weight to evidence that does not depend on it: the ordering of growth and entry, and the contrast between waves with and without a run-up.

For each cohort g and year t, we regress the long difference ΔY~i,t~ = Y~i,t~ − Y~i,g−1~ on X~i~ among never-scored firms (Sant'Anna & Zhao, 2020):

$$latex \Delta Y_{i,t}=X_i'\beta_{g,t}+u_{i,t},\qquad G_i=\infty | (3)

where β~g,t~ is the coefficient vector of the cell and u~i,t~ is the error. Because {{pct_scored_above_p95}}% of scored firms have larger base-year total assets than the 95th percentile of never-scored firms, we use outcome regression rather than the doubly robust estimator and also restrict scored firms to the size range of the controls, in the spirit of Crump et al. (2009). The estimated group-time effect is

$$latex \widehat{\mathrm{ATT}}(g,t)=\frac{1}{N_{g,t}}\sum_{i:\,G_i=g}\left(\Delta Y_{i,t}-X_i'\hat{\beta}_{g,t}\right) | (4)

where N~g,t~ is the number of firms first scored in year g with data in years g − 1 and t and base-year total assets. We average by event year, e = t − g, weighting cohorts by the number of scored firms (Callaway & Sant'Anna, 2021):

$$latex \hat{\theta}(e)=\sum_{g}\frac{N_{g,g+e}}{\sum_{h}N_{h,h+e}}\,\widehat{\mathrm{ATT}}(g,g+e) | (5)

where h indexes the cohort. The headline estimate averages, with the same weights, all cells from the first recorded score year to three years later:

$$latex \hat{\theta}_{\mathrm{post}}=\frac{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}\,\widehat{\mathrm{ATT}}(g,t)}{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}} | (6)

All comparisons are relative to the base year, so a negative θ̂(e) for e ≤ −2 means that scored firms grew faster than comparable never-scored firms from year g + e to the base year.

## 3.4. Inference, Sensitivity, and Robustness Checks

We bootstrap by resampling firms with their full time series; all specifications share the same {{B_BOOT}} draws and seed, so differences between specifications have a valid joint distribution. We report the bootstrap standard error (SE), the percentile 95% confidence interval, a normal-approximation p-value, and the minimum detectable effect at 80% power, MDE ≈ 2.8 × SE. Secondary outcomes carry Holm-adjusted p-values. A Wald test of the estimates for e = −5 to −2 serves only as a pre-trend diagnostic, because such tests have low power (Roth, 2022), and an exploratory check resamples the {{n_clusters}} market-by-industry clusters instead of firms.

Three exploratory checks address departures from parallel trends: removing a linear pre-coverage trend through zero in the base year, adding pre-coverage growth of log market capitalization to X~i~, and bounding the bias in the spirit of Rambachan and Roth (2023). For the bound, let δ(e) denote the post-coverage violation of parallel trends in event year e; we assume

$$latex \left|\delta(e)-\delta(e-1)\right|\le \bar{M}\,\max_{s\le -1}\left|\hat{\theta}(s)-\hat{\theta}(s-1)\right|\equiv \bar{M}\,\Delta,\qquad \delta(-1)=0 | (7)

where s indexes the pre-coverage event years. The bias for event year e is then at most M̄Δ(e + 1), and we widen the headline interval by its weighted average; with M̄ = 0.25, the gap may drift each year by a quarter of the largest yearly change before coverage. As a benchmark, we estimate the static two-way fixed effects (TWFE) regression analyzed by Goodman-Bacon (2021) and Baker et al. (2022):

$$latex Y_{i,t}=\alpha_i+\lambda_t+\beta\,D_{i,t}+\varepsilon_{i,t},\qquad D_{i,t}=\mathbf{1}\left[t\ge G_i\right] | (8)

where α~i~ and λ~t~ are firm and year effects, D~i,t~ marks years from the first recorded score onward, and standard errors are clustered by firm; β averages over any run-up and uses already scored firms as controls. The pre-analysis plan fixed six checks: adding not-yet-scored firms to the controls, dropping the covariates, excluding the 2020 and 2021 cohorts, keeping only control firms whose base-year log total assets reach the 10th percentile among scored firms of the same cohort, dating coverage three years early as a placebo, and the TWFE regression. All other checks are exploratory.

# 4. Results

## 4.1. Who Gets Scored and the Valuation Path Around Entry

Table 1 compares scored firms in the base year with never-scored firm-years. Scored firms are larger: their median market capitalization is {{t1_mcap_tr_med}} million U.S. dollars against {{t1_mcap_nv_med}} million, and their median total assets are {{t1_asset_ratio_med}} times as large. Their MTB ratio is also higher, while leverage differs little. In Malaysia, where the expansion was broadest, the median total assets of scored firms, each firm measured by its median over all sample years, were {{my_asset_ratio_med}} times those of the {{n_my_never}} never-scored firms.

Figure 1 plots the event-time estimates. Before the first recorded score, the estimates for market capitalization and MTB are negative and rise toward zero; in event years −5 and −4, the MTB estimates are {{mtb_em5}} and {{mtb_em4}} (p {{mtb_em5_p_txt}} and p {{mtb_em4_p_txt}}). From event year −5 to the base year, scored firms' market capitalization grew {{mcap_runup_m5}}% more than that of never-scored firms, and their MTB ratio {{mtb_runup_m5}}% more; we call this relative growth the run-up. The joint pre-trend test rejects for market capitalization (p {{mcap_pre_p_txt}}) but not at the 5% level for MTB (p {{mtb_pre_p_txt}}). The MTB non-rejection is not evidence of parallel trends: the estimates for event years −5 and −4 differ from zero, and pre-trend tests have low power (Roth, 2022). After the first recorded score, the MTB estimates for event years 0 to 3 lie between {{mtb_e3}} and {{mtb_e2}}, and none differs from zero at the 5% level; event year 4 rests on only {{mtb_nfirms_e4}} scored firms and is excluded from the headline estimate. The MTB gap thus widens before coverage and stops widening afterward. Only reading the post-coverage part as an effect of coverage depends on the parallel trends assumption.

Figure 2 separates the two largest coverage waves from the remaining cohorts; because we drew the wave boundaries after seeing the coverage counts, this split is exploratory. The {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 show the largest run-up: {{mtb_r4wTHSG_runup_m5}}% in MTB relative to never-scored firms (pre-trend p {{mtb_r4wTHSG_pre_p_txt}}). The {{n_wMY}} Malaysian firms first scored in 2021 and 2022 show no detectable run-up, {{s_mtb_wMY_runup_m5}}% (95% interval {{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%; pre-trend p {{mtb_r4wMY_pre_p_txt}}), although a run-up of the pooled size cannot be ruled out, and the {{n_wOth}} firms in the remaining cohorts fall in between. After the first recorded score, no wave shows a detectable MTB gain, while market capitalization fell in the Malaysian wave ({{mcap_r4wMY}}, p {{mcap_r4wMY_p_txt}}), which accounts for most of the negative pooled market capitalization estimate.

## 4.2. Average Change After Entry and the Two Datings

Table 2 reports the headline estimates. The change in log MTB is {{mtb_att}}, with a 95% confidence interval of {{mtb_lo}} to {{mtb_hi}}, so the data are compatible with changes in the MTB ratio from {{mtb_lo_pct}}% to {{mtb_hi_pct}}%; the MDE is about {{mtb_mde_pct}}%. With the cluster bootstrap, which allows for market-wide shocks such as the political uncertainty that moves Thai stock prices (Prukumpai et al., 2022), the interval is {{mtb_cl_lo}} to {{mtb_cl_hi}}. After Holm adjustment, no secondary outcome changes significantly at the 5% level: log market capitalization changes by {{mcap_att}} (p {{mcap_pholm_txt}}), leverage by {{lev_att_pp}} percentage points (p {{lev_pholm_txt}}), and log total assets by {{asset_att}} (p {{asset_pholm_txt}}). The MTB estimate shows no sign of the gain that the recognition channel predicts (Merton, 1987).

Table 3 presents the robustness checks; the first six were pre-specified, and the rest are exploratory. Dating coverage one year after the first recorded score, the earliest year in which a score could have been public, gives an MTB change of {{mtb_R10}}, about {{mtb_R10_pct}}% (95% interval {{mtb_R10_lo}} to {{mtb_R10_hi}}; p {{mtb_R10_p_txt}}), with a joint pre-trend p {{mtb_R10_pre_p_txt}}. Pre-specification does not make the recorded year the date on which investors learned of coverage, so we give the two datings equal standing.

Table 4 moves from the first-recorded-year estimate to the one-year-later estimate one step at a time. Row 2 keeps only firms observed in both g − 1 and g, so that every later row draws on the same set of firms; this changes the MTB estimate by {{s_mtb_d_sample_A1_A0}}. Row 3 averages event years 1 to 4 instead of 0 to 3; this changes it by {{s_mtb_d_window_B1_A1}} (p {{s_mtb_d_window_B1_A1_p_txt}}). Row 4 moves the reference year from g − 1 to g, which is what dating coverage one year later does to the comparison; this changes the estimate by {{s_mtb_d_reference_C1_B1}} (p {{s_mtb_d_reference_C1_B1_p_txt}}), {{s_mtb_d_reference_C1_B1_share}}% of the total gap of {{s_mtb_gap_total}}. Measuring size in g (row 5) and returning to all firms (row 6) change little. The steps are sequential, so the shares depend on their order.

The reference year thus drives the difference. Moving it from g − 1 to g subtracts from each later estimate the change in log MTB of the same scored firms, relative to the same never-scored firms, between g − 1 and g. The row 4 step, {{s_mtb_d_reference_C1_B1}}, is therefore minus each cohort's own change between g − 1 and g ({{s_mtb_d_reference_C1_B1_abs}} on average) weighted as in event years 1 to 4, which fall most on the early cohorts observed longest after entry; it is an accounting identity, not a separate estimate, and it is larger than the pooled event-year-0 estimate in Figure 1. Part of the decline under the later dating is thus the rise these cohorts had in the first recorded year itself. The cohorts observed through event year 4 (rows 7 to 10) show the same pattern more strongly.

The timing difference is also concentrated in the waves that had a run-up. Under the one-year-later dating, the MTB change is {{s_mtb_R10_TH_SG_2019_20}} for the Thai and Singaporean wave and {{s_mtb_R10_other}} for the remaining cohorts, but {{s_mtb_R10_MY_2021_22}} for the Malaysian wave (Table S6 of the supplementary material). Tested with joint firm-bootstrap draws, the Thai and Singaporean wave differs from the Malaysian wave both in the run-up (difference in the event-year −5 estimate {{s_mtb_pre5_TH_SG_2019_20_minus_MY}}, p {{s_mtb_pre5_TH_SG_2019_20_minus_MY_p_txt}}) and in the one-year-later change ({{s_mtb_R10_TH_SG_2019_20_minus_MY}}, p {{s_mtb_R10_TH_SG_2019_20_minus_MY_p_txt}}). The remaining cohorts differ from the Malaysian wave in the one-year-later change ({{s_mtb_R10_other_minus_MY}}, p {{s_mtb_R10_other_minus_MY_p_txt}}) but not detectably in the run-up (p {{s_mtb_pre5_other_minus_MY_p_txt}}). Where no run-up was detected, neither dating detects an MTB change (95% intervals {{s_mtb_base_MY_2021_22_lo}} to {{s_mtb_base_MY_2021_22_hi}} and {{s_mtb_R10_MY_2021_22_lo}} to {{s_mtb_R10_MY_2021_22_hi}}).

Two readings fit this pattern. If firms were selected at an unusually high valuation that later partly reversed, the one-year-later estimate measures that reversal and could hide a gain from coverage; if valuations would otherwise have stayed at their peak, coverage lowered them. Dating coverage two years later gives {{mtb_r4R12}} (95% interval {{mtb_r4R12_lo}} to {{mtb_r4R12_hi}}), and Figure S2 plots the one-year-later path.

## 4.3. Sensitivity and Robustness

Keeping only the {{n_R11_cohorts}} cohorts observed through event year 3 gives {{mtb_R11}} (p {{mtb_R11_p_txt}}), so changing cohort composition does not explain the headline estimate. Removing a linear pre-trend gives {{mtb_R7}}, and matching on pre-coverage growth gives {{mtb_R8}}; both intervals include zero. Under the relative-magnitude bounds (Table S7), with M̄ = 0.25 the interval for the MTB effect is {{mtb_rm025_lo}} to {{mtb_rm025_hi}}, and any departure with M̄ above {{mtb_bd5}} admits a 5% increase. Under the one-year-later dating, the decline loses significance with M̄ = 0.25, when its interval runs from {{mtb_R10_rm025_lo}} to {{mtb_R10_rm025_hi}}. Departures from parallel trends smaller than those observed before coverage are therefore enough to change the reading of either dating.

Table 5 varies the size adjustment and the support. Across functional forms (none, linear, quadratic, cubic, quintile indicators, or size measured at g − 3), the MTB estimate stays between {{s_mtb_ff_min}} and {{s_mtb_ff_max}}. Keeping scored firms no larger than the 95th percentile of controls in their cell retains {{s_mtb_trim95_ntr}} scored firms and gives {{s_mtb_trim95}} (p {{s_mtb_trim95_p_txt}}); the 90th and 99th percentile cut-offs give {{s_mtb_trim90}} and {{s_mtb_trim99}}. Within this support the doubly robust estimator of Sant'Anna and Zhao (2020), with control propensity scores capped at 0.99, gives {{s_mtb_dr_trim95}} (p {{s_mtb_dr_trim95_p_txt}}), and only {{s_ps_dr_trim95_share95}}% of scored firm-cells have an estimated propensity score above 0.95. The MTB result does not depend on extrapolating to the largest firms.

Market capitalization is more sensitive: its estimate is {{s_mcap_no_covariates}} without covariates, between {{s_mcap_ff_min}} and {{s_mcap_ff_max}} across the functional forms that adjust for size, and between {{s_mcap_sup_min}} and {{s_mcap_sup_max}} on the restricted supports, as expected when size enters both selection and the outcome. Table 6 describes the scored firms that the 95th percentile restriction keeps and drops. The {{s_sup_excluded_n}} excluded firms are large (median total assets of {{s_sup_excluded_assets}} million U.S. dollars against {{s_sup_retained_assets}} million) and more often Singaporean ({{s_sup_excluded_sg}}% against {{s_sup_retained_sg}}%), Indonesian ({{s_sup_excluded_id}}% against {{s_sup_retained_id}}%), or Thai ({{s_sup_excluded_th}}% against {{s_sup_retained_th}}%), while the retained firms are mostly Malaysian ({{s_sup_retained_my}}%). The restricted estimate thus describes mid-sized scored firms, largely from the Malaysian expansion.

Missing MTB ratios are not random. Firm-years without one are more often highly levered (book leverage above 0.5 in {{s_mc_never_scored_miss_lev05}}% of never-scored firm-years without an MTB ratio, against {{s_mc_never_scored_obs_lev05}}% with one) and more often Indonesian ({{s_mc_never_scored_miss_id}}% against {{s_mc_never_scored_obs_id}}%; Table S8 of the supplementary material). Only {{s_miss_never_scored_withmcap}}% of never-scored and {{s_miss_scored_withmcap}}% of scored firm-years without an MTB ratio have a market capitalization, so most gaps are missing market data, not negative book equity alone. Among the {{s_entry_out_n}} scored firms that do not enter the MTB estimate, those with base-year total assets have a median similar to that of firms that do ({{s_entry_out_assets}} against {{s_entry_in_assets}} million U.S. dollars).

Table 7 checks whether these gaps and the recording errors change the estimates. Estimating log market capitalization only on firm-years that also have an MTB ratio moves its change from {{s_mcap_baseline}} to {{s_mcap_mcap_on_mtb_sample}}, so part of the negative market capitalization estimate comes from firm-years that drop out of the MTB sample. Keeping only firms with a complete MTB series gives {{s_mtb_complete_mtb_series}} for MTB, and keeping only scored firms with complete series gives {{s_mtb_complete_mtb_scored_only}}. Removing the flagged firm-years gives {{s_mtb_drop_flagged_firm_years}} for MTB and {{s_mcap_drop_flagged_firm_years}} for market capitalization; removing every firm with a flagged year, using the lower threshold of twice total assets, or winsorizing within each market and year gives MTB estimates between {{s_mtb_out_min}} and {{s_mtb_out_max}}. None of these checks produces an MTB gain.

None of the four pre-specified robustness checks shows an MTB effect that differs from zero at the 10% level (estimates from {{mtb_R1}} to {{mtb_R3}}), while the market capitalization and total assets results are less stable. Excluding one market at a time (Table S9) gives MTB effects from {{mtb_lomo_min}} to {{mtb_lomo_max}}. The placebo yields {{mtb_R5}} on log MTB (p {{mtb_R5_p_txt}}), restating the pre-coverage growth in Figure 1. The static TWFE regression attributes an increase of {{mtb_R6}} in log MTB (p {{mtb_R6_p_txt}}) to coverage; comparing each cohort with its own base year accounts for about half of the gap to the headline estimate, and conditioning on base-year size for most of the rest (Table S5).

## 4.4. Initial Scores and What the Pooled Estimate Represents

The last three rows of Table 3 divide scored firms at the cohort median of their first recorded ESG score. The difference between high- and low-score entrants is {{mtb_diff}} (standard error {{mtb_diff_se}}, p {{mtb_diff_p_txt}}). Because the score rises with firm size (correlation {{h3_cor_score_size}} with base-year log total assets), Table S4 repeats the split after purging the score of size, country, and cohort; the difference is then {{mtb_h3r_diff}} (p {{mtb_h3r_diff_p_txt}}). Neither split shows the sign pattern that the preference channel predicts, but with minimum detectable differences of {{mtb_diff_mde}} and {{mtb_h3r_diff_mde}}, about 12% in the MTB ratio, neither can detect a moderate difference, and the residual split removes only part of this link, so the result does not show that ESG preferences are unimportant.

The pooled estimate weights cohorts and event years by the number of scored firms in each cell. Malaysian firms carry {{s_w_market_MY}}% of the weight in the headline MTB estimate and Thai firms {{s_w_market_TH}}%, together {{s_w_my_th}}%; the Malaysian wave of 2021 and 2022 alone carries {{s_w_wave_MY_2021_22}}%, and firm-years from 2021 to 2024 carry {{s_w_years_2021_2024}}% (Table S10). The pooled estimate therefore describes mainly the Malaysian expansion and the Thai cohorts after the COVID-19 pandemic, not an average effect for the five markets; the estimates for Indonesia, the Philippines, and Singapore in Table S11 rest on too few scored firms to support conclusions. Under the parallel trends assumption, the largest increase compatible with the headline interval is of the same order as the announcement return of 4.86% that Demiroglu and Ryngaert (2010) report for the first analyst coverage of neglected stocks, and because annual ratios miss short-lived price pressure, such as the partly reversed price rise at S&P 500 inclusion (Harris & Gurel, 1986; Shleifer, 1986), our estimates concern lasting revaluation (Chen et al., 2004). A first score also differs from the loss of analyst coverage, which lowers prices (Kelly & Ljungqvist, 2012): we find no comparable valuation response to gaining coverage.

# 5. Discussion and Conclusion

The clearest result is an ordering of events: firms entered the scored universe after their MTB ratio and market capitalization had grown faster than those of never-scored firms, and their MTB ratio stopped gaining afterward. The provider may have added firms once they were large and visible enough to matter to its clients, consistent with its higher scores for larger firms (Dobrick et al., 2023; Drempetic et al., 2020), or firms may have become scoreable by reporting, which mandatory disclosure rules make more likely (Krueger et al., 2024), by joining an index, or by issuing equity; the fall in leverage toward the base year fits equity issuance. This ordering does not rest on parallel trends or on the dating of publication, although its size depends on conditioning on base-year size: without covariates, the MTB run-up is {{mtb_r4nocov_runup_m5}}% (pre-trend p {{mtb_r4nocov_pre_p_txt}}). Whether coverage then changed valuations depends on the counterfactual trend (Rambachan & Roth, 2023; Roth, 2022): with parallel paths, the data show no detected effect (95% interval {{mtb_lo}} to {{mtb_hi}} in log MTB); with a continued run-up, coverage lowered valuations; with a partly transitory run-up, a positive effect could have offset a reversal. With annual data, a provider that chooses whom to score, and recorded scores that may precede publication, a valuation effect of coverage cannot be reliably identified without additional assumptions.

The absence of a detected gain fits the evidence on certification by sustainability indices (Durand et al., 2019; Hawn et al., 2018) and contrasts with the price effects of MSCI rating changes (Berg, Heeb, et al., 2022; Shanaev & Ghimire, 2022). U.S. ESG fund holdings respond to MSCI ratings, not to those of other providers (Berg, Heeb, et al., 2022); ratings that investors see directly, such as Morningstar's fund sustainability ratings, redirect flows (Hartzmark & Sussman, 2019); and because providers disagree about the same firm and the disagreement is priced (Avramov et al., 2022; Berg, Kölbel, et al., 2022; Christensen et al., 2022; Gibson Brandon et al., 2021), entry into one provider's coverage need not change how investors who rely on other ratings value a firm. Scored firms were also large and visible before coverage, which leaves less room for recognition (Merton, 1987). Unlike U.S. evidence that coverage changes firm conduct and payout (Bikmetova & Pirinsky, 2026; Tsang et al., 2024, 2025), we find no detected change in leverage ({{lev_att_pp}} percentage points, Holm p {{lev_pholm_txt}}) and a total-assets increase that loses significance after Holm adjustment. The run-up fits evidence that realized green returns reflect unexpected shifts in ESG demand (Pástor et al., 2022), but without ownership data we cannot tell whether ESG investors bought these firms before or after coverage; since ownership shapes corporate social responsibility performance in the region (Nguyen, 2025) and Thai institutional, foreign, and retail investors trade on different horizons (Sudsawasd & Sakdapat, 2026), ownership and trading data by investor group are the natural next step.

For researchers, comparisons of scored and unscored firms, static TWFE estimates, and backtests built on the first recorded score can attribute selection to the score (Berg et al., 2020; Sahin et al., 2023), so studies of ESG ratings in Southeast Asia should model when firms enter coverage and record the download date of their rating data. For providers, publishing the date on which each firm's coverage began, with the vintages of revised scores, would separate what was known from what was filled in later. For investors, a portfolio screened on ESG scores in these markets holds firms that, on average, entered coverage after outgrowing their peers. For exchanges and regulators, broad expansions such as the Malaysian wave appear to select less on prior growth, and we detect no MTB gain within them, although the interval ({{s_mtb_base_MY_2021_22_lo}} to {{s_mtb_base_MY_2021_22_hi}}) admits gains larger than the pooled upper bound; arguments for expanding coverage should therefore rest on grounds other than an expected rise in issuer valuations.

The study has limitations. The post-coverage estimates rest on conditional parallel trends that the pre-coverage estimates question, and our bound is a simplified version of Rambachan and Roth (2023). We observe neither publication dates, returns, ownership, nor index membership, and only LSEG coverage. MTB ratios are missing for {{s_miss_never_scored_share}}% of never-scored and {{s_miss_scored_share}}% of scored listed firm-years, Malaysian and Thai firms make up {{pct_my_th_treated}}% of scored firms, the sample includes only firms that survived to 2024, and effects smaller than the MDE of {{mtb_mde}} on log MTB would be detected with less than 80% probability.

In conclusion, entry into LSEG ESG coverage in five Southeast Asian markets was selective. Scored firms were larger than never-scored firms, and on average their market-to-book ratio had grown {{mtb_runup_m5}}% more than that of similar firms from five years to one year before entry, most in the Thai and Singaporean wave of 2019 and 2020 and not detectably in the broad Malaysian wave of 2021 and 2022 (95% interval {{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%). After entry, the valuation gap stopped widening, but whether coverage itself changed valuations cannot be settled: the answer moves from no detected change to a decline of {{s_mtb_C3_declpct}}% depending on when investors are assumed to have seen the score. Research and investment screens that start from a provider's universe inherit the provider's selection, and point-in-time records of first publication, with ownership and trading data, would allow future work to test whether ESG coverage changes who holds a firm and at what price.

@@ references
Avramov, D., Cheng, S., Lioui, A., & Tarelli, A. (2022). Sustainable investing with ESG rating uncertainty. *Journal of Financial Economics*, *145*(2), 642–664. https://doi.org/10.1016/j.jfineco.2021.09.009

Baker, A. C., Larcker, D. F., & Wang, C. C. Y. (2022). How much should we trust staggered difference-in-differences estimates? *Journal of Financial Economics*, *144*(2), 370–395. https://doi.org/10.1016/j.jfineco.2022.01.004

Berg, F., Fabisik, K., & Sautner, Z. (2020). *Is history repeating itself? The (un)predictable past of ESG ratings* (Finance Working Paper No. 708/2020). European Corporate Governance Institute. https://ssrn.com/abstract=3722087

Berg, F., Heeb, F., & Kölbel, J. F. (2022). *The economic impact of ESG ratings* (SAFE Working Paper No. 439). Leibniz Institute for Financial Research SAFE. https://ssrn.com/abstract=4088545

Berg, F., Kölbel, J. F., & Rigobon, R. (2022). Aggregate confusion: The divergence of ESG ratings. *Review of Finance*, *26*(6), 1315–1344. https://doi.org/10.1093/rof/rfac033

Bernama. (2022, November 2). *Bursa Malaysia signs sustainability MoU with London Stock Exchange Group*. https://www.bernama.com/en/news.php?id=2134522

Bikmetova, N., & Pirinsky, C. A. (2026). Do ESG rating agencies improve ESG performance? *Journal of Business Ethics*, *204*(2), 335–365. https://doi.org/10.1007/s10551-025-06063-0

Bursa Malaysia. (2015). *Sustainability reporting guide*. Bursa Malaysia Berhad.

Callaway, B., & Sant'Anna, P. H. C. (2021). Difference-in-differences with multiple time periods. *Journal of Econometrics*, *225*(2), 200–230. https://doi.org/10.1016/j.jeconom.2020.12.001

Chen, H., Noronha, G., & Singal, V. (2004). The price response to S&P 500 index additions and deletions: Evidence of asymmetry and a new explanation. *The Journal of Finance*, *59*(4), 1901–1929. https://doi.org/10.1111/j.1540-6261.2004.00683.x

Christensen, D. M., Serafeim, G., & Sikochi, A. (2022). Why is corporate virtue in the eye of the beholder? The case of ESG ratings. *The Accounting Review*, *97*(1), 147–175. https://doi.org/10.2308/TAR-2019-0506

{+Crump, R. K., Hotz, V. J., Imbens, G. W., & Mitnik, O. A. (2009). Dealing with limited overlap in estimation of average treatment effects. *Biometrika*, *96*(1), 187–199. https://doi.org/10.1093/biomet/asn055+}

Demiroglu, C., & Ryngaert, M. D. (2010). The first analyst coverage of neglected stocks. *Financial Management*, *39*(2), 555–584. https://doi.org/10.1111/j.1755-053X.2010.01084.x

Dobrick, J., Klein, C., & Zwergel, B. (2023). Size bias in Refinitiv ESG data. *Finance Research Letters*, *55*, Article 104014. https://doi.org/10.1016/j.frl.2023.104014

Drempetic, S., Klein, C., & Zwergel, B. (2020). The influence of firm size on the ESG score: Corporate sustainability ratings under review. *Journal of Business Ethics*, *167*(2), 333–360. https://doi.org/10.1007/s10551-019-04164-1

Durand, R., Paugam, L., & Stolowy, H. (2019). Do investors actually value sustainability indices? Replication, development, and new evidence on CSR visibility. *Strategic Management Journal*, *40*(9), 1471–1490. https://doi.org/10.1002/smj.3035

Gibson Brandon, R., Krueger, P., & Schmidt, P. S. (2021). ESG rating disagreement and stock returns. *Financial Analysts Journal*, *77*(4), 104–127. https://doi.org/10.1080/0015198X.2021.1963186

Goodman-Bacon, A. (2021). Difference-in-differences with variation in treatment timing. *Journal of Econometrics*, *225*(2), 254–277. https://doi.org/10.1016/j.jeconom.2021.03.014

Harris, L., & Gurel, E. (1986). Price and volume effects associated with changes in the S&P 500 list: New evidence for the existence of price pressures. *The Journal of Finance*, *41*(4), 815–829. https://doi.org/10.1111/j.1540-6261.1986.tb04550.x

Hartzmark, S. M., & Sussman, A. B. (2019). Do investors value sustainability? A natural experiment examining ranking and fund flows. *The Journal of Finance*, *74*(6), 2789–2837. https://doi.org/10.1111/jofi.12841

Hawn, O., Chatterji, A. K., & Mitchell, W. (2018). Do investors actually value sustainability? New evidence from investor reactions to the Dow Jones Sustainability Index (DJSI). *Strategic Management Journal*, *39*(4), 949–976. https://doi.org/10.1002/smj.2752

Kelly, B., & Ljungqvist, A. (2012). Testing asymmetric-information asset pricing models. *The Review of Financial Studies*, *25*(5), 1366–1413. https://doi.org/10.1093/rfs/hhr134

Krueger, P., Sautner, Z., Tang, D. Y., & Zhong, R. (2024). The effects of mandatory ESG disclosure around the world. *Journal of Accounting Research*, *62*(5), 1795–1847. https://doi.org/10.1111/1475-679X.12548

{+LSEG. (2023). *Refinitiv Data Platform ESG bulk point in time user guide* (Document version 2). https://developers.lseg.com/content/dam/devportal/api-families/refinitiv-data-platform/refinitiv-data-platform-apis/documentation/rdp_esg_pit_user_guide.pdf+}

LSEG. (2025). *LSEG ESG scores (ESG score field), annual, 2014–2024* [Data set]. LSEG Workspace.

Merton, R. C. (1987). A simple model of capital market equilibrium with incomplete information. *The Journal of Finance*, *42*(3), 483–510. https://doi.org/10.1111/j.1540-6261.1987.tb04565.x

{+Nguyen, T. T. (2025). Ownership structure and corporate social responsibility: Evidence from Vietnam. *Southeast Asian Journal of Economics*, *13*(2), 67–98.+}

Otoritas Jasa Keuangan. (2017). *Peraturan Otoritas Jasa Keuangan Nomor 51/POJK.03/2017 tentang penerapan keuangan berkelanjutan bagi lembaga jasa keuangan, emiten, dan perusahaan publik* [Regulation on the application of sustainable finance to financial services institutions, issuers, and public companies]. https://www.ojk.go.id/sustainable-finance/id/peraturan/peraturan-ojk/Documents/SAL%20POJK%2051%20-%20keuangan%20berkelanjutan.pdf

Pástor, Ľ., Stambaugh, R. F., & Taylor, L. A. (2021). Sustainable investing in equilibrium. *Journal of Financial Economics*, *142*(2), 550–571. https://doi.org/10.1016/j.jfineco.2020.12.011

Pástor, Ľ., Stambaugh, R. F., & Taylor, L. A. (2022). Dissecting green returns. *Journal of Financial Economics*, *146*(2), 403–424. https://doi.org/10.1016/j.jfineco.2022.07.007

Pedersen, L. H., Fitzgibbons, S., & Pomorski, L. (2021). Responsible investing: The ESG-efficient frontier. *Journal of Financial Economics*, *142*(2), 572–597. https://doi.org/10.1016/j.jfineco.2020.11.001

{+Prukumpai, S., Sethapramote, Y., & Luangaram, P. (2022). Political uncertainty and the Thai stock market. *Southeast Asian Journal of Economics*, *10*(3), 227–257.+}

Rambachan, A., & Roth, J. (2023). A more credible approach to parallel trends. *The Review of Economic Studies*, *90*(5), 2555–2591. https://doi.org/10.1093/restud/rdad018

Roth, J. (2022). Pretest with caution: Event-study estimates after testing for parallel trends. *American Economic Review: Insights*, *4*(3), 305–322. https://doi.org/10.1257/aeri.20210236

Sahin, Ö., Bax, K., Paterlini, S., & Czado, C. (2023). The pitfalls of (non-definitive) environmental, social, and governance scoring methodology. *Global Finance Journal*, *56*, Article 100780. https://doi.org/10.1016/j.gfj.2022.100780

Sant'Anna, P. H. C., & Zhao, J. (2020). Doubly robust difference-in-differences estimators. *Journal of Econometrics*, *219*(1), 101–122. https://doi.org/10.1016/j.jeconom.2020.06.003

Securities and Exchange Commission Philippines. (2019). *Memorandum Circular No. 4, series of 2019: Sustainability reporting guidelines for publicly-listed companies*. https://www.sec.gov.ph/wp-content/uploads/2020/09/2019MCNo4.pdf

Shanaev, S., & Ghimire, B. (2022). When ESG meets AAA: The effect of ESG rating changes on stock returns. *Finance Research Letters*, *46*(Part A), Article 102302. https://doi.org/10.1016/j.frl.2021.102302

Shleifer, A. (1986). Do demand curves for stocks slope down? *The Journal of Finance*, *41*(3), 579–590. https://doi.org/10.1111/j.1540-6261.1986.tb04518.x

Singapore Exchange. (2016). *SGX Mainboard Rules 711A and 711B: Sustainability report* [Listing rules]. SGX Rulebook. https://rulebook.sgx.com/rulebook/711a

S&P Global Market Intelligence. (2025). *Compustat Global, annual fundamentals, 2014–2024* [Data set].

{+Sudsawasd, S., & Sakdapat, P. (2026). Transaction costs and stock market behavior: Evidence from Thailand. *Southeast Asian Journal of Economics*, *14*(1), 257–287.+}

Tilleke & Gibbins. (2020, September). *Thailand's SEC unifies annual report for listed companies*. https://www.tilleke.com/insights/thailands-sec-unifies-annual-report-listed-companies/

Tsang, A., Wang, Y., Xiang, Y., & Yu, L. (2024). The rise of ESG rating agencies and management of corporate ESG violations. *Journal of Banking & Finance*, *169*, Article 107312. https://doi.org/10.1016/j.jbankfin.2024.107312

Tsang, A., Wang, Y., Xiang, Y., & Yu, L. (2025). ESG ratings and dividend changes: Evidence from the initiation of nonfinancial agency coverage. *Corporate Governance: An International Review*, *33*(4), 554–577. https://doi.org/10.1111/corg.12615

@@ exhibits
kind:=table
caption:=Table 1|Characteristics of scored firms in the base year and of never-scored firm-years
csvfile:=table1_formatted.csv
widths:=1.7,0.65,0.65,0.55,0.7,0.7,0.65,0.7
size:=9
note:=Scored firms in base year g − 1; never-scored firms in 2014–2024. Norm. diff. is the mean difference divided by the root of the average variance.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure 1|Event-time changes in market-to-book ratio, market capitalization, leverage, and total assets around the first recorded LSEG ESG score
png:=Fig1.png
note:=Estimates relative to event year −1 with firm-bootstrap 95% intervals; {{mtb_nfirms_e4}} to {{mtb_nfirms_e0}} scored firms per event year.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure 2|Event-time changes in market-to-book ratio and market capitalization by coverage wave
png:=Fig2.png
note:=Estimates by wave against all never-scored firms, with firm-bootstrap 95% intervals. The waves hold {{n_wMY}}, {{n_wTHSG}}, and {{n_wOth}} scored firms.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 2|Average {+change after the first recorded LSEG ESG score over event years 0 to 3, under parallel trends+}
csvfile:=table2_formatted.csv
widths:=1.45,0.6,0.5,1.15,0.6,0.5,0.6,0.6,0.6
size:=9
note:=Outcome regression with firm-bootstrap standard errors; secondary p-values are Holm-adjusted, intervals are not. MDE: 80%-power minimum detectable effect; pre-trend p from the joint Wald test of event years −5 to −2.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 3|Robustness checks, timing of coverage, and heterogeneity by initial ESG score
csvfile:=table3_formatted.csv
widths:=1.7,0.95,0.95,0.95,0.95,1.0
size:=9
note:=Outcome regression with firm-bootstrap standard errors (firm-clustered for two-way fixed effects); firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 4|Reconciling the first-recorded-year and one-year-later datings, step by step
csvfile:=tableSAJE4_formatted.csv
widths:=2.75,1.05,1.15,0.8,0.75
size:=9
blue:=1
note:=Outcome regression with firm-bootstrap standard errors; each row changes one feature; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 5|Size adjustment and common support
csvfile:=tableSAJE5_formatted.csv
widths:=2.6,1.1,1.15,0.85,0.8
size:=9
blue:=1
note:=Outcome regression unless doubly robust, with firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 6|Scored firms retained and excluded by the 95th percentile size restriction
csvfile:=tableSAJE6_formatted.csv
widths:=2.8,1.1,1.1,1.4
size:=9
blue:=1
note:=Scored firms in the ln(MTB) estimate, measured in base year g − 1; never-scored firms over all firm-years.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 7|Missing valuation data and recording errors
csvfile:=tableSAJE8_formatted.csv
widths:=2.7,1.1,1.15,0.8,0.75
size:=9
blue:=1
note:=Outcome regression with firm-bootstrap standard errors; flags mark implied book equity above ten times total assets. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

@@ supp_intro
This supplementary material accompanies "Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets." {+It presents the supplementary tables and figures first and then Appendix A, which discusses additional results.+} The pre-analysis plan is provided with the replication package.

@@ supp_body
# {+Appendix A.+} Additional robustness results

## A.1. Event Year 4 (Section {+4.1+})

Only {{mtb_nfirms_e4}} scored firms from {{mtb_ncoh_e4}} cohorts reach event year 4; therefore, we plot that year in Figure 1 but exclude it from the headline estimate. Its estimates are {{mtb_e4}} for MTB (p {{mtb_e4_p_txt}}) and {{mcap_e4}} for market capitalization (p {{mcap_e4_p_txt}}).

## A.2. Further Timing Variants of the One-Year-Later Dating (Section {+4.2+})

Under the one-year-later dating, the decline in log MTB loses significance once M̄ in the relative-magnitude bound reaches {{mtb_R10_bd0}}. Holding total assets at the original base year gives {{mtb_r4R10g1}} (p {{mtb_r4R10g1_p_txt}}), so the covariate timing does not drive the one-year-later estimate. Dating coverage two years later gives {{mtb_r4R12}} (95% interval {{mtb_r4R12_lo}} to {{mtb_r4R12_hi}}), a smaller decline that is no longer significant at the 5% level.

## A.3. Reconciling the One-Year-Later and Baseline Event-Time Paths (Section {+4.2+}, Figure S2)

The baseline path in Figure 1 does not show the one-year-later decline because its later event years come from early cohorts, while its first post-coverage years pool all cohorts. Re-based within each cohort to the first {+recorded+} year, the baseline point estimates for event years 3 and 4 are {{mtb_reb_e3}} and {{mtb_reb_e4}}, respectively. These lie closer to the corresponding one-year-later estimates of {{mtb_R10_e2}} and {{mtb_R10_e3}} than the pooled baseline path suggests. We report the re-based values without standard errors, as a reconciliation of the two paths rather than a test. {+Table 4 of the paper carries out the full step-by-step reconciliation on a common sample.+}

## A.4. Size Covariate and Support (Section {+4.3+}, Table S4, Figure S2)

Table S4 and Figure S2 vary the size covariate and support{+; Table 5 of the paper reports the full set of variants+}. {+Scored-firm counts differ slightly across tables for the same estimate: Tables 4, 5, and 7 count firms in the averaged event years, while Tables 2, 3, and S4 count firms in any event-time cell.+} The run-up is smaller without conditioning on base-year total assets. Without covariates, the MTB run-up from event year −5 to the base year is {{mtb_r4nocov_runup_m5}}%, weaker than the baseline (event year −5 p {{mtb_r4nocov_em5_p_txt}}; pre-trend p {{mtb_r4nocov_pre_p_txt}}), and the market capitalization run-up is {{mcap_r4nocov_runup_m5}}%. With total assets measured two years before the base year, it is {{mtb_r4sizeg3_runup_m5}}% for MTB (pre-trend p {{mtb_r4sizeg3_pre_p_txt}}) and {{mcap_r4sizeg3_runup_m5}}% for market capitalization.

## A.5. Decomposition of the TWFE Gap (Section {+4.3+}, Table S5)

Table S5 shows the decomposition of the gap between the static TWFE estimate and the headline MTB estimate. Restricting the regression to never-scored controls and event years −5 to 3 changes the estimate to only {{mtb_bridge2}}, while the heterogeneity-robust estimator gives {{mtb_bridge3}} without covariates and {{mtb_bridge4}} with them. Comparing each cohort with its own base year, rather than pooling all years, accounts for approximately half of the gap. Conditioning on base-year total assets accounts for most of the rest, and the choice of controls and window for little.

## A.6. Market-by-Market and Early Versus Late Cohorts (Section {+4.4+}, Table S11)

Estimated market by market in Table S11, the MTB effect is {{mtb_pm_MY}} in Malaysia, with {{mtb_pm_MY_ntr}} scored firms, and {{mtb_pm_TH}} in Thailand, with {{mtb_pm_TH_ntr}}. Indonesia, the Philippines, and Singapore have few scored firms and imprecise estimates. The {{mtb_r4c19_ntr}} firms first scored by 2019 that enter the MTB estimate show a positive post-coverage MTB estimate of {{mtb_r4c19}} (p {{mtb_r4c19_p_txt}}; 95% interval {{mtb_r4c19_lo}} to {{mtb_r4c19_hi}}), and the larger group first scored from 2020 shows {{mtb_r4c20}} (p {{mtb_r4c20_p_txt}}). The early estimate rests on few firms, is one of many exploratory comparisons, and is not adjusted for multiple testing, so we do not read it as evidence of a gain for early entrants.

## A.7. Breadth of the Malaysian Wave (Section {+4.1+}, Figure 2)

The Malaysian wave added {{n_wMY}} firms in two years, yet {{n_my_never}} Malaysian firms remained never-scored, so it was broad but not market-wide.

## {+A.8. Composition of the Pooled Estimate (Section 4.4, Table S10)+}

{+Table S10 counts scored firm-cells, one for each scored firm in each post-coverage cell of the ln(MTB) estimate, by market and by coverage wave. These counts are the weights of the headline estimate.+}

## {+A.9. Dating by Wave (Section 4.2, Table S6)+}

{+Table S6 reports, for each wave, the average change with coverage dated at the first recorded score year and one year later, estimated against all never-scored firms.+}

## {+A.10. Firm-years with and Without an MTB Ratio (Section 4.3, Table S8)+}

{+Table S8 compares scored and never-scored firm-years with and without an MTB ratio in the estimation sample. Book leverage above 0.5 and Indonesian listing are more common among firm-years without an MTB ratio.+}

## {+A.11. Other Robustness Checks (Section 4.3)+}

{+The four pre-specified robustness checks in Table 3 give MTB effects of {{mtb_R1}} with not-yet-scored firms among the controls, {{mtb_R2}} without covariates, {{mtb_R3}} without the 2020 and 2021 cohorts, and {{mtb_R4}} when control firms below the size range of scored firms are dropped. Under the last restriction the market capitalization effect shrinks to {{mcap_R4}} and the total assets effect is {{asset_R4}}, against {{asset_R2}} without covariates. Removing a linear pre-trend that passes through zero in the base year gives a negative MTB effect because a continued run-up would have raised valuations further. Adding market capitalization growth from g − 3 to the base year to the covariates does not settle the reversal question, because control firms matched on past growth can themselves revert. The placebo gives {{mcap_R5}} for log market capitalization (p {{mcap_R5_p_txt}}), and the static TWFE regression gives {{mcap_R6}}. Without Malaysia, the MTB effect is {{mtb_R9}} (p {{mtb_R9_p_txt}}) and the market capitalization effect {{mcap_R9}}.+}

{+In the outcome regression, a country or industry indicator would be unidentified in a cell with no control firm in that country or industry, and its coefficient would be set to zero. This does not occur: in all {{s_na_mtb_cells}} cells of event years 0 to 3 for ln(MTB), and all {{s_na_mcap_cells}} for ln(market capitalization), every indicator carried by a scored firm is also carried by a control firm.+}

@@ exhibits_supp
kind:=table
caption:=Table S1|Number of non-financial firms by year of first {+recorded+} LSEG ESG score and market
csvfile:=tableIA2_formatted.csv
widths:=1.3,0.85,0.85,0.9,0.9,0.85,0.75
note:=Firms first scored in 2014 are excluded because they have no pre-coverage year.
source:=Authors' calculations from LSEG ESG scores.

kind:=figure
caption:=Figure S1|Number of non-financial firms by year of first {+recorded+} LSEG ESG score
png:=FigIA1.png
note:=Firms in the estimation sample, all five markets combined.
source:=Authors' calculations from LSEG ESG scores.

kind:=table
caption:=Table S2|Firm-years and firms available for each outcome
csvfile:=tableIA4_formatted.csv
widths:=1.7,1.0,0.9,1.0,0.9,1.0
note:=Estimation sample; the last column is the share of listed firm-years with a missing outcome.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S3|Scored firms and control firms by event year for ln(MTB)
csvfile:=tableIA6_formatted.csv
widths:=1.2,1.3,1.1,2.2
note:=Scored firms are summed over cohorts; control firms show the range across cohort cells.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S4|Alternative specifications, inference, and initial-score splits for the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA7_formatted.csv
widths:=2.3,1.1,0.75,1.1,0.75
note:=Exploratory outcome-regression estimates with firm-bootstrap standard errors and the joint pre-trend p. \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S5|Decomposition of the gap between the static two-way fixed effects estimate and the baseline estimate
csvfile:=tableIA8_formatted.csv
widths:=3.0,1.4,1.4
note:=Steps from the static TWFE regression to the baseline estimate; standard errors firm-clustered for TWFE, firm-bootstrap otherwise. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S6|Average change by coverage wave under the two datings
csvfile:=tableSAJES10_formatted.csv
widths:=1.9,1.15,1.15,1.15,1.15
size:=9
blue:=1
note:=Outcome regression for each wave against all never-scored firms, with firm-bootstrap standard errors. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure S2|Event-time changes in ln(MTB) under alternative specifications and dating
png:=FigIA2.png
note:=Panel (a) varies the size covariate and support; panel (b) dates the event one year later. Firm-bootstrap 95% intervals.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S7|Relative-magnitude bounds for the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA5_formatted.csv
widths:=1.7,0.6,1.2,0.9,1.6
note:=Relative-magnitude bias bound (Section 3.4); the robust interval widens the firm-bootstrap 95% interval by this bound.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S8|Firm-years with and without a market-to-book ratio
csvfile:=tableSAJE7_formatted.csv
widths:=2.2,1.05,1.05,1.1,1.1
size:=9
blue:=1
note:=Listed firm-years of the estimation sample, 2014–2024; amounts in U.S. dollars after winsorization at the 1st and 99th percentiles.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.


kind:=table
caption:=Table S9|Leave-one-market-out estimates of the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA1_formatted.csv
widths:=1.6,0.95,0.95,0.95,0.95,1.1
note:=Outcome regression with firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S10|Weight of each market and coverage wave in the pooled ln(MTB) estimate
csvfile:=tableSAJES9_formatted.csv
widths:=3.3,1.3,1.6
blue:=1
note:=Each scored firm counts once in every post-coverage cell of the baseline ln(MTB) estimate; weights are cell shares.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S11|Average change after the first {+recorded+} LSEG ESG score by market
csvfile:=tableIA3_formatted.csv
widths:=1.3,1.0,1.05,1.05,1.0,1.1
note:=Outcome regression within each market, with firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

@@ title_page
**Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets**[^ack]

**Ha Hong Hanh**\
National Economics University, Hanoi, Vietnam. Email: hanhhh@neu.edu.vn

**Nguyen Van Trung**^\*^\
International School, Vietnam National University, Hanoi, 144 Xuan Thuy Street, Cau Giay District, Hanoi, Vietnam. Email: kontrungcany@gmail.com. ORCID: 0009-0008-3307-6569

^\*^ Corresponding author: Nguyen Van Trung, International School, Vietnam National University, Hanoi, 144 Xuan Thuy Street, Cau Giay District, Hanoi, Vietnam. Email: kontrungcany@gmail.com. Tel: +84 355 347 831.

[^ack]: The authors thank the editor of the *Southeast Asian Journal of Economics* and an anonymous referee for comments and suggestions that substantially improved this paper. An earlier version of the manuscript was edited for language by a native English-speaking editor.

**Declaration of generative AI and AI-assisted technologies**

The authors used Claude (Anthropic), through Claude Code, in September and October 2026 to screen candidate research questions, draft the pre-analysis plan, write and check the R code, edit and revise the text, check references, and simulate referee reports, and in October 2026 to carry out the additional analyses requested in the review, draft the revised text, and draft the response letter. The authors reviewed every output, checked each reported number against the R output files, and take full responsibility for the content. Claude is not an author.

**Funding statement**

This research did not receive any specific grant from funding agencies in the public, commercial, or not-for-profit sectors.

**Conflict of interest disclosure**

The authors have nothing to disclose.

**Data availability statement**

The ESG scores (LSEG Workspace) and the accounting and market data (Compustat Global) are licensed, and the licenses do not allow the authors to redistribute them, including firm identifiers and derived firm-level variables; the download date of the scores was not recorded. The R code, the pre-analysis plan, and all aggregate output files will be deposited in a public repository with a DOI before final acceptance. Researchers with access to the two databases can rebuild the sample with the code.

**Ethics approval statement**

Not applicable. The study uses firm-level secondary data and involves no human participants.

**Author contributions**

Ha Hong Hanh: supervision, validation, and writing (review and editing); she directed the revision. [AUTHOR_INPUT_NEEDED: confirm the CRediT roles of both authors.] Nguyen Van Trung: conceptualization, data curation, formal analysis, methodology, software, visualization, and writing (original draft, review and editing).
