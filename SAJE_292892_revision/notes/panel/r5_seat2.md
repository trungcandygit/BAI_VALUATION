Loaded: /root/.claude/skills/paper-revision-master/SKILL.md (133 lines); references/cards/core.md (87 lines, <!-- CARD-END core v2 -->); references/cards/seat2-methods-integrity.md (123 lines, <!-- CARD-END seat2 v1 -->); references/cards/tables-figures.md (87 lines, <!-- CARD-END tables-figures v1 -->). Skills invoked: academic-pipeline, paper-revision-master.

# Seat 2 (methods, integrity, tables and figures), panel round 5, SAJE 292892 R1

Target: the frozen round-5 materials, `panel/round5/dossier/` and `panel/round5/build_frozen/*.docx` (all dated 2026-10-31 07:52). I checked them against the current `project_R` code and outputs. The dossier text matches the frozen Word files; the only differences are in table layout.

## What was done

- **Rerun.** I copied project_R without outputs to `/tmp/claude-0/panel_r4_seat2/project_R` and recreated the data symlink. `LANG=C.UTF-8 Rscript run_all.R` finished in 25.1 min with exit 0. `run_saje.R`, run with an empty cache, finished in 15.1 min with exit 0.
  - The copy predates three label-only code edits (04_tables_figures.R, 04b_round4_exhibits.R, 04c_saje_tables.R, edited 01:48). Analysis scripts 00–03c, 05, 05c and 06 are byte-identical to the current project.
  - I then re-ran the current 04, 04b, 04c and 05c code on the rerun outputs in a separate folder, `/tmp/claude-0/panel_r4_seat2/fmtcheck`.
- **Diff of outputs.** All 62 rerun CSV/TXT outputs are byte-identical to `project_R/outputs`.
  - Exception: table3, tableIA7, tableIA8 and tableSAJE4_formatted differed only in row labels, which comes from the code edit above.
  - With the current formatting code, every `table*_formatted.csv`, `numbers.csv` and `numbers_saje.csv` is byte-identical. This includes table3, tableIA2, tableIA3, tableIA4, tableIA7 and tableIA8, so the files regenerated outside the runners are reproduced by a full run.
  - Figures:
    - The PNG and EPS files for Fig1, Fig2, FigIA1 and FigIA2 are byte-identical.
    - The cairo PDFs, rendered at 150 dpi, differ by 0 pixels (ImageMagick AE = 0).
    - The images embedded in the frozen docx have the same MD5 as the rerun PNGs.
- **Independent recomputation from the raw xlsx with my own R code (not the project's functions):**
  - Sample flow: 3,709 → 3,423 → 3,288 firms (675 scored, 2,613 never-scored, 135 firms scored in 2014).
  - Table S1, cell by cell.
  - 17 coverage gaps; 675 of 675 scored firms have a score in 2024; all 3,709 firms have data in 2024; no G at or before the first listed year; no ESG score in an empty row.
  - Listed-row count 3,647 and 32,521 listed firm-years; missing-MTB shares 18.5% / 9.0% and 36.7% / 36.6% with market capitalization.
  - Recording-error flags 27,127 / 1,030 / 540 / 209 / 73 / 749 (0.77%); the maximum, 1,138.8 bn USD, is Indonesian firm 3295 in 2019 with ratio 43.5, so it is flagged.
  - Headline ATTs by my own lm():
    - Post-coverage averages: 0.0019, −0.0549, 0.0085, 0.0435.
    - Every event-time estimate and every cell count in Table S3.
  - Pooled weights in Table S10 (1,946 firm-cells; 55.2 / 26.7 / 44.1 / 87.2%).
  - Relative-magnitude bias bound: weighted mean of (e+1) = 2.2097; Δ = 0.046; bound at M̄ = 0.25 is 0.025.
  - Holm adjustment, MDE, run-up transforms 100(e^−θ − 1), and the TWFE decomposition shares (53% and 79% of the remainder).
- **Scripts on the frozen docx:**
  - check_numbers: 491 + 403 + 15 + 94 decimals, 0 unmatched.
  - All 18 Word tables equal their formatted CSVs after removing whitespace.
  - check_crossrefs: every remaining hard failure is a false positive (exhibits cross-referenced between the paper and the supplement; multi-word institutional authors). I matched citations two-way by hand: 45 references, all cited, none missing.
  - check_docx_style and check_figure: 0 warnings; all fonts embedded; 600 dpi at 6.5 in; text 9.5 pt or larger; Word tables at 9 pt with no vertical borders.
- **Semantic check of placeholders.** I checked every one of the 362 placeholder occurrences in manuscript_saje.md and response_letter_saje.md (07:49 versions, the sources of the frozen build) against its sentence. None is missing; `s_abstract_*` are filled by the builder (149 words, confirmed with wc).
- **Pages rendered and inspected:** every table and figure page of the paper and the supplement.
- **Claim checks with WebSearch:**
  - Berg, Heeb and Kölbel, −2.37%: Supported.
  - Demiroglu and Ryngaert, 4.86%: Supported.
  - Sahin et al., five-year non-definitive scores: Supported.
  - Shanaev and Ghimire: Supported. It uses MSCI, as the text implies.
  - Durand et al.: Supported.
  - Berg, Fabisik and Sautner: still a working paper (R&R at JF), so the letter's claim holds.
  - The Bikmetova and Pirinsky DOI resolves at Springer.
- **Round-4 items resolved in round 5:**
  - The reviewer quotes in the letter are now verbatim; my script checked every sentence against reviewer_A_report_verbatim.txt and found no alteration.
  - The sign of the Table 4 row-4 step is now consistent ("−0.044 … minus each cohort's own change (0.044 on average)").
  - Table 4 row 6 no longer carries an undefined "(R10)".
  - No row codes remain outside the quoted reviewer text.
  - Section references in the paper, supplement and letters point to sections that exist in the five-section structure.

## Findings (CRITICAL first)

No CRITICAL and no MAJOR findings.

| Rule ID | Verdict | Severity | Evidence | Fix |
|---|---|---|---|---|
| S2-06 | FAIL | MINOR | Supplement A.4: "Tables 4, 5, and 7 count firms in the averaged event years, while Tables 2, 3, and S4 count firms in any event-time cell." Table S4 (tableIA7_formatted.csv) has no firm-count column. The tables that do count firms in any event-time cell are Tables 2, 3, S9 and S11 (row_of() uses n_treated_firms from run_cs). | Replace "S4" with "S9 and S11". |
| S2-06 / C-03 | FAIL | MINOR | Reply to Reviewer A, Comment 6: "we also corrected a statement in the original Section 3.1". In manuscript_ORIGINAL.txt (line 38) the sentence on MTB ratios at or below zero sits in original Section 3.2 "Sample and coverage timing", which is also the section the reviewer cites ("Section 3.2 reports substantial differences…"). | Change it to "original Section 3.2". |
| S2-03 / C-07 | FAIL | MINOR | The paper (3.1: "3,288 firms with 32,521 listed firm-years (3,647 rows precede listing)") and the letter ("the 3,647 rows before a firm lists carry no data") both call all 3,647 empty rows pre-listing. Recomputed from the xlsx, using the code's own `listed` flag (03c_saje.R line 237): 3,639 rows precede the firm's first listed year and 8 are interior gaps (firms 596, 692, 756, 831, 846, 1166, 3460). | Say "3,647 rows carry no data, almost all before listing", or report 3,639. The missing-data shares are unaffected because they are computed over listed rows. |
| S2-06 / S2-11 | FAIL | MINOR | The "row 4" identity is described correctly. However, 4.3 says "None of the four pre-specified robustness checks shows an MTB effect that differs from zero at the 10% level". With row codes removed, the reader cannot tell which four of the six pre-specified checks are meant (the placebo and TWFE rows are excluded because they are significant). 4.2 also says "the first six were pre-specified", but the first row of Table 3 is the baseline. | Say "the first four pre-specified checks (not-yet-scored controls, no covariates, no 2020–2021 cohorts, size-trimmed controls)" and "the six checks after the baseline were pre-specified". |
| C-20 / S2-07 | FAIL | MINOR | 4.3 says "matching on pre-coverage growth gives 0.028" and A.11 says "control firms matched on past growth". The estimator adds g−3 to g−1 growth in log market capitalization as a covariate in the outcome regression (02_cs_did.R, `pregrowth`); there is no matching. Section 3.4 describes it correctly ("adding pre-coverage growth … to Xi"). | Replace "matching on" with "conditioning on" (and "matched" with "conditioned"). |
| TF-45 / S2-73 | FAIL | MINOR | Figure 1 note: "141 to 615 scored firms per event year". These are the ln(MTB) counts (firms_by_event_time.csv). For the other panels the counts reach 635 for market capitalization at e=0 and 639 for assets (my recomputation). | Write "141 to 615 scored firms per event year for ln(MTB)", or give the range over all panels (141 to 639). |
| TF-16 / TF-45 | FAIL | MINOR | The notes to Figures 1, 2 and S2 do not name the estimator (outcome regression), although every table note does. | Prefix with "Outcome-regression estimates …"; this fits within the 2-sentence limit. |
| TF-16 | FAIL | MINOR | The Table S4 note says "Exploratory outcome-regression estimates with firm-bootstrap standard errors". Two rows ("Baseline, market-by-industry cluster bootstrap", "One year later, market-by-industry cluster bootstrap") use the cluster bootstrap (WCL in 03b_round4.R), and the baseline row is not exploratory. | Change to "… with firm-bootstrap standard errors unless labeled cluster bootstrap". |
| TF-15 | FAIL | MINOR | The Table 2 note has 32 words (check_docx_style, check 5), above the user's limit of about 30. | Drop "MDE: 80%-power minimum detectable effect;" (MDE is defined in 3.4) or shorten otherwise. |
| C-25 / S2-64 | FAIL | MINOR | 4.2 says the remaining cohorts differ from the Malaysian wave "not detectably in the run-up (p = 0.307)" without an interval. From s_wave_contrasts.csv the difference is −0.075, 95% CI −0.219 to 0.075. | Add the interval. |
| S2-07 | FAIL | MINOR | The Figure S2 legend reads "One year later, size at g − 1", while the Table S4 label is "One year later, size at original g − 1". In panel (b), g − 1 would mean the shifted base year. Figure 1 panel (d) reads "ln(total assets)", while the tables use "ln(assets)". | Use "size at original g − 1" in 06_figures_saje.R; harmonize the asset label. |
| S2-14 / C-18 | FAIL | SUGGESTION | `outputs/validation.csv` (dated 10-25) is written by `validation/validate_estimator.R`, which neither run_all.R nor run_saje.R calls. It does not feed any exhibit. The cache in outputs/cache_saje is valid, since an empty-cache run reproduces it, but it is shipped inside outputs. | Call the validation script from a runner or list it in the README; exclude cache_saje from the replication package. |
| S2-43 / S2-67 | PASS with note | SUGGESTION | The relative-magnitude bound is a conservative simplification (the bias bound is added to the percentile CI endpoints), and the paper states this ("our bound is a simplified version of Rambachan and Roth (2023)"). It is correctly implemented: Δ = 0.046, weight 2.2097, bound 0.025; the M̄ breakdown values are 0.01 (+5%) and 0.23 for the one-year-later dating. | Optionally add HonestDiD confidence sets in a later version. |

## Checks that passed (summary, with evidence)

- **Reproduction (S2-08, S2-10 to S2-13, TF-21, TF-53).** PASS. Everything is byte-identical as described above, and each figure is owned by 06_figures_saje.R.
- **Numbers (C-07, S2-01, S2-02, S2-12).** PASS.
  - Every decimal number matches an output file. I recomputed the headline numbers independently.
  - Abstract, introduction, conclusion and both letters quote the same specification: 10.0%, 14.1%, 0.002 [−0.046, 0.048], −6.6%, 6.6% TWFE, 62%, −0.070.
- **Design (S2-41 to S2-45, S2-29, S2-30).** PASS.
  - Estimator: Callaway and Sant'Anna with never-treated controls, universal base g − 1, outcome regression per cell. The doubly robust estimator (logit, odds capped at p = 0.99) is used on the trimmed support.
  - Inference: firm bootstrap with 999 shared draws, so joint draws support the wave and score contrasts; a 50-cluster market-by-industry bootstrap is reported as exploratory.
  - Event study: reference period e = −1 marked, joint Wald test on e = −5 to −2 with the bootstrap covariance, TWFE benchmark firm-clustered with the clustering named in the note, placebo three years early.
  - The text describes each design in the matching words: ATT under conditional parallel trends, causal reading flagged as assumption-dependent.
- **Table 4 decomposition.** PASS. Steps −0.005, −0.016, −0.044, +0.002 and −0.008 sum to −0.070.
  - The identity is exact. With the same firms, controls and base-year size covariate, OLS linearity makes the reference step equal to minus each cohort's ATT(g,g) on the cell sample. The text and letter now describe it with the correct sign.
- **Wave differences and attribution.** PASS. The Malaysian-wave market-cap decline (−0.146 × weight 0.441 ≈ −0.064) accounts for the pooled −0.055, as the text says. Wave contrasts use the same draws.
- **Common support.** PASS. 24.6% of scored firms lie above the never-scored p95; 487 scored firms retained and 138 excluded; 1.1% of scored firm-cells have a propensity score above 0.95; no indicator is unidentified (0 of 34 cells).
- **Missing data, recording errors, survivorship.** PASS, apart from the "pre-listing" wording finding above. Survivorship is disclosed in 3.1 and in the limitations.
- **Data coding (C-65 to C-68, S2-84).** PASS, checked year by year in the raw data:
  - G is the first year with a non-missing ESG_Score (not ESGC, as the text says).
  - Never-scored firms have G = ∞; event time e = t − g; no G before listing; no ESG score in an empty row.
  - Coverage gaps: 17. Cohorts by market match Table S1.
  - Winsorization is at 1/99 of the pooled estimation sample (MTB cut-offs 0.129 and 21.11).
  - The H3 split is at the cohort median, as stated.
  - I did not re-verify the institutional dates that drive no variable, which the text says ("a date no variable in our analysis depends on"); those are Seat 1's.
- **Tables and figures (TF-01 to TF-64).** PASS, apart from the notes findings above.
  - Booktabs-style tables with no vertical rules; SEs below coefficients; stars defined in every estimate note.
  - Estimator and SE type are named in every table note, and firm counts are given.
  - No table or figure is mentioned before it appears, and the supplement presents its tables before Appendix A.
  - Figures: no in-plot titles; Okabe-Ito colours with distinct marker shapes; reference lines at 0 and between e = −1 and 0; vector PDF and EPS plus 600-dpi PNG; fonts embedded; 9.5 pt or larger at 6.5 in.
- **Citations (S2-77 to S2-82).** PASS for the two-way match (45/45). Claims checked online are listed above; the rest are under UNVERIFIED.

## UNVERIFIED

| Item | Reason |
|---|---|
| Sudsawasd & Sakdapat (2026): "local institutional investors adjust … over the long run, whereas foreign and retail investors adjust in the short run" (2.2, 5) | The abstract found online (SAJE 14(1), 257–287) covers transaction costs, trading value and volatility. I could not confirm the investor-group, short-run versus long-run claim without the full text (only WebSearch is available). The authors should check it against the paper. |
| Bikmetova & Pirinsky (2026): "more ownership by high-ESG institutions" | The Springer page confirms lower emissions and better ratings after coverage initiation. The ownership claim was not found in the snippet. |
| Tsang et al. (2024; 2025): fewer violations; dividend increases | WebSearch did not return either paper's abstract. Metadata is not verified. |
| Hawn et al. (2018): "limited price effects relative to similar firms" | Supported only indirectly, through Durand et al.'s description of it. |
| Institutional dates (Bursa, SGX, SEC PH, OJK, Thai One Report, Bernama MoU, "about 30%") | Seat 1 owns these (C-68). No variable depends on them, which I confirmed in the code. |

COUNTS: CRITICAL 0, MAJOR 0, MINOR 11, SUGGESTION 2

REMAINING CRITICAL/MAJOR: none

rules checked: core 50/50; seat2-methods-integrity 80/80 (IV, RDD, SCM, GMM, time-series, survey, asset-pricing and quantile rules checked as not applicable to this design); tables-figures 57/57
