#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y

# dependencies
sudo apt-get install -y curl openssh-server ca-certificates perl curl 

# gitlab download and install
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
sudo apt-get install gitlab-ce -y 


