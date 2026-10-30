# Panel round 3, Seat 1 (referee + editor): SAJE 292892 R1

Loaded:
- `/root/.claude/skills/paper-revision-master/SKILL.md`: 133 lines (skill entry file, no sentinel)
- `references/cards/core.md`: 87 lines, `<!-- CARD-END core v2 -->`
- `references/cards/seat1-referee-editor.md`: 153 lines, `<!-- CARD-END seat1 v1 -->`
- `Skill("academic-pipeline")` and `Skill("paper-revision-master")` were both invoked first.

Scope of this pass (C-60 to C-62). I read every dossier text in full: the clean and marked revised manuscript, the revised and original supplement, the title page, both letters, the original manuscript, the verbatim editor letter and Reviewer A report, and the journal sample PDF (extracted to text). I also read the original AAMJAF cover page and the version with author details, from `/home/user/trungcandygit/b-i-esg2/submission/AAMJAF_submission/`.

I rendered all seven deliverable PDFs (2 + 34 + 34 + 11 + 11 + 7 + 15 pages) and the 34-page sample PDF with pdftoppm and inspected every page in 4-page tiles at 60 dpi. I re-rendered page 2 of the marked manuscript at 110 dpi to check the colour.

Scripts, all run on copies in `/tmp/claude-0/panel_r3_seat1/`:
- `check_blue.py`, after reading its logic (see S-30).
- My own stricter blue checker, `blue2.py`.
- `check_docx_style.py` on the manuscript, the supplement, the two letters and the title page.
- `check_crossrefs.py` on the manuscript.
- A Python check that every manuscript excerpt quoted in the letters appears verbatim in the revised files.
- A check that every editor and reviewer comment is quoted in full.

Institutional checks used WebSearch only. WebFetch to `so05.tci-thaijo.org` failed (host not resolvable; that host has to be allowed in the session's network settings), so the full texts of the three SAJE papers could not be read.

## Findings table (CRITICAL first; none found)

| ID | Rule | Verdict | Severity | Evidence (quote, file:line) | Fix |
|---|---|---|---|---|---|
| R3S1-01 | C-17, C-03, S1-104 | FAIL | MAJOR | **Authorship changed between submission and revision, and neither letter says so.** The original cover page (`AAMJAF_submission/01_Cover_Page.docx`, para 1 and 15) lists one author: "Nguyen Van Trung is the sole author and carried out the conceptualization, data curation, formal analysis, methodology, software, visualization, and writing." The original manuscript says "The author thanks…" and "Author's calculations" (`manuscript_ORIGINAL.txt:121,173`). The revised title page adds a first author (`title_page_REVISED.txt:2-3`): "Ha Hong Hanh … conceptualization, supervision, … she set the direction of the research and led the revision" (`:18`). The contribution "conceptualization" contradicts the original sole-author statement. Neither `response_to_editor.txt` nor `response_to_reviewer_A.txt` mentions the change. Journals following COPE require an explained authorship-change request signed by all authors; an unexplained new first author at R1 is routinely queried by editors. | Authors decide. Either add a short paragraph to the editor letter (before E1, or under E3 "Title page") that states the change, the reason and Dr Ha's contribution, and submit the journal's authorship-change form signed by both authors; or revert the author list. Make the CRediT roles consistent with what the original declaration said (or explain the difference). Mark AUTHOR_INPUT_NEEDED until the authors confirm. |
| R3S1-02 | S1-24, S1-39 (letter honesty) | FAIL | MINOR | Both letters say that "every sentence that is new or differs from the submitted version is highlighted in blue" (`response_to_editor.txt:6`, `response_to_reviewer_A.txt:4`). This is not literally true. At least 6 revised sentences in the body are only partly blue: the citation tails after a semicolon stay black. At 110 dpi, page 2 shows "(Pástor et al., 2021; **Pedersen et al., 2021**)", "(Dobrick et al., 2023; **Drempetic et al., 2020**)", "(Berg, Kölbel, et al., 2022; **Dobrick et al., 2023**)" and "(Baker et al., 2022; **Goodman-Bacon, 2021**)" with the bold part black. The same happens in 4.2 ("…estimated from Eq. (3)"), 4.5, 6.3 and 6.4 (my `blue2.py`: 22 mixed sentences in the manuscript and 19 in the supplement, mostly notes and sources where only "Authors'" changed). The bundled `check_blue.py` reports 0 misses because it splits sentences at ";" and ":", so the black tail "Pedersen et al., 2021)." matches an original fragment and counts as unchanged (see S-30). | Colour the full revised sentence, including the citation tails, in the 6 body sentences. Alternatively, change the letters' description to "new or changed text is shown in blue". Fix the checker split rule (S-30). |
| R3S1-03 | S1-39, C-01 | FAIL | MINOR | The A5 reply puts in quotation marks text that is not in the manuscript. The letter (`response_to_reviewer_A.txt:51`) has "…or something else. What the data can evaluate is narrower: whether entry follows relative growth, …". The manuscript (`manuscript_REVISED_clean.txt:37`) has "The data can evaluate a narrower set of questions: whether entry follows relative growth, …". All other 26 quoted excerpts match verbatim (script check). | Copy the exact manuscript sentence into the letter, or change the manuscript to match the quote. |
| R3S1-04 | C-16, S1-35 (letter honesty) | FAIL | MINOR | E5 reply: "We have added a declaration of the use of generative AI tools to the title page" (`response_to_editor.txt:26`). The original cover page already had "Declaration of generative AI use" (`01_Cover_Page.docx` para 16-17). The revision expands that declaration (it now covers the revision work); it does not add one. | Say "We have expanded the declaration on the title page, which now also covers…". (This holds if the SAJE submission included that cover page; the authors should confirm.) |
| R3S1-05 | C-25, S1-38 | FAIL | MINOR | The A2 reply says: "We say in the same paragraph that this is not evidence of parallel trends: the run-up interval for the wave runs from −7.4% to 15.2%…" (`response_to_reviewer_A.txt:24`). Section 4.1 does not say that. It says "the run-up interval is wide, however (−7.4% to 15.2%), and the wave split is exploratory, so this argument is weaker than a test would be" (`manuscript_REVISED_clean.txt:70`). The letter also uses the non-rejection "(joint pre-trend p = 0.549)" as support, which the reviewer warned against. | In the letter, paraphrase what 4.1 actually says. Alternatively, add to 4.1: "a non-rejection is not evidence of parallel trends". |
| R3S1-06 | C-07 | FAIL | MINOR | Steps quoted from Table 4 do not match the displayed table. The letter A3 says "Measuring size in g and returning to all firms change little (0.002 and −0.008)" (`response_to_reviewer_A.txt:33`), but Table 4 rows 4→5 go from −0.063 to −0.060, a change of **+0.003** (`manuscript_REVISED_clean.txt:214-218`). In the text, "−0.044 … 62% of the total gap of −0.070" (`:202`) works out to 62.9%, i.e. 63%, from the displayed numbers. The unrounded outputs may justify 0.002 and 62%. | Seat 2 should check against the CSV. If the unrounded values hold, add "(unrounded)"; otherwise use 0.003 and 63%. |
| R3S1-07 | C-28, C-07 | FAIL | MINOR | "the MDE from Eq. (7) is about 7.0%" (`manuscript_REVISED_clean.txt:198`). From the table value 0.067, exp(0.067) − 1 = 6.93%, i.e. about 6.9%. | Write "about 7%" or "6.9%" (Seat 2: check the unrounded MDE). |
| R3S1-08 | S1-25, C-06 | FAIL | MINOR | Two statements about scores dropping out read as contradictory. Section 3.2 says "Only 17 of the 675 scored firms have a later year without a score" (`:45`). Section 3.3 says "That no scored firm in the extract loses its score before 2024 fits a download of the provider's current universe" (`:49`), and letter A6 repeats this as "the absence of any firm losing its score" (`response_to_reviewer_A.txt:62`). A referee will read these as contradictory. | Reword to the fact that holds, e.g. "every scored firm still has a score in 2024; 17 have a gap year in between". Seat 2 should confirm this against the data. |
| R3S1-09 | S1-88, letter claim | FAIL | MINOR | The A1 reply says "the event is now called the first recorded score throughout" (`response_to_reviewer_A.txt:14`). The manuscript still uses "first scored in year g" (`:56,76,80`) and "the recorded first score" (`:22`), and the supplement has "Cohorts first scored by 2019/from 2020" (`supplement_REVISED.txt:193,196`) next to "Malaysia, first recorded 2021–2022" (`:184`). | Use one form: "first recorded in year g" or "with first recorded score in g". Alternatively, change the letter's word "throughout". |
| R3S1-10 | C-25 | FAIL | MINOR | The introduction states "not detected in the 289 Malaysian firms" (`:12`) with no interval at that point (the interval first appears in 5.2, `:196`). Section 6.4 reads the same non-detection as "broad expansions … appear to select less on prior growth" (`:348`), also without the run-up interval. | Add "(95% interval −7.4% to 15.2%)" in the introduction, and in 6.4 add "although its interval admits a run-up of the pooled size". |
| R3S1-11 | C-27 | FAIL | MINOR | "ESG fund holdings respond to MSCI ratings, not to those of other providers (Berg, Heeb, et al., 2022)" (`:342`). That paper's evidence concerns U.S. ESG funds (§2.1 of the manuscript itself says "U.S. funds with ESG mandates", `:25`). | Write "U.S. ESG fund holdings". |
| R3S1-12 | C-27, S1-53 | FAIL | MINOR | "a portfolio screened on ESG scores in these markets holds firms that entered coverage after outgrowing their peers" (`:347`). This is a pooled-average statement applied to all firms, while the largest wave (44.1% of weight) shows no detected run-up. | Write "tilts toward firms that, on average, entered coverage after outgrowing their peers, most clearly outside the Malaysian wave". |
| R3S1-13 | C-65, S1-106 | FAIL | MINOR | Bursa Malaysia sentence (`:40`): the effective date of FY ending on/after 31 Dec 2016, starting with large (≥RM2 bn) Main Market issuers, is confirmed (see I-1). The phase-in "between 2016 and 2018" is not confirmed. The cited source, "Bursa Malaysia (2015). Sustainability reporting guide" (`:362`), is guidance with no URL. The obligation is in the Main and ACE Market Listing Requirements (amended October 2015). | Cite the Listing Requirements amendment (Bursa announcement of 9 Oct 2015) with its URL, and confirm the 2017/2018 phases. Otherwise write "phased in from the largest Main Market companies" without end years. Mark AUTHOR_INPUT_NEEDED until a source is found. |
| R3S1-14 | C-65, S1-71 | FAIL | MINOR | Indonesia sentence (`:40`): "Under its original schedule, a 2017 Indonesian regulation applies to listed companies other than small- and medium-asset issuers from 2020 … the regulator's pandemic relief may have delayed some first reports". The 2020 date is confirmed (I-4). The tense "applies" is mixed with past tense around it, and the relief is uncited even though a source exists: SEOJK 4/SEOJK.04/2022 states that a first sustainability report due for the period 1 Jan–31 Dec 2020 became due for 2021. | Write "applied", and cite the OJK circular or remove the relief clause. No variable depends on it, so this is MINOR. |
| R3S1-15 | S1-71 | FAIL | MINOR | Section 3.2: "…we cannot sign the resulting bias. They combine the annual LSEG ESG score…" (`:44`). After the inserted survivorship sentences, "They" no longer refers to "The data". | Write "The data combine…". |
| R3S1-16 | S1-73 | FAIL | MINOR | "Row R11 keeps the 7 cohorts" (`:240`); "141 scored firms from 6 cohorts" (`supplement_REVISED.txt:6`). The rest of the text spells out numbers under 10 ("eight limitations", "three hypotheses"). | Write "seven" and "six". |
| R3S1-17 | S1-61 | FAIL | MINOR | `check_docx_style.py` check 8 finds 11 number-dense paragraphs. The worst are §5.4 "The reference year thus drives…" (16 decimals), §5.6 (11 and 11) and §5.7 (9). | Move the second-order numbers in §5.4 and §5.6 to Tables 4–6 and S10. |
| R3S1-18 | Journal fit (C-50) | FAIL | MINOR | Length. The main text is about 7,370 words excluding tables, notes and references, and about 8,700 including table and figure notes (the original was about 6,970). This exceeds the 5,000–7,000-word guidance given in the panel brief; I could not verify that figure against a SAJE source. The letters say results were moved "to keep the main text close to the journal's usual length" (`response_to_editor.txt:6`). | Trim §5.4, §5.6 and §5.7 prose that repeats the tables, or soften the letter claim. |
| R3S1-19 | S1-70 (layout) | FAIL | MINOR | In the marked and clean PDFs, page 3 is about 70% blank because Figure 1 is pushed to page 4. | Allow text to flow around the float, or place the figure after the paragraph. |
| R3S1-20 | S1-25 | FAIL | MINOR | Supplement A.3 (`supplement_REVISED.txt:10`): the "R10 estimates of −0.138 and −0.200" for "event years 3 and 4" are counted from the first recorded year. Figure S2(b) plots the same path on re-dated event years, where −0.200 sits at x = 3, so a reader cannot match them. | State "counted from the first recorded year, i.e. re-dated event years 2 and 3". |
| R3S1-21 | S1-24 | FAIL | SUGGESTION | The title page (acknowledgement footnote, expanded declarations, new author) has no blue text. The editor asked for blue in "the main document", so this is not required. Because the title page carries most of the E3 and E5 changes, marking them helps the editor. | Colour the footnote and the changed declarations blue in a marked copy of the title page. |
| R3S1-22 | C-65 | FAIL | SUGGESTION | "We could not confirm the dates of earlier Thai guidance" (`:40`). Secondary sources say Thai SEC-listed companies were required from 1 Jan 2014 to disclose CSR in Form 56-1 or a sustainability report (Kasetsart J. Soc. Sci. article on tci-thaijo; Thai SEC 2013 Sustainability Development Roadmap). | Add one clause with a primary Thai SEC source if found; otherwise keep the honest sentence. |
| R3S1-23 | tables-figures house rule | FAIL | SUGGESTION | 4 notes are longer than 2 sentences (Figure 1, Figure 2, Table 2, Table 7). SAJE sets no rule on this. | Optional: shorten. |
| R3S1-24 | S1-69 | FAIL | SUGGESTION | "CI" in the Table 2 header and note is never written out. | Write "confidence interval (CI)" in the note. |
| R3S1-25 | S1-57 | FAIL | SUGGESTION | The revised introduction has no roadmap paragraph (the original had one at `manuscript_ORIGINAL.txt:16`). | Optional: add a short paragraph specific to this paper. |
| R3S1-26 | Journal fit | FAIL | SUGGESTION | JEL codes (`:5`) do not appear in the SAJE sample article (`0a126083…pdf` p.2 shows keywords only). | Keep only if the SAJE author guidelines ask for JEL codes. |
| R3S1-27 | S1-85, C-07 | FAIL | SUGGESTION | "a one-year abnormal return of approximately −2.37%" (`:25`) pairs "approximately" with two-decimal precision. | Write "of about −2.4%" or drop "approximately". |
| R3S1-28 | S1-78 | FAIL | SUGGESTION | The three SAJE references (`:381,386,396`) have no URL, and the letter (E3) says every reference has "complete citation details". The articles are online at so05.tci-thaijo.org/index.php/saje/article/view/269458, 262745 and 278464. | Add the article URLs. |
| R3S1-29 | C-65, S1-106 | FAIL | SUGGESTION | §3.3 describes the point-in-time product ("keeps values as they were published (LSEG, 2023)") without saying what period it covers. An LSEG fact sheet ("LSEG ESG solutions for quants and data scientists") gives point-in-time history for category and summary scores since 2017. That would cover the 577 firms first recorded in 2020–2023, so a referee will ask why it was not used (see the simulated objections). | State the coverage period, and resolve the A1 placeholder. |
| R3S1-30 | C-12 (tool validity) | FAIL | SUGGESTION | Logic of `check_blue.py`. (a) The split regex `(?<=[.?!:;])\s+` cuts sentences at ";" and ":", so a black citation tail can match an original fragment and pass (the cause of R3S1-02). (b) It reads `p.runs`, which skips hyperlink runs. (c) It ignores footnotes, headers and text boxes (the title-page footnote was not checked). (d) It recognises only the exact colour 0000FF. Its "0 misses" result is therefore not a PASS on its own. | Split only at sentence ends (excluding "et al." and "Eq."), iterate `w:r` in all story parts, and include footnotes. |
| R3S1-31 | S1-73 | FAIL | SUGGESTION | Each letter repeats its heading ("Response to the Editor" and "Response to Reviewer A" each appear on page 1 and again on page 2). | Remove one occurrence. |

### PASS items (with evidence)

**Coverage (S1-03, S1-15, S1-32, S1-33, C-15).**
- All 5 editor comments and all 8 Reviewer A comments are quoted in full; a script compared them paragraph by paragraph, and the only differences are the "1."–"8." numbering prefixes.
- Each reply opens with agreement and action in its first two sentences.
- Every reply names a location, and each location shows a visible change in blue in the marked PDF: §3.3 new, Tables 4–7, Tables S9–S11, §2.4 last paragraph, §5.4–5.10, §6.2–6.4.
- Nothing is dropped. Three replies carry visible AUTHOR_INPUT_NEEDED flags (E4, E5, A1).

**Tone and thanks (S1-47 to S1-51, S1-110).**
- No reply consists only of thanks, and none uses forbidden phrases (script: banned = 0, em dashes = 0 in both letters).
- Concessions are stated early: A2 says "The pooled sample fails the pre-trend diagnostic", and A8 says "Selection into coverage is now the central finding".

**Quotes (S1-39).** 26 of 27 quoted excerpts appear verbatim in the revised files. The acknowledgement quote matches `01_Title_Page.docx` `word/footnotes.xml`. The exception is R3S1-03.

**Abstract (S1-56, E2).**
- 150 words (wc), with no p-values or confidence intervals.
- The forward-looking last sentence is present.
- The letter's copy of the abstract is identical to the manuscript (diff).

**Claim audit (C-20 to C-26).**
- Abstract, introduction, §5 and §8 keep the causal reading conditional on assumption (2). "No effect" wording carries an interval: §6.2 (`:339`), §8 (`:352`), §6.4 "interval excludes increases above 4.9%" (`:348`).
- The non-rejection at p = 0.074 is explicitly not used as evidence (`:194`).
- Pooled and subgroup numbers are attributed correctly. For example, the Malaysian wave market-cap estimate is −0.146 and "accounts for most of the negative pooled" estimate (`:196`), and the exploratory subgroup 0.094 is labelled as such (`:339`).
- §6.4 states the reviewer's point that the results "do not show that expanding ESG coverage has no valuation benefit" (`:348`).

**Numbers I recomputed** (Seat 2 owns the CSV check).
- Table S2 totals: 675, 289, 108, 577, 404 (59.9%), 84.3%.
- Table S9 weights: 0.552, 0.267, 0.441, 87.2%, and the total of 1,946 cells agrees across markets, waves and years.
- Table S11 missing-data shares: 28.0%, 12.7%, 24.8%.
- Table 6 shares match the counts out of 487 and 138.
- Wave differences: −0.258 = −0.286 − (−0.028); −0.148 and −0.123 from Table S10.
- Log-to-percent conversions: −6.6%, 6.6%, 10.0%, −4.5% to 4.9%, 33.1%, 12%.
- 209 / 27,127 = 0.77%; 294.3 / 68.7 = 4.3.

**Declarations (C-17).** Funding, conflict of interest, ethics and data availability statements are present and consistent with the original. The data statement is honest about licensing and the unrecorded download date.

**SAJE citations exist (C-04 spot of the editor-related claim).**
- Nguyen (2025), SAJE 13(2) 67–98: tci-thaijo article 269458.
- Prukumpai, Sethapramote and Luangaram (2022), SAJE 10(3) 227–257: article 262745.
- Sudsawasd and Sakdapat (2026), SAJE 14(1) 257–287: article 278464.
- No journal versions were found for Berg, Fabisik and Sautner (2020) or Berg, Heeb and Kölbel (2022); the MIT Sloan faculty page lists the latter as Working Paper 6787-22. This is consistent with the E3 reply.

### Known open author decisions (one line each; not re-argued, not counted)

- **AUTHOR_INPUT_NEEDED placeholders:** all three remain: E4 (`response_to_editor.txt:23`), E5 (`:26`) and A1 (`response_to_reviewer_A.txt:13`). The package is draft_with_placeholders, not ready_to_submit (S1-41).
  - The surrounding text is honest for E5 and A1.
  - For E4, "We agree" is followed only by an in-house edit. The title-page footnote says only "An earlier version" was edited by a native speaker, so unless the placeholder is filled with a real professional edit of the revised version, the reply does not do what E4 asked.
- **AI-policy conflict:** it remains. The title-page declaration (`title_page_REVISED.txt:8`) discloses use beyond language and readability ("carry out the additional analyses…, draft the revised text, and draft the response letter"), which the editor's policy excludes. The disclosure itself is honest and complete.

## UNVERIFIED (separate list)

- **U-1 (C-65):** Bursa Malaysia phase-in end years "between 2016 and 2018". Only the 31 Dec 2016 start for large issuers is confirmed (see I-1).
- **U-2 (C-04, C-06):** Content claims about the SAJE papers could not be checked against full texts because so05.tci-thaijo.org is blocked in this container.
  - Sudsawasd and Sakdapat: that "local institutional investors adjust … over the long run, whereas foreign and retail investors adjust in the short run". The abstract seen via search mentions brokerage fees, trading value and volatility, not investor groups.
  - Nguyen (2025): "foreign ownership is associated with higher CSR scores, and state and family ownership with lower ones". The search summary says the paper studies CSR *disclosure* in 87 consumer-goods firms, so "scores" may be inaccurate.
- **U-3:** The Bernama URL `news.php?id=2134522` was not opened. The event and date (MoU signed 2 Nov 2022; FTSE Russell coverage extended from EMAS constituents, about 30% of PLCs, to all Main and ACE Market PLCs) are confirmed by The Edge Malaysia and Mondo Visione.
- **U-4:** The SAJE length guidance of 5,000–7,000 words could not be confirmed from a SAJE source (WebFetch blocked). The figure is taken from the panel brief.
- **U-5 (C-07):** Unrounded values behind R3S1-06 and R3S1-07, and the coincidence of p = 0.307 for both the high-versus-low score split (`:331`) and the remaining-cohorts run-up test (`:237`). Passed to Seat 2.
- **U-6:** Whether the SAJE submission included the AI-declaration cover page (relevant to R3S1-04). I used the AAMJAF_submission folder as the original, as the brief directs.

## Institutional claims checked (core C-65 to C-68; WebSearch, accessed 2026-10-30)

| # | Claim in manuscript (`manuscript_REVISED_clean.txt`) | Verdict | Source |
|---|---|---|---|
| I-1 | Bursa Malaysia: sustainability statement for FY ending on/after 31 Dec 2016, phased (`:40`) | PASS on the start date (large Main Market issuers, ≥RM2 bn); phases UNVERIFIED (U-1). Tense "required" is correct, because the rule was replaced by the IFRS-based framework in Dec 2024 (Skrine alert, Jan 2025). | sseinitiative.org/fact-sheet/bursa/; skrine.com/insights/alerts/january-2025/bursa-malaysia-amends-sustainability-reporting-req |
| I-2 | SGX Rules 711A/711B, comply or explain, FY ending on/after 31 Dec 2017 (`:40`) | PASS | rulebook.sgx.com/node/6532/revisions/25997/view ("Past version: Effective from 20 Jul 2016"); hsfkramer.com/es/insights/2016-07/singapore-human-rights-reporting-by-another-name |
| I-3 | SEC Philippines MC No. 4 s.2019: report attached to the 2019 annual report, comply or explain for the first three years (`:40`) | PASS. Past tense is right: one law-firm alert reports that MC 16 s.2025 repealed MC 4. | sec.gov.ph/wp-content/uploads/2020/09/2019MCNo4.pdf; globalcompliancenews.com/2019/07/01/philippines-sec-releases-sustainability-reporting-guidelines-20190522/; oneasia.legal Newsletter 202603 |
| I-4 | OJK POJK 51/2017: issuers other than small and medium-asset issuers from 1 Jan 2020; pandemic relief (`:40`) | PASS on the date. The relief is supportable (SEOJK 4/SEOJK.04/2022 moves a first report from 2020 to 2021) but uncited; tense issue, see R3S1-14. | akuntansi.uad.ac.id/wp-content/uploads/Peraturan-OJK-51-2017.pdf; ojk.go.id … SEOJK 4 - 04 - 2022.pdf |
| I-5 | Thailand 56-1 One Report from FY ending 2021 (`:40`) | PASS (replaces Forms 56-1 and 56-2 from 1 Jan 2022 for FY ending 31 Dec 2021). | tilleke.com/insights/thailands-sec-unifies-annual-report-listed-companies/; KPMG "one-report-ghg-event-23nov21.pdf" |
| I-6 | Bursa Malaysia and LSEG, November 2022, FTSE Russell scores extended from EMAS constituents (about 30%) to all Main and ACE companies (`:41`) | PASS as a description of the agreement. A July 2024 NST report says 237 PLCs are rated, so the manuscript is right to say "agreed … to extend" and not that coverage was achieved. | theedgemalaysia.com/article/ftse-esg-scores-now-available-all-public-listed-companies; mondovisione.com …-2022112/ |
| I-7 | LSEG/Refinitiv: scores for the five most recent fiscal years can change; historical rewriting (Berg et al., 2020) (`:48`) | PASS. Methodology summaries state that scores are definitive except for the five most recent years; Berg, Fabisik and Sautner document the 2020 retroactive rewrite. | lseg.com/…/refinitiv-esg-scores-methodology.pdf; community.developers.refinitiv.com/discussion/comment/75003; ecgi.global/…/bergfabisiksautnerfinal.pdf |
| I-8 | LSEG point-in-time ESG product "keeps values as they were published" (`:49`) | PASS in substance (LSEG markets it as "truly point-in-time"). Coverage period not stated; see R3S1-29. | lseg.com/…/lseg-esg-solutions-for-quants-and-data-scientists.pdf; developers.lseg.com ESG user guides |

No treatment or control variable is coded from these rule dates (`:40` "a date no variable in our analysis depends on"), so C-66 and C-67 coding risk does not arise on the text side.

## Simulated next-round objections (S1-99 to S1-103), ranked

1. **Reviewer A, on Comment 1: "The point-in-time data exist; obtain them."** The revision itself says LSEG sells point-in-time ESG data, and an LSEG fact sheet dates point-in-time summary scores from 2017. That covers about 85% of the scored firms (577 of 675 first recorded in 2020–2023). The reviewer asked for publication dates "at least for a subset of firms", so a reply that only flags AUTHOR_INPUT_NEEDED will draw a repeat demand: "the obvious data source is identified but not used." What would resolve it: a point-in-time-dated re-estimate for the covered cohorts, or a documented statement that access was requested and refused.
2. **Reviewer A or editor, on the new survivorship disclosure.** The sample keeps only firms listed in 2024, and scores are downloaded from the current universe (§3.2–3.3). Firms that were scored and then delisted, or that lost coverage, are absent. That can manufacture both the pre-entry run-up (survivors grew) and the "coverage is permanent" fact. The referee will ask for Compustat Global inactive firms, or at least a bound. What would resolve it: re-extracting with inactive firms, or comparing listing counts with exchange statistics.
3. **Editor, at the desk.**
   - Policy and paperwork: an unexplained new first author (R3S1-01), and an AI declaration that reports AI-generated analyses and revised text, which conflicts with the stated policy.
   - Still incomplete: E4 shows no evidence of a professional edit.
   - The main text has grown past the usual length (R3S1-18).

   Each is quick for the editor to verify and can delay or end the round independently of the science.

(Next in line: whether the Malaysian-wave "no run-up" argument (interval −7.4% to 15.2%) can carry the plausibility case for assumption (2), given that it admits a run-up of the pooled size.)

## Proofreading and anti-slop on blue text (S1-80 to S1-92)

- Script counts: em dashes 0 (manuscript, supplement, both letters, title page); banned phrases 0.
- Causal-verb hits: 26, all reviewed by hand. Each is a conditional reading, a cited prior finding, or negated; none is an unhedged causal claim about this paper's design (C-20, C-21).
- The new prose is direct, without throat-clearing or intensifiers.
- Remaining items are in rows 15–17 and 24–27.
- Sample-format fit:
  - abstract within 150 words;
  - six lowercase-style keywords;
  - APA references with DOIs, as in the sample;
  - acknowledgement footnote on the title page, as the editor asked;
  - declarations on the title page.

  The sample places Acknowledgments, Funding and Data Availability at the end of the article; the editor's instruction takes precedence (C-50).

## Rule tally

- core.md: rules checked 50/50. Process and panel rules C-10, C-14, C-30 to C-36 and C-40 to C-43 were checked as applicable to an auditing seat; C-70 is for the orchestrator and was noted as not applicable.
- seat1-referee-editor.md: rules checked 114/114. The per-comment workflow rules S1-22, S1-29, S1-40, S1-77 and S1-105 do not apply to an audit seat and were marked not applicable after checking.

COUNTS: CRITICAL 0, MAJOR 1, MINOR 19, SUGGESTION 11

REMAINING CRITICAL/MAJOR: R3S1-01
