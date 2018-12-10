#! /usr/bin/env Rscript

# Why is this script so much more complicated than `install_me.R`?
#
# `install_me.R` is designed to work in RStudio, using the `Source` button
# on the script development tab. RStudio provides some default environment
# settings to make that possible,
#
# This script is designed to run on a Linux system, called from a `bash` script
# that installs the distro-specific Linux packages it needs. So it needs to
# create the personal library if it doesn't exist and update packages first.
#
# create personal library if it doesn't exist
CRAN <- "https://cloud.r-project.org/" # CRAN URL
LIB <- Sys.getenv("R_LIBS_USER") # library path
if (!dir.exists(LIB)) {
  dir.create(LIB, recursive = TRUE, mode = '0755')
}
.libPaths(LIB) # add to search path

cat("\nUpdating packages into user library")
cat("\nYou can ignore warnings about not updating packages")
cat("\nThis can take some time\n")
update.packages(ask = FALSE, instlib = LIB, repos = CRAN, quiet = TRUE)
cat("\nInstalling `devtools`\n")
install.packages("devtools", lib = LIB, repos = CRAN, quiet = TRUE)
cat("\nInstalling `sqlpetr` with all dependencies\n")
devtools::install(dependencies = TRUE, quiet = TRUE)
pkgdown::clean_site()
pkgdown::build_site(lazy = FALSE)

# flag this as a non-Jekyll site for GitHub Pages
file.create("./docs/.nojekyll")
