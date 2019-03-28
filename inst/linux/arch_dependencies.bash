#! /bin/bash

sudo pacman --sync --noconfirm --needed \
  base \
  base-devel \
  docker \
  gcc-fortran \
  postgresql-libs \
  r
