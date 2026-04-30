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

# Stage root source files
for (f in c("index.qmd", "custom.scss", "_quarto.yml", "build_site.R")) {
  if (file.exists(f)) system(paste("git add", shQuote(f)))
}

# Stage everything in projects/ folder (qmd + assets + files subfolders)
system("git add -A projects/")

message("✅ Done! All files staged including projects/ assets.")
message("   → Git pane: Commit → Push")

if (!any(grepl("rstudio", search()))) { q("no") }
