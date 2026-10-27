# Panel round 2, Seat 1 (referee + editor): SAJE 292892, major revision R1

Loaded:
- `/root/.claude/skills/paper-revision-master/SKILL.md`: 133 lines (no sentinel; skill entry file)
- `/root/.claude/skills/paper-revision-master/references/cards/core.md`: 87 lines, `<!-- CARD-END core v2 -->`
- `/root/.claude/skills/paper-revision-master/references/cards/seat1-referee-editor.md`: 153 lines, `<!-- CARD-END seat1 v1 -->`
- Skills invoked first: `academic-pipeline`, then `paper-revision-master`.

Date of review: 2026-10-26. Scratch work: `/tmp/claude-0/panel_r2_seat1/`.

## What I checked, and how

- Read in full: the revised manuscript (`manuscript_REVISED_clean.txt`, 280 lines; the `_marked.txt` dump is byte-identical, so I took the blue marking from the docx XML), the original manuscript, the revised and original supplement, the title page, both response letters, the verbatim editor letter and the verbatim Reviewer A report.
- Rendered and looked at every page of all seven deliverable PDFs: manuscript marked (32 pp.), manuscript clean (32), supplement marked (10), supplement clean (10, checked through the docx colour audit plus the marked render), title page (2), response to editor (7) and response to Reviewer A (14). I also rendered all 34 pages of the SAJE sample PDF.
- Blue-marking audit:
  - The script `scripts/bluecheck2.py` reads every run colour in `02_Manuscript_Revised_Marked_blue.docx` and `04_Supplementary_Material_Marked_blue.docx`.
  - It compares each sentence against the original text.
  - Output is in `blue_ms.txt`.
- Ran the skill's checks on copies: `check_docx_style.py` (on the manuscript, supplement and both letters) and `check_crossrefs.py` (on the manuscript).
- Recomputed the arithmetic for every number I quote (Table S2 sums, S9 weights, S11 shares, log-to-percent conversions, Holm ordering, the Table 4 step differences).
- Network: only WebSearch works. WebFetch to ojk.go.id failed (ENOTFOUND), so primary PDFs could not be opened. Where a check rests on search snippets alone, I say so.
- Not run: the R code is not in the dossier, so I did not re-run the analysis. Number-to-output reproduction belongs to Seat 2, and every number that depends on unrounded output is listed as UNVERIFIED below.

## Findings (CRITICAL first)

| # | Rule ID | Verdict | Severity | Evidence (quote, file:line) | Fix |
|---|---|---|---|---|---|
| 1 | C-17, S1-17, C-50 | FAIL | CRITICAL | **The disclosed AI use conflicts with the journal's AI policy.**<br>The editor letter (`editor_decision_letter_verbatim.txt:34`) says AI tools "should be limited to improving the language and readability… must not be used to generate core content such as scientific insights, conclusions, or policy recommendations."<br>The title page (`title_page_REVISED.txt:8`) discloses use to "screen candidate research questions, draft the pre-analysis plan, write and check the R code… carry out the additional analyses requested in the review, draft the revised text, and draft the response letter."<br>The revised text includes the conclusions and the policy implications (Sections 6.4 and 8).<br>The disclosure is honest, and the letter says so (`response_to_editor.txt:26`). As disclosed, though, the use falls outside what the policy allows, which risks rejection regardless of the paper's merit. | The authors must decide this; wording cannot fix it. Options: (a) confirm, and state truthfully, that research questions, interpretation, conclusions and policy text were written or rewritten by the authors (this is the open `AUTHOR_INPUT_NEEDED` in E5); or (b) ask the editor beforehand whether the disclosed use is acceptable. Do not submit with the policy conflict unaddressed. |
| 2 | S1-24, C-16, C-50 (editor instruction) | FAIL | MAJOR | **The blue marking misses new text, and both letters claim it is complete.**<br>The editor asked: "Any changes made should be clearly highlighted in blue" (`editor_decision_letter_verbatim.txt:7`).<br>Both letters claim "every sentence that is new or differs from the submitted version is highlighted in blue" (`response_to_editor.txt:6`, `response_to_reviewer_A.txt:4`).<br>The docx audit finds 39 changed or new sentences with 0% blue and 81 that are not fully blue. Wholly new sentences printed in black (rendered marked PDF) include:<br>- the editor-requested forward-looking last line of the abstract, "Research and investment screens that compare rated with unrated firms should model who gets rated and when." (p. 1; docx run with no colour)<br>- "The paper asks how far the data can separate…" (ms:9, p. 2)<br>- "Third, it warns that comparisons…" (ms:22)<br>- "We return to this distinction in Section 6.3." (ms:38)<br>- "For our question the difference matters…" (ms:48)<br>- "We report the valuation path with coverage dated at g, at g + 1, and at g + 2…" (ms:50; the letter quotes this sentence as new)<br>- "We therefore treat the post-coverage estimates as conditional…" (ms:71; the letter quotes this as "The paragraph ends")<br>- "The steps are sequential…" (ms:140)<br>- "Where no run-up was detected…" (ms:155)<br>- "The MTB result therefore does not depend…" (ms:161)<br>- "Among scored firms, the 50 firms…" (ms:195)<br>- "None of these checks produces an MTB gain." (ms:196)<br>- "This finding does not rest on assumption (2)…" (ms:219)<br>- "One of many exploratory subgroups…" (ms:221)<br>- "Studies of ESG ratings in Southeast Asia should model…" (ms:227)<br>- most of the Conclusion (ms:233–234)<br>- the new references Crump et al. (2009) and the Nguyen (2025) and Sudsawasd & Sakdapat (2026) journal lines.<br>The pattern is systematic: the last sentence of a paragraph is merged into an uncoloured space run (see the docx XML around "Research and investment screens").<br>There is also over-marking: 68 unchanged sentences (mostly reference titles) are blue, which makes the marking unreliable in both directions. The supplement has the same defect on a smaller scale (e.g. A.11 "This does not occur: in all 34 cells…", 0% blue). | Rebuild the marked files: colour whole new or changed sentences, including each paragraph's final sentence, and do not colour unchanged references. Then re-run the sentence-level diff and reach 0 new-but-black sentences. Until then, the two letters' "every sentence" claim is false and must not go out. |
| 3 | C-25, C-08, S1-53, S1-38 | FAIL | MAJOR | **A non-rejected pre-trend test is used as evidence that the Malaysian wave is flat, which is the inference Reviewer A objected to.**<br>Section 4.1 defends assumption (2) with "in the large Malaysian wave the pre-coverage path is flat, so for these firms the assumption asks only that a flat relative path stays flat" (ms:71).<br>The letter repeats it: "the pre-coverage path is flat (joint pre-trend p = 0.549)" (`response_to_reviewer_A.txt:24`).<br>But Section 5.2 reports a run-up of 2.8% (95% interval −7.4% to 15.2%) and says "a run-up of the pooled size cannot be ruled out for this wave" (ms:134).<br>Reviewer A, comment 2, warned that a non-rejection "should not be interpreted as evidence supporting parallel trends" (`reviewer_A_report_verbatim.txt:21`).<br>The wave split is also post hoc ("we drew the wave boundaries after seeing the coverage counts… exploratory", ms:134). Yet ms:71 says the paper gives "most weight" to "the contrast between waves with and without a run-up." | Rewrite ms:71 and the letter at line 24 along these lines: "in the Malaysian wave no run-up is detected (2.8%, 95% interval −7.4% to 15.2%), so for these firms the assumption is less strained, although a run-up of the pooled size cannot be ruled out." In the same place, state that the wave contrast is exploratory. |
| 4 | S1-106, C-65 | FAIL (provisional) | MAJOR | **The Indonesian effective date looks wrong.**<br>The manuscript says: "A 2017 Indonesian regulation applies to listed companies other than small- and medium-asset issuers from 2020 (Otoritas Jasa Keuangan, 2017)" (ms:41).<br>OJK's own summary of SEOJK 4/SEOJK.04/2022 (an amendment of SEOJK 20/SEOJK.04/2021, the COVID relief circular) says that for issuers other than small- and medium-asset issuers, first-time preparation of the sustainability report was postponed to the reporting period 1 January to 31 December 2021, with first submission by 31 May 2022 instead of 30 April 2021. Sources (searched 2026-10-26):<br>- https://www.ojk.go.id/id/regulasi/Documents/Pages/Perubahan-Atas-Surat-Edaran-Otoritas-Jasa-Keuangan-Nomor-20-SEOJK-04-2021/RINGKASAN%20SEOJK%204%20-%2004%20-%202022.pdf<br>- https://www.ojk.go.id/id/regulasi/Documents/Pages/Perubahan-Atas-Surat-Edaran-Otoritas-Jasa-Keuangan-Nomor-20-SEOJK-04-2021/SEOJK%204%20-%2004%20-%202022.pdf<br>These come from search snippets; the PDF fetch was blocked.<br>No variable is coded from this date, so the headline does not depend on it. | Verify against the OJK PDF. Then write: "…applies… from the 2020 reporting year (Otoritas Jasa Keuangan, 2017), postponed to the 2021 reporting year by OJK's COVID-19 relief (SEOJK 4/SEOJK.04/2022)", and add that reference. |
| 5 | S1-39 | FAIL | MINOR | Both letters list "New material: … Tables S9 to S11 and Appendix B.8 to B.10 in the supplementary material" (`response_to_editor.txt:42`, `response_to_reviewer_A.txt:87`). The revised supplement has Appendix A.8 to A.10; Appendix B no longer exists (supp:4, 19–24). | Change to "Appendix A.8 to A.10". |
| 6 | S1-35, C-06 | FAIL | MINOR | **A letter claim outruns its evidence, and a comparison is mislabelled.**<br>- The letter says the 50 scored firms that do not enter the MTB estimate have similar median assets, "so the missing ratios do not remove the largest or smallest scored firms" (`response_to_reviewer_A.txt:59`). Similar medians do not show that the extremes are retained.<br>- In ms:195, "(280.3 against 294.3 million)": 294.3 is the Table 1 median for all 655 scored firms (ms:67), not for "those that do" enter (625). | Delete the "so…" clause in the letter, or show the size distribution. Recompute the comparator for the 625 included firms, or relabel it as "all scored firms". |
| 7 | C-03, S1-35 | FAIL | MINOR | E3 reply: "The new references are Crump et al. (2009)… and the three papers from this journal" (`response_to_editor.txt:20`). LSEG (n.d.), the point-in-time user guide (ms:260), is also new; it is not in the original references (`manuscript_ORIGINAL.txt:123–163`). | Add LSEG (n.d.) to the list of new references. |
| 8 | S1-88, S1-69 (terminology) | FAIL | MINOR | The letter says the event "is now called the first recorded score throughout" (`response_to_reviewer_A.txt:14`). Leftovers:<br>- "cohort median of their first ESG score" (ms:213)<br>- Table S2 column "First score year" (supp:38)<br>- a three-way mix of "first recorded score year", "first recorded year" and "first-recorded-year estimate" (ms:46, 138–155). | Use "first recorded score" and "first recorded score year" uniformly; rename the Table S2 header. |
| 9 | S1-73, S1-88 | FAIL | MINOR | Section 3.4 calls the ratio-above-two rule "A stricter rule" (ms:54). Section 5.7 calls the same rule "a looser flag at twice total assets" (ms:196). | Pick one wording (e.g. "a lower threshold, twice total assets, which flags 749 firm-years"). |
| 10 | S1-75 | FAIL | MINOR | "With M̄ = 0.25, the interval for the MTB effect is −0.071 to 0.073, and any departure at all admits a positive effect" (ms:159). The unadjusted interval (M̄ = 0, [−0.046, 0.048]) already admits a positive effect, so the clause is wrong as written. It is left over from an original sentence about a 5% increase (`manuscript_ORIGINAL.txt:95`). | Delete the clause, or restore the original meaning ("any departure with M̄ above about 0.01 admits a 5% increase"). |
| 11 | S1-54, C-27 (pooled vs subgroup) | FAIL | MINOR | The Conclusion says "The run-up was concentrated in the Thai and Singaporean wave of 2019 and 2020" (ms:233). But the remaining 278 firms also had a run-up (pre-trend p = 0.006, Table S7, supp:119), and Section 5.4 treats them as a run-up group ("−0.111 for the remaining cohorts", ms:155; the letter at line 34 says "both of which had a run-up"). | Write "was largest in the Thai and Singaporean wave… and not detected in the broad Malaysian wave". |
| 12 | C-25 | FAIL | MINOR | Null statements with no interval nearby:<br>- "the data show no detected effect of coverage" (ms:221)<br>- "we detect none under assumption (2)" (ms:223)<br>- "we detect no MTB gain within it" (the Malaysian wave, ms:229). Its interval (−0.053 to 0.091, ms:155) admits gains of about 9%, larger than the pooled upper bound of 4.9%. | Attach the interval at first use in each section, especially for the Malaysian wave in 6.4. |
| 13 | C-23, S1-53 | FAIL | MINOR | The introduction calls the TWFE 6.6% "an artifact of comparing firms after entry with the same firms before their growth" (ms:21). Table S8 (supp:129–132) and ms:211 attribute only about half of the gap to the cohort-own-base-year comparison; most of the rest comes from conditioning on base-year size. | Write "largely an artifact of pooling pre-entry growth years and of not conditioning on size (Table S8)". |
| 14 | S1-54 (consistency of attribution) | FAIL | MINOR | The negative pooled market-cap estimate gets three different explanations:<br>- "market capitalization fell in the Malaysian wave… which accounts for the negative pooled market capitalization estimate" (ms:134)<br>- "part of the negative market capitalization estimate comes from firm-years that drop out of the MTB sample" (ms:196)<br>- "the negative market capitalization change depends on how size is modeled" (ms:177). | Replace "accounts for" with "is concentrated in", and cross-refer to 5.6 and 5.7. |
| 15 | S1-113, S1-73 | FAIL | MINOR | Table 2 reports Holm-adjusted p = 0.053 for ln(assets) (ms:93), while Table 3 shows the same cell as 0.044** (ms:111). Table 3's note (ms:126) no longer says the stars are unadjusted; the original did (`manuscript_ORIGINAL.txt:211`). Tables S3 and S7 lost the word too (supp:62, 125). | Restore "(unadjusted)" in the notes to Table 3, S3 and S7. |
| 16 | S1-79, S1-68 | FAIL | MINOR | In Eqs. (1) and (2), the conditioning bar renders as a slash: "E[Y_{i,t}(g) − Y_{i,t}(∞) / G_i = g]" (clean PDF p. 11). It reads as division. | Use "∣" in the equation editor. |
| 17 | S1-79, S1-70 | FAIL | MINOR | Table 2 is placed between Eq. (8) and its continuation "where θ̂pre stacks…" (PDF p. 14; ms:87–96). It breaks the sentence that defines the equation. | Move Table 2 after the "where…" paragraph. |
| 18 | S1-71, S1-73 | FAIL | MINOR | A sentence begins with a numeral: "28.0% of never-scored and 12.7% of scored firm-years lack a log MTB ratio" (ms:46). | Rewrite as "Log MTB ratios are missing for 28.0%…". |
| 19 | S1-61, C-28 | FAIL | MINOR | "minimum detectable differences of 0.113 and 0.111, about 11.9% in the MTB ratio" (ms:213; the letter repeats it at line 52). The two convert to 12.0% and 11.7%; one rounded figure for both is imprecise. | Write "about 12%". |
| 20 | S1-75, S1-93 | FAIL | MINOR | "their market-to-book ratio had grown 10.0% faster than that of similar firms" (abstract, ms:3; Conclusion, ms:233). The 10.0% is cumulative relative growth over five years (ms:12, "grew… 10.0% more"); "faster" can be read as a higher growth rate. | Use "had grown 10.0% more than that of similar firms over the five years before" in both places. |
| 21 | S1-60, C-06 | FAIL | MINOR | Nguyen (2025) is cited to support "Who discloses also depends on who owns the firm" (ms:32). The paper measures CSR scores on a KLD scale for 87 Vietnamese consumer-goods firms, 2017–2019 (https://so05.tci-thaijo.org/index.php/saje/article/view/269458, searched 2026-10-26), not disclosure. | Write "Ownership also shapes CSR performance: among…". |
| 22 | S1-78 | FAIL | MINOR | Reference details:<br>- LSEG (n.d.): the user guide is dated (Document v2, June 2023, per a search of developers.lseg.com, 2026-10-26).<br>- Bursa Malaysia (2015) cites the *Sustainability Reporting Guide*, not the Listing Requirements amendments that set the dates, and has no URL (ms:243).<br>The E3 claim that "all… have complete details" is therefore not fully true for these grey-literature entries. | Use LSEG (2023). Cite the Bursa Main Market Listing Requirements amendment (Oct 2015, Practice Note 9 / para 9.45) with a URL. |
| 23 | S1-37, C-07 (consistency with the prior version) | FAIL | MINOR | The original supplement B.4 said the 95th-percentile restriction "keeps 492 scored firms and gives −0.021 (p = 0.426; pre-trend p = 0.212)" (`supplement_ORIGINAL.txt`, B.4). The revised Tables 5 and 6 give 487 firms with the identical estimate (ms:161, 171, 180). Nothing explains the change; it may be a different count definition ("in averaged event years"). | Confirm with Seat 2. If it is a definition change, say so in the Table 5 note. |
| 24 | S1-61 (script check 8) | FAIL | MINOR | `check_docx_style.py` flags 10 results paragraphs with more than 6 decimals (7 to 11 each), e.g. ms:177 (11), ms:155 (9), ms:196 (9), ms:213 (9). | Keep the headline number and interval in each paragraph and leave the rest to the exhibit. |
| 25 | C-50, S1-43 (journal fit, length) | FAIL | MINOR | Body text is about 7,100 words without tables, notes and references (about 9,900 including the abstract and 7 tables), against guidance of about 5,000–7,000. The letter says results were moved "to keep the paper within the journal's usual length" (`response_to_editor.txt:6`). The original body was about 6,960 words. | Trim about 300–800 words; repeated statements of the 0.002 interval and the −6.6% figure are the easiest cuts. Or drop the length claim from the letter. |
| 26 | C-17, S1-41 | FAIL | MINOR | The data availability statement says code "will be deposited in a public repository with a DOI before final acceptance, as the journal requires" (title_page:14). Both letters say "the R code that produces them is part of the replication package" (`response_to_editor.txt:42`). I could not verify the journal requirement; the SAJE sample instead gives a live Dataverse DOI (sample PDF p. 27). | Make the two statements agree (deposited now vs. later). Delete "as the journal requires" unless it is sourced. |
| 27 | S1-31, S1-73 | FAIL | SUGGESTION | The Response to the Editor shows the heading "Response to the Editor" twice (PDF p. 1). Headings are in a sans-serif font and the body in serif. | Remove the duplicate heading and use one font. |
| 28 | S1-70 | FAIL | SUGGESTION | The Figure 1 "Source:" line is orphaned at the top of p. 4, away from the figure (marked PDF p. 3–4). | Keep the figure, note and source together. |
| 29 | C-50 (sample format) | FAIL | SUGGESTION | The keywords are capitalised ("ESG ratings, Firm valuation, …", ms:4); the SAJE sample uses lower case ("renewable energy consumption, foreign direct investment, …", sample p. 2). The sample shows no JEL line; JEL is harmless. | Follow the sample's lower-case style. |
| 30 | S1-60 (script check 9) | FAIL | SUGGESTION | Empirical papers cited only in the review never return when the findings are read: Hartzmark & Sussman (2019), Shanaev & Ghimire (2022), Kelly & Ljungqvist (2012), Krueger et al. (2024), Avramov et al. (2022), Gibson Brandon et al. (2021), Christensen et al. (2022). | In 6.3, set the null against one or two of the closest estimates (e.g. Kelly & Ljungqvist's coverage-loss effect). |
| 31 | S1-84 | FAIL | SUGGESTION | Wh-cleft openers recur in the new text: "What the data can evaluate is narrower" (ms:38), "What the datings share is" (ms:156), "What the data evaluate directly is" (ms:223). | Vary the constructions. |
| 32 | S1-34, S1-50 (A8 coverage depth) | PARTIAL | SUGGESTION | Reviewer A comment 8 asks to reconsider implications "for investors, rating providers, and regulators" (`reviewer_A_report_verbatim.txt:79`). Section 6.4 has paragraphs for researchers, for providers and data users, and for exchanges, regulators and firms, but no investor paragraph; investors appear only in "research and investment screens" (abstract, ms:234). | Add one sentence for investors to 6.4 (for example, screens that start from the scored universe inherit its pre-entry growth tilt). |
| 33 | S1-75, C-26 | FAIL | SUGGESTION | "Publication therefore follows the end of fiscal year g, so the first recorded score dates entry too early, never too late" (ms:49). "Never" is absolute. Provider rewriting (Berg et al., 2020) could in principle also drop or re-date an earlier first score. | Write "can date entry too early but, if no earlier scores were deleted, not too late". |
| 34 | C-50 (E3 location) | — | SUGGESTION | The editor asked for the acknowledgement footnote on "the title page or cover page of the main document" (editor:30). It is on the separate title page (title page footnote 1) and not in the manuscript. That is probably acceptable for blind review. | Mention in the E3 reply that it sits on the title page because the main document is anonymised. |

Open placeholders (known author decisions; one line each, not new findings):
- **E4.** `[AUTHOR_INPUT_NEEDED: name of the professional editorial service…]` is still present (`response_to_editor.txt:23`). The surrounding text is honest: it claims only an internal consistency edit. The title-page footnote's "An earlier version… was edited for language by a native English-speaking editor" traces back to the original acknowledgement (`manuscript_ORIGINAL.txt:121`).
- **E5.** `[AUTHOR_INPUT_NEEDED: the authors' statement on how the research questions, interpretation, and conclusions were developed…]` is still present (`response_to_editor.txt:26`). The text around it is honest; the substantive conflict is finding 1.
- **A1.** `[AUTHOR_INPUT_NEEDED: whether the authors can obtain LSEG ESG point-in-time data…]` is still present (`response_to_reviewer_A.txt:13`). The text is honest: Section 3.3 (ms:50) says PIT data exists and that the authors' extract does not contain it.

## Job 1: Coverage of every editor and reviewer item

| Item | Quoted in full | Answer in first two sentences | Location given | Visible change in manuscript | Verdict |
|---|---|---|---|---|---|
| E1 contribution, intuition, SAJE citations | yes | yes | §1; §§2.2, 2.3, 4.3, 6.3 | yes: ms:8–23; three SAJE papers verified to exist (below) | PASS. New intro sentences are partly unmarked (finding 2). |
| E2 abstract ≤150 words, forward-looking last line | yes | yes | Abstract | yes: 149 words (counted); no statistics | PASS on content. FAIL on marking: the last line is black (finding 2). |
| E3 ack footnote, references | yes | yes | title page; references | yes: footnote present in `footnotes.xml`, quoted verbatim | PASS, with minors 7 and 22. |
| E4 professional editing | yes | yes ("We agree…") | whole manuscript | consistency edit only | Placeholder open. |
| E5 AI disclosure on title page | yes | yes | title page | yes: declaration present | Disclosure present, but the use conflicts with policy (finding 1). |
| A1 first recorded score vs observable coverage | yes | yes | §§1, 3.2, 3.3, 5.3, 5.4, 6.1, 8 | yes: new §3.3 and three datings | PASS. PIT placeholder open. |
| A2 parallel trends | yes | yes | §§4.1, 5.2, 5.3, 5.5, 5.8 | yes | PARTIAL: the 4.1 argument uses non-rejection as flatness (finding 3). |
| A3 reconcile datings, common sample | yes | yes | §5.4, Table 4, S10 | yes | PASS. Arithmetic: −0.005, −0.016, −0.044, −0.070 all reproduce from Table 4 (62% from rounded values is 62.9%; see UNVERIFIED). |
| A4 common support, size | yes | yes | §§4.2, 5.6, Tables 5–6 | yes | PASS. Table 6 country shares reconcile with Table S3 counts. |
| A5 mechanisms | yes | yes | §§2.4, 5.9, 6.3 | yes; the "separates" wording in H3 was replaced (original:30 → ms:37) | PASS. |
| A6 missing MTB, erroneous market cap | yes | yes | §§3.2, 3.4, 5.7, 7, Table 7, S11 | yes; 209/27,127 = 0.77% and 540 + 209 = 749 check | PASS, with minors 6 and 9. |
| A7 pooled-estimate representativeness | yes | yes | §5.10, S9 | yes; S9 weights recompute (1,074/1,946 = 0.552; 2021–24 = 1,697/1,946 = 87.2%) | PASS. |
| A8 framing and implications | yes | yes | Abstract, §§1, 6.2, 6.4, 8 | yes | PASS (suggestion 32). |

No item is dropped and no reply is thanks-only. Every verbatim excerpt the letters quote from the manuscript appears in the revised text: I checked all 14 quotes, and the only difference is the lower-case "modest" at ms:159. The letter's paraphrase "keeps values as first published" differs slightly from ms:50 "as they were published", but it is not presented as a quote.

## Job 2: Honesty and tone of the letters

- The tone is respectful and direct, and the letters are not defensive. There is no wording from the S1-48 forbidden list.
- Agreement is not sycophantic: the authors keep both datings and say the baseline gets no extra weight, rather than conceding a negative effect.
- False or unsupported letter claims:
  - "every sentence… highlighted in blue" (finding 2, MAJOR)
  - "Appendix B.8 to B.10" (finding 5)
  - "do not remove the largest or smallest" (finding 6)
  - the incomplete list of new references (finding 7)
  - "first recorded score throughout" (finding 8)
  - "flat (joint pre-trend p = 0.549)" (finding 3)
- The letter's standard errors for the Table 4 steps (0.009 and 0.019) are not in any exhibit. They are consistent with ms:140's p = 0.092 and p = 0.024 only up to rounding (UNVERIFIED, Seat 2).

## Job 3: Claim audit (abstract, introduction, results, discussion, conclusion)

- **Causal wording:** the script found 25 hits, all reviewed. Every post-coverage statement is conditioned on assumption (2) or framed as "change after entry", and the TWFE and placebo results are described as artifacts or restatements. PASS, except findings 13 and 3.
- **Nulls ("no effect", "not detected", "absent"):**
  - The abstract uses "not detected" with no interval. That is acceptable, because the abstract rule (S1-56) bars intervals and the body supplies one (ms:134).
  - Section 5.3 (ms:136), the introduction (ms:21) and the Conclusion (ms:233) give intervals.
  - Section 6 does not (finding 12).
- **Pooled vs subgroup:** the 10.0% and 14.1% run-ups are correctly pooled. The wave statements are correctly attributed except the Conclusion's "concentrated" (finding 11). The 0.094 early-cohort estimate is correctly labelled exploratory (ms:221, supp A.6).
- **Number conversions checked:**
  - e^0.095 − 1 = 10.0%; e^−0.068 − 1 = −6.6%; e^0.064 − 1 = 6.6%
  - [−0.046, 0.048] converts to [−4.5%, 4.9%]
  - 294.3/68.7 = 4.28, reported as 4.3
  - Table S2: the columns sum to 675; 2020–23 = 577; MY 2021–22 = 289; TH + SG 2019–20 = 108; MY 404 = 59.9%; MY + TH = 569 = 84.3%
  - S11: 943/7,425 = 12.7% and 8,037/28,743 = 28.0%; S4 share missing (943 + 8,037)/36,168 = 0.248
  - Holm ordering in Table 2 is consistent.

## Job 4: Institutional claims (searches dated 2026-10-26; WebFetch blocked)

| Claim (ms line) | Verdict | Source |
|---|---|---|
| Bursa Malaysia sustainability statement for FY ending on or after 31 Dec 2016, phased in from the largest companies over 2016–2018 (ms:41) | PASS. The RM2bn threshold detail comes from secondary sources only. | https://sseinitiative.org/stock-exchange/bursa-malaysia ("staggered basis over a period of 3 years, starting from 31 December 2016 to 31 December 2018"); https://south-east-asia.bureauveritas.com/magazine/empowering-sustainable-progress-malaysia |
| SGX Rules 711A/711B, comply-or-explain, FY ending on or after 31 Dec 2017 (ms:41) | PASS (secondary source; rulebook not fetched) | https://www.hsfkramer.com/insights/2016-07/singapore-human-rights-reporting-by-another-name ("with effect for financial years ending on or after 31 December 2017"); https://rulebook.sgx.com/node/6532/revisions/25997/view |
| SEC Philippines MC No. 4 s.2019, comply-or-explain, from the 2019 annual reports (ms:41) | PASS. The circular was later repealed, but after the sample period. | https://conventuslaw.com/report/philippines-sec-releases-sustainability-reporting/ ("apply to the 2019 Annual Reports that are to be submitted in 2020"; "first 3 years… comply or explain") |
| OJK POJK 51/2017 applies to listed companies other than small- and medium-asset issuers from 2020 (ms:41) | FAIL (provisional), finding 4: the first report was postponed to FY2021 | OJK SEOJK 4/SEOJK.04/2022 and its summary (URLs in finding 4); POJK text at https://sikepo.ojk.go.id/SIKEPO/DatabasePeraturan/PeraturanUtuh/2bc3eb67-4acd-47b7-87b3-e4de04d47a9f |
| Thailand 56-1 One Report since the fiscal year ending in 2021 (ms:41) | PASS | https://www.tilleke.com/insights/thailands-sec-unifies-annual-report-listed-companies/ (applies to fiscal years ending 31 Dec 2021; the One Report only from 1 Jan 2022). Earlier Thai CSR disclosure rules were not confirmed; the paper says so honestly. |
| Bursa Malaysia–LSEG MoU, Nov 2022; FTSE Russell previously scored only FBM EMAS constituents (~30%); extension to all Main and ACE Market companies (ms:42) | PASS | https://mondovisione.com/media-and-resources/news/bursa-malaysia-signs-sustainability-mou-with-london-stock-exchange-group-2022112/; https://www.thestar.com.my/business/business-news/2022/11/03/bursa-malaysia-inks-sustainability--mou-with-lseg |
| LSEG/Refinitiv: scores for the five most recent fiscal years are non-definitive and can change (ms:49, cited to Sahin et al., 2023) | PASS | https://lseg.com/content/dam/marketing/en_us/documents/methodology/refinitiv-esg-scores-methodology.pdf (only years older than the five most recent are marked "definitive") |
| Historical rewriting (Berg et al., 2020) | PASS; still a working paper (ECGI WP 708/2020), as the E3 reply says | https://www.ecgi.global/publications/working-papers/is-history-repeating-itself-the-unpredictable-past-of-esg-ratings |
| LSEG distributes a point-in-time ESG data product (ms:50) | PASS that it exists (ESG Bulk PIT User Guide, v2, June 2023). The "keeps values as they were published" semantics are not confirmed verbatim. | https://developers.lseg.com/content/dam/devportal/api-families/refinitiv-data-platform/refinitiv-data-platform-apis/documentation/rdp_esg_pit_user_guide.pdf |

The three SAJE citations exist and say what the paper claims:
- Nguyen (2025): SAJE 13(2), 67–98. https://so05.tci-thaijo.org/index.php/saje/article/view/269458 (see finding 21 on the disclosure framing).
- Sudsawasd & Sakdapat (2026): SAJE 14(1), 257–287. https://so05.tci-thaijo.org/index.php/saje/article/view/278464
- Prukumpai et al. (2022): SAJE 10(3), 227–257. https://so05.tci-thaijo.org/index.php/saje/article/view/262745

Berg, Heeb & Kölbel is still SAFE WP 439 (https://safe-frankfurt.de/publications/working-papers/details/publicationname/the-economic-impact-of-esg-ratings.html), so the E3 reply is accurate. The 4.86% in Demiroglu & Ryngaert (2010) is confirmed (https://ideas.repec.org/a/bla/finmgt/v39y2010i2p555-584.html).

## Job 5: Simulated referee and editor objections (ranked by likelihood)

1. **Editor: AI policy.** The title page discloses AI-drafted text, analyses and research-question screening; the journal allows language and readability only (finding 1). The editor is near-certain to raise this, possibly as a desk-level issue. The open E4 placeholder (no professional editing) adds to it.
2. **Reviewer A: "You found the point-in-time product; get it."** The manuscript now concedes that LSEG PIT data exists (ms:50), and Reviewer A asked for publication dates "at least for a subset of firms." The referee will likely ask for a PIT-dated re-estimation for the cohorts it covers, or for a documented reason it cannot be licensed. Evidence that would resolve it: a re-run of Table 2 and Table 4 on PIT first-publication dates for any subset.
3. **Reviewer A: identification rests on an exploratory wave contrast.** Section 4.1 defends assumption (2) with a "flat" Malaysian path that the paper itself says cannot rule out the pooled run-up (finding 3). The wave boundaries were chosen after seeing the counts. The Malaysian wave also shows the market-cap fall (−0.146) that drives the pooled market-cap estimate. The referee will likely ask for a pre-specified or data-driven grouping, honest-DiD confidence sets (Rambachan & Roth, 2023, rather than the simplified bound the Limitations admit), and the wave-level interval in Section 6.4.

## Job 6: Consistency of text, tables, figures, supplement, title page and letters

- **Consistent:**
  - The core numbers agree across the abstract, introduction, Tables 2–7, S1–S11, both letters and the Conclusion (0.002 [−0.046, 0.048], −0.068, −6.6%, 10.0%, 14.1%, 2.8% [−7.4%, 15.2%], 55.2%, 26.7%, 44.1%, 87.2%, 487/138, 209/749).
  - Table 6 shares × firm counts reproduce the Table S3 country counts within rounding.
  - Every supplement exhibit is referenced in the main text, and the section references inside the supplement (A.1–A.11) resolve.
- **Inconsistent:** findings 5, 8, 9, 11, 14, 15, 23 and 26.
- Supplement A.7 is labelled "(Section 5.2, Figure 2)", but the 565-firm fact is in Section 5.1 (ms:130); trivial.

## Job 7: Proofreading, anti-slop and journal fit

- **Script results:**
  - 0 em dashes and 0 banned phrases in the manuscript, the supplement and both letters (S1-80, S1-89).
  - 16 acronym flags; all are defined or are proper names (MSCI, FTSE, EMAS, ACE), except "CI" in the Table 2 note (trivial).
  - 0 statistics in the abstract.
- **Proofreading and anti-slop:** findings 16–20, 24 and 31. The new prose is plain and specific. Hedging is not stacked. Metaphors are limited to the one "entry ticket" framing.
- **Journal fit:**
  - Abstract 149 words, within the limit.
  - Keywords and JEL present (suggestion 29).
  - Title page with declarations and the acknowledgement footnote present.
  - Reference style is APA-like, as in the sample.
  - Length is slightly over (finding 25).

## Job 8: Declarations

- **Data availability:** present (finding 26).
- **CRediT:** present for both authors.
- **COI:** "The authors have nothing to disclose."
- **Funding:** none.
- **Ethics:** not applicable, with a reason.
- **AI use:** present; it conflicts with the policy (finding 1).
- **Authorship:** see UNVERIFIED.

## UNVERIFIED (not PASS)

1. **Authorship continuity.** The original manuscript is written as by a single author ("The author thanks…", `manuscript_ORIGINAL.txt:121`; "Author's calculations" in every source line). The revised title page lists two authors, Ha Hong Hanh (first) and Nguyen Van Trung (corresponding). A different version in the project folder (`manuscript/Manuscript_with_Author_Details.docx`) lists four authors and a different affiliation for the corresponding author (Academy of Policy and Development). I cannot see what SAJE has on file. If the author list or affiliation differs from the submission, the change needs the editor's approval and a statement signed by all authors, and the letters are silent on it. That would be MAJOR.
2. **AI declaration dates.** The declaration says "September and October 2026" for the original research-question screening, the pre-analysis plan and the code. Whether that fits the original submission date is unknown; the authors should confirm.
3. **The ack footnote's "edited… by a native English-speaking editor".** It is consistent with the original acknowledgement, but the editor's identity was not checked.
4. **Numbers that depend on unrounded R output.** The R code is not in the dossier and I did not re-run it (Seat 2's job):
   - 62% (62.9% from rounded values)
   - MDE "about 7.0%" (6.9% from 0.067)
   - Malaysian wave 2.8% (the original reported −0.027 at e = −5, which converts to 2.7%)
   - the letter's SEs 0.009 and 0.019 against p = 0.092 and p = 0.024
   - the Table S10 percentile intervals (−0.053 to 0.091; −0.055 to 0.076), which appear in the text but in no exhibit
   - the "0.044 accounting identity" (ms:155)
   - 141 versus 142 scored firms at event year 4
5. **Bikmetova & Pirinsky (2026),** *J. Bus. Ethics* 204(2), DOI 10.1007/s10551-025-06063-0: two searches found no record (Seat 2 to verify).
6. **Rulebook and primary URLs** for SGX, OJK, SEC PH, Bernama and Tilleke could not be opened (WebFetch blocked); the claims were checked through search results only.
7. **The "about 5,000–7,000 words" length guidance** is not stated in the editor letter or the sample PDF; I used the figure given in the task brief.
8. **Earlier Thai sustainability disclosure rules** (before the One Report) were not confirmed by search.

rules checked (core): 50/50. 38 were applied to the deliverables. The other 12 are process or orchestrator rules that are not observable here or are satisfied by this seat's own conduct: C-10, C-13, C-14, C-30, C-31, C-32, C-34, C-35, C-36, C-40, C-42, C-70.

rules checked (seat1): 114/114. 80 were applied. The other 34 are intake and edit-loop process rules that cannot be judged from the deliverables: S1-03, S1-04, S1-05, S1-07, S1-08, S1-09, S1-10, S1-11, S1-15, S1-18, S1-19, S1-22, S1-23, S1-26, S1-27, S1-29, S1-30, S1-40, S1-41, S1-44, S1-45, S1-77, S1-91, S1-99, S1-100, S1-101, S1-102, S1-103, S1-105, S1-108, S1-110, S1-111, S1-112, S1-114. Simulation rules S1-99 to S1-103 were applied only as far as the brief's top-3 ranking.

COUNTS: CRITICAL 1, MAJOR 3, MINOR 22, SUGGESTION 8

REMAINING CRITICAL/MAJOR: 1 (C-17/S1-17 AI-use declaration conflicts with journal AI policy), 2 (S1-24 blue marking incomplete; letters' "every sentence" claim false), 3 (C-25 Malaysian-wave "flat" pre-trend used as identifying argument), 4 (S1-106 OJK effective date, provisional)
