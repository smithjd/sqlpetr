#! /bin/bash

sudo apt-get update
sudo apt-get install -qqy --no-install-recommends \
  libpq-dev \
  libpqxx-dev \
  qpdf \
  wget
./install_me_linux.R
