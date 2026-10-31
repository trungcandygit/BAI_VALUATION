# Round 3, Seat 2 (methods + integrity + tables/figures): SAJE 292892 R1

Loaded: /root/.claude/skills/paper-revision-master/SKILL.md (132 lines, no sentinel); references/cards/core.md (87 lines, `<!-- CARD-END core v2 -->`); references/cards/seat2-methods-integrity.md (123 lines, `<!-- CARD-END seat2 v1 -->`); references/cards/tables-figures.md (87 lines, `<!-- CARD-END tables-figures v1 -->`). Skills invoked: academic-pipeline, paper-revision-master.

**Scope.** I audited build_r3/*.docx (27 Oct 08:42), panel/round3/dossier (27 Oct 08:43) and project_R/outputs (last written 27 Oct 08:41). While I worked (30 Oct, from 14:15 UTC), someone edited manuscript/manuscript_saje.md, response_letter_saje.md, docx_build/build_saje.py and check_blue.py, and wrote build_r3b/, build_r4/ and pdf_r4/. None of this report covers those newer files. Every finding below refers to the round-3 files.

**Reproduction (C-60, S2-13).** I copied project_R without outputs/ to /tmp/claude-0/panel_r3_seat2/work/project_R and linked the data from there. A container restart killed the first run, so I ran again from an empty outputs/ and an empty cache. `run_all.R` finished with EXIT=0 in 29.2 min, and `run_saje.R` with EXIT=0 in 17 min. Results:
- **CSV and TXT files.** All 72 files the runners write are byte-identical to project_R/outputs. This includes numbers.csv, numbers_saje.csv, sessionInfo.txt, every *_formatted.csv, and tableIA2_formatted.csv, which reproduces.
- **Figures.** The four PNG and four EPS files are byte-identical. The four cairo PDFs differ only in metadata; rendered at 150 dpi, ImageChops.difference gives bbox None (no differing pixels).
- **File not made by the runners.** outputs/validation.csv comes from validation/validate_estimator.R, which neither runner calls.

**Independent checks.**
- **Estimator.** I rewrote the outcome-regression and doubly robust (DR) group-time ATTs in Python from the raw xlsx (/tmp/claude-0/panel_r3_seat2/audit/csdid.py). It reproduces these to 6 decimals: the headline (0.001923 MTB, −0.054887 mcap, 0.008481 leverage, 0.043527 assets), every event-time estimate, R10/C3 (−0.06847), trim95 (−0.02087) and DR trim95 (−0.009774 MTB, −0.063416 mcap).
- **Data and coding.** I recomputed from the raw data, in Python: Table 1, Table S2, Table S4, the sample funnel, the 17 coverage gaps, the 24.6% overlap figure and the 3.3× Malaysian asset ratio, plus every number of the recording-error flag (27,127 / 1,030 / 540 / 209 / 73 / 749 / 0.77% / 1,138.8 bn). All match.
- **Docx versus CSVs.** Every cell of all 18 docx tables matches the rerun formatted CSVs (744 cells, 0 missing). The two figures embedded in the docx are byte-identical (md5) to outputs/figures.

## Findings (CRITICAL first)

| Rule ID | Verdict | Severity | Evidence | Fix |
|---|---|---|---|---|
| — | No CRITICAL finding | — | Reproduction is exact. All 523 decimals in the manuscript, 442 in the supplement, 25 in the editor letter and 101 in the Reviewer A letter match outputs (check_numbers.py, 0 unmatched). Each placeholder's meaning was checked against 05_numbers.R and 05c_numbers_saje.R (see the PASS list). | — |
| C-07, S2-02 (semantic layer of S2-06), C-23 | FAIL | MAJOR | **The "high point" explanation of the dating gap misstates the event-year-0 change.** Manuscript §5.4 (clean txt l.237) says: "The row 4 step is therefore this event-year-0 change, 0.044, averaged with the weights…", and calls the first recorded year "the high point of the relative MTB path". The same wording appears in §1 l.21 ("the high point of the relative MTB path") and in the Reviewer A letter (Comment 3). **What Figure 1 shows:** the pooled event-year-0 MTB estimate is 0.017 (event_study.csv: 0.01686, p = 0.360). Event year 2 is 0.01714, which is higher. So the pooled path has no detected rise at g, and g is not its high point. **What 0.044 actually is:** the step d_reference_C1_B1 (−0.0438) is the cohort-specific event-year-0 changes, reweighted by the event-year 1–4 cell weights. Those weights favour the small early cohorts. att_gt.csv, e = 0: 2015 cohort 0.278 (8 firms), 2018 cohort 0.444 (7 firms), 2019 cohort 0.090 (29 firms); 2023 cohort −0.058 and 2024 cohort −0.061 (cohorts that hardly enter years 1–4). Recomputed on the full sample, the event-year-0 ATTs weighted by e = 1–4 cell sizes give 0.036, against 0.017 under e = 0 weights. **What is correct:** the identity itself is right. The regression is linear, uses the same firms and the same size covariate, so C1 − B1 equals minus the weighted g−1→g change exactly. Only the number's label and the "high point" reading are wrong. | (1) Say that the pooled event-year-0 estimate is 0.017 (p = 0.36), and that the 0.044 step is the g−1→g change of the cohorts observed in event years 1–4, weighted as in those years. That makes it mostly the 2015–2020 cohorts and the Thai/Singaporean wave. (2) Replace "the high point of the relative MTB path" (§1, §5.4, letter Comment 3) with wording limited to those cohorts, e.g. "a local peak for the cohorts observed longest". (3) Optionally report the e = 0 change by wave, since the waves are already estimated. |
| S2-03, S2-18, C-07 | FAIL | MAJOR | **"Firm-years" and "missing" MTB counts include years before a firm lists.** Every firm has a row for each year 2014–2024; I checked all 3,709 firms. 36,168 = 3,288 × 11 counts rows from before a firm has any data, which contradicts "Firms enter the panel when they list" (§3.2 l.44). In the estimation sample, 3,644 rows have no data at all. They make up 3,341 of the 8,037 never-scored and 303 of the 943 scored "MTB missing" firm-years, i.e. 41.6% and 32.1%. These rows feed: the "28.0% / 12.7%" missingness (§3.2); Table S4's "Share missing" (0.248, and the "about a quarter" in §7 limitation 5); Table S11 (943 / 8,037 firm-years; mean calendar years 2017.2 and 2017.8); and §5.7 / letter Comment 6 "Only 21.5% … and 24.8% … have a market capitalization". **Recomputed on firm-years with any data:** MTB is missing for 18.5% (never-scored) and 9.0% (scored), 16.4% overall. Among those, 36.7% and 36.6% have a market capitalization. Mean years are 2019.1 and 2018.0. The qualitative conclusion holds: most gaps are missing market data (about 63%). The quantities answering Reviewer comment 6 are mislabelled, though, and Table S11 compares listed with not-yet-listed years. | Define firm-years as years with any data. Alternatively, report pre-listing rows as a separate category in Table S4, Table S11, §3.2, §5.7 and §7, and in the letter (Comment 6). Recompute the 28.0 / 12.7 / 21.5 / 24.8 percentages and "about a quarter" on listed firm-years, and state the 36,168 total with that definition. No estimate changes: cells already require observed outcomes. |
| S2-04, C-27, C-07 | FAIL | MINOR | **The run-up is described as covering five years and all scored firms.** Abstract: "over the five years before the first recorded score"; Conclusion l.352: "over the five years before entry". The statistic is 100·(e^{0.0949} − 1) from event year −5 to the base year −1, i.e. four annual changes. It also rests on the 6 cohorts (2019–2024, 497 firms; Table S6) that reach event year −5, not on all 675 firms implied by "on average their market-to-book ratio". | Write "from five years before the first recorded score to the year before it" (the wording §1 l.12 already uses). Optionally add "for cohorts observed five years earlier". |
| TF-04, TF-45, S2-73 | FAIL | MINOR | **Some estimate tables and one figure note lack the right N.** No firm count in Table S5 (bounds), Table S7 (18 specifications), Table S8 (bridge) or Table S10 (waves × datings). Tables 4, 5 and 7 give scored firms but not control firms. The Figure S2 note says "scored firms per event year in Table S6", but Table S6 counts only the baseline sample. Panel (b) (R10: 646 firms) and the trimmed or alternative-size series have different counts (r4_post.csv n_treated_firms). | Add a "Scored / control firms" column to S7, S8 and S10 (from r4_post.csv, s_waves_dating.csv and r4_twfe_bridge.csv), and control counts to Tables 4, 5 and 7 (s_*.csv n_control_firms). In Figure S2, cite Table S7 for counts, or give the R10 count. |
| C-18, S2-14, TF-53 | PASS with note | SUGGESTION | **Stale outputs.** outputs/ holds validation.csv and overlap/, which the runners do not write, and 120+ cache_saje/*.rds files from runs on 25–26 Oct. Timestamps show the folder was assembled piecemeal: numbers.csv and figures on 26 Oct, s_* and cohort_sizes on 27 Oct 08:39–08:40, and tableIA2 at 08:41 from a hand-run code block. My clean rerun reproduces every file byte for byte, so no number is stale. | Before the replication deposit, delete outputs/ and cache_saje/, run both runners once, and add validation/validate_estimator.R to the runner or the README. |
| S2-31, C-18 | PASS (independent re-implementation) / UNVERIFIED (package) | SUGGESTION | **Hand-written estimator.** The Callaway–Sant'Anna estimator in 02_cs_did.R and 03c_saje.R is written by hand. My Python re-implementation reproduces it exactly. Benchmarking against did::att_gt or DRDID was not possible: neither package is installed, and CRAN is unreachable ("package not available"; network blocked). | Run once: did::att_gt(est_method = "reg", control_group = "nevertreated", base_period = "universal", xformla = ~ size + size² + country + industry), and report the match in the replication README. |
| S2-54, S2-75 | PASS with note | SUGGESTION | **Doubly robust propensity fit.** `suppressWarnings(glm.fit(...))` hides separation warnings, and s_support_pscore.csv gives max_p = 0.99999998, so a few cells are (quasi-)separated. My Newton-Raphson logit also overflowed in some cells. The 0.99 cap applies to controls only, as stated, and the DR estimates still reproduce. | State in §5.6 or Table 5 note that some cells are near-separated, or report the count. |
| S2-17, C-09 | PASS with note | SUGGESTION | **Indicators absent from bootstrap resamples.** In cell_atts and cell_atts2, a country or industry indicator missing from a resample's controls gets a NA coefficient, which is set to 0. Appendix A.11 says this "does not occur", but checks point estimates only (s_na_coefficients.csv, 34 of 34 cells clean). | Count the affected cells per draw, or say the A.11 statement covers point estimates. |
| TF-44 | Note | SUGGESTION | **Equation rendering in the dossier PDFs.** In the LibreOffice PDFs, the conditioning bar of Eqs. (1)–(2) renders as "∨" (dossier 03_…Clean.pdf p.12). The docx OMML holds " | " and is correct in Word. | Never submit LibreOffice-rendered PDFs. Render through Word, or set the bar as a delimiter separator. |
| S2-12 | Note | SUGGESTION | **Rounded breakdown value.** §5.5: "any departure with M̄ above 0.01 admits a 5% increase"; rm_breakdown.csv gives 0.0121. | Write "about 0.01" or "0.012". |
| S2-45 | Note | SUGGESTION | **Only one placebo.** The only placebo is the fake date (R5), which fails and is discussed. There is no cross-unit placebo (random never-scored firms as fake treated) and no unaffected-outcome placebo. | Optional: add a permutation of whole treatment paths across never-scored firms (S2-70). |
| TF-53, TF-15 | Note | SUGGESTION | **Exhibit housekeeping.** Figure files are named FigIA1 and FigIA2 for Figures S1 and S2. Table S9 stacks three groupings (market, wave, calendar year) with no panel separators. | Rename the files to FigS1 and FigS2. Add panel headers to Table S9. |

### Rules checked and passed (evidence in brief)

- **Sample definition and coding (C-65–C-68, S2-84–S2-86).**
  - G is the first year with a non-missing ESG_Score.
  - 675 scored firms, 2,613 never-scored firms and 135 firms of the 2014 cohort, matching Table S2 cell by cell.
  - No duplicate firm-years. Country and industry are constant within each firm. No scored firm lacks base-year data. No scored firm loses its score before 2024, which supports §3.3. All firms have data in 2024, which supports the survivorship statement.
  - No variable depends on a regulation date.
  - Institutional dates I verified by WebSearch:
    - Bursa sustainability statement, FYE on or after 31 Dec 2016, phased in by market capitalisation to 2018.
    - SEC Philippines MC 4-2019: report attached to the 2019 annual report, comply-or-explain for 3 years.
    - Thai 56-1 One Report from FY ending 31 Dec 2021.
    - Bursa–LSEG MoU of 2 Nov 2022, under which FTSE Russell scores extend beyond the EMAS constituents (about 30% of listed companies).
    - OJK 51/2017: issuer reports from 2020 data, with COVID-19 extensions.
- **Design and inference.**
  - Outcome regression on never-scored controls with base period g−1 (Eq. 3–4), cohort weights (Eq. 5–6), and a firm bootstrap with 999 draws shared across specifications (except the separately seeded 50-cluster bootstrap, which the text treats separately).
  - Percentile CI with a normal-approximation p-value, Holm adjustment for secondary outcomes (recomputed: 0.134, 0.134, 0.053), Wald pre-trend test with χ²₄, MDE = 2.8·SE.
  - The relative-magnitude bound matches Eq. (10) and is disclosed as simplified (§7).
  - Wave contrasts use joint draws (diff_row).
  - Table 4 steps: C1 − B1 is an exact identity, given the linear outcome regression with the same firms and covariates. Row 6 equals R10 (−0.068470 in both).
  - Every "absent / not detected" claim in the body carries a 95% interval: Malaysian run-up −7.4% to 15.2%; waves −0.053 to 0.091 and −0.055 to 0.076; headline −0.046 to 0.048.
  - "accounts for most of the negative pooled mcap estimate": 0.441 × −0.146 = −0.064, against −0.055 pooled.
  - Table S8 "about half … most of the rest": 0.033 and 0.023 of the 0.062 gap.
- **Numbers.**
  - Every placeholder was checked against its generating line, including: mtb_runup_* (firm run-up), s_mtb_wMY_runup_m5 (Malaysian e = −5 interval), mtb_R10_pct and s_mtb_C3_declpct (both 6.6), mtb_reb_e3/e4 against R10 e2/e3 (correct shift), s_mtb_d_reference_C1_B1_share (62%), s_w_* weights (55.2 / 26.7 / 81.9 / 44.1 / 87.2), and s_mtb_ff / mcap ranges.
  - Abstract: 150 words.
- **Tables and figures.**
  - All table text is 9 pt, the same size throughout (TF-64 floor). Notes are 9 pt and at most 2 sentences / about 31 words (check_docx_style hits are "Eq." abbreviation splits).
  - SEs sit below coefficients. The star legend is in every table with stars. Estimator and SE type are named in the notes.
  - Figures: vector PDF and EPS plus 600-dpi PNG at 6.5 in. Fonts are embedded (pdffonts). Text is 9.5 pt at print size. Okabe-Ito colours plus marker shapes. No in-plot titles. Reference lines at 0 and −0.5. Exactly one script (06_figures_saje.R) writes each figure file.
- **Citations.**
  - Two-way match passes: 45 references, all cited. check_crossrefs.py hits are corporate-author parse artefacts and cross-document references between paper and supplement.
  - Verified by WebSearch:
    - Demiroglu & Ryngaert 4.86%.
    - Berg/Heeb/Kölbel −2.37% over one year, MSCI.
    - Sudsawasd & Sakdapat, SAJE 14(1) 257–287.
    - Nguyen (2025), SAJE 13(2) 67–98.
    - Prukumpai et al., SAJE 10(3) 227–257.
    - Bikmetova & Pirinsky: the DOI 10.1007/s10551-025-06063-0 resolves to a Springer JBE article.
- **Causal wording.** All 26 causal-word hits are negated, hedged or attributed to cited work (C-20, C-21).

### UNVERIFIED (reason)

- Tsang et al. (2025, CGIR 33(4)): the WebSearch did not surface the article, so its existence and the "dividend increases" claim are unverified (WebFetch and curl blocked).
- Nguyen (2025): the abstract describes CSR disclosure in 87 Vietnamese consumer-goods firms. The specific signs the manuscript attributes (foreign higher; state and family lower) could not be confirmed without the full text.
- LSEG (2023) point-in-time user guide URL; Bernama article id 2134522: not fetched (network).
- Benchmark against did::att_gt or DRDID: packages unavailable offline (see above).
- Claim-level support for the remaining literature citations (Hawn, Durand, Kelly & Ljungqvist, Chen et al., and others) was not rechecked this round.

COUNTS: CRITICAL 0, MAJOR 2, MINOR 2, SUGGESTION 8

REMAINING CRITICAL/MAJOR: C-07/S2-02 ("high point" and "event-year-0 change, 0.044" in §1, §5.4 and letter Comment 3); S2-03/S2-18 (pre-listing rows counted as firm-years and as missing MTB: §3.2, §5.7, §7, Tables S4 and S11, letter Comment 6)

rules checked: core 50/50; seat2-methods-integrity 80/80 (IV, RDD, SCM, GMM, time-series, asset-pricing and survey rules judged N/A); tables-figures 57/57
