# 06_figures_saje.R: final figures for the SAJE revision, redrawn from the output CSVs with one house style.
# Writes outputs/figures/Fig1, Fig2, FigIA1 (Figure S1) and FigIA2 (Figure S2), each as .pdf (cairo, fonts
# embedded), .eps and 600-dpi .png at the printed width of 6.5 in. Overwrites the drafts from 04 and 04b.
# Style: no gridlines, one sans-serif family, text at 9.5 pt or more at print size, solid interval bars,
# marker shape plus an Okabe-Ito colour for every group (legible in grayscale), legend below without a box.

if (!exists("strip_eps_date")) strip_eps_date <- function(f) {   # drop %%CreationDate so reruns are byte-identical
  x <- readLines(f, warn = FALSE); writeLines(x[!grepl("^%%CreationDate", x)], f)
}
FONT <- "Liberation Sans"   # metric-compatible with Arial
OKABE <- c("#000000", "#0072B2", "#D55E00", "#009E73")
minus <- function(x) sub("^-", "−", as.character(x))
theme_saje <- function() {
  theme_classic(base_size = 10.5, base_family = FONT) +
    theme(axis.text = element_text(size = 9.5, colour = "black"), axis.title = element_text(size = 10),
          axis.line = element_line(linewidth = 0.4), axis.ticks = element_line(linewidth = 0.4),
          strip.background = element_blank(), strip.text = element_text(size = 10, face = "bold", hjust = 0),
          legend.position = "bottom", legend.text = element_text(size = 9.5), legend.key.width = unit(1.2, "lines"),
          legend.background = element_blank(), legend.key = element_blank(), legend.margin = margin(0, 0, 0, 0),
          panel.spacing = unit(1, "lines"), plot.margin = margin(4, 8, 4, 4))
}
save_fig <- function(p, name, h, w = 6.5) {
  ggsave(file.path(FIG, paste0(name, ".pdf")), p, width = w, height = h, device = cairo_pdf)
  ggsave(file.path(FIG, paste0(name, ".eps")), p, width = w, height = h, device = cairo_ps)
  strip_eps_date(file.path(FIG, paste0(name, ".eps")))
  ggsave(file.path(FIG, paste0(name, ".png")), p, width = w, height = h, dpi = 600, bg = "white")
}
ref_lines <- list(geom_hline(yintercept = 0, linewidth = 0.4, colour = "grey45"),
                  geom_vline(xintercept = -0.5, linetype = "dashed", linewidth = 0.4, colour = "grey45"))
x_event <- scale_x_continuous(breaks = E_MIN:E_MAX, labels = minus)

# ---- Figure 1: event-time changes, four outcomes ----
OUT4 <- c(ln_mtb = "(a) ln(MTB)", ln_mcap = "(b) ln(market cap)", leverage = "(c) Leverage (ratio)",
          ln_asset = "(d) ln(total assets)")
PER <- c("Before the first recorded score", "From the first recorded score")
ev <- read.csv(file.path(OUT, "event_study.csv")) %>% mutate(e = as.integer(term)) %>%
  select(outcome, e, est, ci_lo, ci_hi) %>%
  bind_rows(data.frame(outcome = names(OUT4), e = -1L, est = 0, ci_lo = NA, ci_hi = NA)) %>%
  mutate(period = factor(ifelse(e < 0, PER[1], PER[2]), levels = PER), panel = factor(OUT4[outcome], levels = OUT4))
f1 <- ggplot(ev, aes(e, est, colour = period, shape = period)) + ref_lines +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0, linewidth = 0.6, na.rm = TRUE) +
  geom_point(size = 2.2, fill = "white", stroke = 0.7) +
  scale_colour_manual(values = OKABE[2:1], name = NULL) + scale_shape_manual(values = c(21, 16), name = NULL) +
  x_event + scale_y_continuous(labels = minus) +
  facet_wrap(~ panel, ncol = 2, scales = "free_y") +
  labs(x = "Years relative to the first recorded LSEG ESG score", y = "Change relative to event year −1") +
  theme_saje()
save_fig(f1, "Fig1", h = 5.2)

# ---- Figure 2: by coverage wave ----
WAVE <- c(wave_MY_2021_22 = "Malaysia 2021–22", wave_TH_SG_2019_20 = "Thailand and Singapore 2019–20",
          wave_other = "Other cohorts")
OUT2P <- c(ln_mtb = "(a) ln(MTB)", ln_mcap = "(b) ln(market cap)")
r4ev <- read.csv(file.path(OUT, "r4_event_profiles.csv")) %>% mutate(e = as.integer(term))
wv <- r4ev %>% filter(spec %in% names(WAVE), outcome %in% names(OUT2P)) %>% select(outcome, spec, e, est, ci_lo, ci_hi) %>%
  bind_rows(expand.grid(outcome = names(OUT2P), spec = names(WAVE), e = -1L, stringsAsFactors = FALSE) %>%
              mutate(est = 0, ci_lo = NA, ci_hi = NA)) %>%
  filter(!is.na(est)) %>%
  mutate(wave = factor(WAVE[spec], levels = WAVE), panel = factor(OUT2P[outcome], levels = OUT2P))
pd <- position_dodge(width = 0.55)
f2 <- ggplot(wv, aes(e, est, colour = wave, shape = wave, group = wave)) + ref_lines +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0, linewidth = 0.55, position = pd, na.rm = TRUE) +
  geom_point(size = 2, fill = "white", stroke = 0.7, position = pd) +
  scale_colour_manual(values = OKABE[c(1, 3, 2)], name = NULL) + scale_shape_manual(values = c(16, 21, 17), name = NULL) +
  x_event + scale_y_continuous(labels = minus) +
  facet_wrap(~ panel, ncol = 1, scales = "free_y") +
  labs(x = "Years relative to the first recorded LSEG ESG score", y = "Change relative to event year −1") +
  theme_saje() + guides(colour = guide_legend(nrow = 1), shape = guide_legend(nrow = 1))
save_fig(f2, "Fig2", h = 5.6)

# ---- Figure S1: firms by year of first recorded score ----
cs <- read.csv(file.path(OUT, "cohort_sizes.csv"))
fs1 <- ggplot(cs, aes(G, total)) + geom_col(fill = "grey55", width = 0.7) +
  scale_x_continuous(breaks = cs$G) + scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(x = "Year of first recorded LSEG ESG score", y = "Non-financial firms") + theme_saje()
save_fig(fs1, "FigIA1", h = 3.4)

# ---- Figure S2: ln(MTB) paths under alternative specifications and dating ----
ALT <- c(baseline = "Baseline", no_covariates = "No covariates", size_at_g3 = "Size at g \u2212 3",
         trim_top_p95 = "Within control size range")
R10 <- c(R10_shift1 = "One year later", R10_size_at_g1 = "One year later, size at g \u2212 1")
alt <- r4ev %>% filter(outcome == "ln_mtb", spec %in% c(names(ALT), names(R10))) %>% select(spec, e, est, ci_lo, ci_hi) %>%
  bind_rows(data.frame(spec = c(names(ALT), names(R10)), e = -1L, est = 0, ci_lo = NA, ci_hi = NA)) %>%
  filter(!is.na(est)) %>%
  mutate(panel = factor(ifelse(spec %in% names(ALT), "(a) Event at the first recorded year", "(b) Event dated one year later")),
         label = factor(c(ALT, R10)[spec], levels = c(ALT, R10)))
fs2 <- ggplot(alt, aes(e, est, colour = label, shape = label, group = label)) + ref_lines +
  geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi), width = 0, linewidth = 0.5, position = pd, na.rm = TRUE) +
  geom_point(size = 1.9, fill = "white", stroke = 0.7, position = pd) +
  scale_colour_manual(values = c(OKABE, OKABE[1:2]), name = NULL) +
  scale_shape_manual(values = c(16, 21, 17, 24, 15, 22), name = NULL) +
  x_event + scale_y_continuous(labels = minus) +
  facet_wrap(~ panel, ncol = 1) +
  labs(x = "Years relative to the event", y = "Change in ln(MTB) relative to event year −1") +
  theme_saje() + guides(colour = guide_legend(nrow = 2), shape = guide_legend(nrow = 2))
save_fig(fs2, "FigIA2", h = 6.4)
