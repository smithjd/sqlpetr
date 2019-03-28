#! /bin/bash

sudo pacman --sync --noconfirm --needed \
  base \
  base-devel \
  gcc-fortran \
  postgresql-libs \
  r
