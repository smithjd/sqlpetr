update.packages(ask = FALSE)
install.packages("devtools")
devtools::install(dependencies = TRUE, build_vignettes = TRUE)
cat("\nTrying 'tinytex::install_tinytex()'")
cat("\nYou can ignore errors\n")
try(tinytex::install_tinytex())
webshot::install_phantomjs()
pkgdown::clean_site()
pkgdown::build_site(lazy = FALSE)

# flag this as a non-Jekyll site for GitHub Pages
file.create("./docs/.nojekyll")
