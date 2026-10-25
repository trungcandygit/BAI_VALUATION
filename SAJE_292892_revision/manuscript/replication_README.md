# Replication package — "Who Gets an ESG Score? Coverage Selection and Firm Value in Five Southeast Asian Markets"

## Requirements
R 4.3 or later with packages readxl, dplyr, tidyr, ggplot2, plm, sandwich (parallel is part of base R).
The licensed input file `DATA GW2.xlsx` (LSEG ESG scores and Compustat Global fundamentals, ASEAN-5, 2014–2024) is not
included; place it at `../Dữ liệu ban đầu và thô/DATA GW2.xlsx` relative to this folder (path set in `R/00_setup.R`).

## Run
    LANG=C.UTF-8 Rscript run_all.R        # about 30 minutes on 4 cores; seed 20260925; B = 999
    LANG=C.UTF-8 Rscript validation/validate_estimator.R   # estimator checks (optional)
Reruns reproduce every CSV byte for byte.

## Exhibit ↔ output map
| Manuscript item | Output file |
|---|---|
| Table 1 | outputs/table1_formatted.csv (raw: table1_raw.csv) |
| Table 2 | outputs/table2_formatted.csv (raw: att_main.csv, pretrend_tests.csv) |
| Figure 1 | outputs/figures/Fig1.eps, Fig1.png (data: event_study.csv) |
| Figure 2 | outputs/figures/Fig2.eps, Fig2.png (data: r4_event_profiles.csv) |
| Table 3 | outputs/table3_formatted.csv (raw: att_main.csv, robustness.csv, twfe_static.csv, robustness_revision.csv, robustness_revision2.csv, heterogeneity_initial_score.csv) |
| Table S1 | outputs/tableIA1_formatted.csv (raw: leave_one_market_out.csv) |
| Table S2, Figure S1 | outputs/tableIA2_formatted.csv, outputs/figures/FigIA1.* (raw: cohort_sizes.csv) |
| Table S3 to S6 | outputs/tableIA3_formatted.csv to tableIA6_formatted.csv (raw: per_market.csv, rm_bounds.csv, firms_by_event_time.csv) |
| Table S7, Figure S2 | outputs/tableIA7_formatted.csv, outputs/figures/FigIA2.* (raw: r4_post.csv, r4_pretrend_tests.csv, r4_event_profiles.csv, r4_cluster_bootstrap.csv, r4_cluster_pretrend.csv, r4_h3_residual_score.csv) |
| Table S8 | outputs/tableIA8_formatted.csv (raw: r4_twfe_bridge.csv) |
| Numbers quoted in the text | outputs/numbers.csv (key → formatted value) |
| Sample construction | outputs/sample_flow.csv, coverage_gaps.csv |
| Group-time effects | outputs/att_gt.csv |
| Estimator validation | outputs/validation.csv |

## Pre-analysis plan
`pre_analysis_plan.md` was committed before any effect was estimated. Rows R7–R11 of Table 3, Tables S1, S3,
S5, S7, S8 and Figures 2 and S2 were added after review rounds (scripts 03_estimate.R revision sections, 03b_round4.R,
04b_round4_exhibits.R) and are labeled exploratory in the paper.
