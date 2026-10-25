# overlap_audit.R: text overlap between the new JF:IP manuscript and the companion (original ESG2) manuscript.
# Metric: share of the new section's word 8-grams that also occur anywhere in the original manuscript text.
# Also reports 5-gram overlap as a more sensitive check, and lists every shared 8-gram.
# Inputs: overlap/original_ESG2_text.txt (manuscript text from the GPTZero scan of the original v3, abstract to the
#         end of the scanned discussion) and overlap/new_manuscript_sections.tsv (written by export_sections.py).
# Run from project_R/:  LANG=C.UTF-8 Rscript overlap/overlap_audit.R
suppressPackageStartupMessages(library(dplyr))
tok <- function(x) {
  x <- tolower(gsub("[^A-Za-z0-9]+", " ", x))
  w <- strsplit(trimws(x), "\\s+")[[1]]
  w[nchar(w) > 0]
}
ngrams <- function(w, n) if (length(w) < n) character(0) else
  vapply(seq_len(length(w) - n + 1), function(i) paste(w[i:(i + n - 1)], collapse = " "), "")

orig_txt <- paste(readLines("overlap/original_ESG2_text.txt", warn = FALSE), collapse = " ")
# Section boundaries of the original, located by the first words of each part in the scanned text.
cuts <- c(Abstract = "Abstract:", Introduction = "As societal and regulatory pressures",
          Literature_Hypotheses = "Strong ESG disclosure leads", Data_Methods = "We collect data from multiple databases",
          Results = "We first estimate the baseline relationships", Discussion_Conclusion = "Main results focus on two way")
pos <- vapply(cuts, function(k) regexpr(k, orig_txt, fixed = TRUE)[1], numeric(1))
stopifnot(all(pos > 0))
pos <- c(pos, nchar(orig_txt) + 1)
orig_sec <- setNames(lapply(seq_along(cuts), function(i) substr(orig_txt, pos[i], pos[i + 1] - 1)), names(cuts))
orig_w <- tok(orig_txt)
o8 <- unique(ngrams(orig_w, 8)); o5 <- unique(ngrams(orig_w, 5))

new <- read.delim("overlap/new_manuscript_sections.tsv", quote = "", stringsAsFactors = FALSE)
res <- bind_rows(lapply(seq_len(nrow(new)), function(i) {
  w <- tok(new$text[i]); g8 <- ngrams(w, 8); g5 <- ngrams(w, 5)
  data.frame(section = new$section[i], words = length(w), ngrams8 = length(g8),
             shared8 = sum(g8 %in% o8), pct8 = if (length(g8)) 100 * mean(g8 %in% o8) else 0,
             ngrams5 = length(g5), shared5 = sum(g5 %in% o5), pct5 = if (length(g5)) 100 * mean(g5 %in% o5) else 0)
}))
all_w <- tok(paste(new$text, collapse = " ")); g8 <- ngrams(all_w, 8)
res <- bind_rows(res, data.frame(section = "WHOLE MANUSCRIPT", words = length(all_w), ngrams8 = length(g8),
  shared8 = sum(g8 %in% o8), pct8 = 100 * mean(g8 %in% o8), ngrams5 = NA, shared5 = NA, pct5 = NA))
shared_list <- unique(g8[g8 %in% o8])
dir.create("outputs/overlap", showWarnings = FALSE)
write.csv(res, "outputs/overlap/overlap_by_section.csv", row.names = FALSE)
writeLines(if (length(shared_list)) shared_list else "(none)", "outputs/overlap/shared_8grams.txt")
write.csv(data.frame(section = names(orig_sec), words = vapply(orig_sec, function(s) length(tok(s)), 1)),
          "outputs/overlap/original_sections.csv", row.names = FALSE)
print(res)
