# 00_setup.R: packages, paths, constants. Sourced by run_all.R (working directory = project_R/).
suppressPackageStartupMessages({
  library(readxl); library(dplyr); library(tidyr); library(ggplot2); library(plm); library(sandwich)
})
options(dplyr.summarise.inform = FALSE, stringsAsFactors = FALSE)

N_CORES  <- max(1L, min(4L, parallel::detectCores()))
SEED     <- 20260925L   # fixed seed for every bootstrap
B_BOOT   <- as.integer(Sys.getenv("B_BOOT", "999"))   # cluster (firm) bootstrap replications
DATA_XLS <- file.path("..", "Dữ liệu ban đầu và thô", "DATA GW2.xlsx")
OUT      <- "outputs"
FIG      <- file.path(OUT, "figures")
dir.create(FIG, recursive = TRUE, showWarnings = FALSE)

E_MIN <- -5L; E_MAX <- 4L      # event window reported in the event study
POST_MAX <- 3L                 # ATT_post averages event times 0..3
PRE_TEST <- -5:-2              # joint pre-trend test (e = -1 is the base period)

write_out <- function(df, name) {
  # Fixed formatting so that reruns are byte-identical.
  df <- as.data.frame(df)
  num <- vapply(df, is.numeric, logical(1))
  df[num] <- lapply(df[num], function(x) ifelse(is.na(x), NA, trimws(formatC(x, digits = 10, format = "g"))))
  write.csv(df, file.path(OUT, name), row.names = FALSE, na = "")
}
