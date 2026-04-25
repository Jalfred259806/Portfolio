#!/usr/bin/env Rscript
# ============================================================
#  build_site.R  –  Render & stage Javier's portfolio
# ============================================================

if (!require("quarto")) install.packages("quarto")
library(quarto)

if (!quarto::quarto_binary_sitrep()) {
  stop("Something is wrong with your quarto installation.")
}

# Render the entire site into docs/
quarto::quarto_render(".")

# Stage all rendered docs
system("git add docs/*")

# Stage source files
source_files <- c(
  "index.qmd",
  "styles.css",
  "_quarto.yml",
  "build_site.R"
)

# Stage any project write-up files (mp*.qmd, project*.qmd)
project_qmds <- Sys.glob(c("mp*.qmd", "project*.qmd"))

for (f in c(source_files, project_qmds)) {
  if (file.exists(f)) system(paste("git add", f))
}

message("✅ Site rendered and files staged. Now Commit & Push in RStudio's Git pane.")

if (!any(grepl("rstudio", search()))) { q("no") }
