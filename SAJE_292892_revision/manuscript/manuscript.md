% Manuscript, version 4 (round-2 review after the Sustainable Finance Review desk rejection; notes/review_round2/).
% Numbers are {{key}} placeholders filled from project_R/outputs/numbers.csv.
% Display equations: "$$latex <LaTeX> | (n)" are converted to Word equations (OMML) by the builder.
@@ title
Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets

@@ running_title
ESG score coverage and firm value

@@ abstract
Most listed firms in Southeast Asia have no environmental, social, and governance (ESG) score, so they sit outside the universe that ESG-screened investors can hold. Following {{n_treated_all}} non-financial firms that entered London Stock Exchange Group (LSEG) ESG coverage, we find that their market-to-book (MTB) ratio grew {{mtb_runup_m5}} percent more than that of never-scored firms beforehand, a run-up absent in a large Malaysian wave. Under parallel trends, we detect no MTB gain after the first score (estimate {{mtb_att}}; 95% interval {{mtb_lo}} to {{mtb_hi}}) for high- or low-score firms.

@@ keywords
Emerging markets; ESG investing; ESG ratings; Firm valuation; Rating coverage; Sustainable finance

@@ jel
G14, G15, G32, M14, Q56

@@ body
# 1. Introduction

Environmental, social, and governance (ESG) scores decide which firms ESG-screened investors can hold. A fund, index, or mandate restricted to scored stocks cannot buy a firm that no provider covers. In five Southeast Asian equity markets, most listed firms had no score from the London Stock Exchange Group (LSEG) at any point between 2014 and 2024. Much of the academic literature on ESG ratings uses LSEG scores (Berg, Kölbel, et al., 2022; Dobrick et al., 2023). Entry into the scored universe therefore raises two questions: which firms get scored, and does entry change how the market values them?

Theory provides no single answer to the second question. Investor recognition predicts a gain for every newly scored firm, because a first score makes it visible to ESG-screening investors and a broader investor base raises its price (Merton, 1987). ESG preferences predict a gain for firms the score reveals as green and a loss for those it reveals as brown (Pástor et al., 2021; Pedersen et al., 2021). Evidence on index additions and rating changes is mixed (Section 2).

The first question matters because providers choose whom to score. They are likely to add a firm once it is large, liquid, and discloses enough to be scored, and their scores rise with firm size (Dobrick et al., 2023; Drempetic et al., 2020). If coverage follows growth in market value, a comparison of scored and unscored firms, or a regression that pools all years around coverage, attributes past growth to the score. U.S. studies link coverage by more raters to fewer ESG violations (Tsang et al., 2024), lower emissions and more ownership by high-ESG institutions (Bikmetova & Pirinsky, 2026), and dividend increases (Tsang et al., 2025). None examines valuation in emerging markets, where most firms are unscored and coverage has expanded in waves.

We study Indonesia, Malaysia, the Philippines, Singapore, and Thailand. LSEG, whose scores were earlier distributed as Refinitiv ESG and ASSET4, extended coverage in market-specific waves. Of the {{n_treated_all}} non-financial firms that entered coverage between {{n_coh_min_year}} and {{n_coh_max_year}}, {{n_coh_2020_2023}} did so in 2020 to 2023, and {{n_my_2021_2022}} were Malaysian firms first scored in 2021 or 2022. We compare these firms with {{n_never}} never-scored firms before and after each firm's first scored year, using the estimator of Callaway and Sant'Anna (2021), which makes this comparison cohort by cohort and avoids the biases of two-way fixed effects regressions under staggered timing (Baker et al., 2022; Goodman-Bacon, 2021). A pre-analysis plan, committed to version control before the estimation code, records the hypotheses, sample rules, estimator, and robustness checks; we label every later analysis exploratory.

The evidence has four parts. First, scored firms had outgrown never-scored firms of similar size, country, and industry before their first scored year (Fig. 1). From five years before the first score to the base year (the year before it), their market capitalization grew {{mcap_runup_m5}}% more (95% interval {{mcap_runup_lo}}% to {{mcap_runup_hi}}%) and their market-to-book (MTB) ratio {{mtb_runup_m5}}% more ({{mtb_runup_lo}}% to {{mtb_runup_hi}}%). The joint test of parallel pre-coverage trends rejects for market capitalization but not, at the 5% level, for MTB (p {{mtb_pre_p_txt}}). Second, the run-up differs across coverage waves (Fig. 2): it is large in the {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 and absent in the {{n_wMY}} Malaysian firms first scored in 2021 and 2022, the largest wave in the data. Third, under parallel trends from the base year, the average effect on log MTB over the first four years is {{mtb_att}} (95% interval {{mtb_lo}} to {{mtb_hi}}). The difference between firms with high and low initial scores, which tests the preference channel, is {{mtb_diff}} (p {{mtb_diff_p_txt}}); with a minimum detectable difference of {{mtb_diff_mde}}, we cannot exclude a moderate difference. Fourth, a static two-way fixed effects regression on the same data attributes a {{mtb_R6_pct}}% MTB increase to coverage.

We do not claim that coverage has no effect on valuation. With coverage dated one year later, to the first year in which investors could have seen a score, the MTB ratio changes by {{mtb_R10_pct}}% relative to never-scored firms (95% interval {{mtb_R10_lo_pct}}% to {{mtb_R10_hi_pct}}%). Because we measure this decline from the end of the run-up, it cannot separate a reversal of earlier growth from an effect of coverage. The decline loses significance if post-coverage departures from parallel trends may reach about a quarter of the largest pre-coverage year-to-year change (Rambachan & Roth, 2023), at which point the headline estimate's interval widens to {{mtb_rm025_lo}} to {{mtb_rm025_hi}}.

The study makes three contributions. First, it adds valuation and an emerging-market setting to the rating-coverage literature (Bikmetova & Pirinsky, 2026; Tsang et al., 2024, 2025) and shows which firms one provider brought into its scored universe: outside its largest wave, firms that had just outgrown their peers. Second, it adds coverage initiation to the evidence on ratings as price-relevant information: unlike an MSCI downgrade (Berg, Heeb, et al., 2022), entry into LSEG coverage was not followed by a detectable revaluation for firms with high or low initial scores. Third, it shows how selection into the scored universe can make scored firms look more valuable than the score itself made them.

Section 2 reviews the literature and states the hypotheses. Sections 3, 4, and 5 present the data, methods, and results. Section 6 discusses mechanisms and implications, Section 7 states the limitations, and Section 8 concludes.

# 2. Related Literature and Hypotheses

## 2.1. ESG ratings as information and certification

ESG ratings can move prices when they change what investors know or which investors may hold a stock. Evidence on rating changes points to both channels. MSCI downgrades are followed by lower ownership by U.S. funds with ESG mandates and a one-year abnormal return of approximately −2.37%, with weaker effects for upgrades (Berg, Heeb, et al., 2022). Calendar-time portfolios of firms with rating changes show a similar asymmetry (Shanaev & Ghimire, 2022). Hartzmark and Sussman (2019) show that publishing Morningstar sustainability ratings for mutual funds redirected fund flows, although any effect on the stocks those funds hold is indirect.

Certification by inclusion in a sustainability index is the closest analog to a first score. Additions to the Dow Jones Sustainability Index have limited price effects relative to similar firms outside the index (Hawn et al., 2018). A replication finds no price effect but more analyst following after addition and more long-term ownership after continued membership (Durand et al., 2019). In sell-side research, losing analyst coverage lowers prices (Kelly & Ljungqvist, 2012), and the first report on a neglected stock raises its price when the report is favorable (Demiroglu & Ryngaert, 2010).

## 2.2. ESG demand, recognition, and price pressure

Two channels predict a valuation response to a first score. Under investor recognition, a stock known to few investors trades at a discount because a small group bears its idiosyncratic risk (Merton, 1987). Recognition therefore predicts a gain for every newly scored firm. S&P 500 additions raise prices permanently, whereas deletions do not lower them permanently (Chen et al., 2004). Under ESG preferences, investors accept lower expected returns on assets they classify as sustainable (Pástor et al., 2021; Pedersen et al., 2021). Because a first score reveals where a firm stands, this channel predicts gains for firms revealed as green and losses for those revealed as brown, and a pooled average can be close to zero when the two signs offset.

Demand shocks also shape realized prices before any rating event. Pástor et al. (2022) show that the high realized returns of green assets reflect unexpected increases in ESG concerns rather than high expected returns. S&P 500 inclusion raises prices (Harris & Gurel, 1986; Shleifer, 1986), and part of the increase reverses within weeks (Harris & Gurel, 1986). A run-up in value before coverage, followed by a flat path, is consistent with a demand shift that ended, with selection on growth, or with both.

## 2.3. Which firms providers score

We expect providers to cover firms in the indices their clients track and firms that disclose enough to be scored, although our data omit the provider's coverage rules. Mandatory sustainability reporting increases the information available on listed firms (Krueger et al., 2024). The provider we study gives higher scores to larger firms, a bias documented for its ASSET4 scores (Drempetic et al., 2020) and its Refinitiv scores (Dobrick et al., 2023), and it has rewritten historical scores on a large scale (Berg et al., 2020). Providers disagree about the same firm (Berg, Kölbel, et al., 2022; Christensen et al., 2022), and the disagreement is priced (Avramov et al., 2022; Gibson Brandon et al., 2021). If providers select firms that have grown, a scored-unscored comparison mixes the effect of coverage with the growth that led to it.

## 2.4. Hypotheses

The pre-analysis plan states three hypotheses, all tested two-sided.

H~1~ (primary): The initiation of LSEG ESG coverage changes the log MTB ratio of scored firms relative to comparable never-scored firms. The recognition channel predicts an increase. The preference channel predicts an increase for high-score firms and a decrease for low-score firms. The selection view predicts relative growth before coverage and, after it, no effect if the growth was permanent or a decline if it was transient.

H~2~ (secondary): Coverage changes log market capitalization, book leverage, and log total assets.

H~3~ (heterogeneity): The effect on log MTB differs between firms with initial scores above and below their cohort median. Only the preference channel depends on what the score says, so this test separates it from recognition.

# 3. Institutional Setting and Data

## 3.1. ESG disclosure and rating coverage in the five markets

The five markets introduced sustainability reporting rules for listed firms at different times. Bursa Malaysia required a sustainability statement in annual reports for financial years ending on or after December 31, 2016, phased in from the largest companies over two years (Bursa Malaysia, 2015). Singapore requires listed issuers to publish a comply-or-explain sustainability report for financial years ending on or after December 31, 2017 (Singapore Exchange, 2016). Philippine listed companies have attached a comply-or-explain sustainability report since the 2019 annual reports (Securities and Exchange Commission Philippines, 2019). A 2017 Indonesian regulation applies to listed companies from 2020 (Otoritas Jasa Keuangan, 2017), and Thai listed companies have reported sustainability information in the 56-1 One Report since the fiscal year ending in 2021 (Tilleke & Gibbins, 2020). We could not confirm the dates of earlier Thai guidance.

Several providers score firms in these markets. In Malaysia, FTSE Russell, another part of LSEG, scored only the constituents of the FTSE Bursa Malaysia EMAS index, about 30% of listed companies, until Bursa Malaysia and LSEG agreed in November 2022 to extend these scores to all Main and ACE Market companies (Bernama, 2022). The LSEG ESG score we study, formerly Refinitiv ESG, is a separate product. Some newly covered firms may thus already have had scores that our data do not record, so our event is the initiation of LSEG ESG coverage, not a firm's first ESG rating of any kind. Throughout, a score is the LSEG ESG score, a data-vendor assessment built from company disclosures; a rating is the broader class of assessments, including MSCI-type ratings produced by analysts; and coverage means that LSEG publishes a score for the firm.

Table S2 and Fig. S1 of the Supplemental Appendix show that coverage arrived in waves: {{n_th_sg_2019_2020}} first scores in Thailand and Singapore in 2019 and 2020, and {{n_my_2021_2022}} in Malaysia in 2021 and 2022. Of the {{n_treated_all}} scored firms, {{n_my_treated}} ({{pct_my_treated}}%) are Malaysian, and Malaysian and Thai firms together make up {{pct_my_th_treated}}%. Because first scored years can precede publication (Section 3.2), we cannot link the Malaysian wave to the November 2022 agreement on FTSE Russell scores. The waves do not follow a single reporting rule: the Thai wave preceded the One Report requirement, and the Malaysian wave came years after Bursa Malaysia's rule. Singapore, Indonesia, and the Philippines have too few first scores per year to relate them to their rules. The data do not record why the provider expanded coverage. The pooled estimates are weighted toward Malaysia and Thailand; therefore, we also report estimates by market and wave.

## 3.2. Sample and coverage timing

The data cover all {{n_universe_firms}} firms listed in the five markets from 2014 to 2024 ({{n_universe_fy}} firm-years). They combine the annual LSEG ESG score (LSEG, 2025), not the controversy-adjusted combined score, with accounting and market data from Compustat Global (S&P Global Market Intelligence, 2025).

We call firms without an LSEG score unscored and firms that never receive one in our sample never-scored, and the latter form the comparison group. Dropping financial firms leaves {{n_nonfin_firms}} firms. A firm's first scored year, g, is its first fiscal year with an LSEG ESG score, and its base year is g − 1. Only {{n_cov_gap}} of the {{n_treated_all}} scored firms have a later year without a score; therefore, we treat coverage as permanent, the staggered-adoption setting of Callaway and Sant'Anna (2021). Excluding the {{n_cov2014}} firms scored in 2014, which have no pre-coverage year, leaves {{n_est_firms}} firms and {{n_est_fy}} firm-years: {{n_treated_all}} firms first scored between {{n_coh_min_year}} and {{n_coh_max_year}} and {{n_never}} never-scored firms. A firm-year enters an estimate only if its outcome is observed in both the base year and the comparison year, so counts differ slightly across Tables S4 and S6 of the Supplemental Appendix. We set MTB ratios at or below zero (negative book equity) to missing; {{pct_miss_mtb_never}}% of never-scored and {{pct_miss_mtb_scored}}% of scored firm-years lack a log MTB ratio. Never-scored firms are smaller on average; a check in Section 5.5 and Appendix B restricts scored firms to the size range of the controls.

The first scored year may precede the year in which investors first see a score. First, the score for fiscal year g draws on reports published after the year ends, so it reaches investors in year g + 1 at the earliest. Second, the provider has rewritten historical scores on a large scale (Berg et al., 2020), and scores for the five most recent fiscal years can change after publication (Sahin et al., 2023); if the provider backfilled a firm's history at entry, the gap exceeds one year. Both features move the true publication date later, never earlier, so they cannot create the pre-coverage growth we report but can place pre-publication years in our post-coverage window. Section 5.4 therefore also dates coverage one and two years later.

## 3.3. Outcomes

The primary outcome is the natural logarithm of the MTB ratio, the market value of equity divided by its book value. The secondary outcomes are log market capitalization, log total assets, and book leverage, total debt divided by total assets. Because the data contain neither stock returns nor shares outstanding, we use MTB for valuation and treat market capitalization, which mixes price and share changes, and total assets as measures of firm scale. Amounts are in U.S. dollars. We winsorize all four variables at the 1st and 99th percentiles of the pooled sample before taking logarithms.

# 4. Methods

## 4.1. Target parameter and identification

In the notation of Callaway and Sant'Anna (2021), let G~i~ be the first year in which firm i has an LSEG ESG score, with G~i~ = ∞ if it is never scored, and let Y~i,t~(g) be the potential outcome of firm i in year t if it were first scored in year g. The group-time average treatment effect on the treated (ATT), the average effect in year t for firms first scored in year g, is

$$latex \mathrm{ATT}(g,t)=\mathbb{E}\left[Y_{i,t}(g)-Y_{i,t}(\infty)\mid G_i=g\right] | (1)

We identify it under conditional parallel trends relative to the base year:

$$latex \mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=g\right]=\mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=\infty\right] | (2)

where X~i~ contains country and industry indicators and log total assets and its square, measured in the base year. Because assumption (2) concerns changes in outcomes, level differences between scored and never-scored firms (Table 1) do not violate it, but a different growth path before coverage would.

## 4.2. Estimation

For each cohort g and year t, we regress the long difference ΔY~i,t~ = Y~i,t~ − Y~i,g−1~ on X~i~ among never-scored firms (Sant'Anna & Zhao, 2020):

$$latex \Delta Y_{i,t}=X_i'\beta_{g,t}+u_{i,t},\qquad G_i=\infty | (3)

where β~g,t~ is the coefficient vector of the cell and u~i,t~ is the error. We omit the propensity-score model of the doubly robust estimator because total assets overlap poorly: {{pct_scored_above_p95}}% of scored firms have larger base-year total assets than the 95th percentile of never-scored firms. The estimated group-time effect is

$$latex \widehat{\mathrm{ATT}}(g,t)=\frac{1}{N_{g,t}}\sum_{i:\,G_i=g}\left(\Delta Y_{i,t}-X_i'\hat{\beta}_{g,t}\right) | (4)

where N~g,t~ is the number of firms first scored in year g with data in years g − 1 and t, and β̂~g,t~ is estimated from Eq. (3). We average by event year, e = t − g, weighting cohorts by the number of scored firms (Callaway & Sant'Anna, 2021):

$$latex \hat{\theta}(e)=\sum_{g}\frac{N_{g,g+e}}{\sum_{h}N_{h,h+e}}\,\widehat{\mathrm{ATT}}(g,g+e) | (5)

where h indexes the cohort. The headline estimate averages, with the same weights, all cells from the first scored year to three years later:

$$latex \hat{\theta}_{\mathrm{post}}=\frac{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}\,\widehat{\mathrm{ATT}}(g,t)}{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}} | (6)

Cohorts first scored after 2021 are not observed for all four post-coverage years, so cohort composition changes across event years; row R11 keeps only the cohorts observed through event year 3.

The design involves three choices. First, baseline controls are never-scored firms; later-scored firms, which may also be growing toward the provider's universe, join them only in check R1. Second, all comparisons, including pre-coverage ones, are relative to the base year: a negative θ̂(e) for e ≤ −2 means that scored firms grew faster than never-scored firms with the same covariates from year g + e to the base year. Third, we measure the covariates in the base year, at the end of any run-up. Because the provider's scores rise with firm size (Dobrick et al., 2023), conditioning on base-year total assets matches scored firms to never-scored firms of similar size and can absorb part of the run-up. Checks therefore drop the covariates, measure total assets two years before the base year, or replace the quadratic with quintile indicators.

## 4.3. Inference

We bootstrap the aggregated effects by resampling firms with their full time series, a nonparametric alternative to the multiplier bootstrap of Callaway and Sant'Anna (2021). All specifications share the same {{B_BOOT}} draws and fixed seed, so differences between specifications have a valid joint distribution. We report the bootstrap standard error, the percentile 95% confidence interval, and a normal-approximation two-sided p-value. The minimum detectable effect (MDE) at 80% power in a two-sided 5% test is

$$latex \mathrm{MDE}=(z_{0.975}+z_{0.80})\,\widehat{\mathrm{SE}}\approx 2.8\,\widehat{\mathrm{SE}} | (7)

where z~0.975~ and z~0.80~ are standard normal quantiles and the hatted SE is the bootstrap standard error. We test the primary outcome at the 5% level and Holm-adjust the p-values, but not the confidence intervals, of the three secondary outcomes; an interval that excludes zero can therefore accompany an adjusted p-value above 5%, as for log total assets in Table 2. The joint test of parallel pre-coverage trends is

$$latex W=\hat{\theta}_{\mathrm{pre}}'\,\hat{V}_{\mathrm{pre}}^{-1}\,\hat{\theta}_{\mathrm{pre}}\ \sim\ \chi^2_{4} | (8)

where θ̂~pre~ stacks the estimates for e = −5 to −2 and V̂~pre~ is their bootstrap covariance matrix. Because pre-trend tests can have low power and conditioning on them can distort inference (Roth, 2022), we report W only as a diagnostic.

Coverage arrived in market-level waves, so a market or industry shock can affect many scored firms at once. The country indicators in Eq. (3) absorb market-wide changes within each cell; because five markets are too few clusters, an exploratory check resamples the {{n_clusters}} market-by-industry clusters instead of firms.

## 4.4. Sensitivity to departures from parallel trends

Because the pre-coverage estimates cast doubt on assumption (2), we add exploratory checks not in the pre-analysis plan. The first removes a linear pre-coverage trend that passes through zero in the base year:

$$latex \hat{b}=\frac{\sum_{e=-5}^{-1}(e+1)\,\hat{\theta}(e)}{\sum_{e=-5}^{-1}(e+1)^{2}},\qquad \tilde{\theta}(e)=\hat{\theta}(e)-\hat{b}\,(e+1) | (9)

where b̂ is the fitted slope and θ̃(e) is the trend-adjusted estimate, which we average over e = 0 to 3 with the weights of Eq. (6). The second bounds the bias in the spirit of the relative-magnitude restriction of Rambachan and Roth (2023). Let δ(e) denote the post-coverage violation of assumption (2) in event year e. We assume that δ(e) changes from year to year by at most M̄ times Δ, the largest change between consecutive pre-coverage estimates:

$$latex \left|\delta(e)-\delta(e-1)\right|\le \bar{M}\,\max_{s\le -1}\left|\hat{\theta}(s)-\hat{\theta}(s-1)\right|\equiv \bar{M}\,\Delta,\qquad \delta(-1)=0 | (10)

where s indexes the pre-coverage event years. The bias for event year e is at most M̄Δ(e + 1), and we widen the headline confidence interval by the weighted average of this bound. With M̄ = 0.25, the post-coverage gap may drift each year by a quarter of the largest yearly change before coverage. We also add to X~i~ the growth of log market capitalization from year g − 3 to the base year (row R8), matching scored firms to never-scored firms of similar pre-coverage growth.

## 4.5. Benchmark regression and robustness checks

As a benchmark, we estimate on scored and never-scored firms the static two-way fixed effects (TWFE) regression analyzed by Goodman-Bacon (2021) and Baker et al. (2022):

$$latex Y_{i,t}=\alpha_i+\lambda_t+\beta\,D_{i,t}+\varepsilon_{i,t},\qquad D_{i,t}=\mathbf{1}\left[t\ge G_i\right] | (11)

where α~i~ and λ~t~ are firm and year effects, D~i,t~ marks years from the first score onward, and ε~i,t~ is the error term. We include no covariates, use all event years, and cluster standard errors by firm. The coefficient β compares all post-coverage with all pre-coverage years, so it averages over any run-up; with staggered timing, it also uses already scored firms as controls for later cohorts.

The pre-analysis plan fixed rows R1 to R6 of Table 3: four robustness checks, a placebo, and the benchmark of Eq. (11). The checks add not-yet-scored firms to the controls (R1), drop the covariates (R2), exclude the 2020 and 2021 cohorts (R3), and keep only control firms whose base-year log total assets reach the 10th percentile among scored firms of the same cohort (R4). The placebo (R5) dates coverage three years early and uses only years before the actual score. Rows R7 to R11 and Tables S7 and S8 of the Supplemental Appendix are exploratory; Section 5 describes each check with its results.

# 5. Results

## 5.1. Which firms get scored

Table 1 compares scored firms in the base year with never-scored firm-years in the sample. Scored firms are larger: their median market capitalization is {{t1_mcap_tr_med}} million U.S. dollars against {{t1_mcap_nv_med}} million, and their median total assets are {{t1_asset_ratio_med}} times as large, with normalized differences of {{t1_mcap_nd}} and {{t1_asset_nd}}. Their MTB ratio is also higher, with a mean of {{t1_mtb_tr_mean}} against {{t1_mtb_nv_mean}} and a median of {{t1_mtb_tr_med}} against {{t1_mtb_nv_med}}, while leverage differs little (normalized difference: {{t1_lev_nd}}). Because scored firms are concentrated in the base years 2019 to 2022 while never-scored firm-years span 2014 to 2024, these level differences mix calendar effects with selection. Return on assets covers fewer than half of the firm-years; therefore, we use it only descriptively. In Malaysia, where the expansion was broadest, the {{n_my_never}} never-scored firms remained smaller than the scored ones: the median total assets of scored firms were {{my_asset_ratio_med}} times those of the never-scored firms. Because scores rise with total assets in this provider's data (Dobrick et al., 2023), we compare changes and adjust for size, country, and industry in Eq. (3).

## 5.2. Average effects of the first score

Table 2 reports the headline estimates of Eq. (6). The effect on log MTB is {{mtb_att}}, with a standard error of {{mtb_se}} and a 95% confidence interval of {{mtb_lo}} to {{mtb_hi}}. Under assumption (2), the data are compatible with changes in the MTB ratio from {{mtb_lo_pct}}% to {{mtb_hi_pct}}%, so increases of a few percent remain possible. The MDE from Eq. (7) is {{mtb_mde}}, about {{mtb_mde_pct}}%. With the cluster bootstrap, the interval is {{mtb_cl_lo}} to {{mtb_cl_hi}}.

After Holm adjustment, no secondary outcome changes significantly at the 5% level. Log market capitalization changes by {{mcap_att}} (p {{mcap_pholm_txt}}), leverage by {{lev_att_pp}} percentage points (p {{lev_pholm_txt}}), and log total assets by {{asset_att}} (p {{asset_pholm_txt}}, against an unadjusted p {{asset_p_txt}}). Under assumption (2), the MTB estimate shows no sign of the gain that the recognition channel predicts (Merton, 1987). It also does not show the demand response to newly published sustainability ratings that Hartzmark and Sussman (2019) document for funds.

## 5.3. Dynamics before and after the first score

Fig. 1 plots the event-time estimates of Eq. (5) for all four outcomes. Before the first score, the estimates for market capitalization and MTB are negative and rise toward zero. In event years −5 and −4, the MTB estimates are {{mtb_em5}} and {{mtb_em4}} (p {{mtb_em5_p_txt}} and p {{mtb_em4_p_txt}}). From event year −5 to the base year, scored firms' market capitalization grew {{mcap_runup_m5}}% more than that of never-scored firms, and their MTB ratio {{mtb_runup_m5}}% more. We call this relative growth the run-up; with the cluster bootstrap, the 95% interval for the MTB run-up is {{mtb_runup_cl_lo}}% to {{mtb_runup_cl_hi}}%. The joint test of Eq. (8) rejects parallel pre-coverage trends for market capitalization (p {{mcap_pre_p_txt}}) but not at the 5% level for MTB (p {{mtb_pre_p_txt}}). With the cluster bootstrap, the two tests give p {{mcap_cl_pre_p_txt}} and p {{mtb_cl_pre_p_txt}}. As Roth (2022) cautions, a non-rejection is not evidence that pre-coverage trends are parallel. Log total assets follow a weaker version of the pattern, and leverage falls toward the base year (pre-trend p {{lev_pre_p_txt}}).

After the first score, the MTB estimates for event years 0 to 3 lie between {{mtb_e3}} and {{mtb_e2}}, and none differs from zero at the 5% level. The market capitalization estimate is {{mcap_e1}} in event year 1 (p {{mcap_e1_p_txt}}) and not significant later. Only {{mtb_nfirms_e4}} scored firms from {{mtb_ncoh_e4}} cohorts reach event year 4; therefore, we plot that year but exclude it from Eq. (6) (Appendix B reports its estimates). Log total assets rise to {{asset_e3}} by event year 3, and leverage returns toward its earlier level. The MTB gap between scored and never-scored firms thus widens before coverage and stops widening afterward. Because we cannot separate rising prices from new shares in market capitalization, we base statements about valuation on the MTB ratio.

Fig. 2 separates the two largest coverage waves from the remaining cohorts. We drew the wave boundaries from Table S2 after seeing the coverage counts; therefore, this split is exploratory. The {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 show the largest run-up. From event year −5 to the base year, their MTB ratio grew {{mtb_r4wTHSG_runup_m5}}% and their market capitalization {{mcap_r4wTHSG_runup_m5}}% more than those of never-scored firms (pre-trend p {{mtb_r4wTHSG_pre_p_txt}} and p {{mcap_r4wTHSG_pre_p_txt}}). The {{n_wMY}} Malaysian firms first scored in 2021 and 2022 show no run-up: their pre-coverage MTB estimates range from {{mtb_r4wMY_em5}} in event year −5 to {{mtb_r4wMY_em2}} in event year −2 (pre-trend p {{mtb_r4wMY_pre_p_txt}}). The {{n_wOth}} firms in the remaining cohorts, including {{n_coh_2023}} firms first scored in 2023, fall in between. Their MTB ratio lies below that of never-scored firms by a similar amount in event years −5 and −2 ({{mtb_r4wOth_em5}} and {{mtb_r4wOth_em2}}) and catches up in the base year (pre-trend p {{mtb_r4wOth_pre_p_txt}}), while their market capitalization shows no run-up (pre-trend p {{mcap_r4wOth_pre_p_txt}}). After the first score, no group shows an MTB gain: the estimates of Eq. (6) are {{mtb_r4wMY}} for the Malaysian wave, {{mtb_r4wTHSG}} for the Thai and Singaporean wave, and {{mtb_r4wOth}} for the remaining cohorts. Market capitalization fell after coverage in the Malaysian wave ({{mcap_r4wMY}}, p {{mcap_r4wMY_p_txt}}), which accounts for the negative pooled estimate.

## 5.4. Timing of coverage and sensitivity to pre-trends

Table 3 presents the robustness checks. Rows R1 to R6 were pre-specified, and rows R7 to R11 are exploratory. Row R10 dates coverage one year after the first scored year, when a score could first have been published. Because scores were backfilled or revised (Berg et al., 2020; Sahin et al., 2023), this also moves the base year closer to the end of the run-up. The MTB effect is {{mtb_R10}}, a change of about {{mtb_R10_pct}}% (95% interval {{mtb_R10_lo}} to {{mtb_R10_hi}}; p {{mtb_R10_p_txt}}), estimated from {{mtb_R10_ntr}} scored and {{mtb_R10_nco}} control firms. With the cluster bootstrap, its interval is {{mtb_clR10_lo}} to {{mtb_clR10_hi}}. Its joint pre-trend test gives p {{mtb_R10_pre_p_txt}}. With M̄ = 0.25 in Eq. (10), its interval runs from {{mtb_R10_rm025_lo}} to {{mtb_R10_rm025_hi}} and includes zero. Appendix B reports the breakdown value of M̄ and two further timing variants, which also give declines.

Fig. S2 plots the event-time path under R10. The decline grows with time since coverage, from {{mtb_R10_e0}} in the re-dated event year 0 to {{mtb_R10_e3}} in event year 3. The baseline path in Fig. 1 does not show this because its later event years come from early cohorts, while its first post-coverage years pool all cohorts; Appendix B reconciles the two paths. The long-horizon reading therefore rests on the R10 path and its interval, which come from the early cohorts only. If firms are selected at an unusually high valuation that later partly reverses, the decline measures the reversal and can hide an offsetting positive effect of coverage. If valuations would otherwise have stayed at their pre-coverage peak, coverage lowered them. The data cannot separate the two readings.

Row R11 keeps the {{n_R11_cohorts}} cohorts first scored by 2021 and observed through event year 3, with {{mtb_R11_ntr}} scored and {{mtb_R11_nco}} control firms. Its MTB effect of {{mtb_R11}} (p {{mtb_R11_p_txt}}) shows that changing cohort composition does not explain the headline estimate. Row R7 removes a linear pre-trend with Eq. (9). The MTB effect becomes {{mtb_R7}} (95% interval {{mtb_R7_lo}} to {{mtb_R7_hi}}), negative because a continued run-up would have raised valuations further. Row R8 compares scored firms with never-scored firms that grew at a similar rate before coverage and so share any tendency to revert. Its MTB effect is {{mtb_R8}} (p {{mtb_R8_p_txt}}), with an interval from {{mtb_R8_lo}} to {{mtb_R8_hi}} that admits gains of several percent. R8 conditions only on market capitalization growth from year g − 3 to the base year. Because control firms matched on past growth can themselves revert, it does not settle the reversal question.

Table S5 reports the bounds of Eq. (10). The largest change between consecutive pre-coverage MTB estimates was {{mtb_rm_dmax}}. With M̄ = 0.25, the interval for the MTB effect is {{mtb_rm025_lo}} to {{mtb_rm025_hi}}; with M̄ = 1, it widens to {{mtb_rm100_lo}} to {{mtb_rm100_hi}}. Every interval includes zero and admits moderate effects in either direction. The upper limit of the unadjusted interval lies just below a 5% increase in the MTB ratio. Any departure with M̄ above about {{mtb_bd5}} thus admits an increase of 5%, and any departure at all admits a positive effect. The absence of a detected positive effect is therefore conditional on assumption (2).

## 5.5. Robustness

None of the pre-specified rows R1 to R4 shows an effect on log MTB that differs from zero at the 10% level. The effect is {{mtb_R1}} when not-yet-scored firms join the controls, as Callaway and Sant'Anna (2021) propose, and {{mtb_R2}} without the covariates of Eq. (3). It is {{mtb_R3}} without the 2020 and 2021 cohorts and {{mtb_R4}} when we drop control firms below the size range of scored firms. The market capitalization and total assets results are less stable than the MTB result. Under the size restriction, the market capitalization effect shrinks to {{mcap_R4}} and the total assets effect is {{asset_R4}}, against {{asset_R2}} without covariates. We therefore do not read the total assets estimate in Table 2 as evidence that coverage causes growth. Appendix B reports variants of the size covariate and support (Table S7, Fig. S2): the run-up does not depend on conditioning on base-year total assets, and the post-coverage MTB estimate does not depend on extrapolating the size adjustment to the largest firms.

The placebo in row R5, which dates coverage three years before the first score within pre-score years, yields {{mtb_R5}} on log MTB (p {{mtb_R5_p_txt}}) and {{mcap_R5}} on log market capitalization (p {{mcap_R5_p_txt}}). This failure restates the pre-coverage growth in Fig. 1 and adds no independent evidence. The static TWFE regression in Eq. (11) in row R6 attributes increases of {{mtb_R6}} in log MTB (p {{mtb_R6_p_txt}}) and {{mcap_R6}} in log market capitalization to coverage. In the decomposition of Table S8 (Appendix B), comparing each cohort with its own base year, rather than pooling all years, accounts for approximately half of the MTB gap. Conditioning on base-year total assets accounts for most of the rest, and the choice of controls and window for little.

Row R9 and Table S1 exclude one market at a time. The MTB effect ranges from {{mtb_lomo_min}} to {{mtb_lomo_max}} and is {{mtb_R9}} without Malaysia (p {{mtb_R9_p_txt}}), whereas the market capitalization effect turns to {{mcap_R9}}. Appendix B reports market-by-market estimates (Table S3) and early versus late cohorts; we do not read the positive estimate for the few firms first scored by 2019 as evidence of a gain for early entrants.

## 5.6. Does the score itself matter?

The last three rows of Table 3 divide scored firms at the cohort median of their first ESG score. The MTB effect is {{mtb_high}} for high-score and {{mtb_low}} for low-score entrants, and the difference of {{mtb_diff}} (standard error {{mtb_diff_se}}, p {{mtb_diff_p_txt}}) is not significant. Because the score rises with firm size (correlation {{h3_cor_score_size}} with base-year log total assets), a split on the raw score partly separates large from small firms. Table S7 therefore repeats the split after purging the score of base-year total assets, country, and cohort, which together explain {{h3_r2_score}} of its variance. The difference is then {{mtb_h3r_diff}} (standard error {{mtb_h3r_diff_se}}, p {{mtb_h3r_diff_p_txt}}). Neither split supports the sign pattern that the preference channel predicts, but with minimum detectable differences of {{mtb_diff_mde}} and {{mtb_h3r_diff_mde}}, neither test excludes moderate differences.

## 5.7. Economic magnitude

Under assumption (2), the largest increase compatible with the headline interval is of the same order as the announcement return of 4.86% that Demiroglu and Ryngaert (2010) report for the first analyst coverage of neglected stocks. It is also twice the one-year abnormal return that follows an MSCI downgrade (Berg, Heeb, et al., 2022). Annual year-end ratios would miss short-lived price pressure, so our estimates concern the lasting revaluation of the kind that a permanent rise in investor recognition would produce (Chen et al., 2004; Merton, 1987). A lasting effect half as large as the MTB run-up would lie at the upper end of the headline interval; therefore, any such effect is small relative to the growth that preceded coverage.

# 6. Discussion

## 6.1. What the ordering of events shows

The clearest result is an ordering of events. On average, firms entered the scored universe after their MTB ratio and market capitalization had grown faster than those of never-scored firms, and their MTB ratio stopped gaining afterward. Several mechanisms fit this ordering. The provider may have added firms once they had grown large and visible enough to matter to its clients (Section 2.3). Firms may have become scoreable by publishing a first sustainability report, joining an index, or issuing equity, any of which can coincide with rising value; the fall in leverage toward the base year is consistent with equity issuance. Firms may also have started or expanded sustainability reporting when doing well or planning to raise capital, a strategic-disclosure reading that our data cannot test. Each mechanism implies that entry into a provider's coverage marks the end of a period of relative growth, not a random draw.

The flat post-coverage MTB path admits three readings, depending on the counterfactual trend (Rambachan & Roth, 2023; Roth, 2022). With parallel paths from the base year, the data show no detected effect of coverage, and the interval of Section 5.2 bounds its size. With a continued run-up, coverage lowered valuations relative to the trend. With a partly transitory run-up, the flat path is consistent with a positive coverage effect that offset a reversal. The awareness evidence on index additions predicts a permanent gain from recognition (Chen et al., 2004); under assumption (2), we detect none. The decline that the publication-dated estimates of Section 5.4 show for early cohorts could reflect a reversal, partly offset by a positive coverage effect, or a negative effect of coverage. The evidence therefore does not show that coverage has no effect: no heterogeneity-robust specification detects a valuation gain, and the bounds do not exclude one.

## 6.2. Relation to evidence on ESG ratings and certification

The absence of a detected gain fits the evidence on certification by sustainability indices, where additions have little price effect relative to comparable firms (Durand et al., 2019; Hawn et al., 2018). This contrasts with the price effects of MSCI downgrades (Berg, Heeb, et al., 2022; Shanaev & Ghimire, 2022). Two features of our setting may explain this difference. First, the evidence that ESG funds trade on ratings concerns MSCI, the one rating that explains their holdings (Berg, Heeb, et al., 2022). Entering the coverage of another provider may change little for these funds. Second, scored firms were large and visible before coverage (Table 1), and some may have had FTSE Russell scores, which leaves less room for recognition (Merton, 1987). Disagreement among providers (Berg, Kölbel, et al., 2022; Serafeim & Yoon, 2023) further weakens the information in any single score. U.S. studies find that coverage changes firm conduct (Bikmetova & Pirinsky, 2026; Tsang et al., 2024) and payout (Tsang et al., 2025). We find no stable change in leverage or total assets and observe no measures of conduct.

The pre-coverage run-up also relates to evidence on ESG demand. Pástor et al. (2022) show that realized green returns can reflect unexpected shifts in demand. A one-time demand shift, or selection after one, would produce a run-up followed by a flat path. Without ownership data, we cannot determine whether ESG investors bought these firms before or after coverage. In Section 4.4, with M̄ = 0.25, the data admit MTB changes from {{mtb_rm025_lo_pct}}% to {{mtb_rm025_hi_pct}}%, so we cannot exclude a demand shift of a few percent after coverage.

## 6.3. Implications

These implications are bounded by the design: one provider whose score is not the rating shown to drive ESG fund holdings, annual data, five markets, and no data on ownership, returns, or publication dates.

For rating providers, data users, and ESG investors, the LSEG scored universe in these markets tilts toward large firms and, outside the Malaysian wave, toward firms that have just outgrown their peers. Because the first scored year can precede publication and the provider may have filled in the history, backtests around coverage initiation may suffer from look-ahead bias (Berg et al., 2020; Sahin et al., 2023). Our annual MTB data do not speak to the returns of a strategy that buys newly scored firms.

For exchanges and regulators, broad expansions of coverage within a market, such as the Malaysian wave, appear to select less on prior growth, but we cannot attribute that wave to the November 2022 arrangement between Bursa Malaysia and LSEG (Bernama, 2022), and we detect no MTB gain within it. Under assumption (2), our evidence does not support using rating coverage as a lever for issuer valuation.

For listed firms, under assumption (2), the estimates give no support to the expectation that a first LSEG score will raise valuation through investor recognition or preferences (Merton, 1987; Pástor et al., 2021). The interval excludes increases above {{mtb_hi_pct}}% with the firm bootstrap and above {{mtb_cl_hi_pct}}% with the cluster bootstrap, but smaller effects remain possible. For empirical research, a cross-sectional valuation premium of scored firms or a static TWFE estimate can reflect selection into coverage rather than an effect of scores (Table S8), so studies comparing scored and unscored firms in these markets should model coverage timing and report pre-coverage dynamics.

# 7. Limitations

The study has eight limitations. First, the provider chooses when to cover a firm, and we have no coverage variation unrelated to firm performance. The post-coverage estimates rest on conditional parallel trends from the base year, which the pre-coverage estimates question. Our sensitivity analysis uses a linear trend and a simplified bound, not the confidence sets of Rambachan and Roth (2023). Second, the data are annual and may contain backfilled or revised scores, so we observe neither first-score publication dates nor announcement returns; dating coverage later closes only part of this gap. Third, we observe only LSEG coverage, whose score is not the rating that the cited evidence links to ESG fund holdings (Berg, Heeb, et al., 2022). For firms with earlier scores from other providers, such as FTSE Russell scores for Malaysian index constituents (Bernama, 2022), the event is an additional score. We do not examine domestic ESG channels such as exchange sustainability indices or Shariah screens. Fourth, the data contain no stock returns, shares outstanding, ownership, foreign holdings, foreign-ownership limits, index membership, or firm-level sustainability report dates. We therefore cannot separate price changes from share issuance, test the recognition channel directly, or link first scores to index entry or first sustainability reports. We date the reporting rules in Section 3.1 by market, not by firm, from regulatory texts and, for Thailand and Malaysia, from secondary summaries. Fifth, a few market capitalization values are implausibly large; pooled winsorization limits but does not correct them. Sixth, Malaysian and Thai firms make up {{pct_my_th_treated}}% of scored firms and dominate the pooled estimates; five markets are too few for market-level inference. Seventh, with an MDE of {{mtb_mde}} on log MTB, our design would detect smaller effects with less than 80% probability. Eighth, the unrecorded download date leaves the vintage of revisable recent scores uncertain.

# 8. Conclusion

On average, entry into LSEG ESG coverage in five Southeast Asian markets followed relative growth and was not followed by a detected rise in MTB ratios. Before their first scored year, scored firms grew faster than never-scored firms of similar size, country, and industry, by {{mtb_runup_m5}}% in MTB ({{mtb_runup_lo}}% to {{mtb_runup_hi}}%). The Malaysian firms covered in the large 2021 and 2022 wave showed no such run-up. Under parallel trends, the headline effect is {{mtb_att}} (95% interval {{mtb_lo}} to {{mtb_hi}}), and we detect no difference between firms with high and low initial scores. Dating coverage one year later gives an MTB change of {{mtb_R10_pct}}%, which may reflect a reversal of the run-up or a negative effect of coverage. Departures from parallel trends, such as those before coverage, would admit effects of several percent in either direction. Comparisons of scored and unscored firms that ignore coverage timing can attribute this selection to the score.

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

LSEG. (2025). *LSEG ESG scores (ESG score field), annual, 2014–2024* [Data set]. LSEG Workspace.

Merton, R. C. (1987). A simple model of capital market equilibrium with incomplete information. *The Journal of Finance*, *42*(3), 483–510. https://doi.org/10.1111/j.1540-6261.1987.tb04565.x

Otoritas Jasa Keuangan. (2017). *Peraturan Otoritas Jasa Keuangan Nomor 51/POJK.03/2017 tentang penerapan keuangan berkelanjutan bagi lembaga jasa keuangan, emiten, dan perusahaan publik* [Regulation on the application of sustainable finance to financial services institutions, issuers, and public companies].

Pástor, Ľ., Stambaugh, R. F., & Taylor, L. A. (2021). Sustainable investing in equilibrium. *Journal of Financial Economics*, *142*(2), 550–571. https://doi.org/10.1016/j.jfineco.2020.12.011

Pástor, Ľ., Stambaugh, R. F., & Taylor, L. A. (2022). Dissecting green returns. *Journal of Financial Economics*, *146*(2), 403–424. https://doi.org/10.1016/j.jfineco.2022.07.007

Pedersen, L. H., Fitzgibbons, S., & Pomorski, L. (2021). Responsible investing: The ESG-efficient frontier. *Journal of Financial Economics*, *142*(2), 572–597. https://doi.org/10.1016/j.jfineco.2020.11.001

Rambachan, A., & Roth, J. (2023). A more credible approach to parallel trends. *The Review of Economic Studies*, *90*(5), 2555–2591. https://doi.org/10.1093/restud/rdad018

Roth, J. (2022). Pretest with caution: Event-study estimates after testing for parallel trends. *American Economic Review: Insights*, *4*(3), 305–322. https://doi.org/10.1257/aeri.20210236

Sahin, Ö., Bax, K., Paterlini, S., & Czado, C. (2023). The pitfalls of (non-definitive) environmental, social, and governance scoring methodology. *Global Finance Journal*, *56*, Article 100780. https://doi.org/10.1016/j.gfj.2022.100780

Sant'Anna, P. H. C., & Zhao, J. (2020). Doubly robust difference-in-differences estimators. *Journal of Econometrics*, *219*(1), 101–122. https://doi.org/10.1016/j.jeconom.2020.06.003

Securities and Exchange Commission Philippines. (2019). *Memorandum Circular No. 4, series of 2019: Sustainability reporting guidelines for publicly-listed companies*. https://www.sec.gov.ph/wp-content/uploads/2020/09/2019MCNo4.pdf

Serafeim, G., & Yoon, A. (2023). Stock price reactions to ESG news: The role of ESG ratings and disagreement. *Review of Accounting Studies*, *28*(3), 1500–1530. https://doi.org/10.1007/s11142-022-09675-3

Shanaev, S., & Ghimire, B. (2022). When ESG meets AAA: The effect of ESG rating changes on stock returns. *Finance Research Letters*, *46*(Part A), Article 102302. https://doi.org/10.1016/j.frl.2021.102302

Shleifer, A. (1986). Do demand curves for stocks slope down? *The Journal of Finance*, *41*(3), 579–590. https://doi.org/10.1111/j.1540-6261.1986.tb04518.x

Singapore Exchange. (2016). *SGX Mainboard Rules 711A and 711B: Sustainability report* [Listing rules]. SGX Rulebook. https://rulebook.sgx.com/rulebook/711a

S&P Global Market Intelligence. (2025). *Compustat Global, annual fundamentals, 2014–2024* [Data set].

Tilleke & Gibbins. (2020, September). *Thailand's SEC unifies annual report for listed companies*. https://www.tilleke.com/insights/thailands-sec-unifies-annual-report-listed-companies/

Tsang, A., Wang, Y., Xiang, Y., & Yu, L. (2024). The rise of ESG rating agencies and management of corporate ESG violations. *Journal of Banking & Finance*, *169*, Article 107312. https://doi.org/10.1016/j.jbankfin.2024.107312

Tsang, A., Wang, Y., Xiang, Y., & Yu, L. (2025). ESG ratings and dividend changes: Evidence from the initiation of nonfinancial agency coverage. *Corporate Governance: An International Review*, *33*(4), 554–577. https://doi.org/10.1111/corg.12615

@@ exhibits
kind:=table
caption:=Table 1|Characteristics of scored firms in the base year and of never-scored firm-years
csvfile:=table1_formatted.csv
widths:=1.7,0.65,0.65,0.55,0.7,0.7,0.65,0.8
note:=Scored firms are measured in the year before their first LSEG ESG score; never-scored firms contribute all firm-years from 2014 to 2024. Norm. diff. is the difference in means divided by the square root of the average of the two variances.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 2|Average effect of the first LSEG ESG score over event years 0 to 3
csvfile:=table2_formatted.csv
widths:=1.55,0.6,0.5,1.15,0.6,0.5,0.6,0.55,0.6
note:=ATT is the average effect over event years 0 to 3 (Eq. 6), with bootstrap standard errors and unadjusted 95% confidence intervals (CI); p-values of the three secondary outcomes are Holm-adjusted. MDE is the minimum detectable effect at 80% power, and pre-trend p is the joint test of Eq. (8).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Fig. 1|Event-time effects of the first LSEG ESG score on market-to-book ratio, market capitalization, leverage, and total assets
png:=Fig1.png
note:=Markers show the estimates of Eq. (5) relative to event year −1 (set to zero), with bootstrap 95% intervals; open markers and dotted bars are years before the first score. Event year 4 is not part of Eq. (6).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Fig. 2|Event-time effects on market-to-book ratio and market capitalization by coverage wave
png:=Fig2.png
note:=Markers show the estimates of Eq. (5) for each wave against all never-scored firms, with bootstrap 95% intervals; marker shape and line type identify the wave. All other cohorts are firms first scored outside the two waves.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 3|Robustness checks, timing of coverage, and heterogeneity by initial ESG score
csvfile:=table3_formatted.csv
widths:=1.9,1.15,1.15,1.15,1.15
note:=Cells show the average effect over event years 0 to 3 (0 to 2 in R5; the Eq. (11) coefficient in R6), with bootstrap standard errors in parentheses (firm-clustered in R6); R1 to R6 are pre-specified and R7 to R11 exploratory. \*, \*\*, and \*\*\* denote significance at 10%, 5%, and 1% (unadjusted p-values).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

@@ ia_intro
This Supplemental Appendix accompanies "Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets." Table S1 re-estimates the average effects of the first score over event years 0 to 3 after excluding one market at a time. Table S2 and Fig. S1 show the number of non-financial firms that received their first LSEG ESG score in each year, by market. Table S3 reports the estimates for each market separately, Table S4 the number of firm-years available for each outcome, Table S5 the relative-magnitude bounds of Eq. (10) in the paper, and Table S6 the number of scored and control firms by event year for ln MTB. Table S7 and Fig. S2 report the exploratory analyses added after the second review, and Table S8 decomposes the gap between the static two-way fixed effects estimate and the baseline. The pre-analysis plan is provided with the replication package.

@@ exhibits_ia
kind:=table
caption:=Table S1|Leave-one-market-out estimates of the average effect of the first LSEG ESG score
csvfile:=tableIA1_formatted.csv
widths:=1.9,1.15,1.15,1.15,1.15
note:=Cells show the average effect over event years 0 to 3 without the named market, with bootstrap standard errors in parentheses. \*, \*\*, and \*\*\* denote significance at 10%, 5%, and 1% (unadjusted p-values).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S2|Number of non-financial firms by year of first LSEG ESG score and market
csvfile:=tableIA2_formatted.csv
widths:=1.3,0.85,0.85,0.9,0.9,0.85,0.75
note:=Firms first scored in 2014 are excluded because they have no pre-coverage year.
source:=Author's calculations from LSEG ESG scores.

kind:=figure
caption:=Fig. S1|Number of non-financial firms by year of first LSEG ESG score
png:=FigIA1.png
note:=Bars show the number of firms in the estimation sample first scored in each year, all five markets combined.
source:=Author's calculations from LSEG ESG scores.

kind:=table
caption:=Table S3|Estimates of the average effect of the first LSEG ESG score by market
csvfile:=tableIA3_formatted.csv
widths:=1.2,1.1,1.1,1.1,1.1,0.9
note:=Cells show the average effect over event years 0 to 3 estimated within each market, with bootstrap standard errors in parentheses. \*, \*\*, and \*\*\* denote significance at 10%, 5%, and 1% (unadjusted p-values).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S4|Firm-years and firms available for each outcome
csvfile:=tableIA4_formatted.csv
widths:=1.7,1.0,0.9,1.0,0.9,1.0
note:=Counts refer to the estimation sample; the last column is the share of firm-years with a missing outcome.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S5|Relative-magnitude bounds for the average effect of the first LSEG ESG score
csvfile:=tableIA5_formatted.csv
widths:=1.7,0.6,1.2,0.9,1.6
note:=The bias bound is M̄ times the largest change between consecutive pre-coverage estimates times the weighted mean of (e + 1) over event years 0 to 3 (Eq. 10). The robust interval widens the bootstrap 95% interval by this bound.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S6|Scored firms and control firms by event year for ln(MTB)
csvfile:=tableIA6_formatted.csv
widths:=1.2,1.3,1.1,2.2
note:=Scored firms are summed over cohorts; control firms are the smallest and largest number of never-scored firms across cohort cells.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S7|Alternative specifications, inference, and initial-score splits for the average effect of the first LSEG ESG score
csvfile:=tableIA7_formatted.csv
widths:=2.3,1.1,0.75,1.1,0.75
note:=Cells show the average effect over event years 0 to 3 with bootstrap standard errors in parentheses and the joint pre-trend p-value of Eq. (8); all rows are exploratory. \*, \*\*, and \*\*\* denote significance at 10%, 5%, and 1% (unadjusted p-values).
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S8|Decomposition of the gap between the static two-way fixed effects estimate and the baseline estimate
csvfile:=tableIA8_formatted.csv
widths:=3.0,1.4,1.4
note:=Rows move step by step from Eq. (11) on all firm-years to the baseline of Eq. (6), with standard errors in parentheses (firm-clustered for TWFE, bootstrap otherwise). \*, \*\*, and \*\*\* denote significance at 10%, 5%, and 1%.
source:=Author's calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Fig. S2|Event-time effects on ln(MTB) under alternative specifications and dating
png:=FigIA2.png
note:=Panel A varies the size covariate and the support with the first scored fiscal year as event; panel B dates the event one year later. Marker shape and line type identify the specification, and bars are bootstrap 95% intervals.
source:=Author's calculations from LSEG ESG scores and Compustat Global.
