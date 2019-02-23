#! /bin/bash

sudo pacman --sync --noconfirm --needed \
  pgadmin4 \
  postgresql-libs \
  psqlodbc \
  qpdf \
  unixodbc
./install_me_linux.R
