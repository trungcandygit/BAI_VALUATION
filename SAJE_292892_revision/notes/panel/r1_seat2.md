Loaded: SKILL.md (132 lines); references/cards/core.md (87 lines, <!-- CARD-END core v2 -->); references/cards/seat2-methods-integrity.md (123 lines, <!-- CARD-END seat2 v1 -->); references/cards/tables-figures.md (87 lines, <!-- CARD-END tables-figures v1 -->). Also: academic-pipeline SKILL.md (invoked).

# Seat 2, round 1: methods, integrity, tables and figures (SAJE 292892)

Scope: the round-1 dossier (manuscript, supplement, letter, title page, original manuscript and supplement, verbatim comments), the deliverables docx (built 2026-10-25 15:47), the code in project_R, and the current project outputs. The markdown sources were being edited while I worked (manuscript_saje.md and response_letter_saje.md changed at 2026-10-26 00:12). My findings refer to the round-1 dossier and deliverables. The two flagged sentences (abstract and conclusion "outside ... by 10.0%", and "subtracts exactly") are still in the current sources.

## Reproduction (S2-13, C-60)
- I copied project_R to /tmp/claude-0/panel_r1_seat2 without outputs (so the cache was empty) and symlinked the data. I ran `run_all.R` (52.7 min, exit 0) and `run_saje.R` (18.7 min, exit 0).
- The project then changed 03c_saje.R, 04c_saje_tables.R, 05c_numbers_saje.R (share_with_mcap) and build_saje.py. I copied those four files and reran `run_saje.R` (2.2 min, exit 0, cache from my own fresh run). I also ran `validation/validate_estimator.R`.
- Result: all 71 output CSV/TXT files are byte-identical to project_R/outputs, including sessionInfo.txt and validation.csv. All 8 figure files are byte-identical (Fig1, Fig2, FigIA1, FigIA2; .eps and .png). The validation checks all pass: manual lm() matches the pipeline ATT(g,t) to 1e-11, and the simulation recovers the true ATT.
- My first run_saje (old code) differed from the project only in s_missing_compare.csv and the files built from it: tableSAJE6, tableSAJE7, tableSAJES9 and numbers_saje.csv. That is the expected change.
- No script writes outputs/run_log.txt. It is a stale log ("Done in 12.8 minutes", an older run).
- PASS S2-10, S2-11, S2-13.

## Independent recomputations (no sampling)
- Data and coding (C-65 to C-68, S2-84):
  - The source has 3,709 firms × 11 years (40,799 rows), no duplicate firm-years, and one country and one industry per firm.
  - G is the first year with a non-missing ESG_Score. I rebuilt it independently: no score falls in a year before G, and cohort counts by year and market match Table S2 exactly (MY 404, TH 165, SG 50, ID 42, PH 14).
  - Text counts check out: 108 = TH+SG 2019-20; 289 = MY 2021-22; 577 in 2020-23; 135 in 2014; 3,288 firms; 36,168 firm-years.
  - Coverage gaps: 17 scored estimation firms, 17 firm-years. No scored firm stops being scored before 2024.
  - MTB at or below zero: 0 of the 31,300 non-missing MTB values in the whole source (minimum 0.00066). marketcap and asset are never ≤ 0. The claim holds.
- Recording-error flag: 209 of 27,127 firm-years (0.770%), 73 of them scored, 40 firms. By market: ID 56, MY 111, TH 24, SG 16, PH 2. The ratio-2 flag catches 749. The maximum is 1,138.8 bn USD (firm 3295, ID, 2019; implied book equity is 43 times total assets).
- Missing data: 28.0% / 12.7% missing; 21.5% / 24.8% of missing firm-years have mcap. Table S11 cells: lev>0.5 at 25.4% vs 8.4%; ID share 38.9% vs 24.1%.
- Table 1: every cell, the normalized differences, 4.3x, and 24.6% (same-year p95; the pooled p95 gives 25.0%) all match.
- Correlation of score with size: 0.351.
- R10 decomposition, point estimates rebuilt from build_cells2/cell_atts2:
  - A0 = 0.001923 equals the baseline. C3 = −0.068470 equals R10 to 10 digits.
  - Steps: −0.0048, −0.0160, −0.0438, +0.0024, −0.0082. The 62% share is right.
- Weights: 1,946 scored firm-cells = 615+578+483+270 (Table S6). The market and wave shares match Table S9. Calendar years 2021-24 = 87.2%.
- Table S5 bias bound: (e+1) weight 4,300/1,946 = 2.210; 0.25 × 0.046 × 2.210 = 0.025.

## Design and code audit (R/02_cs_did.R, R/03c_saje.R line by line)
- Outcome regression (Eq. 3-6): the code fits OLS of ΔY on X among never-scored firms in each cell, takes the treated mean residual, weights cells by scored-firm count, and uses a universal base g−1. This matches the text and the equations in the docx (11 OMML equations checked).
- Doubly robust estimator (cell_atts2): `mean_tr(ΔY−m̂) − Σ odds·(ΔY_c−m̂_c)/Σ odds`, odds = p/(1−p), logit on the same X refit in every bootstrap draw. This is exactly the Sant'Anna-Zhao (2020) traditional panel DR-DiD. Control p is capped at 0.99 (DRDID itself trims at 0.995 instead).
- Common support: the restriction is a one-sided cap on scored firms' base-year size at the q-th percentile of controls in each cell. Retained/excluded in Table 6 means "in any trim95 cell" vs "in baseline cells only". This is consistent with the text.
- Missing-MTB checks, the flag, the market and wave weights, and the wave datings: specified as described. The wave R10 rows are C3 restricted by wave.
- Inference: firm bootstrap with 999 draws shared across specifications, percentile CI, normal p. Market-by-industry cluster bootstrap with 50 clusters. TWFE uses firm-clustered Arellano HC1. SE types are named in the text (Sections 4.3, 4.5).

## Findings

| rule ID | verdict | severity | evidence | fix |
|---|---|---|---|---|
| C-07, S2-02 | FAIL | MAJOR | Abstract: "outside a broad Malaysian wave their market-to-book ratio had outgrown that of similar firms ... by 10.0% on average". Conclusion (s.8): "outside the broad Malaysian wave ... by 10.0% over five years". 10.0% is the pooled run-up over all scored firms, including the Malaysian wave (key mtb_runup_m5 = 100·(e^0.0949−1) from event_study.csv). Malaysian-wave firms dominate the e=−5 cells (cohorts 2021/2022 = 316 of 497 firms). I recomputed the point estimate excluding the Malaysian wave: e=−5 = −0.160, a run-up of 17.3%. The Malaysian wave alone gives 2.8%. | Either attach 10.0% to all scored firms ("by 10.0% on average, a run-up concentrated outside the Malaysian wave"), or estimate the non-Malaysian-wave run-up with its bootstrap CI and quote that number. Apply the same change in the abstract, the conclusion and the letter (E2 abstract quote). |
| C-25, S2-64 | FAIL | MAJOR | "absent in the 289 Malaysian firms" (s.1), "show no run-up" (s.5.2), "Where valuations did not run up before entry, the two datings agree that MTB did not change" (s.5.4), and the letter ("which had none"; "both datings show no MTB change"). None of these gives a CI. r4_event_profiles.csv, MY wave e=−5: −0.027, 95% CI [−0.142, 0.077], i.e. a run-up between −7.4% and +15.2%, which does not exclude the pooled 10%. The post estimates 0.021 (SE 0.037) and 0.012 (SE 0.033) have CIs of about ±0.07. | Report the CIs. Write "no run-up is detected (95% interval −7.4% to 15.2%)" and "neither dating detects an MTB change (intervals ...)". |
| TF-04, S2-03 | FAIL | MAJOR | Table 3 (main robustness table, 15 rows, 4 outcomes) has no N. The same holds for Tables S1, S7, S8 and S10 and for the notes of Figures 1, 2 and S2. The same headline estimate (0.002) shows 628 scored firms in Table 2 (firms in any cell, e = −5..4) and 625 in Tables 4, 5 and 7 (firms in the e = 0..3 cells). No note explains the difference. The R10 estimate shows 613 (Table 4) where r4_post gives 646 (the original text said 646). | Add a scored-firms and control-firms row or column to every estimate table. Define "scored firms" once, as firms in the post-coverage cells (625), and use that count everywhere, or explain the difference in the note. |
| C-17 | FAIL | MAJOR (author decision) | Title-page declaration: Claude was used "to screen candidate research questions, draft the pre-analysis plan, write and check the R code ... carry out the additional analyses ... draft the revised text, and draft the response letter". Editor E5: tools "should be limited to improving the language and readability ... must not be used to generate core content such as scientific insights, conclusions". The disclosure is honest, but it reports uses outside the journal's policy. | Authors decide: AUTHOR_INPUT_NEEDED. At minimum, the letter's E5 answer should not imply compliance. Seat 1 owns this. |
| C-02 | FAIL | MAJOR | Letter E4 contains "[AUTHOR_INPUT_NEEDED: name of the professional editorial service ...]". The package is still a draft. | Authors supply the service name and month, or answer E4 truthfully without it. |
| S2-78, C-18 (bug-as-insight check) | FAIL | MINOR | s.5.4: "the MTB ratio of scored firms rose by 0.044 relative to never-scored firms between g − 1 and g, and row 4 subtracts exactly this rise". The letter repeats it ("rose by a further 0.044 ... subtracts exactly"). 0.044 is just abs(d_reference_C1_B1). The identity holds exactly only for the g−1→g change measured on the same firm-cells as each (g,t) cell. I checked: treated and control sets are identical in B1 and C1, 30/30 cells. The e=0 change estimated on all firms observed in g−1 and g, weighted with the e1-4 weights, is 0.036, not 0.044. For ln(mcap) the identity holds exactly on full e=0 cells (+0.0017). | Rephrase: "row 4 subtracts the relative change between g − 1 and g of the same firms (0.044)". Do not present 0.044 as a separately estimated rise. |
| S2-03 | FAIL | MINOR | s.5.4: "so that the same firms enter every later row". Table 4 scored firms run 615 → 585 → 585 → 583 → 613. Row 5's label says "same firms", but it has 583 against 585. | Write "drawn from the same set of firms" and note that the window and size availability drop a few. |
| C-08, S2-02 | FAIL | MINOR | s.5.6 and letter: "between −0.096 and −0.033 with them". s_mcap_cov_min includes the trim95 and DR support rows. Across functional forms only, the range is −0.059 to −0.033. | Separate the functional-form range from the support-restriction range. |
| TF-16 | FAIL | MINOR | The notes of Tables 2-5, 7, S1, S3, S7 and S10 say "bootstrap standard errors" without the resampling unit. The Table 5 and Table 7 notes do not name the estimator (outcome regression, with DR rows). | "firm-level (cluster) bootstrap standard errors"; "outcome-regression estimates unless labelled doubly robust". |
| TF-15 | FAIL | MINOR | check_docx_style finds notes over 30 words: Table 5 (31), Table 7 (31), S1 (35), S3 (35), S5 (41), S7 (43), S8 (39), Figure S2 (40), S10 (39). | Shorten to 2 sentences and about 30 words. |
| TF-37, TF-60 | FAIL | MINOR | ggplot theme_bw(base_size = 10) puts ticks, strips and legend at 8 pt. All figures are saved at 6.5 in and printed at 6.5 in, so they print at 8.0 pt (FigIA1: 8.7 pt). check_figure.py output. SAJE's own minimum is UNVERIFIED, so the stricter 9 pt applies. | Use base_size = 11, or set axis.text, strip.text and legend.text to 9 pt. |
| TF-64, TF-24 | FAIL | MINOR | Main tables are 9 pt and supplement tables 10 pt, except S10 and S11 at 9 pt (docx XML). In the dossier PDFs, Tables 6, 7, S7 and S9 split across pages without a repeated header row. | Use one table size. Keep tables together or repeat the header. |
| S2-07 | FAIL | MINOR | Terminology drift from "first recorded score": the Figure 1, 2 and S1 axis labels read "first LSEG ESG score"; the Figure S2 panel reads "First scored fiscal year as event"; the titles of Tables S1, S3, S5 and S7 read "average effect of the first LSEG ESG score"; s.1 says "entered LSEG coverage between 2015 and 2024". Table 2 was retitled "change ... under assumption (2)", but the supplement titles still say "effect". | Use "first recorded score" and "change under assumption (2)" everywhere. |
| S2-08 | FAIL | MINOR | The deliverables (15:47) predate the current outputs (16:34). Current tableSAJE7 (Table S11) has a new row "Share with market capitalization". tableSAJE6 shows "2,351.7" and "1,478.0" where the docx has 2351.7 and 1478.0 (the thousands-separator inconsistency TF-07 is fixed in the code). tableSAJES9 now lists calendar-year rows. | Rebuild the docx and PDFs from the current outputs, then rerun check_numbers. Against current outputs it gives 0 unmatched in all 6 deliverables. |
| S2-02 | FAIL | MINOR | s.5.1: "the median total assets of scored firms were 3.3 times those of the 565 never-scored firms". my_asset_ratio_med is exp(difference of median firm-level all-year median ln assets), which includes post-coverage years. On the Table 1 basis (base year against never-scored firm-years), the Malaysian ratio is 3.0. | State the basis, or use the base-year comparison. |
| S2-03 | FAIL | MINOR | Supplement B.6: "The 58 firms first scored by 2019". Table S2 has 62 firms in cohorts 2015-2019; 58 is the number in the MTB estimate. | "58 of the 62 firms first scored by 2019 enter the MTB estimate". |
| C-08 | FAIL | MINOR | Letter, Comment 6: "so the missing ratios do not remove the largest or smallest scored firms". Equal medians (280.3 against 294.3) say nothing about the tails. | Drop the clause, or report quartiles. |
| C-15, S2-79 | FAIL | MINOR | Letter E3 lists the new references but does not say that Serafeim & Yoon (2023), which is in the original reference list, was removed. The two-way match in the revised paper itself is PASS. | Mention the removal. |
| S2-78 | FAIL | MINOR | s.4.2: "restricts scored firms to the size range of the controls, where the doubly robust estimator becomes usable (Crump et al., 2009; ...)". Crump et al. trim on the estimated propensity score (about 0.1-0.9), not on a size percentile. Support is partial. | "in the spirit of Crump et al. (2009)", or add a propensity-score trim row. |
| S2-20 | FAIL | MINOR | s.3.4 justifies the ten-times threshold by "ratios slightly above one". Among the 27,127 checked firm-years, 1,030 have ratios in (1, 2] and 540 in (2, 10]. A factor of 2-10 cannot come from measurement dates. The ratio-2 row exists in Table 7, but its count (749) is not in the text. | Report both counts and present ratio > 2 as the stricter flag. |
| S2-14, S2-17 | FAIL | MINOR | Three code issues. (1) OR and DR set NA coefficients to 0 (`b[is.na(b)] <- 0`), so a country or industry with no controls in a cell silently falls back to the reference level. This is not documented, and I did not count how often it happens. (2) The run_win cache (outputs/cache_saje) is keyed on arguments only, not on data or code, so a stale cache can silently reproduce old results. (3) outputs/run_log.txt is stale and is written by no script. | Count and report the NA-coefficient cells. Key the cache on the data hash and file md5, or clear it in run_saje.R. Delete or regenerate run_log.txt. |
| TF-44 | FAIL | MINOR | Dossier PDF 02_Manuscript_Revised_Marked_blue.pdf shows equations (1)-(11) as blank lines with only the numbers (pages 11, 13, 15). The docx contains all 11 OMML equations, so the converter dropped them. | Produce any PDF from Word, or check that the equations render, before uploading. |
| S2-06 | PASS with note | SUGGESTION | check_crossrefs: equations (1) and (4) are never referenced. Every other hit is a cross-document or organisational-author false positive. | Optional. |
| S2-43 | NOTE | SUGGESTION | The bounds are a simplified relative-magnitude interval (disclosed in s.4.4 and s.7), not HonestDiD confidence sets. HonestDiD is not installed here. | Optionally report HonestDiD::createSensitivityResults_relativeMagnitudes. |
| S2-41 | NOTE | SUGGESTION | Table S8 gives a bridge, not a Goodman-Bacon decomposition. | Optional bacondecomp figure. |
| S2-27 | NOTE | SUGGESTION | The Table 4 sequential decomposition is order-dependent (the window step is taken before the reference step). The 62% share is conditional on that order. | One sentence noting the order. |
| TF-35, TF-38 | NOTE | SUGGESTION | The figures keep major gridlines (theme_bw), and pre-period intervals are dotted. | Lighter or no grid; dashed instead of dotted. |

PASS checks (rule: evidence):
- S2-01, S2-02: check_numbers finds 0 unmatched decimals in the manuscript (480), supplement (389) and letter (89), clean and marked. A semantic audit of all 226 manuscript and 67 letter placeholders found every key mapped to the right quantity except the rows above. Abstract: 144 words, no statistics.
- S2-05: stars match p in every table (spot list: R10 −0.068*** p=0.004; R12 −0.048* p=0.057, CI upper +0.0001, consistent).
- S2-29, S2-30: SE types are named in the text. A 50-cluster bootstrap is reported.
- S2-31: CS-OR and DR-DiD are validated against manual lm() (validation.csv).
- S2-65: Holm across the three secondary outcomes.
- C-20, C-21, C-23: causal wording is conditional on assumption (2) throughout. Mechanisms are worded as consistency.
- S2-79: the two-way citation match passes, 44 references (manual check; the script hits are false positives).
- S2-77, S2-78: claims verified by WebSearch:
  - Berg, Heeb & Kölbel: −2.37% one-year abnormal return; MSCI is the only rating that explains the holdings of ESG-mandate funds.
  - Demiroglu & Ryngaert: +4.86%, driven by favourable reports.
  - Sahin et al. (2023): the five most recent years can change after publication.
  - Nguyen (2025), SAJE 13(2) 67-98: foreign ownership positive, state and family ownership negative, consumer-goods firms.
  - Sudsawasd & Sakdapat (2026), SAJE 14(1) 257-287: institutional investors adjust in the long run, foreign and retail in the short run.
  - Prukumpai et al. (2022), SAJE 10(3) 227-257.
  - Berg, Fabisik & Sautner: no journal version found.
- TF-48: EPS (vector, cairo, LiberationSans embedded) plus 600-dpi PNG for every figure.
- TF-01: booktabs-style rules in all tables.

## UNVERIFIED
- Bikmetova & Pirinsky (2026, JBE 204(2) 335-365, doi 10.1007/s10551-025-06063-0) and Tsang et al. (2025, CGIR 33(4) 554-577, doi 10.1111/corg.12615): WebSearch did not find the title or the DOI. Both are carried unchanged from the original, and only WebSearch reaches the internet here.
- Tsang et al. (2024): not checked in this round.
- "Firm-years with negative book equity appear as missing" (s.3.2) is an inference about vendor practice. The data show no MTB ≤ 0, but cannot show how negative book equity is coded.
- "Amounts are in U.S. dollars": not checkable against vendor metadata. The magnitudes are plausible.
- SAJE figure font and file rules (TF-52): the author guide was not reachable.
- Institutional dates in s.3.1 and the Bernama "about 30%" claim: Seat 1's scope. Not driving any variable (G does not depend on the rules).

COUNTS: CRITICAL 0, MAJOR 5, MINOR 17, SUGGESTION 5
REMAINING CRITICAL/MAJOR: C-07/S2-02 (abstract and conclusion "outside the Malaysian wave ... 10.0%"), C-25/S2-64 ("absent / no run-up / did not change" without CIs), TF-04/S2-03 (N missing in Table 3, S1, S7, S8, S10 and figures; 628 vs 625), C-17 (AI-use declaration vs editor E5 policy), C-02 (AUTHOR_INPUT_NEEDED in letter E4)

rules checked: core 50/50 (including N/A: C-40 to C-43 process rules, C-35 and C-36 orchestrator) · seat2-methods-integrity 80/80 (including N/A: IV, GMM, RDD, SCM, time-series, asset-pricing, survey and Bayesian rules S2-37 to S2-39, S2-47 to S2-54, S2-56 to S2-60) · tables-figures 57/57 (including N/A: TF-22 and TF-23 LaTeX, TF-51 TIFF, TF-54 alt text)
