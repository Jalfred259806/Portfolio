#!/usr/bin/env Rscript
# ============================================================
#  build_site.R  —  Render & stage Javier's portfolio
# ============================================================

if (!require("quarto")) install.packages("quarto")
library(quarto)

if (!quarto::quarto_binary_sitrep()) {
  stop("Something is wrong with your quarto installation.")
}

# Render entire site into docs/
quarto::quarto_render(".")

# Stage ALL rendered output recursively
system("git add -A docs/")

# Stage all source .qmd files at root level
qmd_files <- Sys.glob("*.qmd")
for (f in qmd_files) {
  system(paste("git add", shQuote(f)))
}

# Stage config and style files
for (f in c("custom.scss", "_quarto.yml", "build_site.R")) {
  if (file.exists(f)) system(paste("git add", shQuote(f)))
}

message("✅ Done! All files staged.")
message("   → Git pane: Commit → Push")

if (!any(grepl("rstudio", search()))) { q("no") }
