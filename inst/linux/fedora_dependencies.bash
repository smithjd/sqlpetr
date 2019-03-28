#! /bin/bash

echo "Installing Linux dependencies"
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
echo "Adding you to the 'docker' group"
sudo usermod -aG docker ${USER}
echo "Enabling and starting the Docker service"
sudo systemctl enable --now docker.service
echo "You will need to log out to the display manager prompt"
echo "and log back in again to use the 'docker' command."
