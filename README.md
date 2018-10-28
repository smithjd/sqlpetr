sqlpetr
================

## Introduction

`sqlpetr` is the companion R package for the database tutorial eBook at
<https://github.com/smithjd/sql-pet>. It has two classes of functions:

1.  Functions to install the dependencies needed to build the book and
    perform the operations covered in the tutorial, and
2.  Utilities for dealing with Docker and the PostgreSQL Docker image we
    use.

If you are working on the book, you will need to install this package
first. `sqlpetr` has a `pkgdown` site at
<https://smithjd.github.io/sqlpetr/>,

## Installing

1.  Install `devtools` if you haven’t already; you’ll need it to install
    this package.
2.  Clone this repository and open it with RStudio.
3.  Source the file `install_me.R`. The script will install the package
    and rebuild the `pkgdown` site.

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
browser. The `install_me.R` script rebuilds the site after installing.

For more detail on `pkgdown`, see <https://pkgdown.r-lib.org/>.
