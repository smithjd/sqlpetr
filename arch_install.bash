#! /bin/bash

sudo pacman --sync --noconfirm --needed \
  libpqxx \
  postgresql-libs \
  qpdf
./install_me_linux.R
xdg-open docs/index.html
