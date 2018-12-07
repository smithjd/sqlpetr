update.packages(ask = FALSE)
install.packages("devtools", quiet = TRUE)
devtools::install(dependencies = TRUE, build_vignettes = TRUE)
pkgdown::clean_site()
pkgdown::build_site(lazy = FALSE)

# flag this as a non-Jekyll site for GitHub Pages
file.create("./docs/.nojekyll")
