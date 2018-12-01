#! /bin/bash

sudo apt-get install -qqy --no-install-recommends \
  libmagick++-dev \
  libpoppler-cpp-dev \
  qpdf
./install_me.R
