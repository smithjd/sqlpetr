sqlpetr
================

## Introduction

`sqlpetr` is the companion R package for the database tutorial eBook at
<https://github.com/smithjd/sql-pet>. It has two classes of functions:

1.  Functions to install the dependencies needed to build the book and
    perform the operations covered in the tutorial, and
2.  Utilities for dealing with Docker and the PostgreSQL Docker image we
    use.

`sqlpetr` has a `pkgdown` site at <https://smithjd.github.io/sqlpetr/>.

## Prerequisites

You will need the following software:

1.  R 3.5.1 or later:
      - For Windows, go to <https://cran.rstudio.com/bin/windows/base/>.
      - For MacOS, go to <https://cran.rstudio.com/bin/macosx/>.
2.  R source package development tools:
      - For Windows, go to
        <https://cran.rstudio.com/bin/windows/Rtools/> and install
        `Rtools35.exe`.
      - For MacOS, go to <https://cran.rstudio.com/bin/macosx/tools/>
        and install the packages for your MacOS version.
3.  Git:
      - For Windows, use Git for Windows
        (<https://git-scm.com/download/win>).
      - For MacOS, see
        <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>
        for the options.
4.  RStudio Preview 1.2.1186 or later
    (<https://www.rstudio.com/products/rstudio/download/preview/>).
5.  Docker:
      - For Windows 10 Pro, use Docker for Windows
        (<https://docs.docker.com/docker-for-windows/install/>).
      - For other versions of Windows, use Docker Toolbox
        (<https://docs.docker.com/toolbox/overview/>).
      - For MacOS El Capitan 10.11 or newer macOS release running on a
        2010 or newer Mac, with Intel’s hardware support for MMU
        virtualization, use Docker for Mac
        (<https://docs.docker.com/v17.12/docker-for-mac/install/>).
      - For other versions of MacOS, use Docker Toolbox
        (<https://docs.docker.com/toolbox/overview/>).

See below for the details if you’re a Linux desktop
user.

## Installing this package for users of <https://smithjd.github.io/sql-pet>

If you are working through the code in the book, you will need to
install this package first. Note that these instructions assume Windows
or MacOS. For Linux, you will need to install some Linux packages. See
below for the details on Ubuntu “Bionic Beaver”, Debian “stretch” or
Arch Linux.

1.  Make sure you have a writeable personal library.

2.  Update all your packages with `update.packages()`.

3.  Install `devtools` if you haven’t already.

4.  In an R console, type
    
        devtools::install_github("smithjd/sqlpetr", force = TRUE)

## Developer workflow

If you’re working as a developer of this package or the book, you’ll
need to install more dependencies. To do that:

1.  Clone this repository and open the project file `sqlpetr.Rproj` in
    RStudio.

2.  On Windows or MacOS, open the file `install_me.R` and `source` it.
    This will install all the dependencies and rebuild the `pkgdown`
    site for the package.
    
    On Windows, you may get a dialog box asking you if you want to use a
    personal library. If you do, press the `Yes` button. If you get a
    dialog box asking if you want to install source packages, press the
    `Yes` button.

For more details on R package development, see [R
Packages](http://r-pkgs.had.co.nz/).

## Pkgdown

This package uses `pkgdown` to build a package documentation site on
GitHub Pages. The site is hosted at <https://smithjd.github.io/sqlpetr>.
Once you’ve added a function, go to the RStudio Addins dropdown and
select “Build pkgdown”. This will render the site and open it in your
browser. The `install_me.R` script rebuilds the site after installing.

For more detail on `pkgdown`, see <https://pkgdown.r-lib.org/>.

## `webshot` and `phantomjs`

The `webshot` CRAN package converts `htmlwidgets` widgets to HTML or PDF
in the `bookdown` rendering process. See
<https://bookdown.org/yihui/bookdown/html-widgets.html>. `webshot` uses
the “headless browser” `phantomjs` to do this. You do not need to do
anything; they’re installed when you run `install_me.R`.

## `TinyTex`

CRAN package `tinytex` (<https://yihui.name/tinytex/>) is a relatively
new tool for dealing with LaTeX packages. It is a standard package in
the Tidyverse, so if you have the Tidyverse, you have `tinytex`.
`install_me.R` will install the run-time components via
`tinytex::install_tinytex()` if you haven’t installed it already.

Note that if you already have a system-wide LaTeX install, `tinytex`
will not override it by default. You’ll see an error message if that
happens, but your system will still work.

## Developing and testing on Linux

As with Windows and MacOS, you’ll need

  - R 3.5.1 or later, including all the package development tools,
  - RStudio Preview 1.2.1186 or later,
  - `git`, and
  - Docker. You’ll need to use Docker Community Edition
    (<https://store.docker.com/search?q=docker%20ce&type=edition&offering=community>)
    rather than the Docker that is packaged in the distro.

Once you have the prerequisites installed, make sure your user ID is
allowed to execute the `sudo` operation. Then, clone this repo, `cd`
into it, and type

  - Debian 9.6 “stretch” or Ubuntu 18.04 LTS “Bionic Beaver”:
    `./debian_ubuntu_install.bash`,
  - Arch Linux (requires Arch User Repository and `yaourt`):
    `./arch_install.bash`.

If you want to use another distro (supported by Docker CE, please - we
don’t have the bandwidth to support other Docker versions) open an issue
at <https://github.com/smithjd/sqlpetr/issues/new>.
