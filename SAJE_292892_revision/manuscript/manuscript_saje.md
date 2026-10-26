% Revised manuscript for the Southeast Asian Journal of Economics (manuscript 292892), first revision.
% Base text: manuscript.md as submitted (round 0). {+ ... +} marks text that is new or changed in this revision.
% Numbers are {{key}} placeholders from project_R/outputs/numbers.csv and numbers_saje.csv.
@@ title
Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets

@@ abstract
{+Most listed firms in Southeast Asia have no environmental, social, and governance (ESG) score, so investors who screen on scores cannot hold them. We ask which firms enter the London Stock Exchange Group (LSEG) ESG database and what happens to their valuation around entry. We follow {{n_treated_all}} non-financial firms in Indonesia, Malaysia, the Philippines, Singapore, and Thailand that received a first recorded score and compare them with {{n_never}} never-scored firms. Entry is selective. Scored firms are larger, and on average their market-to-book ratio had grown {{mtb_runup_m5}}% faster than that of similar firms before the first recorded score, a run-up not detected in a broad Malaysian wave. After entry, the valuation gap stops widening, but whether coverage itself changed valuations depends on when investors first saw the score and on untestable trend assumptions. Research and investment screens that compare rated with unrated firms should model who gets rated and when.+}

@@ keywords
ESG ratings, Firm valuation, Rating coverage, {+Selection, Southeast Asia,+} Sustainable finance

@@ jel
G14, G15, G32, M14, Q56

@@ ack_head
Acknowledgments

@@ ack_blind
{+We thank the editor and an anonymous referee for comments that substantially improved this paper.+}

@@ body
# 1. Introduction

{+Environmental, social, and governance (ESG) scores work as an entry ticket. A fund, index, or mandate that may hold only scored stocks cannot buy a firm that no provider covers, so the set of scored firms decides which firms ESG-screened capital can reach.+} In five Southeast Asian equity markets, most listed firms had no score from the London Stock Exchange Group (LSEG) at any point between 2014 and 2024{+, and much of the academic evidence on ESG ratings uses LSEG data+} (Berg, Kölbel, et al., 2022; Dobrick et al., 2023). {+This paper asks two questions: which firms enter the scored universe, and what happens to their market valuation around entry?+}

{+The economic intuition runs as follows. If a score makes a firm visible to more investors, its price should rise, because a wider investor base shares its risk (Merton, 1987); if the score also tells investors whether the firm is green or brown, prices should move in opposite directions for the two groups (Pástor et al., 2021; Pedersen et al., 2021). A provider, however, is likely to add a firm once it is large, liquid, and discloses enough to be scored, and its scores rise with firm size (Dobrick et al., 2023; Drempetic et al., 2020). If firms enter after a period of rising value, a comparison of scored and unscored firms credits the score with growth that came before it. The paper asks how far the data can separate the effect of being scored from the selection of who is scored.+}

Studies, mostly of U.S. firms, link coverage by more raters to fewer ESG violations (Tsang et al., 2024), lower emissions and more ownership by high-ESG institutions (Bikmetova & Pirinsky, 2026), and dividend increases (Tsang et al., 2025). None examines valuation in emerging markets, where most firms are unscored and coverage has expanded in waves.

We study Indonesia, Malaysia, the Philippines, Singapore, and Thailand. Of the {{n_treated_all}} non-financial firms {+whose first recorded LSEG score falls+} between {{n_coh_min_year}} and {{n_coh_max_year}}, {{n_coh_2020_2023}} {+had it+} in 2020 to 2023, and {{n_my_2021_2022}} were Malaysian firms first scored in 2021 or 2022. We compare these firms with {{n_never}} never-scored firms before and after each firm's {+first recorded score, the first fiscal year for which the database holds a score+}, using the estimator of Callaway and Sant'Anna (2021), which avoids the biases of two-way fixed effects regressions under staggered timing (Baker et al., 2022; Goodman-Bacon, 2021). {+The first recorded score is not necessarily the date on which investors could first see the score (Section 3.3).+} A pre-analysis plan, committed to version control before the estimation code, records the hypotheses, sample rules, estimator, and robustness checks; we label every later analysis exploratory.

{+The evidence has three parts. First, entry is selective. Scored firms are larger, and they had outgrown never-scored firms of similar size, country, and industry before their first recorded score (Figure 1).+} From five years before the first {+recorded+} score to the base year (the year before it), their market capitalization grew {{mcap_runup_m5}}% more (95% interval {{mcap_runup_lo}}% to {{mcap_runup_hi}}%) and their market-to-book (MTB) ratio {{mtb_runup_m5}}% more ({{mtb_runup_lo}}% to {{mtb_runup_hi}}%). {+The run-up is large in the {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 and not detected in the {{n_wMY}} Malaysian firms first scored in 2021 and 2022, the largest wave in the data (Figure 2).+}

{+Second, after entry the MTB gap stops widening, but the data do not pin down a causal effect of coverage. Under parallel trends from the base year, the average change in log MTB over the first four years is {{mtb_att}} (95% interval {{mtb_lo}} to {{mtb_hi}}). Dated one year later, when a score could first have been public, the change is {{mtb_R10_pct}}%. Section 5.4 shows that most of this difference arises because the later dating measures valuations from the first recorded year, at the top of the run-up, and that the decline appears only in the waves that had a run-up. Third, a static two-way fixed effects regression on the same data attributes a {{mtb_R6_pct}}% MTB increase to coverage, an artifact of comparing firms after entry with the same firms before their growth.+}

{+The paper makes three contributions. First, it documents selection into ESG rating coverage in Southeast Asian markets and adds valuation to the rating-coverage literature (Bikmetova & Pirinsky, 2026; Tsang et al., 2024, 2025): one provider scored firms that had outgrown their peers, most clearly outside its largest wave. Second, it shows why the valuation effect of coverage is hard to identify: entry follows growth and the recorded first score may precede publication, so the estimates depend on dating and on trend assumptions. None of the main specifications detects a gain, but the bounds do not exclude one. Third, it warns that comparisons of scored and unscored firms, and regressions that pool all years around entry, can attribute selection to the score.+}

{+Section 2 sets out the channels through which a score could change value and the selection that can mimic them. Section 3 describes the markets, the data, and what the first recorded score does and does not date. Section 4 presents the estimator and its identifying assumption. Section 5 reports who gets scored, the valuation path around entry, and the checks that the timing and the sample raise. Section 6 discusses what the evidence can and cannot say about mechanisms and policy, Section 7 lists the limitations, and Section 8 concludes.+}

# 2. Related Literature and Hypotheses

## 2.1. ESG ratings as information and certification

ESG ratings can move prices when they change what investors know or which investors may hold a stock. MSCI downgrades are followed by lower ownership by U.S. funds with ESG mandates and a one-year abnormal return of approximately −2.37%, with weaker effects for upgrades (Berg, Heeb, et al., 2022), and calendar-time portfolios show a similar asymmetry (Shanaev & Ghimire, 2022). Hartzmark and Sussman (2019) show that publishing Morningstar sustainability ratings for mutual funds redirected fund flows.

Certification by inclusion in a sustainability index is the closest analog to a first score. Additions to the Dow Jones Sustainability Index have limited price effects relative to similar firms outside the index (Hawn et al., 2018). A replication finds no price effect but more analyst following after addition and more long-term ownership after continued membership (Durand et al., 2019). In sell-side research, losing analyst coverage lowers prices (Kelly & Ljungqvist, 2012), and the first report on a neglected stock raises its price when the report is favorable (Demiroglu & Ryngaert, 2010).

## 2.2. ESG demand, recognition, and price pressure

Two channels predict a valuation response to a first score. Under investor recognition, a stock known to few investors trades at a discount because a small group bears its idiosyncratic risk (Merton, 1987). Recognition therefore predicts a gain for every newly scored firm. S&P 500 additions raise prices permanently, whereas deletions do not lower them permanently (Chen et al., 2004). Under ESG preferences, investors accept lower expected returns on assets they classify as sustainable (Pástor et al., 2021; Pedersen et al., 2021). Because a first score reveals where a firm stands, this channel predicts gains for firms revealed as green and losses for those revealed as brown, and a pooled average can be close to zero when the two signs offset. {+Both channels work through who trades the stock, and investor groups in the region respond differently to trading conditions: on the Stock Exchange of Thailand, local institutional investors adjust their trading to brokerage fees over the long run, whereas foreign and retail investors adjust in the short run (Sudsawasd & Sakdapat, 2026). A first score could therefore matter more for some investor groups than for others.+}

Demand shocks also shape realized prices before any rating event. Pástor et al. (2022) show that the high realized returns of green assets reflect unexpected increases in ESG concerns rather than high expected returns. S&P 500 inclusion raises prices (Harris & Gurel, 1986; Shleifer, 1986), and part of the increase reverses within weeks (Harris & Gurel, 1986). A run-up in value before coverage, followed by a flat path, is consistent with a demand shift that ended, with selection on growth, or with both.

## 2.3. Which firms providers score

We expect providers to cover firms in the indices their clients track and firms that disclose enough to be scored, although our data omit the provider's coverage rules. Mandatory sustainability reporting increases the information available on listed firms (Krueger et al., 2024). {+Who discloses also depends on who owns the firm: among Vietnamese listed consumer-goods firms, outside our sample, foreign ownership is associated with higher corporate social responsibility scores, and state and family ownership with lower ones (Nguyen, 2025).+} The provider we study gives higher scores to larger firms, a bias documented for its ASSET4 scores (Drempetic et al., 2020) and its Refinitiv scores (Dobrick et al., 2023), and it has rewritten historical scores on a large scale (Berg et al., 2020). Providers disagree about the same firm (Berg, Kölbel, et al., 2022; Christensen et al., 2022), and the disagreement is priced (Avramov et al., 2022; Gibson Brandon et al., 2021). If providers select firms that have grown, a scored-unscored comparison mixes the effect of coverage with the growth that led to it.

## 2.4. Hypotheses

The pre-analysis plan states three hypotheses, all tested two-sided.

H~1~ (primary): The initiation of LSEG ESG coverage changes the log MTB ratio of scored firms relative to comparable never-scored firms. The recognition channel predicts an increase. The preference channel predicts an increase for high-score firms and a decrease for low-score firms. The selection view predicts relative growth before coverage and, after it, no effect if the growth was permanent or a decline if it was transient.

H~2~ (secondary): Coverage changes log market capitalization, book leverage, and log total assets.

H~3~ (heterogeneity): The effect on log MTB differs between firms with initial scores above and below their cohort median. Only the preference channel depends on what the score says, so {+a difference would point toward it; the absence of a difference cannot rule it out (Section 5.9).+}

{+The two channels motivate these predictions, but our data cannot observe them. They contain no ownership, fund holdings, trading activity, or investor participation, so we cannot tell whether a missing valuation response reflects weak recognition, weak demand for ESG-rated firms, or something else. What the data can evaluate is narrower: whether entry follows relative growth, how the valuation gap evolves around entry, and whether that path differs with the initial score. We return to this distinction in Section 6.3.+}

# 3. Institutional Setting and Data

## 3.1. ESG disclosure and rating coverage in the five markets

The five markets introduced sustainability reporting rules for listed firms at different times. Bursa Malaysia required a sustainability statement in annual reports for financial years ending on or after December 31, 2016, phased in from the largest companies {+between 2016 and 2018+} (Bursa Malaysia, 2015). Singapore requires listed issuers to publish a comply-or-explain sustainability report for financial years ending on or after December 31, 2017 (Singapore Exchange, 2016). Philippine listed companies have attached a comply-or-explain sustainability report since the 2019 annual reports (Securities and Exchange Commission Philippines, 2019). A 2017 Indonesian regulation applies {+to listed companies other than small- and medium-asset issuers+} from 2020 (Otoritas Jasa Keuangan, 2017), and Thai listed companies have reported sustainability information in the 56-1 One Report since the fiscal year ending in 2021 (Tilleke & Gibbins, 2020). We could not confirm the dates of earlier Thai guidance.

Several providers score firms in these markets. In Malaysia, FTSE Russell, another part of LSEG, scored only the constituents of the FTSE Bursa Malaysia EMAS index, about 30% of listed companies, until Bursa Malaysia and LSEG agreed in November 2022 to extend these scores to all Main and ACE Market companies (Bernama, 2022). The LSEG ESG score we study, formerly Refinitiv ESG, is a separate product, so our event is the initiation of LSEG ESG coverage, not a firm's first ESG rating of any kind. Throughout, a score is the LSEG ESG score, a rating is the broader class of assessments, including MSCI-type ratings, and coverage means that LSEG publishes a score for the firm.

Table S2 and Figure S1 of the supplementary material show that coverage arrived in waves: {{n_th_sg_2019_2020}} first scores in Thailand and Singapore in 2019 and 2020, and {{n_my_2021_2022}} in Malaysia in 2021 and 2022. Of the {{n_treated_all}} scored firms, {{n_my_treated}} ({{pct_my_treated}}%) are Malaysian, and Malaysian and Thai firms together make up {{pct_my_th_treated}}%. Because first {+recorded+} scores can precede publication (Section {+3.3+}), we cannot link the Malaysian wave to the November 2022 agreement. The waves do not follow a single reporting rule: the Thai wave preceded the One Report requirement, and the Malaysian wave came years after Bursa Malaysia's rule. {+Section 5.10 reports the weight of each market and wave in the pooled estimates.+}

## 3.2. Sample

The data cover all {{n_universe_firms}} firms listed in the five markets from 2014 to 2024 ({{n_universe_fy}} firm-years). They combine the annual LSEG ESG score (LSEG, 2025), not the controversy-adjusted combined score, with accounting and market data from Compustat Global (S&P Global Market Intelligence, 2025).

We call firms without an LSEG score unscored and firms that never receive one in our sample never-scored, and the latter form the comparison group. Dropping financial firms leaves {{n_nonfin_firms}} firms. A firm's first {+recorded score year+}, g, is its first fiscal year with an LSEG ESG score, and its base year is g − 1. Only {{n_cov_gap}} of the {{n_treated_all}} scored firms have a later year without a score; therefore, we treat coverage as permanent, the staggered-adoption setting of Callaway and Sant'Anna (2021). Excluding the {{n_cov2014}} firms scored in 2014, which have no pre-coverage year, leaves {{n_est_firms}} firms and {{n_est_fy}} firm-years: {{n_treated_all}} firms first scored between {{n_coh_min_year}} and {{n_coh_max_year}} and {{n_never}} never-scored firms. A firm-year enters an estimate only if its outcome is observed in both the base year and the comparison year, so counts differ slightly across Tables S4 and S6 of the supplementary material. {+The source data contain no MTB ratio at or below zero, so firm-years with negative book equity appear as missing, like firm-years without market or accounting data, and we cannot separate the two cases.+} {{pct_miss_mtb_never}}% of never-scored and {{pct_miss_mtb_scored}}% of scored firm-years lack a log MTB ratio{+; Section 5.7 examines whether these gaps change the comparison+}. Never-scored firms are smaller on average; {+Section 5.6 restricts+} scored firms to the size range of the controls.

## {+3.3. What the first recorded score dates+}

{+The event in this paper is the first recorded score: the first fiscal year for which our extract of the LSEG database holds a score. It is not the date on which investors could first see the score. For our question the difference matters, because a score recorded today for an earlier fiscal year was not information available to investors in that year.+}

The first {+recorded score+} may precede the year in which investors first see a score {+for three reasons+}. First, the score for fiscal year g draws on reports published after {+that fiscal year ends, so it reaches investors only after the year closes, in year g + 1 for a December year-end.+} Second, the provider has rewritten historical scores on a large scale (Berg et al., 2020), and scores for the five most recent fiscal years can change after publication (Sahin et al., 2023){+. Third,+} if the provider backfilled a firm's history at entry, the gap exceeds one year. {+Publication therefore follows the end of fiscal year g, so the first recorded score dates entry too early, never too late.+}

{+We could not recover the publication dates. Our extract contains each score by fiscal year, with no publication or update date, and the scores it holds are the ones in the database at download, after any revision. We found no public archive of the provider's coverage lists for these markets, and the provider's methodology documents describe how scores are updated, not when each firm entered. LSEG also distributes a point-in-time version of its ESG data that keeps values as they were published (LSEG, n.d.), but our extract does not contain it. We therefore keep two concepts apart. The first recorded score is what we observe; publicly observable coverage begins at an unknown date from g + 1 onward. We report the valuation path with coverage dated at g, at g + 1, and at g + 2, and we draw conclusions only where they hold across these datings.+}

{+Late dating cannot create the pre-coverage growth we report, because that growth occurs before g and therefore before any possible publication. It can, however, place pre-publication years in the post-coverage window of the baseline estimate, which is why Section 5.4 compares the datings directly.+}

## {+3.4. Outcomes and recording errors+}

The primary outcome is the natural logarithm of the MTB ratio, the market value of equity divided by its book value. The secondary outcomes are log market capitalization, log total assets, and book leverage, total debt divided by total assets. Because the data contain neither stock returns nor shares outstanding, we use MTB for valuation and treat market capitalization, which mixes price and share changes, and total assets as measures of firm scale. Amounts are in U.S. dollars. We winsorize all four variables at the 1st and 99th percentiles of the pooled sample before taking logarithms.

{+A few market capitalization records are implausibly large; one Indonesian firm is recorded at {{s_flag_ID_maxmcap}} billion U.S. dollars. We identify such records with an internal-consistency rule. Market capitalization divided by the MTB ratio gives the implied book equity, which cannot exceed total assets. Of the {{s_flag_All_checked}} firm-years with all three items, {{s_flag_All_r12}} have ratios between one and two, which can arise when the items are measured on different dates, and {{s_flag_All_r210}} have ratios between two and ten. Our main rule flags firm-years in which the implied book equity exceeds ten times total assets, an error of an order of magnitude: {{s_flag_All_n}} firm-years ({{s_flag_pct_checked}}%), {{s_flag_All_scored}} of them for scored firms. A stricter rule, a ratio above two, flags {{s_flag_All_n2}} firm-years. Winsorization limits their influence but does not correct them, so Section 5.7 re-estimates without them.+}

# 4. Methods

## 4.1. Target parameter and identification

In the notation of Callaway and Sant'Anna (2021), let G~i~ be the first {+recorded score year of+} firm i, with G~i~ = ∞ if it is never scored, and let Y~i,t~(g) be the potential outcome of firm i in year t if it were first scored in year g. The group-time average treatment effect on the treated (ATT), the average effect in year t for firms first scored in year g, is

$$latex \mathrm{ATT}(g,t)=\mathbb{E}\left[Y_{i,t}(g)-Y_{i,t}(\infty)\mid G_i=g\right] | (1)

We identify it under conditional parallel trends relative to the base year:

$$latex \mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=g\right]=\mathbb{E}\left[Y_{i,t}(\infty)-Y_{i,g-1}(\infty)\mid X_i,G_i=\infty\right] | (2)

where X~i~ contains country and industry indicators and log total assets and its square, measured in the base year. Because assumption (2) concerns changes in outcomes, level differences between scored and never-scored firms (Table 1) do not violate it, but a different growth path before coverage would.

{+Assumption (2) asks that, after the base year, scored firms would have followed the valuation path of never-scored firms of the same size, market, and industry had they not been scored. Section 5.2 shows that the pooled sample violates the analogous condition before the base year, so the pre-coverage estimates cannot be used to defend it. Two arguments make it plausible in parts of the sample, and one argues against it. First, in the large Malaysian wave the pre-coverage path is flat, so for these firms the assumption asks only that a flat relative path stays flat. Second, if the provider adds firms once they cross a size or visibility threshold, relative growth stops being a reason for selection once the threshold is crossed, and conditioning on base-year size compares firms on the same side of it. Against it, if part of the run-up was transitory, scored firms would have fallen back toward never-scored firms even without a score, and the estimates would understate any effect of coverage. We therefore treat the post-coverage estimates as conditional on assumption (2) and give most weight to evidence that does not depend on it: the ordering of growth and entry, and the contrast between waves with and without a run-up.+}

## 4.2. Estimation

For each cohort g and year t, we regress the long difference ΔY~i,t~ = Y~i,t~ − Y~i,g−1~ on X~i~ among never-scored firms (Sant'Anna & Zhao, 2020):

$$latex \Delta Y_{i,t}=X_i'\beta_{g,t}+u_{i,t},\qquad G_i=\infty | (3)

where β~g,t~ is the coefficient vector of the cell and u~i,t~ is the error. We omit the propensity-score model of the doubly robust estimator because total assets overlap poorly: {{pct_scored_above_p95}}% of scored firms have larger base-year total assets than the 95th percentile of never-scored firms. {+Outcome regression does not remove this support problem; it extrapolates the relation estimated among controls to scored firms larger than most controls. Section 5.6 therefore restricts scored firms to the size range of the controls, in the spirit of the overlap trimming of Crump et al. (2009), where the doubly robust estimator becomes usable (Sant'Anna & Zhao, 2020).+} The estimated group-time effect is

$$latex \widehat{\mathrm{ATT}}(g,t)=\frac{1}{N_{g,t}}\sum_{i:\,G_i=g}\left(\Delta Y_{i,t}-X_i'\hat{\beta}_{g,t}\right) | (4)

where N~g,t~ is the number of firms first scored in year g with data in years g − 1 and t, and β̂~g,t~ is estimated from Eq. (3). We average by event year, e = t − g, weighting cohorts by the number of scored firms (Callaway & Sant'Anna, 2021):

$$latex \hat{\theta}(e)=\sum_{g}\frac{N_{g,g+e}}{\sum_{h}N_{h,h+e}}\,\widehat{\mathrm{ATT}}(g,g+e) | (5)

where h indexes the cohort. The headline estimate averages, with the same weights, all cells from the first {+recorded score year+} to three years later:

$$latex \hat{\theta}_{\mathrm{post}}=\frac{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}\,\widehat{\mathrm{ATT}}(g,t)}{\sum_{(g,t):\,0\le t-g\le 3}N_{g,t}} | (6)

Cohorts first scored after 2021 are not observed for all four post-coverage years, so cohort composition changes across event years; row R11 keeps only the cohorts observed through event year 3.

The design involves three choices. First, baseline controls are never-scored firms; later-scored firms join them only in check R1. Second, all comparisons, including pre-coverage ones, are relative to the base year: a negative θ̂(e) for e ≤ −2 means that scored firms grew faster than never-scored firms with the same covariates from year g + e to the base year. Third, we measure the covariates in the base year, at the end of any run-up, so conditioning on base-year total assets matches scored firms to never-scored firms of similar size and can absorb part of the run-up{+; Section 5.6 varies this choice+}.

## 4.3. Inference

We bootstrap the aggregated effects by resampling firms with their full time series, a nonparametric alternative to the multiplier bootstrap of Callaway and Sant'Anna (2021). All specifications share the same {{B_BOOT}} draws and fixed seed, so differences between specifications have a valid joint distribution. We report the bootstrap standard error, the percentile 95% confidence interval, and a normal-approximation two-sided p-value. The minimum detectable effect (MDE) at 80% power in a two-sided 5% test is

$$latex \mathrm{MDE}=(z_{0.975}+z_{0.80})\,\widehat{\mathrm{SE}}\approx 2.8\,\widehat{\mathrm{SE}} | (7)

where z~0.975~ and z~0.80~ are standard normal quantiles and the hatted SE is the bootstrap standard error. We test the primary outcome at the 5% level and Holm-adjust the p-values, but not the confidence intervals, of the three secondary outcomes; an interval that excludes zero can therefore accompany an adjusted p-value above 5%, as for log total assets in Table 2. The joint test of parallel pre-coverage trends is

$$latex W=\hat{\theta}_{\mathrm{pre}}'\,\hat{V}_{\mathrm{pre}}^{-1}\,\hat{\theta}_{\mathrm{pre}}\ \sim\ \chi^2_{4} | (8)

where θ̂~pre~ stacks the estimates for e = −5 to −2 and V̂~pre~ is their bootstrap covariance matrix. Because pre-trend tests can have low power and conditioning on them can distort inference (Roth, 2022), we report W only as a diagnostic.

Coverage arrived in market-level waves, so a market or industry shock can affect many scored firms at once{+, as shifts in political uncertainty do for Thai stock prices (Prukumpai et al., 2022)+}. The country indicators in Eq. (3) absorb market-wide changes within each cell; because five markets are too few clusters, an exploratory check resamples the {{n_clusters}} market-by-industry clusters instead of firms.

## 4.4. Sensitivity to departures from parallel trends

Because the pre-coverage estimates cast doubt on assumption (2), we add exploratory checks not in the pre-analysis plan. The first removes a linear pre-coverage trend that passes through zero in the base year:

$$latex \hat{b}=\frac{\sum_{e=-5}^{-1}(e+1)\,\hat{\theta}(e)}{\sum_{e=-5}^{-1}(e+1)^{2}},\qquad \tilde{\theta}(e)=\hat{\theta}(e)-\hat{b}\,(e+1) | (9)

where b̂ is the fitted slope and θ̃(e) is the trend-adjusted estimate, which we average over e = 0 to 3 with the weights of Eq. (6). The second bounds the bias in the spirit of the relative-magnitude restriction of Rambachan and Roth (2023). Let δ(e) denote the post-coverage violation of assumption (2) in event year e. We assume that δ(e) changes from year to year by at most M̄ times Δ, the largest change between consecutive pre-coverage estimates:

$$latex \left|\delta(e)-\delta(e-1)\right|\le \bar{M}\,\max_{s\le -1}\left|\hat{\theta}(s)-\hat{\theta}(s-1)\right|\equiv \bar{M}\,\Delta,\qquad \delta(-1)=0 | (10)

where s indexes the pre-coverage event years. The bias for event year e is at most M̄Δ(e + 1), and we widen the headline confidence interval by the weighted average of this bound. With M̄ = 0.25, the post-coverage gap may drift each year by a quarter of the largest yearly change before coverage. We also add to X~i~ the growth of log market capitalization from year g − 3 to the base year (row R8), matching scored firms to never-scored firms of similar pre-coverage growth.

## 4.5. Benchmark regression and robustness checks

As a benchmark, we estimate on scored and never-scored firms the static two-way fixed effects (TWFE) regression analyzed by Goodman-Bacon (2021) and Baker et al. (2022):

$$latex Y_{i,t}=\alpha_i+\lambda_t+\beta\,D_{i,t}+\varepsilon_{i,t},\qquad D_{i,t}=\mathbf{1}\left[t\ge G_i\right] | (11)

where α~i~ and λ~t~ are firm and year effects, D~i,t~ marks years from the first {+recorded+} score onward, and ε~i,t~ is the error term. We include no covariates, use all event years, and cluster standard errors by firm. The coefficient β compares all post-coverage with all pre-coverage years, so it averages over any run-up; with staggered timing, it also uses already scored firms as controls for later cohorts.

The pre-analysis plan fixed rows R1 to R6 of Table 3: four robustness checks, a placebo, and the benchmark of Eq. (11). The checks add not-yet-scored firms to the controls (R1), drop the covariates (R2), exclude the 2020 and 2021 cohorts (R3), and keep only control firms whose base-year log total assets reach the 10th percentile among scored firms of the same cohort (R4). The placebo (R5) dates coverage three years early and uses only years before the actual score. Rows R7 to R11{+, the checks in Sections 5.4 to 5.7,+} and Tables S7 and S8 of the supplementary material are exploratory; Section 5 describes each check with its results.

# 5. Results

## 5.1. Which firms get scored

Table 1 compares scored firms in the base year with never-scored firm-years in the sample. Scored firms are larger: their median market capitalization is {{t1_mcap_tr_med}} million U.S. dollars against {{t1_mcap_nv_med}} million, and their median total assets are {{t1_asset_ratio_med}} times as large. Their MTB ratio is also higher, while leverage differs little. Because scored firms are concentrated in the base years 2019 to 2022, these level differences mix calendar effects with selection. In Malaysia, where the expansion was broadest, the median total assets of scored firms, each firm measured by its median over all sample years, were {{my_asset_ratio_med}} times those of the {{n_my_never}} never-scored firms.

## 5.2. {+The valuation path before and after the first recorded score+}

Figure 1 plots the event-time estimates of Eq. (5) for all four outcomes. Before the first {+recorded+} score, the estimates for market capitalization and MTB are negative and rise toward zero; in event years −5 and −4, the MTB estimates are {{mtb_em5}} and {{mtb_em4}} (p {{mtb_em5_p_txt}} and p {{mtb_em4_p_txt}}). From event year −5 to the base year, scored firms' market capitalization grew {{mcap_runup_m5}}% more than that of never-scored firms, and their MTB ratio {{mtb_runup_m5}}% more; we call this relative growth the run-up. The joint test of Eq. (8) rejects parallel pre-coverage trends for market capitalization (p {{mcap_pre_p_txt}}) but not at the 5% level for MTB (p {{mtb_pre_p_txt}}). {+The MTB non-rejection is not evidence of parallel trends: the individual estimates for event years −5 and −4 differ from zero, the market capitalization test rejects, and pre-trend tests have low power (Roth, 2022). We therefore read the pooled sample as failing the pre-trend diagnostic.+}

After the first {+recorded+} score, the MTB estimates for event years 0 to 3 lie between {{mtb_e3}} and {{mtb_e2}}, and none differs from zero at the 5% level. Event year 4 rests on only {{mtb_nfirms_e4}} scored firms, so we plot it but exclude it from Eq. (6). The MTB gap between scored and never-scored firms thus widens before coverage and stops widening afterward. {+This description of the observed gap does not depend on assumption (2); reading the post-coverage part as an effect of coverage does.+} Because we cannot separate rising prices from new shares in market capitalization, we base statements about valuation on the MTB ratio.

Figure 2 separates the two largest coverage waves from the remaining cohorts; because we drew the wave boundaries after seeing the coverage counts, this split is exploratory. The {{n_wTHSG}} Thai and Singaporean firms first scored in 2019 and 2020 show the largest run-up: from event year −5 to the base year, their MTB ratio grew {{mtb_r4wTHSG_runup_m5}}% more than that of never-scored firms (pre-trend p {{mtb_r4wTHSG_pre_p_txt}}). The {{n_wMY}} Malaysian firms first scored in 2021 and 2022 show no detectable run-up: {{s_mtb_wMY_runup_m5}}% (95% interval {{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%; pre-trend p {{mtb_r4wMY_pre_p_txt}}), so a run-up of the pooled size cannot be ruled out for this wave, and the {{n_wOth}} firms in the remaining cohorts fall in between. After the first recorded score, no wave shows a detectable MTB gain (Table S10), while market capitalization fell in the Malaysian wave ({{mcap_r4wMY}}, p {{mcap_r4wMY_p_txt}}), which accounts for the negative pooled market capitalization estimate.

## 5.3. {+Average change after entry under assumption (2)+}

Table 2 reports the headline estimates of Eq. (6). The change in log MTB is {{mtb_att}}, with a 95% confidence interval of {{mtb_lo}} to {{mtb_hi}}. Under assumption (2), the data are compatible with changes in the MTB ratio from {{mtb_lo_pct}}% to {{mtb_hi_pct}}%, so increases of a few percent remain possible; the MDE from Eq. (7) is about {{mtb_mde_pct}}%. With the cluster bootstrap, the interval is {{mtb_cl_lo}} to {{mtb_cl_hi}}.

After Holm adjustment, no secondary outcome changes significantly at the 5% level: log market capitalization changes by {{mcap_att}} (p {{mcap_pholm_txt}}), leverage by {{lev_att_pp}} percentage points (p {{lev_pholm_txt}}), and log total assets by {{asset_att}} (p {{asset_pholm_txt}}). Under assumption (2), the MTB estimate shows no sign of the gain that the recognition channel predicts (Merton, 1987).

{+Table 3 presents the robustness checks; rows R1 to R6 were pre-specified, and rows R7 to R11 are exploratory. Row R10 dates coverage one year after the first recorded score, the earliest year in which a score could have been public. Its MTB change is {{mtb_R10}}, about {{mtb_R10_pct}}% (95% interval {{mtb_R10_lo}} to {{mtb_R10_hi}}; p {{mtb_R10_p_txt}}), and its joint pre-trend test gives p {{mtb_R10_pre_p_txt}}. We do not give the first-recorded-year estimate more weight because it was pre-specified: pre-specification guards against choosing a dating after seeing results, but it does not make the recorded year the date on which investors learned of coverage. The later dating is closer to that date on economic grounds, while the first recorded year is the date we observe; Section 5.4 shows what separates the two.+}

## 5.4. {+Reconciling the two datings+}

{+Table 4 moves from the first-recorded-year estimate to the one-year-later estimate one step at a time, so that each step changes one feature. Row 2 keeps only firms observed in both g − 1 and g, so that every later row draws on the same set of firms (a few drop out when the window or the size measure changes); this changes the MTB estimate by {{s_mtb_d_sample_A1_A0}}. Row 3 averages event years 1 to 4 instead of 0 to 3, with the same reference year g − 1; this changes it by {{s_mtb_d_window_B1_A1}} (p {{s_mtb_d_window_B1_A1_p_txt}}). Row 4 moves the reference year from g − 1 to g, which is what dating coverage one year later does to the comparison; this changes the estimate by {{s_mtb_d_reference_C1_B1}} (p {{s_mtb_d_reference_C1_B1_p_txt}}), {{s_mtb_d_reference_C1_B1_share}}% of the total gap of {{s_mtb_gap_total}}. Measuring size in g instead of g − 1 (row 5) and returning to all firms (row 6) change little. The steps are sequential, so the shares depend on their order; we take the window step before the reference step.+}

{+The reference year thus drives the difference. Dated one year later, every later valuation is compared with the first recorded year, the last year of the run-up. Moving the reference year from g − 1 to g subtracts from each later estimate the change in log MTB of the same scored firms, relative to the same never-scored firms, between g − 1 and g. The row 4 step is therefore this event-year-0 change, {{s_mtb_d_reference_C1_B1_abs}}, averaged with the weights that the cohorts receive in event years 1 to 4; it is an accounting identity, not a separate estimate. A later dating thus starts from a higher point, and part of the decline it reports is the rise in the first recorded year itself. The cohorts observed through event year 4 (rows 7 to 10) show the same pattern more strongly. Composition matters as well: the timing difference is concentrated in the waves that had a run-up. Table S10 of the supplementary material shows that under the one-year-later dating the MTB change is {{s_mtb_R10_TH_SG_2019_20}} for the Thai and Singaporean wave and {{s_mtb_R10_other}} for the remaining cohorts, but {{s_mtb_R10_MY_2021_22}} for the Malaysian wave, whose estimate under the first recorded year is {{s_mtb_base_MY_2021_22}}. Where no run-up was detected before entry, neither dating detects an MTB change (95% intervals {{s_mtb_base_MY_2021_22_lo}} to {{s_mtb_base_MY_2021_22_hi}} and {{s_mtb_R10_MY_2021_22_lo}} to {{s_mtb_R10_MY_2021_22_hi}}).+}

{+Two readings fit this pattern, and the data cannot separate them. If firms were selected at an unusually high valuation that later partly reversed, the one-year-later estimate measures that reversal and could hide a gain from coverage; if valuations would otherwise have stayed at their peak, coverage lowered them. What the datings share is that neither shows a gain and that the decline appears only where a run-up preceded entry. Dating coverage two years later gives {{mtb_r4R12}} (95% interval {{mtb_r4R12_lo}} to {{mtb_r4R12_hi}}), and Figure S2 plots the one-year-later path.+}

## 5.5. {+Sensitivity to departures from parallel trends+}

Row R11 keeps the {{n_R11_cohorts}} cohorts observed through event year 3 and gives {{mtb_R11}} (p {{mtb_R11_p_txt}}), so changing cohort composition does not explain the headline estimate. Removing a linear pre-trend with Eq. (9) (row R7) gives {{mtb_R7}}, and matching on pre-coverage growth (row R8) gives {{mtb_R8}}; both intervals include zero, and Appendix A.11 of the supplementary material discusses them.

Table S5 reports the bounds of Eq. (10). With M̄ = 0.25, the interval for the MTB effect is {{mtb_rm025_lo}} to {{mtb_rm025_hi}}, and any departure at all admits a positive effect. Under the one-year-later dating, the decline loses significance with M̄ = 0.25, when its interval runs from {{mtb_R10_rm025_lo}} to {{mtb_R10_rm025_hi}}. Modest departures from parallel trends, smaller than those observed before coverage, are therefore enough to change the reading of either dating.

## 5.6. {+Firm size and common support+}

{+Scored firms are much larger than most controls, so the outcome regression extrapolates for the largest firms. Table 5 varies the size adjustment and the support. Across functional forms (none, linear, quadratic, cubic, quintile indicators, or size measured at g − 3), the MTB estimate stays between {{s_mtb_ff_min}} and {{s_mtb_ff_max}}. Restricting scored firms to the size range of the controls changes the estimand to the effect on scored firms that have comparable controls. Keeping scored firms no larger than the 95th percentile of controls in their cell retains {{s_mtb_trim95_ntr}} scored firms and gives {{s_mtb_trim95}} (p {{s_mtb_trim95_p_txt}}); the 90th and 99th percentile cut-offs give {{s_mtb_trim90}} and {{s_mtb_trim99}}. Within this support the doubly robust estimator of Sant'Anna and Zhao (2020) gives {{s_mtb_dr_trim95}} (p {{s_mtb_dr_trim95_p_txt}}), and only {{s_ps_dr_trim95_share95}}% of scored firm-cells have an estimated propensity score above 0.95. The MTB result therefore does not depend on extrapolating the size adjustment to the largest firms.+}

{+Market capitalization is more sensitive. Its estimate is {{s_mcap_no_covariates}} without covariates, between {{s_mcap_ff_min}} and {{s_mcap_ff_max}} across the functional forms that adjust for size, and between {{s_mcap_sup_min}} and {{s_mcap_sup_max}} on the restricted supports, so the negative market capitalization change depends on how size is modeled. This is expected, because size enters both the selection into coverage and market capitalization itself. Table 6 describes the scored firms that the 95th percentile restriction keeps and drops. The {{s_sup_excluded_n}} excluded firms are large (median total assets of {{s_sup_excluded_assets}} million U.S. dollars against {{s_sup_retained_assets}} million) and more often Singaporean ({{s_sup_excluded_sg}}% against {{s_sup_retained_sg}}%), Indonesian ({{s_sup_excluded_id}}% against {{s_sup_retained_id}}%), or Thai ({{s_sup_excluded_th}}% against {{s_sup_retained_th}}%). Because the restriction uses the controls' percentile within each cell, it drops fewer firms than the pooled comparison in Section 4.2 suggests. The retained firms are mostly Malaysian ({{s_sup_retained_my}}%). The restricted estimate thus describes mid-sized scored firms, largely from the Malaysian expansion, and says little about the largest firms in each market.+}

## 5.7. {+Missing valuation data and recording errors+}

{+Missing MTB ratios are not random. Table S11 of the supplementary material compares firm-years with and without an MTB ratio. Firm-years without one are more often highly levered (book leverage above 0.5 in {{s_mc_never_scored_miss_lev05}}% of never-scored firm-years without an MTB ratio, against {{s_mc_never_scored_obs_lev05}}% with one) and more often Indonesian ({{s_mc_never_scored_miss_id}}% against {{s_mc_never_scored_obs_id}}%), consistent with financial distress and with gaps in market data. Only {{s_miss_never_scored_withmcap}}% of never-scored and {{s_miss_scored_withmcap}}% of scored firm-years without an MTB ratio have a market capitalization, so most gaps are missing market data, not negative book equity alone. Among scored firms, the {{s_entry_out_n}} firms that do not enter the MTB estimate have median base-year total assets similar to those that do ({{s_entry_out_assets}} against {{s_entry_in_assets}} million U.S. dollars).+}

{+Table 7 checks whether these gaps and the recording errors of Section 3.4 change the estimates. Estimating log market capitalization only on firm-years that also have an MTB ratio moves its change from {{s_mcap_baseline}} to {{s_mcap_mcap_on_mtb_sample}}, so part of the negative market capitalization estimate comes from firm-years that drop out of the MTB sample. Keeping only firms with a complete MTB series gives {{s_mtb_complete_mtb_series}} for MTB, and keeping only scored firms with complete series gives {{s_mtb_complete_mtb_scored_only}}. Removing the flagged firm-years gives {{s_mtb_drop_flagged_firm_years}} for MTB and {{s_mcap_drop_flagged_firm_years}} for market capitalization; removing every firm with a flagged year, or using a looser flag at twice total assets, or winsorizing within each market and year instead of the pooled sample gives MTB estimates between {{s_mtb_out_min}} and {{s_mtb_out_max}}. None of these checks produces an MTB gain.+}

## 5.8. {+Other robustness checks+}

{+None of the pre-specified rows R1 to R4 shows an MTB effect that differs from zero at the 10% level (estimates from {{mtb_R1}} to {{mtb_R3}}; Appendix A.11 of the supplementary material). The market capitalization and total assets results are less stable, so we do not read the total assets estimate in Table 2 as evidence that coverage causes growth. Excluding one market at a time (row R9 and Table S1) gives MTB effects from {{mtb_lomo_min}} to {{mtb_lomo_max}}.+}

The placebo in row R5, which dates coverage three years before the first {+recorded+} score within pre-score years, yields {{mtb_R5}} on log MTB (p {{mtb_R5_p_txt}}). This failure restates the pre-coverage growth in Figure 1 {+and shows how hard it is to construct a counterfactual path for firms that were growing toward the provider's universe+}. The static TWFE regression in Eq. (11) in row R6 attributes an increase of {{mtb_R6}} in log MTB (p {{mtb_R6_p_txt}}) to coverage. {+Table S8 shows that comparing each cohort with its own base year accounts for about half of the gap to the headline estimate and conditioning on base-year size for most of the rest.+}

## {+5.9. Does the initial score matter?+}

The last three rows of Table 3 divide scored firms at the cohort median of their first ESG score. The difference between high- and low-score entrants is {{mtb_diff}} (standard error {{mtb_diff_se}}, p {{mtb_diff_p_txt}}). Because the score rises with firm size (correlation {{h3_cor_score_size}} with base-year log total assets), Table S7 repeats the split after purging the score of size, country, and cohort; the difference is then {{mtb_h3r_diff}} (p {{mtb_h3r_diff_p_txt}}). {+Neither split shows the sign pattern that the preference channel predicts, but the test is weak: with minimum detectable differences of {{mtb_diff_mde}} and {{mtb_h3r_diff_mde}}, about {{s_mtb_diff_mde_pct}}% in the MTB ratio, neither can detect a moderate difference, and the residual split removes only part of the link between the score and firm characteristics. The insignificant difference therefore does not show that ESG preferences are unimportant; our sample cannot detect them if they are moderate.+}

## {+5.10. What the pooled estimate represents, and its magnitude+}

{+The pooled estimate is a weighted average over cohorts and event years, with weights equal to the number of scored firms in each cell (Eq. 6). Table S9 of the supplementary material shows that Malaysian firms carry {{s_w_market_MY}}% of the weight in the headline MTB estimate and Thai firms {{s_w_market_TH}}%, so the two markets account for {{s_w_my_th}}%; Indonesia, the Philippines, and Singapore together carry the rest. The Malaysian wave of 2021 and 2022 alone carries {{s_w_wave_MY_2021_22}}%, and firm-years from 2021 to 2024 carry {{s_w_years_2021_2024}}%. The pooled estimate therefore describes mainly the Malaysian expansion and the Thai cohorts in the years after the COVID-19 pandemic. It is not an average effect for the five markets, and the country estimates in Table S3 for Indonesia, the Philippines, and Singapore rest on too few scored firms to support conclusions for those markets.+}

Under assumption (2), the largest increase compatible with the headline interval is of the same order as the announcement return of 4.86% that Demiroglu and Ryngaert (2010) report for the first analyst coverage of neglected stocks. {+Because annual ratios miss short-lived price pressure, our estimates concern lasting revaluation (Chen et al., 2004; Merton, 1987), and a lasting effect half as large as the MTB run-up would lie at the upper end of the interval.+}

# 6. Discussion

## 6.1. What the ordering of events shows

The clearest result is an ordering of events: firms entered the scored universe after their MTB ratio and market capitalization had grown faster than those of never-scored firms, and their MTB ratio stopped gaining afterward. {+The provider may have added firms once they were large and visible enough to matter to its clients (Section 2.3), or firms may have become scoreable by publishing a first sustainability report, joining an index, or issuing equity, which can coincide with rising value; the fall in leverage toward the base year fits equity issuance. Either way, entry marks the end of a period of relative growth, not a random draw. This finding does not rest on assumption (2) or on the dating of publication, because the growth happened before the first recorded score.+}

## 6.2. {+What the evidence says about a valuation effect of coverage+}

The flat post-coverage MTB path admits three readings, depending on the counterfactual trend (Rambachan & Roth, 2023; Roth, 2022). With parallel paths from the base year, the data show no detected effect of coverage. With a continued run-up, coverage lowered valuations relative to the trend. With a partly transitory run-up, the flat path is consistent with a positive coverage effect that offset a reversal. {+The comparison of datings in Section 5.4 fits a reversal, but a negative effect of coverage confined to the waves with a run-up would look the same. With annual data, a provider that chooses whom to score, and recorded scores that may precede publication, a valuation effect of coverage cannot be reliably identified without additional assumptions; under the assumptions we can state, none of the main specifications detects a gain, and the bounds do not exclude one. One of many exploratory subgroups, the {{mtb_r4c19_ntr}} firms first scored by 2019, shows {{mtb_r4c19}} (p {{mtb_r4c19_p_txt}}), which we do not read as evidence of a gain because it is not adjusted for multiple comparisons.+}

## 6.3. {+Mechanisms that the data can and cannot evaluate+}

{+The recognition and preference channels motivate the hypotheses, but the evidence speaks to them only indirectly. Recognition predicts a lasting gain for every newly scored firm; we detect none under assumption (2), but without ownership, trading, or fund-holding data we cannot tell whether recognition did not increase or whether it increased without moving prices. Investor participation is a natural place to look, since investor groups in the region respond differently to trading conditions (Sudsawasd & Sakdapat, 2026). Preferences predict opposite signs for high- and low-score entrants; the split in Section 5.9 cannot detect a moderate difference. What the data evaluate directly is selection into coverage and the valuation path that follows it.+}

The absence of a detected gain fits the evidence on certification by sustainability indices, where additions have little price effect relative to comparable firms (Durand et al., 2019; Hawn et al., 2018), and contrasts with the price effects of MSCI downgrades (Berg, Heeb, et al., 2022). {+Two features of our setting may explain the contrast: ESG fund holdings respond to MSCI ratings, not to those of other providers (Berg, Heeb, et al., 2022), and scored firms were large and visible before coverage (Table 1), which leaves less room for recognition (Merton, 1987). U.S. studies find that coverage changes firm conduct and payout (Bikmetova & Pirinsky, 2026; Tsang et al., 2024, 2025); we find no stable change in leverage or total assets.+}

{+The run-up also fits evidence that realized green returns reflect unexpected shifts in ESG demand (Pástor et al., 2022): a one-time demand shift, or selection after one, would produce a run-up followed by a flat path. Without ownership data, we cannot tell whether ESG investors bought these firms before or after coverage.+}

## {+6.4. Implications+}

{+These implications are bounded by the design: one provider, annual data, five markets, and no data on ownership, returns, or publication dates. For researchers, comparisons of scored and unscored firms, static TWFE estimates, and backtests built on the first recorded score can attribute selection to the score (Table S8; Berg et al., 2020; Sahin et al., 2023). Studies of ESG ratings in Southeast Asia should model when firms enter coverage, report pre-entry dynamics, and record the download date of their rating data.+}

{+For rating providers and data users, the scored universe in these markets tilts toward large firms and toward firms that had outgrown their peers, most clearly in the Thai and Singaporean wave. Publishing the date on which each firm's coverage began, and keeping the vintages of revised scores, would separate what was known from what was filled in later.+}

{+For exchanges, regulators, and listed firms, broad expansions such as the Malaysian wave appear to select less on prior growth, and we detect no MTB gain within it. Our results do not show that expanding ESG coverage has no valuation benefit; they show that such a benefit cannot be established from these data, so arguments for expanding coverage should rest on grounds other than an expected rise in issuer valuations. Under assumption (2), the interval excludes increases above {{mtb_hi_pct}}%, but smaller effects remain possible.+}

# 7. Limitations

{+The study has seven limitations. First, the provider chooses when to cover a firm, and the post-coverage estimates rest on conditional parallel trends that the pre-coverage estimates question; our sensitivity analysis uses a linear trend and a simplified bound, not the confidence sets of Rambachan and Roth (2023). Second, we observe neither publication dates nor announcement returns, and the unrecorded download date leaves the vintage of revisable recent scores uncertain. Third, we observe only LSEG coverage, so for firms with earlier FTSE Russell or other scores the event is an additional score. Fourth, the data contain no returns, shares outstanding, ownership, index membership, or firm-level report dates. Fifth, MTB ratios are missing for about a quarter of firm-years, more often for distressed and Indonesian firms, and some market capitalization records contain scale errors. Sixth, Malaysian and Thai firms make up {{pct_my_th_treated}}% of scored firms. Seventh, with an MDE of {{mtb_mde}} on log MTB, smaller effects would be detected with less than 80% probability.+}

# 8. Conclusion

{+Entry into LSEG ESG coverage in five Southeast Asian markets was selective. The firms that received a first recorded score were larger than never-scored firms, and on average their market-to-book ratio had grown {{mtb_runup_m5}}% faster than that of similar firms over the five years before entry. The run-up was concentrated in the Thai and Singaporean wave of 2019 and 2020 and was not detected in the broad Malaysian wave of 2021 and 2022 (95% interval {{s_mtb_wMY_runup_m5_lo}}% to {{s_mtb_wMY_runup_m5_hi}}%). After entry, the valuation gap stopped widening. Whether coverage itself changed valuations cannot be settled with these data: the answer moves from no detected change (95% interval {{mtb_lo}} to {{mtb_hi}} in log MTB) to a decline of {{s_mtb_C3_declpct}}% depending on when investors are assumed to have seen the score, the decline appears only where valuations had run up, and modest departures from parallel trends change either reading.+}

{+A rated firm is not a random firm, and research and investment screens that start from a provider's universe inherit the provider's selection. Two kinds of data would move the question forward: point-in-time records of when each firm's score was first published, which would date the event as investors saw it, and ownership and trading data, which would show whether new coverage brings new investors. With both, future work could test whether ESG coverage in Southeast Asian markets changes who holds a firm and at what price.+}

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

LSEG. (2025). *LSEG ESG scores (ESG score field), annual, 2014–2024* [Data set]. LSEG Workspace.

{+LSEG. (n.d.). *Refinitiv Data Platform ESG bulk point in time user guide*. https://developers.lseg.com/content/dam/devportal/api-families/refinitiv-data-platform/refinitiv-data-platform-apis/documentation/rdp_esg_pit_user_guide.pdf+}

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
note:={+Scored firms in the base year g − 1; never-scored firms over 2014 to 2024. Norm. diff. is the mean difference over the root of the average variance.+}
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure 1|Event-time {+changes around+} the first {+recorded+} LSEG ESG score on market-to-book ratio, market capitalization, leverage, and total assets
png:=Fig1.png
note:={+Estimates of Eq. (5) relative to event year −1, with firm-bootstrap 95% intervals; open markers are pre-coverage years. Event year 4 is excluded from Eq. (6).+}
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure 2|Event-time effects on market-to-book ratio and market capitalization by coverage wave
png:=Fig2.png
note:={+Estimates of Eq. (5) by wave against all never-scored firms, with firm-bootstrap 95% intervals. Other cohorts are firms first scored outside the two waves.+}
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 2|Average {+change after the first recorded LSEG ESG score over event years 0 to 3, under assumption (2)+}
csvfile:=table2_formatted.csv
widths:=1.45,0.6,0.5,1.15,0.6,0.5,0.6,0.6,0.6
size:=9
note:={+Eq. (6), firm-bootstrap standard errors, unadjusted 95% CI; secondary p-values Holm-adjusted. MDE: 80%-power minimum detectable effect; pre-trend p tests Eq. (8). Firm counts cover all event-time cells.+}
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 3|Robustness checks, timing of coverage, and heterogeneity by initial ESG score
csvfile:=table3_formatted.csv
widths:=1.7,0.95,0.95,0.95,0.95,1.0
size:=9
note:={+Outcome-regression changes over event years 0 to 3 (R5: 0 to 2; R6: Eq. 11, firm-clustered), firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1%.+}
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 4|Reconciling the first-recorded-year and one-year-later datings, step by step
csvfile:=tableSAJE4_formatted.csv
widths:=3.3,1.15,1.25,0.8
size:=9
blue:=1
note:=Outcome-regression changes, firm-bootstrap standard errors in parentheses; each row changes one feature. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 5|Size adjustment and common support
csvfile:=tableSAJE5_formatted.csv
widths:=3.0,1.25,1.3,0.9
size:=9
blue:=1
note:=Outcome regression unless labeled doubly robust; firm-bootstrap standard errors in parentheses. Percentile rows cap scored firms' base-year assets at that control percentile. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 6|Scored firms retained and excluded by the 95th percentile size restriction
csvfile:=tableSAJE6_formatted.csv
widths:=2.8,1.1,1.1,1.4
size:=9
blue:=1
note:=Scored firms in the ln(MTB) estimate, measured in the base year g − 1; never-scored firms are summarized over all firm-years. Shares are fractions of firms.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table 7|Missing valuation data and recording errors
csvfile:=tableSAJE8_formatted.csv
widths:=3.2,1.2,1.25,0.8
size:=9
blue:=1
note:=Outcome-regression changes, firm-bootstrap standard errors in parentheses; flags mark implied book equity above ten times assets (Section 3.4). \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

@@ supp_intro
This supplementary material accompanies "Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets." Table S1 re-estimates the average {+changes after+} the first {+recorded+} score over event years 0 to 3 after excluding one market at a time. Table S2 shows the number of non-financial firms that received their first {+recorded+} LSEG ESG score in each year by market, and Figure S1 for all markets combined. Table S3 reports the estimates for each market separately, Table S4 the number of firm-years available for each outcome, Table S5 the relative-magnitude bounds of Eq. (10) in the paper, and Table S6 the number of scored and control firms by event year for ln MTB. Table S7 and Figure S2 report {+further exploratory specifications+}, and Table S8 decomposes the gap between the static two-way fixed effects estimate and the baseline. {+Table S9 reports the weight of each market and coverage wave in the pooled estimate, Table S10 the estimates by wave under both datings, and Table S11 compares firm-years with and without an MTB ratio. Appendix A gives additional results.+} The pre-analysis plan is provided with the replication package.

@@ supp_body
# {+Appendix A.+} Additional robustness results

## A.1. Event year 4 (Section {+5.2+})

Only {{mtb_nfirms_e4}} scored firms from {{mtb_ncoh_e4}} cohorts reach event year 4; therefore, we plot that year in Figure 1 but exclude it from Eq. (6). Its estimates are {{mtb_e4}} for MTB (p {{mtb_e4_p_txt}}) and {{mcap_e4}} for market capitalization (p {{mcap_e4_p_txt}}).

## A.2. Further timing variants of R10 (Section {+5.4+})

Under R10, the decline in log MTB loses significance once M̄ in Eq. (10) reaches {{mtb_R10_bd0}}. Holding total assets at the original base year gives {{mtb_r4R10g1}} (p {{mtb_r4R10g1_p_txt}}), so the covariate timing does not drive R10. Dating coverage two years later gives {{mtb_r4R12}} (95% interval {{mtb_r4R12_lo}} to {{mtb_r4R12_hi}}), a smaller decline that is no longer significant at the 5% level.

## A.3. Reconciling the R10 and baseline event-time paths (Section {+5.4+}, Figure S2)

The baseline path in Figure 1 does not show the R10 decline because its later event years come from early cohorts, while its first post-coverage years pool all cohorts. Re-based within each cohort to the first {+recorded+} year, the baseline point estimates for event years 3 and 4 are {{mtb_reb_e3}} and {{mtb_reb_e4}}, respectively. These lie closer to the corresponding R10 estimates of {{mtb_R10_e2}} and {{mtb_R10_e3}} than the pooled baseline path suggests. We report the re-based values without standard errors, as a reconciliation of the two paths rather than a test. {+Table 4 of the paper carries out the full step-by-step reconciliation on a common sample.+}

## A.4. Size covariate and support (Section {+5.6+}, Table S7, Figure S2)

Table S7 and Figure S2 vary the size covariate and support{+; Table 5 of the paper reports the full set of variants+}. The run-up does not depend on conditioning on base-year total assets. Without covariates, the MTB run-up from event year −5 to the base year is {{mtb_r4nocov_runup_m5}}%, weaker than the baseline (event year −5 p {{mtb_r4nocov_em5_p_txt}}; pre-trend p {{mtb_r4nocov_pre_p_txt}}), and the market capitalization run-up is {{mcap_r4nocov_runup_m5}}%. With total assets measured two years before the base year, it is {{mtb_r4sizeg3_runup_m5}}% for MTB (pre-trend p {{mtb_r4sizeg3_pre_p_txt}}) and {{mcap_r4sizeg3_runup_m5}}% for market capitalization.

## A.5. Decomposition of the TWFE gap (Section {+5.8+}, Table S8)

Table S8 shows the decomposition of the gap between the static TWFE estimate in row R6 and the headline MTB estimate. Restricting the regression to never-scored controls and event years −5 to 3 changes the estimate to only {{mtb_bridge2}}, while the heterogeneity-robust estimator gives {{mtb_bridge3}} without covariates and {{mtb_bridge4}} with them. Comparing each cohort with its own base year, rather than pooling all years, accounts for approximately half of the gap. Conditioning on base-year total assets accounts for most of the rest, and the choice of controls and window for little.

## A.6. Market-by-market and early versus late cohorts (Section {+5.8+}, Table S3)

Estimated market by market in Table S3, the MTB effect is {{mtb_pm_MY}} in Malaysia, with {{mtb_pm_MY_ntr}} scored firms, and {{mtb_pm_TH}} in Thailand, with {{mtb_pm_TH_ntr}}. Indonesia, the Philippines, and Singapore have few scored firms and imprecise estimates. The {{mtb_r4c19_ntr}} firms first scored by 2019 that enter the MTB estimate show a positive post-coverage MTB estimate of {{mtb_r4c19}} (p {{mtb_r4c19_p_txt}}; 95% interval {{mtb_r4c19_lo}} to {{mtb_r4c19_hi}}), and the larger group first scored from 2020 shows {{mtb_r4c20}} (p {{mtb_r4c20_p_txt}}). The early estimate rests on few firms, is one of many exploratory comparisons, and is not adjusted for multiple testing, so we do not read it as evidence of a gain for early entrants.

## A.7. Breadth of the Malaysian wave (Section {+5.2+}, Figure 2)

The Malaysian wave added {{n_wMY}} firms in two years, yet {{n_my_never}} Malaysian firms remained never-scored, so it was broad but not market-wide.

## {+A.8. Composition of the pooled estimate (Section 5.10, Table S9)+}

{+Table S9 counts scored firm-cells, one for each scored firm in each post-coverage cell of the ln(MTB) estimate, by market and by coverage wave. These counts are the weights of Eq. (6).+}

## {+A.9. Dating by wave (Section 5.4, Table S10)+}

{+Table S10 reports, for each wave, the average change with coverage dated at the first recorded score year and one year later, estimated against all never-scored firms.+}

## {+A.10. Firm-years with and without an MTB ratio (Section 5.7, Table S11)+}

{+Table S11 compares scored and never-scored firm-years with and without an MTB ratio in the estimation sample. Book leverage above 0.5 and Indonesian listing are more common among firm-years without an MTB ratio.+}

## {+A.11. Other robustness checks (Sections 5.5 and 5.8)+}

{+Rows R1 to R4 of Table 3 give MTB effects of {{mtb_R1}} with not-yet-scored firms among the controls, {{mtb_R2}} without covariates, {{mtb_R3}} without the 2020 and 2021 cohorts, and {{mtb_R4}} when control firms below the size range of scored firms are dropped. Under the last restriction the market capitalization effect shrinks to {{mcap_R4}} and the total assets effect is {{asset_R4}}, against {{asset_R2}} without covariates. Row R7 removes a linear pre-trend with Eq. (9); its MTB effect is negative because a continued run-up would have raised valuations further. Row R8 adds market capitalization growth from g − 3 to the base year to the covariates; because control firms matched on past growth can themselves revert, it does not settle the reversal question. The placebo in row R5 gives {{mcap_R5}} for log market capitalization (p {{mcap_R5_p_txt}}), and the static TWFE regression gives {{mcap_R6}}. Without Malaysia (row R9), the MTB effect is {{mtb_R9}} (p {{mtb_R9_p_txt}}) and the market capitalization effect {{mcap_R9}}.+}

@@ exhibits_supp
kind:=table
caption:=Table S1|Leave-one-market-out estimates of the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA1_formatted.csv
widths:=1.6,0.95,0.95,0.95,0.95,1.1
note:=Average change over event years 0 to 3 without the named market; firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S2|Number of non-financial firms by year of first {+recorded+} LSEG ESG score and market
csvfile:=tableIA2_formatted.csv
widths:=1.3,0.85,0.85,0.9,0.9,0.85,0.75
note:=Firms first scored in 2014 are excluded because they have no pre-coverage year.
source:=Authors' calculations from LSEG ESG scores.

kind:=figure
caption:=Figure S1|Number of non-financial firms by year of first {+recorded+} LSEG ESG score
png:=FigIA1.png
note:=Bars show the number of firms in the estimation sample first scored in each year, all five markets combined.
source:=Authors' calculations from LSEG ESG scores.

kind:=table
caption:=Table S3|Average change after the first {+recorded+} LSEG ESG score by market
csvfile:=tableIA3_formatted.csv
widths:=1.3,1.0,1.05,1.05,1.0,1.1
note:=Average change over event years 0 to 3 within each market; firm-bootstrap standard errors; firm counts for ln(MTB). \*, \*\*, \*\*\*: 10%, 5%, 1% (unadjusted).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S4|Firm-years and firms available for each outcome
csvfile:=tableIA4_formatted.csv
widths:=1.7,1.0,0.9,1.0,0.9,1.0
note:=Counts refer to the estimation sample; the last column is the share of firm-years with a missing outcome.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S5|Relative-magnitude bounds for the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA5_formatted.csv
widths:=1.7,0.6,1.2,0.9,1.6
note:=Bias bound: M̄ × largest pre-coverage step × weighted mean of (e + 1) over event years 0 to 3 (Eq. 10); the robust interval widens the firm-bootstrap interval by it.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S6|Scored firms and control firms by event year for ln(MTB)
csvfile:=tableIA6_formatted.csv
widths:=1.2,1.3,1.1,2.2
note:=Scored firms are summed over cohorts; control firms are the smallest and largest number of never-scored firms across cohort cells.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S7|Alternative specifications, inference, and initial-score splits for the average change after the first {+recorded+} LSEG ESG score
csvfile:=tableIA7_formatted.csv
widths:=2.3,1.1,0.75,1.1,0.75
note:=Average change over event years 0 to 3, firm-bootstrap standard errors in parentheses, and the pre-trend p of Eq. (8); all rows exploratory. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S8|Decomposition of the gap between the static two-way fixed effects estimate and the baseline estimate
csvfile:=tableIA8_formatted.csv
widths:=3.0,1.4,1.4
note:=Steps from Eq. (11) on all firm-years to the baseline Eq. (6); standard errors firm-clustered for TWFE, firm bootstrap otherwise. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=figure
caption:=Figure S2|Event-time effects on ln(MTB) under alternative specifications and dating
png:=FigIA2.png
note:=Panel A varies the size covariate and support, dated at the first {+recorded+} year; panel B dates the event one year later. Bars are firm-bootstrap 95% intervals.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S9|Weight of each market and coverage wave in the pooled ln(MTB) estimate
csvfile:=tableSAJES9_formatted.csv
widths:=3.3,1.3,1.6
blue:=1
note:=Scored firm-cells count each scored firm once in every post-coverage cell (event years 0 to 3) of the baseline ln(MTB) estimate; weights are their shares (Eq. 6).
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S10|Average change by coverage wave under the two datings
csvfile:=tableSAJES10_formatted.csv
widths:=1.9,1.15,1.15,1.15,1.15
size:=9
blue:=1
note:=Average change over event years 0 to 3 for each wave against all never-scored firms, with firm-bootstrap standard errors in parentheses. \*, \*\*, \*\*\*: 10%, 5%, 1%.
source:=Authors' calculations from LSEG ESG scores and Compustat Global.

kind:=table
caption:=Table S11|Firm-years with and without a market-to-book ratio
csvfile:=tableSAJE7_formatted.csv
widths:=2.2,1.05,1.05,1.1,1.1
size:=9
blue:=1
note:=Estimation sample, all firm-years from 2014 to 2024; amounts in U.S. dollars after winsorization at the 1st and 99th percentiles.
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

The ESG scores (LSEG Workspace) and the accounting and market data (Compustat Global) are licensed, and the licenses do not allow the authors to redistribute them, including firm identifiers and derived firm-level variables; the download date of the scores was not recorded. The R code, the pre-analysis plan, and all aggregate output files will be deposited in a public repository with a DOI before final acceptance, as the journal requires. Researchers with access to the two databases can rebuild the sample with the code.

**Ethics approval statement**

Not applicable. The study uses firm-level secondary data and involves no human participants.

**Author contributions**

Ha Hong Hanh: conceptualization, supervision, and writing (review and editing); she set the direction of the research and led the revision. Nguyen Van Trung: conceptualization, data curation, formal analysis, methodology, software, visualization, and writing (original draft, review and editing).
