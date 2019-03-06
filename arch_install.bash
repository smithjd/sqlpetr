#! /bin/bash

echo "You will need the Arch User Repository (AUR) and the AUR helper 'yay'"
yay --sync --noconfirm --needed \
  pgadmin4 \
  postgresql-libs-10 \
  qpdf
./install_me_linux.R
