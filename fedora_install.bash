#! /bin/bash

echo "Installing PostgreSQL 10 repo"
sudo dnf install -y \
  https://download.postgresql.org/pub/repos/yum/10/fedora/fedora-29-x86_64/pgdg-fedora10-10-4.noarch.rpm
echo "Installing Linux dependencies"
sudo dnf install -y \
  libcurl-devel \
  libssh2-devel \
  libxml2-devel \
  openssl-devel \
  pgadmin4-desktop-gnome \
  postgresql10 \
  postgresql10-devel \
  postgresql10-odbc \
  qpdf \
  unixODBC \
  unixODBC-devel
echo "Installing 'sqlpetr'"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/pgsql-10/lib/pkgconfig
./install_me_linux.R
