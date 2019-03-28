#! /bin/bash

echo "Installing 'sqlpetr' prerequisites"
echo "Installing Linux dependencies"
sudo apt-get update && sudo apt-get install -qqy --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  libcurl4-openssl-dev \
  libpq-dev \
  libssl-dev \
  libxml2-dev \
  r-base \
  r-base-dev \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"
sudo apt-get update && sudo apt-get install -qqy --no-install-recommends \
  docker-ce \
  docker-ce-cli \
  containerd.io
echo "Adding you to the 'docker' group"
sudo usermod -aG docker ${USER}
echo "Enabling and starting the Docker service"
sudo systemctl enable --now docker.service
echo "You will need to log out to the display manager prompt"
echo "and log back in again to use the 'docker' command."
