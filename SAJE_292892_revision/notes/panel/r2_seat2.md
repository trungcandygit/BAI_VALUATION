# Panel round 2, Seat 2 (methods + integrity + tables/figures): SAJE 292892 R1

Loaded: SKILL.md (132 lines); references/cards/core.md (87 lines, `<!-- CARD-END core v2 -->`); references/cards/seat2-methods-integrity.md (123 lines, `<!-- CARD-END seat2 v1 -->`); references/cards/tables-figures.md (87 lines, `<!-- CARD-END tables-figures v1 -->`). Skills invoked: academic-pipeline, paper-revision-master.

Scope audited: the frozen files build_r2/*.docx, panel/round2/dossier/* (including rendered PDFs, the ORIGINAL manuscript and supplement, the verbatim editor letter and Reviewer A report), and project_R/outputs as they stood on 2026-10-26 (docx built 01:33, outputs 00:18 to 01:32). I did not use the current state of the markdown sources, which are being edited in parallel.

## What was run (core C-60 to C-62)

- **Reproduction.** I copied project_R without outputs/ to /tmp/claude-0/panel_r2_seat2/run/project_R and symlinked the data so that `../Dữ liệu ban đầu và thô/DATA GW2.xlsx` resolves. I then ran `run_all.R` (41.2 min) and `run_saje.R` with an empty cache (25.1 min).
  - **CSV and TXT files:** all 71 files are byte-identical to project_R/outputs, including numbers.csv, numbers_saje.csv, every *_formatted.csv and sessionInfo.txt.
  - **Figures:** the .png and .eps files are byte-identical. The cairo .pdf files differ in bytes only; rendered at 150 dpi they show zero pixel difference.
  - **Word files:** the PNGs embedded in the clean manuscript and supplement are byte-identical (md5) to Fig1, Fig2, FigIA1 and FigIA2.
  - **Not produced by the pipeline:** outputs/validation.csv and outputs/overlap/.
- **Independent re-implementation.** I wrote my own base-R code for the outcome-regression ATT(g,t), event-time aggregation, R10 and Table 1. Every check reproduced to at least 1e-9:
  - Table 1, all cells.
  - Headline ATT: ln(MTB) 0.001923, ln(market cap) −0.054887, leverage 0.008481, ln(assets) 0.043527.
  - R10: −0.068470.
  - Event-time estimates e = −5…4: −0.0949, −0.0818, −0.0363, −0.0296, 0.0169, −0.0053, 0.0171, −0.0438, −0.0770.
- **Data-coding audit.** I checked the raw xlsx year by year. It has 40,799 rows, a balanced panel of 3,709 firms × 2014–2024, and no duplicate firm-years. No firm changes industry or country.
  - G is the first year with a non-missing ESG_Score.
  - 286 financial firms → 3,423 non-financial firms; 135 are first scored in 2014 → 3,288 firms. Of these, 675 are scored in 2015–2024 and 2,613 are never scored.
  - Table S2 is reproduced exactly. 17 firms have interior gaps in coverage.
  - The MTB ratio is never ≤ 0, so the source has no non-positive ratios. ESG scores range from 2.16 to 92.07.
- **Deterministic checks.**
  - `check_numbers.py`: 0 unmatched in all seven docx files (477 / 403 / 24 / 93 decimals checked).
  - `check_crossrefs.py`, `check_docx_style.py`, `check_figure.py`: hits adjudicated by hand below.
- **Semantic check of numbers.** I mapped every {{key}} in the frozen text back to its CSV cell and recomputed it, including the percent conversions, the Holm adjustment, the decomposition shares and the bound arithmetic.
- **Rendering.** I rendered all 32 manuscript pages and all 10 supplement pages. Every table and figure page was inspected at 80–110 dpi.
- **Web checks.** I used WebSearch for the institutional dates and the cited claims. WebFetch and curl are blocked, so primary PDFs (Bursa 2015 circular, the POJK full text, the LSEG methodology) could not be opened; this limits the checks marked UNVERIFIED.
- **Extra check (my own computation).** I estimated wave contrasts with the joint firm-bootstrap draws, using the authors' functions on my copy (audit/extra.R).

## Findings (CRITICAL first)

| Rule ID | Verdict | Severity | Evidence | Fix |
|---|---|---|---|---|
| C-06, S2-03, S2-22, C-65 | FAIL | MAJOR | **The sample is restricted to firms that survived to 2024, and the paper does not say so.** In the raw data, all 3,709 firms have total assets or market cap in 2024. First data year varies: 2,757 in 2014, then 132, 141, 128, 156, 150, 121, 90, 20, 3, 11 in 2015–2024. Last data year is 2024 for all 3,709 firms. So IPOs enter but no firm ever exits. In addition, every one of the 901 scored firms (675 in the sample) has a 2024 score; none loses coverage. Text, 3.2 (clean l.45): "The data cover all 3,709 firms listed in the five markets from 2014 to 2024". The universe is in fact firms listed, with data, in 2024. Firms that delisted in 2014–2023 (likely distressed or acquired, with different valuation paths) are missing from both groups. For a paper about selection, this conditioning bears directly on the run-up and post-entry comparisons. It is disclosed nowhere: not in 3.2, Section 7, or the data statement. The fact that no firm leaves coverage is also consistent with a current-universe download, which is relevant to Section 3.3. | Describe the universe correctly ("firms listed with data in 2024"). Add survivorship conditioning to Section 7 and to the 3.3 backfill argument. If possible, rebuild with delisted firms from Compustat Global, or report how many firms were delisted in each market over 2014–2023 as a bound. `AUTHOR_INPUT_NEEDED`: how the firm list was drawn. |
| S2-06 | FAIL | MINOR | Both letters, summary paragraph (06_Response_to_Editor; 07_Response_to_Reviewer_A last "New material" line; response_letter_saje.md l.74 and l.248): "Tables S9 to S11 and Appendix B.8 to B.10 in the supplementary material". The supplement has Appendix A only (A.8–A.10). | Change to "Appendix A.8 to A.10". |
| S2-05, TF-06, TF-16 | FAIL | MINOR | Table 3, baseline row: "−0.055* … 0.008* … 0.044**". These stars use unadjusted p. Table 2 prints the Holm-adjusted p for the same estimates: 0.134, 0.134, 0.053. The Table 3 note now omits "(unadjusted p-values)"; the original note had it, and Tables S1 and S3 keep it. A reader sees starred secondaries in Table 3 that Table 2 calls insignificant. | Add "unadjusted p-values" to the Table 3 note (and to the notes of Tables 4, 5, 7, S7, S8 and S10). |
| TF-17, TF-04 | FAIL | MINOR | Tables 4, 5 and 7 have a column "Scored firms in averaged event years" that holds ln(MTB) counts (04c_saje_tables.R: `fmtn(a$n_treated_firms)`). In Table 7 the row "Market capitalization on firm-years with an MTB ratio" holds the ln(mcap) count instead (624). The ln(mcap) counts differ from the MTB counts: Table 5, 95th-percentile row, mcap 492 vs 487; Table 7, flagged-years row, mcap 625 vs 615. None of the three notes says which outcome is counted. | Add "firm counts for ln(MTB) unless only ln(market cap) is estimated", or show both counts. |
| S2-07 | FAIL | MINOR | The same flag is called two things. Section 3.4: "A stricter rule, a ratio above two, flags 749 firm-years". Section 5.7: "using a looser flag at twice total assets". Letter Comment 6: "flagging at twice instead of ten times". | Use one word ("stricter", since it flags more firm-years) in both places. |
| S2-07 | FAIL | MINOR | Section 5.2 defines the run-up as e = −5 to the base year g − 1. Section 5.4 then calls year g "the last year of the run-up", and Section 1 says "at the top of the run-up". Year g is post-coverage event year 0 in the baseline. Separately, the Figure 2 and Figure S2 captions say "Event-time effects", while the Figure 1 caption and the text now use "changes". | Say "the first recorded year, after the run-up". Use "changes" in the Figure 2 and S2 captions. |
| S2-64, S2-65, C-25 | FAIL | MINOR | Section 4.1 gives "most weight" to "the contrast between waves with and without a run-up". Sections 5.4, 6.2 and the Conclusion rest on it, yet no difference test between waves is reported, and the wave split was drawn after seeing the data (5.2). Section 4.1 also says the Malaysian "pre-coverage path is flat", although its run-up interval (−7.4% to 15.2%) includes the pooled 10.0%; Section 5.2 admits this. My joint-draw contrasts (firm bootstrap, 999 draws, same seed): <br>• Run-up at e = −5, TH/SG minus MY: −0.258 (SE 0.100, p = 0.010). <br>• Run-up at e = −5, other cohorts minus MY: −0.075 (SE 0.074, p = 0.31). <br>• R10, TH/SG minus MY: −0.148 (SE 0.054, p = 0.006). <br>• R10, other minus MY: −0.123 (SE 0.048, p = 0.010). <br>• Baseline post-entry, TH/SG minus MY: −0.030 (p = 0.61). <br>The main contrast therefore holds, but the remaining cohorts' run-up cannot be distinguished from the Malaysian wave's. | Report the wave differences with their joint bootstrap SEs (a short table or one sentence). Replace "flat" with "no detectable run-up (interval …)". Qualify "the waves that had a run-up" for the remaining cohorts. |
| S2-73, S2-54 | FAIL | MINOR | In the doubly robust estimator (03c_saje.R, `cell_atts2`), the propensity score is capped: `p <- pmin(plogis(...), 0.99)`. This is not disclosed in Section 5.6 or the Table 5 note. s_support_pscore.csv shows max_p = 0.99999998, so the cap binds for some cells. | State the cap at 0.99 and the share of capped cells, in one clause in Section 5.6 or Appendix A. |
| C-25, C-24 | FAIL | MINOR | Section 5.5: "With M̄ = 0.25, the interval for the MTB effect is −0.071 to 0.073, and any departure at all admits a positive effect." The unadjusted interval [−0.046, 0.048] already admits positive effects (rm_breakdown.csv, Mbar_admit_zero = 0), so the clause adds nothing. The original version's informative breakdown (+5% admitted at M̄ ≈ 0.01) was dropped. | Replace with "any departure with M̄ above 0.01 admits a 5% increase" (rm_breakdown.csv: 0.0121). |
| C-06, C-16 | FAIL | MINOR | Letter Comment 6: "the 50 scored firms that do not enter the MTB estimate have median base-year total assets similar … (280.3 against 294.3), so the missing ratios do not remove the largest or smallest scored firms". A comparison of medians cannot show anything about the tails. Also, only 30 of the 50 firms have base-year assets: 655 scored firms have assets, and 625 of them enter. | Change the clause to "do not differ in median size". |
| C-03 | FAIL | MINOR | Letter Comment E3: "The new references are Crump et al. (2009) … and the three papers from this journal". This omits LSEG (n.d.), the point-in-time user guide, which is new in the revision (manuscript_saje.md marks it {+…+}). | Add LSEG (n.d.) to the list. |
| S2-04 | FAIL | MINOR | Abstract: "their market-to-book ratio had grown 10.0% faster than that of similar firms before the first recorded score". The figure is cumulative over e = −5 to −1 (r4_runup.csv 9.955), not a growth rate. Without the horizon, "faster" reads as a rate. The Conclusion adds "over the five years". | Write "10.0% more over the five years before…". |
| TF-05, TF-23 | FAIL | MINOR | Tables 3, 4, 5, 7, S1, S3, S7, S8 and S10 put SEs in parentheses beside the coefficients, not below. Table 3 (p.16) and Table S1 (supp. p.4) wrap inconsistently: some cells read "0.012***↵(0.004)", their neighbours are on one line. | Put SEs on a second line in every cell, or widen the columns so that no cell wraps. |
| TF-42 | FAIL | MINOR | Figure S2 note: "Panel A varies … panel B dates …". The panels inside the figure are labelled "(a)" and "(b)". | Write "Panel (a) … panel (b)". |
| TF-45, TF-27 | FAIL | MINOR | The notes to Figures 1, 2 and S2 give no N. The number of scored firms per event year (Table S6: 497 at e = −5 down to 141 at e = 4) is not referenced. | Add "scored firms per event year in Table S6". |
| TF-53, S2-14 | FAIL | MINOR | Fig1 and Fig2 are written by 04_tables_figures.R and 04b_round4_exhibits.R, then overwritten by 06_figures_saje.R. Running run_all.R alone therefore leaves draft figures that differ from the submitted ones. outputs/validation.csv and outputs/overlap/ are not produced by either runner, yet sit in the folder that check_numbers.py reads. | Let one script own each figure file. Move non-pipeline files out of outputs/. |
| C-65, C-27 | FAIL | MINOR | Section 3.1 has two institutional facts that are no longer accurate as stated. <br>• Philippines: "Philippine listed companies have attached a comply-or-explain sustainability report since the 2019 annual reports". In SEC MC 4-2019, comply-or-explain applied to the first three years only. A 2026 law-firm newsletter (oneasia.legal) reports that MC 4-2019 was repealed and replaced by MC 16-2025 (22 Dec 2025). <br>• Singapore: "Singapore requires … a comply-or-explain sustainability report" is in the present tense. The current Rule 711B(1)(aa) primary component may not be excluded (rulebook.sgx.com/node/6532). <br>Neither fact drives a variable: G comes from the data, not from rule dates. | Use the past tense limited to the sample period ("required, for 2019–2024 annual reports …"). |
| S2-31, S2-41, S2-43 | FAIL | SUGGESTION | The Callaway–Sant'Anna outcome-regression and doubly robust estimators are hand-written (02_cs_did.R, 03c_saje.R) rather than taken from did::att_gt. I confirmed the point estimates with my own code, but the `did` package is not installed, so they were not cross-checked against the reference implementation. No Goodman-Bacon decomposition is shown; Table S8 gives a bridge instead. The exact HonestDiD sets are not used, which Section 7 acknowledges. | In the replication package, report did::att_gt (est_method "reg", allow_unbalanced_panel) for the headline estimate. Optionally add bacondecomp. |
| TF-09, TF-12 | FAIL | SUGGESTION | Table 1 reports mean, median and N, without SD, min or max, and without the % missing per variable (that is in Table S4). | Optional: add SD. |
| S2-06 | FAIL | SUGGESTION | Supplementary exhibits are not numbered in order of first mention in the manuscript: Table S2 and Figure S1 appear first (3.1), then S4 and S6 (3.2), with S1 only in 5.8. | Optional renumbering. |
| S2-27 | FAIL | SUGGESTION | Section 4.2 defines N_{g,t} as firms "with data in years g − 1 and t". Estimation also requires base-year total assets (02_cs_did.R `inner_join(ab)`). | Add "and base-year total assets". |

### Checks that passed (evidence in brief)

- **C-07, S2-02, S2-12 (headline numbers).** Every headline number traces to its output cell, both semantically and to the digit:
  - Run-up 9.955 → 10.0% (CI 1.92–18.22); market-cap run-up 14.11 (3.08–25.27).
  - ATT 0.002 [−0.046, 0.048] → −4.5% to 4.9%; MDE 0.0675 → 7.0%.
  - R10 −0.06847 → −6.6% [−0.116, −0.020], p = 0.004.
  - R6 0.064 → 6.6%. Cluster-bootstrap interval −0.050 to 0.053.
  - Table 4 steps −0.0048 / −0.0160 (SE 0.0095, p = 0.092) / −0.0438 (SE 0.0194, p = 0.024) / +0.0024 / −0.0082. Gap −0.0704; the reference step is 62.2% of it.
  - Weights: MY 55.2%, TH 26.7%, sum 81.9%; MY wave 44.1%; 2021–24 87.2%.
  - Flags 209/27,127 = 0.77%; 73 scored; 1,030 / 540 / 749.
  - Missing-data shares 28.0 / 12.7 / 21.5 / 24.8 / 25.4 / 8.4 / 38.9 / 24.1.
  - Table 6 shares: 71.5 / 29.0 / 1.2 / 18.1 / 2.9 / 29.0 / 24.0.
  - H3 difference −0.041 (SE 0.040, p = 0.307), MDE 0.1127 → 11.9%; residual split −0.027 (p = 0.491), MDE 0.111; correlation 0.35.
  - Malaysian ratio exp(18.739 − 17.532) = 3.3. Abstract is 149 words.
  - The letter's "largest flagged value" is correct: firm 3295 (ID, 2019) has a ratio of 43.5, so it is flagged.
- **S2-08 (table files).** All 18 Word tables match their *_formatted.csv cell by cell, and the CSVs are generated by code from the estimate files.
- **S2-05 (stars).** Stars are computed from p using the 1.65 / 1.96 / 2.58 equivalents, consistently across tables (except the Table 3 note issue above).
- **S2-10 to S2-13 (reproduction).** Exact reproduction; see above.
- **Identity claim in Section 5.4.** It is valid by construction. With `common = TRUE`, rows (3) and (4) use the same treated and control firms (observed in g − 1, g and t) and the same covariates. Since the outcome regression is linear in ΔY, the step equals minus the weighted event-year-0 change.
- **S2-41 to S2-45 (DiD design).** Callaway–Sant'Anna with never-scored controls. The event study shows leads, uses reference year −1 and is from the robust estimator. The joint lead test uses bootstrap covariance. The placebo fails and is reported honestly as a failure. The TWFE contrast is shown, along with R11 balanced cohorts, leave-one-market-out, the cluster bootstrap with 50 clusters, and Holm adjustment for secondaries.
- **C-25 (null claims).** Every "not detected / no change" claim in the text carries a CI or is tied to Table S10 intervals.
- **C-66, S2-84 (variable coding).** The treatment variable G is coded from the data, not from rule dates, so no dummy precedes an effective date. Event time e = t − G is correct.
  - Winsorization is at the pooled 1/99 percentiles of the estimation sample, applied before logs, as stated.
  - The recording-error flag ((mcap/MTB)/assets > 10) is coded as described.
  - R10 = G + 1, with base and size measured at G; R12 = G + 2; R5 = placebo within pre-score years; R4 and R11 as described.
- **S2-79 (citations two-way).** All 45 reference entries are cited, and every in-text citation is in the list. The script's 5 "missing" and 7 "uncited" hits are corporate-author parsing artifacts, checked by hand.
- **S2-78 (claims verified via WebSearch).**
  - Demiroglu & Ryngaert, +4.86% at initiation.
  - Berg, Heeb & Kölbel, −2.37% one-year downgrade return and MSCI-only holdings; still a working paper.
  - Berg, Fabisik & Sautner: still a working paper.
  - Sahin et al.: five most recent years revisable.
  - Nguyen (2025), SAJE 13(2) 67–98: foreign ownership +, state/family −, consumer goods.
  - Sudsawasd & Sakdapat (2026), SAJE 14(1) 257–287: institutional investors long run, foreign and retail short run.
  - Prukumpai et al. (2022), SAJE 10(3) 227–257.
  - Tsang et al. (2024), JBF 169.
  - Bernama MoU: Nov 2022, about 30% EMAS, all Main/ACE.
  - SGX 711A: FY ending on or after 31 Dec 2017.
  - Thai One Report: FY ending 31 Dec 2021.
  - PH MC4: 2019 annual reports.
  - OJK: small-asset issuers 2024 (consistent with "other than small and medium from 2020").
- **TF-35 to TF-41, TF-48 to TF-50, TF-64 (figure and table format).**
  - Figures are 6.5 in wide, text 9.5–10.5 pt at print size, Liberation Sans, all fonts embedded. Vector PDF/EPS plus 600-dpi PNG.
  - No gridlines, legend below without a box, Okabe-Ito colours plus shape encoding.
  - Tables are 9 pt throughout, rules top and bottom only, no vertical borders, real Word tables. Notes are 2 sentences and ≤ 30 words; the script's "4 sentences" counts are "Eq." abbreviations. Each note gives the estimator, firm-bootstrap SEs and the star legend, and each table has a Source line.
- **C-17 (declarations).** The AI declaration, funding, COI, data availability, ethics and CRediT statements are on the title page, and the acknowledgement footnote is present (word/footnotes.xml).

### UNVERIFIED (with reason)

- **Bursa Malaysia phasing ("between 2016 and 2018").** WebSearch confirms only the October 2015 framework. The 2015 circular could not be fetched (WebFetch is blocked).
- **Bikmetova & Pirinsky (2026), JBE 204(2), DOI 10.1007/s10551-025-06063-0.** Two searches did not surface it, and the DOI cannot be resolved without WebFetch. `[CITATION NEEDED]` until checked.
- **The LSEG (n.d.) point-in-time guide URL, and whether its PIT history covers these markets.** Not fetchable.
- **Durand et al. (2019), Hawn et al. (2018) and Chen et al. (2004) claims.** Full texts were not accessible; the statements are consistent with the abstracts I know but were not re-checked.
- **SAJE figure-file requirements (TF-52).** The live author guide could not be fetched.
- **Wave contrasts as an authors' output.** These are my computation, not an authors' output (see the MINOR row above).

## AI failure-mode checklist (core C-18)

| Mode | Status |
|---|---|
| Implementation bug | Not suspected: exact rerun plus independent re-implementation. |
| Hallucinated citation | Not suspected, except Bikmetova & Pirinsky, which is UNVERIFIED. |
| Hallucinated result | Not suspected: 0 unmatched numbers, semantic mapping checked. |
| Shortcut reliance | Not suspected. |
| Bug reported as insight | Not suspected: the decomposition "identity" is verified algebraically. |
| Methodology fabrication | Not suspected: the DR cap is undisclosed but real. |
| Frame-lock | Partially suspected. The wave contrast became the main evidence without a test, and survivorship was not considered. |
| Stale outputs | Not suspected for the cache. The run_all.R-only figure path and two non-pipeline files in outputs/ remain (MINOR TF-53). |

rules checked: core 46/50 (C-40 to C-43 are orchestrator process, N/A); seat2 64/80 (GMM S2-37 to S2-39, IV S2-47 to S2-50, RDD/SCM S2-52 and S2-53, time series, asset pricing and surveys S2-56 to S2-60 are N/A); tables-figures 55/57 (TF-08 and TF-22 N/A).

COUNTS: CRITICAL 0, MAJOR 1, MINOR 15, SUGGESTION 4
REMAINING CRITICAL/MAJOR: C-06/S2-03 (survivorship: sample is firms with data in 2024, undisclosed)
