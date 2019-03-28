#! /bin/bash

echo "Installing Linux dependencies"
sudo dnf install -y \
  libcurl-devel \
  libxml2-devel \
  openssl-devel \
  postgresql-devel \
  R
