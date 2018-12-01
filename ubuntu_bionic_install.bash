#! /bin/bash

sudo apt-get install -qqy --no-install-recommends \
  libmagick++-dev \
  libpoppler-cpp-dev \
  libpq-dev \
  libv8-3.14-dev \
  qpdf
sudo sed -i.bak '/<policy domain="coder" rights="none" pattern="PDF" \/>/d' /etc/ImageMagick-6/policy.xml
./install_me.R
