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

# Stage ALL rendered output — including docs/projects/ subfolder
system("git add -A docs/")

# Stage all source files at root
for (f in c("index.qmd", "custom.scss", "_quarto.yml", "build_site.R")) {
  if (file.exists(f)) system(paste("git add", shQuote(f)))
}

# Stage all source files in projects/ subfolder
project_files <- Sys.glob("projects/*.qmd")
for (f in project_files) {
  system(paste("git add", shQuote(f)))
}

message("✅ Site rendered and ALL files staged (including docs/projects/).")
message("   → Git pane: Commit all → Push")

if (!any(grepl("rstudio", search()))) { q("no") }
