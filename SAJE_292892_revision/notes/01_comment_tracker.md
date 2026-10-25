# SAJE manuscript 292892: comment tracker (Phase A/B, paper-revision-master O-04, O-07, S1-40)

Decision letter: Vasileios Zikos, Editor in Chief, Southeast Asian Journal of Economics, 24 October 2026. Decision:
major revision, 45 days, changes highlighted in blue, separate responses to editor and referee.
Source manuscript (round 0): `submission/AAMJAF_submission/02_Manuscript_Anonymized.docx` of `trungcandygit/B-i-ESG2`
(built from `manuscript/manuscript.md` + `manuscript/aamjaf.md`, commit "AAMJAF submission folder as a single zip",
2026-10-12). Section, table and p-value references in the report (3.2, 4.2, 5.3, 5.4, 5.6, 7; Table 3 R5, R10;
p = 0.074; 24.6%) match this file.

User authorisation (verbatim, 2026-10-25): "tự động hoá mạnh nhất, đầy đủ theo quy trình của skill ... KHÔNG CẦN TÔI
CAN THIỆP VÌ TÔI ĐI NGỦ" and "Không hỏi lại". Recorded as the user's decision to accept all checkpoint defaults
(core C-40 "accept all remaining"; orchestrator O-59: this ledger records, it does not create, the decision).
Integrity gates are not covered by the authorisation and still run (O-38).

| ID | Verbatim (short) | Type / category / severity | Strategy | Change (where) | Evidence | Status |
|---|---|---|---|---|---|---|
| E1 | "make its contribution clearer ... simple economic intuitions ... cite [SAJE] papers" | editorial / clarity / major | accept | Introduction rewritten around one question and a plain intuition; contribution paragraph; three SAJE papers cited where relevant (Nguyen 2025; Sudsawasd & Sakdapat 2026; Prukumpai et al. 2022) | references verified by search, URLs in 02_verification_log.md | done |
| E2 | "abstract ... about 150 words or less ... last line ... forward-looking" | editorial / clarity / major | accept | new abstract, no test statistics, forward-looking last sentence | word count by script | done |
| E3a | "title page ... acknowledgements footnote" | editorial / compliance / minor | accept | title page footnote | title page file | done |
| E3b | "references up-to-date ... remove very old unpublished working papers and/or obscure journals" | editorial / evidence / minor | accept + explain | all references checked; two working papers kept (no journal version found, Oct 2026) and explained; no reference older than Merton (1987) that is unpublished | 02_verification_log.md | done |
| E4 | "professional editorial service" | editorial / compliance / minor | accept (author action) | full language pass by us; professional edit of the revised text is an author action | AUTHOR_INPUT_NEEDED: name of the service and date | needs author |
| E5 | "disclose any use of such tools on the title page" | editorial / compliance / blocking | accept, disclose truthfully | AI-use statement on the title page | earlier statement (meta/aamjaf) lists AI use beyond language editing; journal limits use to language | needs author decision (see hand-off) |
| R1.1 | first recorded year vs publicly observable coverage; archived dates; reflect in abstract and conclusion | major / evidence_gap+clarity / blocking | clarify + experiment (bounds) | event renamed "first recorded score"; new Section 3.3 on what the record can and cannot date; estimates for record year, +1 and +2 reported side by side; abstract, conclusion rewritten | Table 3 (new), s_r10_decomposition.csv | done |
| R1.2a | p = 0.074 is not support for parallel trends; individual years; market cap | major / incorrect_premise? no, valid / blocking | concede | text states pooled design fails the pre-trend diagnostics; post-coverage numbers labelled conditional | Sections 5.3, 6.1 | done |
| R1.2b | placebo R5 reinforces difficulty | major / valid | concede | text | Section 5.5 | done |
| R1.2c | explain why conditional PT might hold after base year | major / clarity | clarify (argue both sides) | new paragraph: when PT after g-1 is plausible (Malaysian wave with flat pre-path; size match; R8) and when it is not (reversal) | Section 4.4/6.1 | done |
| R1.2d | distinguish observed evolution from causal effect; emphasise descriptive selection | major / scope | accept | reframing throughout; Table 2 relabelled | Sections 1, 5, 8 | done |
| R1.3a | baseline 0.002 vs R10 -0.068 | major / evidence_gap | experiment | decomposition on a common sample: window, reference period, covariate timing, sample | new Table 4, s_r10_decomposition.csv | done |
| R1.3b | which treatment definition is most defensible; baseline should not get more weight because pre-specified | major / valid | accept | both datings reported as co-equal estimands with a stated reading | Section 5.4 | done |
| R1.4a | common support; OR relies on functional form | major / evidence_gap | experiment | size-range restriction promoted to main text; DR estimator on the restricted support; propensity overlap | Table 5, s_support*.csv | done |
| R1.4b | characteristics of retained and excluded firms | major / evidence_gap | experiment | retained vs excluded table | Table 5 panel B | done |
| R1.4c | sensitivity to size adjustment | major / evidence_gap | experiment | none, linear, quadratic, cubic, quintiles, size at g-3, trims 90/95/99 | Table 5 panel A | done |
| R1.5a | mechanisms not observed | major / scope | clarify + narrow claims | Section 2 separates motivating from testable; Section 6 rewritten | Sections 2.4, 6.2 | done |
| R1.5b | high/low score test: power and size correlation | major / valid | concede | Section 5.6 rewritten, no "tests the preference channel" claim | Section 5.6 | done |
| R1.6a | missing MTB may be systematic; compare firms with and without MTB | major / evidence_gap | experiment + correct text | source of missingness corrected (no MTB <= 0 in the data); comparison table; selection checks | Table 6, s_missing_*.csv | done |
| R1.6b | implausible market capitalization: how identified, robustness | major / evidence_gap | experiment | internal-consistency flag (implied book equity > total assets); exclusion and market-year winsorisation | Table 6 panel C, s_flag_summary.csv, s_outliers.csv | done |
| R1.7 | uneven markets; what pooled estimate represents | major / clarity | clarify + experiment | weight shares by market, wave and year; interpretive paragraph | Section 5.3/5.7, s_weights.csv | done |
| R1.8 | reframe contribution: selection central; valuation effect not identified; implications | major / scope | accept | title kept; abstract, introduction, discussion, implications and conclusion reframed | Sections 1, 6, 7, 8 | done |
