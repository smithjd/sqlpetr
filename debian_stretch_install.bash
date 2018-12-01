#! /bin/bash

sudo apt-get install -qqy --no-install-recommends \
  libmagick++-dev \
  libpoppler-cpp-dev \
  libpq-dev \
  libpqxx-dev \
  libv8-3.14-dev \
  qpdf
./install_me.R
