# Verification log (core C-04, C-05, C-65; Seat 2 S2-77 to S2-80), 2026-10-25

Network note: the session's proxy blocks direct fetches of publisher, Crossref, OpenAlex and journal pages (HTTP 403 /
DNS failure); verification below uses web search results only. Items are labelled VERIFIED (search result shows the
bibliographic record or official page) or UNVERIFIED (record seen only indirectly).

## New references
| Reference | Evidence | Status |
|---|---|---|
| Nguyen, T. T. (2025). Ownership structure and corporate social responsibility: Evidence from Vietnam. SAJE 13(2), 67-98 | so05.tci-thaijo.org/index.php/saje/article/view/269458 and PDF header "Southeast Asian Journal of Economics Vol.13(2), August 2025: 67-98"; abstract: 87 consumer-goods firms, 2017-2019, foreign ownership positive, government and family ownership negative | VERIFIED (no DOI found) |
| Sudsawasd, S., & Sakdapat, P. (2026). Transaction costs and stock market behavior: Evidence from Thailand. SAJE 14(1), 257-287 | so05.tci-thaijo.org/index.php/saje/article/view/278464; abstract: brokerage fees, SET 2013-2022; local institutional investors respond in the long run, foreign and retail in the short run | VERIFIED (no DOI found) |
| Prukumpai, S., Sethapramote, Y., & Luangaram, P. (2022). Political uncertainty and the Thai stock market. SAJE 10(3), 227-257 | so05.tci-thaijo.org/index.php/saje/article/view/262745; search summary: vol 10(3), pp. 227-257, December 2022; stock prices fall in response to uncertainty | VERIFIED (no DOI found) |
| Crump, R. K., Hotz, V. J., Imbens, G. W., & Mitnik, O. A. (2009). Dealing with limited overlap in estimation of average treatment effects. Biometrika 96(1), 187-199. doi:10.1093/biomet/asn055 | ideas.repec.org/a/oup/biomet/v96y2009i1p187-199.html; scholars.duke.edu/publication/712388 | VERIFIED |

Claim support (S2-78): each new citation supports only the claim attached to it in the text (Nguyen: ownership and
CSR scores; Sudsawasd & Sakdapat: investor groups respond differently to trading costs; Prukumpai et al.: political
uncertainty moves Thai stock prices; Crump et al.: limited overlap and trimming).

## Working papers kept (editor E3)
| Reference | Search result | Status |
|---|---|---|
| Berg, Fabisik & Sautner (2020), ECGI Finance WP 708/2020 | ECGI page and SSRN 3722087; no journal version found | still a working paper as far as search shows |
| Berg, Heeb & Kölbel (2022), "The economic impact of ESG ratings" | MIT Sloan WP 6787-22, SAFE WP; no journal version found | still a working paper as far as search shows |

## Institutional facts (C-65, O-06)
| Claim in the paper | Source seen | Status |
|---|---|---|
| Bursa Malaysia sustainability statement, FY ending on/after 31 Dec 2016, phased | sseinitiative.org fact sheet: "staggered basis over a period of 3 years, starting from 31 December 2016 to 31 December 2018" | consistent |
| SGX Rule 711A, FY ending on/after 31 Dec 2017, comply or explain | rulebook.sgx.com and SGX guide extract: "for financial years ending on or after 31 December 2017" | consistent |
| SEC Philippines MC No. 4 s.2019, 2019 annual reports | citation unchanged from round 0 | not re-checked (unchanged text) |
| OJK POJK 51/2017 applies to listed companies from 2020 | OJK SEOJK summaries: first reporting period FY2020 (submitted 30 April 2021), later deferred by relaxation letters | consistent with "applies from 2020"; deferral not mentioned in the paper |
| Thailand 56-1 One Report from FY ending 2021 | Conventus Law / Tilleke & Gibbins: new form from 1 Jan 2022 for FY ending 31 Dec 2021 | consistent |
| Bursa Malaysia-LSEG MoU, November 2022, FTSE Russell scores extended to all PLCs, about 30% covered before | crowdfundinsider, theedgemalaysia, mondovisione (2 Nov 2022) | consistent |
| Refinitiv/LSEG: scores for the five most recent fiscal years non-definitive; coverage expands as indices are added | LSEG 2019/2022 methodology PDFs (search extracts) | consistent; cited through Sahin et al. (2023) and Berg et al. (2020) |

No treatment variable in this paper is coded from a rule date (coverage timing comes from the score data), so the
year-by-unit coding check of C-66 applies only to G (first recorded score year): G is the first fiscal year with a
non-missing ESG_Score (01_data.R lines 11-14); 17 scored firms have later gaps (coverage_gaps.csv).

## Journal requirements (O-65)
See 03_saje_checklist.md.

## Round 2 additions (2026-10-26)
- Bikmetova & Pirinsky (2026), JBE 204(2) 335–365, doi 10.1007/s10551-025-06063-0: VERIFIED by WebSearch (Springer and RePEc pages; online July 2025). Claim "lower emissions and more ownership by high-ESG institutions" matches the abstract.
- Tsang, Wang, Xiang & Yu (2025), CGIR 33(4) 554–577, doi 10.1111/corg.12615: VERIFIED by WebSearch (Wiley page). Coverage initiation followed by dividend increases; sample includes non-U.S. firms, so the introduction now says "Studies, mostly of U.S. firms".
- LSEG (2023) RDP ESG Bulk PIT user guide, Document Version v2, June 2023: VERIFIED by WebSearch 2026-10-26 (developers.lseg.com PDF cover).
