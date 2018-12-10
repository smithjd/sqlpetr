#! /bin/bash

echo "You will need the Arch User Repository and 'yaourt'!!"
yaourt --aur --sync --noconfirm --needed \
  libpqxx \
  postgresql-libs \
  qpdf
./install_me_linux.R
