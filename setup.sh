#!/bin/bash

# Stock chromebook doesnt have docker installed, so we need to install it.
sudo apt-get install -y software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo usermod -a -G docker $USER

ln -s ~/dotfiles/bin  ~/bin

echo "Please close this terminal window and open a new one."

