#! /usr/bin/env Rscript

devtools::install(
  ".", dependencies = TRUE, quiet = TRUE, build_vignettes = TRUE)
pkgdown::clean_site()
pkgdown::build_site(lazy = FALSE)

# flag this as a non-Jekyll site for GitHub Pages
file.create("./docs/.nojekyll")
