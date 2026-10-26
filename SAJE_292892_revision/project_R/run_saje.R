# run_saje.R: analyses added for the Southeast Asian Journal of Economics revision (manuscript 292892).
# Usage (from project_R/, after run_all.R):  LANG=C.UTF-8 Rscript run_saje.R
t0 <- Sys.time()
source("R/00_setup.R")
source("R/01_data.R")
source("R/02_cs_did.R")
source("R/03c_saje.R")
source("R/04c_saje_tables.R")
source("R/05c_numbers_saje.R")
source("R/06_figures_saje.R")   # final figures (overwrite the drafts from 04 and 04b)
cat("Done in", round(as.numeric(difftime(Sys.time(), t0, units = "mins")), 1), "minutes\n")
