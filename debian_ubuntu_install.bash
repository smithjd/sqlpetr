#! /bin/bash

sudo apt-get update
echo "Installing prerequisites"
sudo apt-get install curl ca-certificates
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo apt-get install -qqy --no-install-recommends \
  bzip2 \
  libcurl4-openssl-dev \
  libpq-dev \
  libpqxx-dev \
  libssh2-1-dev \
  libssl-dev \
  libxml2-dev \
  postgresql-client-10 \
  pgadmin4 \
  qpdf \
  wget \
  zlib1g-dev
./install_me_linux.R
