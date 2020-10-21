#!/usr/bin/env bash

# Update Package Sources
sudo apt-get update

# Install Tools
sudo apt-get install -y vim htop dnsutils less git wget

# Install Docker
echo "Installing docker"
sudo apt-get purge docker lxc-docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install EE
echo "Installing easyengine"
wget -qO ee rt.cx/ee4 && sudo bash ee

# Install a mysql client
echo "Installing mysql client"
apt-get install -y default-mysql-client

# END
echo "COMPLETED"