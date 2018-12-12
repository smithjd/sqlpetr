#! /bin/bash

sudo apt-get update
sudo apt-get install -qqy --no-install-recommends \
  bzip2 \
  libpq-dev \
  libpqxx-dev \
  libxml2-dev \
  qpdf \
  wget \
  zlib1g-dev
./install_me_linux.R
