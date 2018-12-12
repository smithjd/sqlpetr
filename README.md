sqlpetr
================

Introduction
------------

`sqlpetr` is the companion R package for the database tutorial eBook at <https://github.com/smithjd/sql-pet>. It has two classes of functions:

1.  Functions to install the dependencies needed to build the book and perform the operations covered in the tutorial, and
2.  Utilities for dealing with Docker and the PostgreSQL Docker image we use.  These are typically `system2` calls which have two parts:; the first is the command stub (e.g., "docker") and the second contains the parameters (e.g., send "ps -a" to `docker`).

`sqlpetr` has a `pkgdown` site at <https://smithjd.github.io/sqlpetr/>.

Installing for users of <https://smithjd.github.io/sql-pet>
-----------------------------------------------------------

If you are working through the code in the book, you will need to install this package first. Note that these instructions assume Windows or MacOS. For Linux, you will need to install some Linux packages and edit a configuration file. See below for the details on Ubuntu "Bionic Beaver".

1.  Install `devtools` if you haven't already; you'll need it to install this package.
2.  In an R console, type `devtools::install_github("smithjd/sqlpetr", force = TRUE, build_vignettes = TRUE)`.

Developer workflow
------------------

If you're working as a developer of this package or the book, you'll need to install more dependencies. To do that:

1.  Clone this repository and open the project file `sqlpetr.Rproj` in RStudio.
2.  Open the file `install_me.R` and `source` it. This will install all the dependencies and rebuild the `pkgdown` site for the package.

For more details on R package development, see [R Packages](http://r-pkgs.had.co.nz/).

Pkgdown
-------

This package uses `pkgdown` to build a package documentation site on GitHub Pages. The site is hosted at <https://smithjd.github.io/sqlpetr>. Once you've added a function, go to the RStudio Addins dropdown and select "Build pkgdown". This will render the site and open it in your browser. The `install_me.R` script rebuilds the site after installing.

For more detail on `pkgdown`, see <https://pkgdown.r-lib.org/>.

Installing on Ubuntu "Bionic Beaver"
------------------------------------

### Ubuntu packages you need to install

R packages are usually built from source on Linux. Before you can build this package and its dependencies from source, you will need to install the following Ubuntu packages with `sudo apt-get install`:

    sudo apt-get install \
      libssl-dev \
      libcurl4-openssl-dev \
      libmagick++-dev \
      libpoppler-cpp-dev \
      libv8-3.14-dev \
      libpq-dev

### Fixing the ImageMagick policy file

A recent security update to the library we use to write images to PDF files has caused errors trying to write PDFs. You will see the error

    <Magick::ErrorPolicy in magick_image_write(image, format, quality, depth, density, comment): Magick: not authorized `PDF:/tmp/RtmpMHXxNk/magick-12720uFi-fA7hwBIB' @ error/constitute.c/WriteImage/1037>
    Error in magick_image_write(image, format, quality, depth, density, comment) : 
      Magick: not authorized `PDF:/tmp/RtmpMHXxNk/magick-12720uFi-fA7hwBIB' @ error/constitute.c/WriteImage/1037

To fix this, you need to become `root` and edit the file `/etc/ImageMagick-6/policy.xml`. Find the line

    <policy domain="coder" rights="none" pattern="PDF" />

and change `none` to `all`.
