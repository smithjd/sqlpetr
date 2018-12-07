#! /bin/bash

sudo apt-get update
sudo apt-get install -qqy --no-install-recommends \
  libmagick++-dev \
  libpoppler-cpp-dev \
  libpq-dev \
  libpqxx-dev \
  libv8-3.14-dev \
  qpdf
sudo sed -i.bak '/<policy domain="coder" rights="none" pattern="PDF" \/>/d' /etc/ImageMagick-6/policy.xml
R -e "source('install_me_linux.R')"
