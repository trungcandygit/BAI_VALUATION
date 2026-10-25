% Asian Academy of Management Journal of Accounting and Finance (AAMJAF, Penerbit USM) version: sections that differ
% from manuscript.md. Numbers are {{key}} placeholders filled from project_R/outputs/numbers.csv.
% Built by project_R/docx_build/build_aamjaf.py. Guidelines: ejournal.usm.my/aamjaf/submission-guidelines (D-61).
@@ abstract
Most listed firms in Southeast Asia have no environmental, social, and governance (ESG) score, so they sit outside the universe that ESG-screened investors can hold. We ask which firms enter London Stock Exchange Group (LSEG) ESG coverage and whether entry changes their valuation. We compare {{n_treated_all}} non-financial firms in Indonesia, Malaysia, the Philippines, Singapore, and Thailand that received a first score with {{n_never}} never-scored firms. Over the five years before the first score, the market-to-book (MTB) ratio of scored firms grew {{mtb_runup_m5}}% more than that of never-scored firms, a run-up absent in a large Malaysian wave. Under parallel trends, we detect no MTB gain after the first score (estimate {{mtb_att}}; 95% interval {{mtb_lo}} to {{mtb_hi}}) and no difference between high- and low-score firms. ESG screens built on this provider's scores draw on firms that have often just outgrown their peers.

@@ keywords
Emerging markets; ESG ratings; Firm valuation; Rating coverage; Sustainable finance

@@ ai_declaration
The author used Claude (Anthropic), through Claude Code, in September and October 2026 to screen research questions, draft the pre-analysis plan, write the R code, edit and revise the text, check references, and simulate referee reports. The author reviewed every output, checked each reported number against the R output files, and takes full responsibility for the content.

@@ appendix_b
# Appendix B. Additional robustness results

## B.1. Event year 4 (Section 5.3)

Only {{mtb_nfirms_e4}} scored firms from {{mtb_ncoh_e4}} cohorts reach event year 4; therefore, we plot that year in Fig. 1 but exclude it from Eq. (6). Its estimates are {{mtb_e4}} for MTB (p {{mtb_e4_p_txt}}) and {{mcap_e4}} for market capitalization (p {{mcap_e4_p_txt}}).

## B.2. Further timing variants of R10 (Section 5.4)

Under R10, the decline in log MTB loses significance once M̄ in Eq. (10) reaches {{mtb_R10_bd0}}. Holding total assets at the original base year gives {{mtb_r4R10g1}} (p {{mtb_r4R10g1_p_txt}}), so the covariate timing does not drive R10. Dating coverage two years later gives {{mtb_r4R12}} (95% interval {{mtb_r4R12_lo}} to {{mtb_r4R12_hi}}), a smaller decline that is no longer significant at the 5% level.

## B.3. Reconciling the R10 and baseline event-time paths (Section 5.4, Fig. S2)

The baseline path in Fig. 1 does not show the R10 decline because its later event years come from early cohorts, while its first post-coverage years pool all cohorts. Re-based within each cohort to the first scored year, the baseline point estimates for event years 3 and 4 are {{mtb_reb_e3}} and {{mtb_reb_e4}}, respectively. These lie closer to the corresponding R10 estimates of {{mtb_R10_e2}} and {{mtb_R10_e3}} than the pooled baseline path suggests. We report the re-based values without standard errors, as a reconciliation of the two paths rather than a test.

## B.4. Size covariate and support (Section 5.5, Table S7, Fig. S2)

Table S7 and Fig. S2 vary the size covariate and support. The run-up does not depend on conditioning on base-year total assets. Without covariates, the MTB run-up from event year −5 to the base year is {{mtb_r4nocov_runup_m5}}%, weaker than the baseline (event year −5 p {{mtb_r4nocov_em5_p_txt}}; pre-trend p {{mtb_r4nocov_pre_p_txt}}), and the market capitalization run-up is {{mcap_r4nocov_runup_m5}}%. With total assets measured two years before the base year, it is {{mtb_r4sizeg3_runup_m5}}% for MTB (pre-trend p {{mtb_r4sizeg3_pre_p_txt}}) and {{mcap_r4sizeg3_runup_m5}}% for market capitalization. The post-coverage MTB effect is {{mtb_r4sizeg3}} with total assets measured two years earlier and {{mtb_r4bins}} with quintile indicators. Restricting scored firms to those no larger than the 95th percentile of never-scored firms in their cell changes the estimand to the effect on scored firms within the controls' size range. This restriction keeps {{mtb_r4trim_ntr}} scored firms and gives {{mtb_r4trim}} for MTB (p {{mtb_r4trim_p_txt}}; pre-trend p {{mtb_r4trim_pre_p_txt}}) and {{mcap_r4trim}} for market capitalization (p {{mcap_r4trim_p_txt}}). The post-coverage MTB estimate therefore does not depend on extrapolating the size adjustment to the largest firms, whereas the negative market capitalization effect is larger within the controls' size range.

## B.5. Decomposition of the TWFE gap (Section 5.5, Table S8)

Table S8 shows the decomposition of the gap between the static TWFE estimate in row R6 and the headline MTB estimate. Restricting the regression to never-scored controls and event years −5 to 3 changes the estimate to only {{mtb_bridge2}}, while the heterogeneity-robust estimator gives {{mtb_bridge3}} without covariates and {{mtb_bridge4}} with them. Comparing each cohort with its own base year, rather than pooling all years, accounts for approximately half of the gap. Conditioning on base-year total assets accounts for most of the rest, and the choice of controls and window for little.

## B.6. Market-by-market and early versus late cohorts (Section 5.5, Table S3)

Estimated market by market in Table S3, the MTB effect is {{mtb_pm_MY}} in Malaysia, with {{mtb_pm_MY_ntr}} scored firms, and {{mtb_pm_TH}} in Thailand, with {{mtb_pm_TH_ntr}}. Indonesia, the Philippines, and Singapore have few scored firms and imprecise estimates. The {{mtb_r4c19_ntr}} firms first scored by 2019 show a positive post-coverage MTB estimate of {{mtb_r4c19}} (p {{mtb_r4c19_p_txt}}; 95% interval {{mtb_r4c19_lo}} to {{mtb_r4c19_hi}}), and the larger group first scored from 2020 shows {{mtb_r4c20}} (p {{mtb_r4c20_p_txt}}). The early estimate rests on few firms, is one of many exploratory comparisons, and is not adjusted for multiple testing, so we do not read it as evidence of a gain for early entrants.

## B.7. Breadth of the Malaysian wave (Section 5.3, Fig. 2)

The Malaysian wave added {{n_wMY}} firms in two years, yet {{n_my_never}} Malaysian firms remained never-scored, so it was broad but not market-wide.

@@ cover_letter
Dear Editor,

I submit the manuscript "[[TITLE]]" for consideration in the Asian Academy of Management Journal of Accounting and Finance.

The paper asks which listed firms in Southeast Asia receive an environmental, social, and governance (ESG) score and whether receiving one changes how the equity market values them. I follow {{n_treated_all}} non-financial firms in Indonesia, Malaysia, the Philippines, Singapore, and Thailand that received a first LSEG ESG score and compare them with {{n_never}} never-scored firms. Scored firms had outgrown comparable never-scored firms before their first score, a pattern absent in the large Malaysian coverage wave of 2021 and 2022. Under parallel trends, I detect no rise in market-to-book ratios after the first score and no difference between high- and low-score firms, while a static two-way fixed effects regression on the same data would attribute a valuation gain of {{mtb_R6_pct}}% to coverage. The paper fits the journal's interest in finance and governance in Asian capital markets and relates to the journal's earlier work on ESG coverage and credit ratings in Asia. I fixed the hypotheses, sample rules, estimator, and robustness checks in a pre-analysis plan before estimation and report all pre-specified results, including a placebo test that fails.

The manuscript is original, has not been published elsewhere, and is not under consideration by another journal. I am the sole author and declare no competing interests. The manuscript file is anonymized; my name, affiliation, and declarations are on the separate cover page. Tables and figures follow the references, each on a separate page, and their positions are marked in the text; the supplementary material contains Appendix B (additional robustness results), eight tables, and two figures. The LSEG and Compustat data are licensed and cannot be redistributed; the R code, the pre-analysis plan, and all aggregate output files are available on request.

Sincerely,

Nguyen Van Trung
International School, Vietnam National University, Hanoi
