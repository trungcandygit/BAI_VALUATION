# Decision ledger: SAJE revision R1 (manuscript 292892)

Records decisions; it does not create them (orchestrator O-59). User words are quoted verbatim.

## Authorisation and scope
- U-1 (2026-10-25, user): "tự động hoá mạnh nhất, đầy đủ theo quy trình của skill ... Spawn tối đa 2 agent ... force load
  các card ... KHÔNG CẦN TÔI CAN THIỆP VÌ TÔI ĐI NGỦ" and "Không hỏi lại". Read as: accept the default at every
  checkpoint (C-40 "accept all remaining"); integrity gates still run and blocking items are reported, not decided.
- U-2 (user): "tạp chí AAA kia từ chối rồi ... giờ submit tạp chí của thái major revision" and sample-format PDF
  supplied. Target: Southeast Asian Journal of Economics; layout follows the sample (tables in text, Times New Roman).
- U-3 (user): "BẠN ĐỪNG SỬA XOÁ GÌ SKILL CỦA TÔI". Skill files are copied into ~/.claude/skills of this container and
  never edited; compression-check notes (C-70) are written here, not into VALIDATION.md.
- U-4 (user email draft): Ha Hong Hanh (NEU, hanhhh@neu.edu.vn) first author; Nguyen Van Trung second and
  corresponding. Applied to the title page and the letter signature.

## Source and workspace
- D-1 Round-0 source = submission/AAMJAF_submission/02_Manuscript_Anonymized.docx of trungcandygit/B-i-ESG2 (body
  from manuscript/manuscript.md). The source repository is read-only for this revision; all work is in
  BAI_VALUATION/SAJE_292892_revision on branch claude/push-directory-git-x126dz (session instruction).
- D-2 Licensed data are not copied into the workspace or committed; the R code reads them through a symlink that is
  git-ignored.
- D-3 Reproduction: run_all.R rerun in the workspace; outputs diffed against outputs_submitted (see 05_reproduction.md).

## Analysis decisions (all exploratory, labelled so in the paper)
- D-4 R10 decomposition on a common sample (firms with the outcome at g-1 and g); steps: sample, window, reference
  year, size timing, sample. Identity check: A0 reproduces the headline (0.002) and C3 reproduces R10 (-0.068).
- D-5 Recording-error flag: implied book equity (market cap / MTB) above ten times total assets. Threshold chosen
  after inspecting the ratio distribution (99th percentile 7.4; ratios 1-2 plausibly timing): 1,779 firm-years exceed
  1 (mostly Malaysian, judged definitional), 211 exceed 10. Looser threshold (2) reported as a check.
- D-6 Doubly robust estimator run only inside the 95th and 90th percentile size support, logit propensity on the
  baseline covariates, odds weights capped at p = 0.99.
- D-7 Main-text tables limited to seven: Table 4 decomposition, Table 5 size/support, Table 6 retained vs excluded,
  Table 7 missing-data and error checks; missing-MTB comparison to Table S11, weights to S9, wave datings to S10.

## Text decisions
- D-8 Event renamed "first recorded score"; new Section 3.3; both datings reported as co-equal estimands.
- D-9 Pre-registered hypotheses H1-H3 kept verbatim except the H3 sentence that overclaimed what the test separates.
- D-10 Sentence "We set MTB ratios at or below zero ... to missing" removed: the source has no MTB <= 0 (finding from
  the data; the original sentence misdescribed the cause of missingness).
- D-11 SAJE citations: Nguyen (2025), Sudsawasd & Sakdapat (2026), Prukumpai et al. (2022); each placed where it bears
  on the argument (S1-20). Crump et al. (2009) added for limited overlap. All verified by web search, 2026-10-25.
- D-12 Two working papers kept (Berg et al. 2020; Berg, Heeb & Kölbel 2022): no journal version found by search.

## Items for the authors (not decided here)
- A-1 E4: name of the professional editorial service for the revised text (AUTHOR_INPUT_NEEDED in the letter).
- A-2 E5: the truthful AI-use statement describes use beyond language editing (research-question screening, pre-analysis
  plan, R code, revision analyses and text). The journal limits AI use to language and readability. The authors must
  decide how to proceed; the statement must not be weakened into something untrue.
- A-3 Companion study: the round-0 package omitted the companion-study disclosure (earlier author decision D-30 of the
  source repository). Not re-added; the authors should reconsider, since journals expect disclosure of shared data.
- A-4 The source repository B-i-ESG2 is public and contains the licensed data file, which conflicts with the data
  availability statement.
- A-5 Authorship change form and CRediT wording for Ha Hong Hanh to be confirmed by both authors.

## Round-1 panel fixes (2026-10-26)
- D-R1-01: Pooled 10.0% run-up now attributed to all scored firms (abstract, conclusion, introduction contribution, implications). Malaysian wave reported as "not detected" with its 95% interval (new keys s_mtb_wMY_runup_m5[_lo,_hi] from r4_event_profiles.csv, e = −5, transformed as in 03b).
- D-R1-02: Section 5.4 and letter: the reference step is described as an accounting identity (event-year-0 change of the same firm-cells, weighted by event years 1–4), not as a separately estimated rise; order dependence of the sequential decomposition stated.
- D-R1-03: Table 3 gains a scored/control firm column (ln(MTB)); Tables 4, 5, 7 header renamed "Scored firms in averaged event years"; Table 2/3 notes say counts cover all event-time cells (628 vs 625 explained by definition).
- D-R1-04: Market-capitalization range split into functional forms and restricted supports (new keys s_mcap_ff_*, s_mcap_sup_*).
- D-R1-05: Flag counts by ratio band reported (new columns ratio_1_2, ratio_2_10; keys s_flag_All_r12, _r210, _n2).
- D-R1-06: run_win cache key now includes md5 of setup/data/estimator files, a panel signature and the deparsed estimator functions; stale outputs/run_log.txt removed; NA-coefficient cells counted in s_na_coefficients.csv.
- D-R1-07: Notes ≤30 words, name firm bootstrap and estimator; one table font size (9 pt); figure base_size 11.5; S-table titles use "first recorded" and "change".
- D-R1-08 (user decision, 2026-10-26, verbatim): "việc khai dùng chung data với bài khác thì không cần, vì bài khác tôi chưa submit. bài này có lẽ là bài được đăng trước thì cần gì khai". The companion-study / shared-data disclosure item is closed: no disclosure is added to the title page or letter.
- D-R1-09 (user instruction, 2026-10-26): "nhớ các hình vẽ lại mạnh nhất theo chuẩn skill". New R/06_figures_saje.R redraws Figures 1, 2, S1, S2 under tables-figures TF-35 to TF-50: theme_classic without gridlines, Liberation Sans (Arial metrics) at ≥9.5 pt at 6.5 in, solid interval bars (no dotted lines), shape + Okabe-Ito colour per group, panel letters, no in-plot title, cairo PDF (embedded fonts) + EPS + 600-dpi PNG; y axis "Change relative to event year −1" (no causal "effect").

## Round-2 panel merge (2026-10-27)
Seat 1: CRITICAL 1 (AI policy, author decision), MAJOR 3, MINOR 22, SUGGESTION 8. Seat 2: CRITICAL 0, MAJOR 1, MINOR 15, SUGGESTION 4.
Fixed: blue marking now computed purely by sentence diff against round 0 (check_blue.py: 0 new sentences unmarked); Malaysian "flat" pre-trend replaced by "no detectable run-up" with interval and exploratory caveat; OJK date worded as original schedule with pandemic relief; survivorship to 2024 disclosed (3.2, 3.3, Section 7, letter); wave differences tested with joint firm-bootstrap draws (new s_wave_contrasts.csv; Section 5.4, letter); DR propensity cap 0.99 disclosed; M-bar breakdown (0.01) restored; SEs below coefficients in all tables; notes name counted outcome; figure notes give N; one script (06) owns every figure file; Table S2 header; terminology; references (LSEG 2023 dated, Nguyen 2025 claim); letters (Appendix A, new references, acknowledgement location, median clause); investor implications paragraph; intro roadmap removed; keywords lower case.
Declined with reason: dense-decimal paragraphs (results sections need their numbers; exhibits carry the rest); Table 1 SD (optional); renumbering supplement exhibits by first mention (optional; would desynchronise the letter); did::att_gt cross-check (package not installable offline; estimator validated against manual lm()).
Still author decisions: AI-use policy (E5), editorial service (E4), LSEG PIT data access, authorship change form, how the firm list was drawn (survivorship; AUTHOR_INPUT_NEEDED in notes only).
- D-R3-01 (user, 2026-10-30): "tối đa 6 round mạnh nhất chuẩn skill, tới khi hoàn thiện thì thôi"; notes 1–2 sentences; never mention a table or figure before it appears; figures must not sit in Section 1.
