#! /bin/bash

echo "Installing Linux dependencies"
sudo dnf install -y \
  dnf-plugins-core \
  libcurl-devel \
  libxml2-devel \
  openssl-devel \
  postgresql-devel \
  R
sudo dnf config-manager --add-repo \
  https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io
