Loaded: /root/.claude/skills/paper-revision-master/SKILL.md (133 lines, no sentinel); references/cards/core.md (87 lines, `<!-- CARD-END core v2 -->`); references/cards/seat2-methods-integrity.md (123 lines, `<!-- CARD-END seat2 v1 -->`); references/cards/tables-figures.md (87 lines, `<!-- CARD-END tables-figures v1 -->`). Also loaded: Skill("academic-pipeline"), Skill("paper-revision-master").

# Seat 2, round 6 (final): methods, integrity, tables and figures. SAJE 292892 R1

Scope: a fresh pass on the refreshed frozen set (panel/round6/build_frozen and dossier, timestamped 12:57). I diffed the refreshed docx text against the earlier frozen copy. The changes are text-only, in six manuscript paragraphs, the Discussion and Limitations, and one paragraph of each letter. Supplement and title page: no text change. Tables and figures: unchanged.

## Reproduction (C-60, S2-13): PASS

- I copied the project to /tmp/claude-0/panel_r6_seat2/project_R, without outputs/ and with the data symlink recreated. `run_all.R` finished in 25.7 min with exit 0. `run_saje.R` then ran on an empty cache in 15.8 min, exit 0.
- **74 of 74 output CSV/TXT files are byte-identical to project_R/outputs.** This includes the regenerated table3, tableIA2, IA3, IA4, IA7 and IA8, all s_* and numbers*.csv files, and sessionInfo.txt.
- validation.csv is not written by either runner. I reran validation/validate_estimator.R separately, and its output is byte-identical to the project copy.
- Figures, checked after run_all and again after run_saje:
  - Fig1, Fig2, FigIA1 and FigIA2 .png and .eps are byte-identical.
  - The cairo PDFs differ only in CreationDate. Rendered at 150 dpi, their pixel difference bounding box is None (identical).
- The four PNGs embedded in the manuscript and supplement docx are byte-identical (md5) to outputs/figures.
- All 18 docx tables (7 main, 11 supplementary) match their *_formatted.csv source cell for cell, ignoring whitespace.

## Numbers (S2-01, S2-02, C-07): PASS

- `check_numbers.py` was run on all five refreshed docx against the rerun outputs. Unmatched numbers: 0 in every file.
- Semantics: I listed all 228 distinct manuscript placeholder keys and 85 letter keys with their context, read the meaning of each key, and recomputed every number from the raw CSVs. Examples:
  - MDE 7.0% = e^0.06746 − 1.
  - Interval −4.5%/4.9% = e^−0.046 − 1 and e^0.048 − 1.
  - Run-up 10.0% = e^0.0949 − 1, with interval 1.9 to 18.2 from the inverted percentiles.
  - Malaysian-wave run-up 2.8% (interval −7.4 to 15.2); remaining cohorts 10.8% ("fall in between" holds).
  - Gap −0.070 = −0.0685 − 0.0019. Reference-step share 62% = 0.04381/0.07039.
  - Weights: 55.19 + 26.67 = 81.9; calendar years 2021–24 = 87.2. Total cells 1,946 equal the sum of Table S3 rows e = 0..3.
  - Missing shares: 4,694/25,400 = 18.5% and 639/7,121 = 9.0%, computed over listed firm-years.
  - Table S2 share missing: 1 − 27,188/32,521 = 0.164.
  - Flags: 209/27,127 = 0.77%. The flagged maximum is firm 3295, ID, 2019, market cap 1.139e12 USD, implied equity/assets = 43.5. It is the largest value overall, so the letter's "largest flagged value" is correct.
  - Breakdown values: M̄ = 0.012 and 0.228.
  - Stars match |b/se| in every table. Example: the placebo has p = 0.00987, so *** with p shown as 0.010 is correct.
- Abstract: 149 words, as both letters state.

## Design and inference: PASS, with MINOR items

- **Estimator (code read in full).**
  - Staggered DiD with outcome regression per (g,t) cell, on never-scored controls, using a long difference from universal base g−1 regressed on base-year size, size², and country and industry indicators.
  - Firm bootstrap: 999 shared draws (frequency weights), percentile CIs, normal p-values.
  - Holm adjustment on H2. Wald pre-test on e = −5..−2 using the bootstrap covariance.
  - The description in Section 3.3 and 3.4 matches the code.
  - Doubly robust estimator: OR residuals plus odds-weighted control residuals, logit on the same covariates, control p capped at 0.99. This matches the text.
  - No country or industry indicator lacks a control firm in any of the 34+34 cells (s_na_coefficients).
- **Table 4 identity.** On the common sample, the firm sets in the B1 and C1 cells are identical and the estimator is linear in Y. So C1 − B1 = −Σ w·ATT(g,g) holds exactly, with the right sign: own change +0.044, step −0.044. The pooled event-year-0 estimate is 0.0169, so "larger than the pooled event-year-0 estimate" holds.
- **Wave contrasts.** These use joint draws on the same WBOOT matrix. All six quoted values check out (−0.258 p = 0.0096; −0.148 p = 0.0061; −0.123 p = 0.0095; −0.075 [−0.219, 0.075]).
- **Other design checks.**
  - The relative-magnitude bound is (e+1)·M̄·Δ, weighted by the post-period cell counts (w̄ = 2.21). This matches equation (7) and the text. The text calls it a simplified version.
  - Common support: 24.6% of scored firms are above the never-scored 95th percentile in the same year.
  - Table 6 groups come from the cells used in the estimate.
  - "Not detected" claims carry 95% CIs throughout (C-25). SE types are named in every note.
- **Data coding (C-65 to C-68, S2-84).** The year-by-unit cohort table rebuilt from the raw xlsx matches Table S1 cell for cell.
  - G is the first non-missing ESG_Score year. No score appears in a row without data, and no firm with G > 2014 is scored in its first listed year.
  - The TWFE dummy is D = 1[year ≥ G], so no unit is treated before G.
  - 17 of the scored firms have a coverage gap. All 901 scored firms have a score in 2024.
  - All 3,709 firms have data in 2024, so the survivorship claim holds.
  - 3,647 empty rows: 3,639 before listing and 8 after.
  - MTB ≤ 0 count is 0, so the "no MTB at or below zero" claim holds.
  - No regulation-based treatment dummy exists. The reporting-rule dates in Section 3.1 do not drive any variable; Seat 1 owns those claims. The November 2022 Bursa–LSEG MoU and the EMAS ≈ 30% figure were confirmed by WebSearch (The Edge, The Star, Finextra).

## Findings (CRITICAL first)

| rule ID | verdict | severity | evidence | fix |
|---|---|---|---|---|
| — | none | CRITICAL | No CRITICAL finding. Reproduction, numbers and tables pass in full. | — |
| — | none | MAJOR | No MAJOR finding. | — |
| S2-06 (semantic) | FAIL | MINOR | §4.2, after Table 4: the row-4 step is "weighted as in event years 1 to 4, which fall most on the early cohorts observed longest after entry". In the baseline cells (att_gt.csv, ln_mtb), cohorts 2015–2020 carry 38.0% of the e = 1..4 weights against 23.1% of the e = 0 weights. Cohorts 2021–2022 still carry 55%. The weights shift toward the early cohorts but do not fall mostly on them. | Write "which give the early cohorts more weight than event year 0 does". |
| S2-06, C-23 | FAIL | MINOR | Several passages attribute the step from no covariates to baseline to "base-year size": the introduction ("base-year size is held fixed"), §4.3 ("conditioning on base-year size for most of the rest"), A.5 ("Conditioning on base-year total assets"), and §5 ("depends on conditioning on base-year size: without covariates, the MTB run-up is 6.6%"). But the no-covariate spec (make_X with covars = FALSE) also drops the country and industry indicators. No spec isolates size. | Say "base-year covariates (size, country, industry)", or add a country-and-industry-only row. |
| C-24 wording | FAIL | MINOR | §4.2: "With the cluster bootstrap, which allows for market-wide shocks …". The clusters are the 50 market-by-industry groups (03b_round4.R), so correlation across industries within a market is not allowed for. Market-wide level shocks are absorbed by the country indicators in each cell. The letter's version ("our country indicators and cluster bootstrap address") is accurate. | Say "allows for correlated shocks within market-industry groups; market-wide shocks are absorbed by country indicators". |
| S2-06 | FAIL | MINOR | Supplementary exhibits are not numbered in order of first mention in the main text. Character offsets in the clean text: S6 30356, Fig S2 31290, S7 31683, S8 35713, S9 38170, then S5 38574 and S4 38939. Main-text exhibits are in order. | Renumber S4 and S5 to follow S9, or cite them earlier. |
| C-07, S2-02 | FAIL | MINOR | Text percentages cannot be traced to the digit in the tables they cite. §4.3 says "Singaporean (29.0% against 1.2%) … Indonesian (18.1% against 2.9%) … Thai (29.0% against 24.0%) … Malaysian (71.5%)", but Table 6 shows 0.29/0.01/0.18/0.03/0.29/0.24/0.71. §4.3 also says "25.4% … 8.4% … 36.2% against 24.1%", but Table S8 shows 0.25/0.08/0.36/0.24. The values match s_support_retained.csv and s_missing_compare.csv. | Show Table 6 and Table S8 shares as percentages with one decimal, or round the text to the table. |
| S2-12 (letter) | FAIL | MINOR | Response to Reviewer A, Comment 6: "the 3,647 rows before a firm lists carry no data". Raw data: 3,639 of the empty rows are before the first listed year and 8 are after it. The manuscript's "almost all before listing" is correct. | Write "the 3,647 rows without data, almost all before a firm lists". |
| S2-20, S2-17 (recording errors) | NOTE | SUGGESTION | The flag catches implied book equity only on the high side (> 10× assets). On the low side, 269 firm-years have implied book equity below 1% of total assets despite a median book leverage of 0.24 (31 of them scored; ratio < 0.001 for 70). My scratch point estimates, which I ran myself (no SEs): dropping them gives ln MTB 0.003 and ln market cap −0.046. Dropping both tails gives −0.006 and −0.036. Conclusions are unchanged. The new Limitations sentence covers smaller errors but not this low tail. | Add one clause, or a row to Table 7, for the symmetric flag. |
| S2-31 | NOTE | SUGGESTION | The CS estimator is hand-coded. validation.csv confirms 8 cells against manual lm() (diff < 1e-10) and 3 simulations, and I reproduced it. The `did`/`DRDID` packages are not installed here, so a cross-package check is UNVERIFIED. | Replication README: a one-line did::att_gt(est_method = "reg", base_period = "universal") comparison. |
| S2-43, S2-31 | NOTE | SUGGESTION | The relative-magnitude bound is a simplified, conservative construction, not HonestDiD. This is disclosed in §5 and in the code comment. | None required; optionally add an HonestDiD RM set for the two datings. |
| TF-14 | NOTE | SUGGESTION | "No Malaysia" appears in both Table 3 and Table S9 with identical values. | Optional: drop the row from Table 3. |
| TF-17 | NOTE | SUGGESTION | Table S5 note uses "TWFE", which is not defined anywhere in the supplement. The title spells out "two-way fixed effects". | Write "static two-way fixed effects (TWFE)" in the note, or "static regression". |

### Checked and passing (selected)

- C-25, S2-64: every "not detected" claim has a CI or an MDE (MTB [−0.046, 0.048], MDE 0.067; wave [−0.053, 0.091]; H3 MDD 0.113 and 0.111).
- S2-65: Holm adjustment is applied to H2. Exploratory analyses are labeled.
- S2-05: stars match in all 18 tables.
- S2-03: sample funnel 3,709 → 3,423 → 3,288 = 675 + 2,613; 32,521 + 3,647 = 36,168.
- TF-15 and TF-16: notes are at most 2 sentences (`check_docx_style` long_notes = 0). Each note names the SE type and the star legend.
- TF-37 and TF-48 to TF-50 (`check_figure`): 0 warnings, fonts embedded, 600 dpi, 9 pt prints at 9.0 pt. Vector PDF and EPS exist.
- TF-40: Okabe-Ito colours plus shape in every figure.
- TF-30: zero line, dashed line at −0.5, and the −1 reference shown.
- Refreshed pages 9–20 of the clean manuscript were re-rendered (27 pages now). There are no awkward table breaks.
- Letters: every quoted reviewer and editor comment is verbatim. Every manuscript quote in the letters is present in the refreshed manuscript. The earlier mismatches are now resolved by the refreshed text: "report pre-entry dynamics", "exchanges, regulators, and listed firms", "says little about the largest firms", and "the data cannot separate them".
- Marked and clean texts are identical apart from colour.

### Citations (S2-77 to S2-80)

- `check_crossrefs` hard failures are all parser false positives: corporate authors, the two "Berg … 2022" entries, and supplement exhibits cited from the main text.
- Verified by WebSearch:
  - Demiroglu & Ryngaert (2010): +4.86% and "positive coverage, not mere introduction". Supports the §2.1 and §4.4 wording.
  - Berg, Heeb & Kölbel: −2.37% over a one-year holding period. SAFE WP 439.
  - Bikmetova & Pirinsky: the DOI resolves at Springer. Emissions decline and ratings improve.
  - Sudsawasd & Sakdapat: SAJE 14(1), 257–287.
  - Nguyen (2025): SAJE 13(2), 67–98. Foreign ownership positive; state and family ownership negative.
  - Prukumpai, Sethapramote & Luangaram: SAJE 10(3), 227–257.
  - Bernama, Nov 2022: MoU confirmed; EMAS ≈ 30%.
- Reference changes against the original: +Crump 2009, +LSEG 2023, +Nguyen 2025, +Prukumpai 2022, +Sudsawasd 2026; −Serafeim & Yoon 2023. This matches the Response to Editor, Comment E3.

### C-18 AI failure-mode checklist

1. Implementation bug: NOT SUSPECTED. Full rerun is identical, the manual-cell validation is reproduced, and I re-derived the identity by hand.
2. Hallucinated citation: NOT SUSPECTED. The seven references checked by WebSearch exist; see UNVERIFIED for the rest.
3. Hallucinated result: NOT SUSPECTED. 0 unmatched numbers and keys checked semantically.
4. Shortcut reliance: NOT SUSPECTED.
5. Bug reported as insight: NOT SUSPECTED. The reference-year "accounting identity" is correct and correctly signed.
6. Methodology fabrication: NOT SUSPECTED. Every described check exists in code.
7. Frame-lock: NOT SUSPECTED. Both datings are given equal standing, and the alternative readings are stated.

## UNVERIFIED

- These claims were not confirmed by the search snippets:
  - Bikmetova & Pirinsky (2026): "more ownership by high-ESG institutions".
  - Tsang et al. (2024): fewer violations.
  - Tsang et al. (2025): dividend increases.
  - The 2025 paper is listed on a faculty page with these authors; the journal volume and pages were not seen.
- Cross-package check against did::att_gt: the package is unavailable and there is no network to install it.
- The variable definitions in the licensed extract (that `debt` is total debt, and that `year` is the fiscal year of the score) cannot be checked from the file alone.
- Institutional rule dates in §3.1 (Bursa 2016, SGX 2017, SEC PH 2019, OJK 51/2017, Thai 56-1 One Report): Seat 1 owns these. They drive no variable.

## Rules checked

- core.md: 38/50. C-40 to C-43, C-50, C-51, C-30 to C-36 and C-70 are process or orchestrator rules, not applicable to a seat audit.
- seat2-methods-integrity.md: 54/80. The GMM, IV/shift-share, RDD, SCM, time-series, quantile, asset-pricing, survey and Bayesian rules are not applicable.
- tables-figures.md: 51/57. TF-22, TF-23 (LaTeX), TF-29, TF-51, TF-52 (live journal page not checked) and TF-54 are not applicable or not run.

COUNTS: CRITICAL 0, MAJOR 0, MINOR 6, SUGGESTION 5

REMAINING CRITICAL/MAJOR: none
