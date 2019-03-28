#! /bin/bash

echo "Installing 'sqlpetr' prerequisites"
sudo apt-get update && \
  sudo apt-get install -qqy --no-install-recommends \
    libcurl4-openssl-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    r-base \
    r-base-dev
