#! /bin/bash

echo "Installing PostgreSQL Global Development Group (PGDG) repository"
sudo dnf install -y \
  https://download.postgresql.org/pub/repos/yum/10/fedora/fedora-29-x86_64/pgdg-fedora10-10-4.noarch.rpm
echo "Installing pgAdmin4 and Linux dependencies"
sudo dnf install -y \
  libcurl-devel \
  libpqxx-devel \
  libssh2-devel \
  libxml2-devel \
  openssl-devel \
  pgadmin4-desktop-gnome \
  pgrouting_10 \
  postgis25_10-devel \
  postgresql10-devel \
  qpdf
echo "Installing 'sqlpetr'"
./install_me_linux.R
xdg-open docs/index.html
