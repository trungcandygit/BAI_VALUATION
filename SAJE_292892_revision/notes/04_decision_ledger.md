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
