#!/bin/bash

sudo apt update
sudo apt install -y python3 python3-pip unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
rm -rf awscliv2.zip aws
