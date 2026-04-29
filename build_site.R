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

# Stage rendered output
system("git add docs/*")

# Stage all source files
source_files <- c(
  "index.qmd",
  "custom.scss",
  "_quarto.yml",
  "build_site.R"
)

# Stage any project pages added later
project_pages <- Sys.glob(c("project*.qmd", "mp*.qmd"))

for (f in c(source_files, project_pages)) {
  if (file.exists(f)) system(paste("git add", shQuote(f)))
}

message("✅ Site rendered and files staged.")
message("   → Git pane: Commit all → Push")

if (!any(grepl("rstudio", search()))) { q("no") }
