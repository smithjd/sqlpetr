sqlpetr
================

## Introduction

This is the companion R package for the database tutorial we are writing
at <https://github.com/smithjd/sql-pet>. The plan is to have two classes
of functions:

1.  Functions to install the dependencies needed to build the book and
    perform the operations covered in the tutorial, and
2.  Provide some useful utilities for dealing with Docker in general and
    the PostgreSQL Docker image we are using.

This package has a `pkgdown` site at
<https://smithjd.github.io/sqlpetr/>,

## Installing

You will need `devtools` to install this package. 

If you want to work on it, you will need RStudio 1.2.1015 (currently in preview) or later,
`devtools`, `roxygen2` and `pkgdown`. To install, clone this repository, `cd` into it and type
`devtools::install()`.

To just use the package, you need `devtools` and use `devtools::install_github("smithjd/sqlpetr")`.

## Developer workflow

See [R Packages](http://r-pkgs.had.co.nz/) for the details, but briefly;

1.  Code a function with `roxygen2` comments in it. Test it.
2.  When the function does what it’s supposed to do, go to the RStudio
    `Build` tab. Press the `Check` button. This will run `R CMD check`.
3.  Fix any errors, then when the check passes, press the “Install and
    Restart” button.

## Pkgdown

This package uses `pkgdown` to build a package documentation site on
GitHub Pages. The site is hosted at <https://smithjd.github.io/sqlpetr>.
Once you’ve added a function, go to the RStudio Addins dropdown and
select “Build pkgdown”. This will render the site and open it in your
browser.

For more detail on `pkgdown`, see <https://pkgdown.r-lib.org/>.