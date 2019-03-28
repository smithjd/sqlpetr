#! /bin/bash

echo "Installing Linux dependencies"
sudo pacman --sync --noconfirm --needed \
  base \
  base-devel \
  docker \
  gcc-fortran \
  postgresql-libs \
  r
echo "Adding you to the 'docker' group"
sudo usermod -aG docker ${USER}
echo "Enabling and starting the Docker service"
sudo systemctl enable --now docker.service
echo "You will need to log out to the display manager prompt"
echo "and log back in again to use the 'docker' command."
