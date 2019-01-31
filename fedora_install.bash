#! /bin/bash

sudo dnf install -y \
  libcurl-devel \
  libpqxx-devel \
  libssh2-devel \
  libxml2-devel \
  openssl-devel \
  postgresql-libs \
  qpdf
./install_me_linux.R
xdg-open docs/index.html
