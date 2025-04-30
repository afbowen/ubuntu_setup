#!/bin/bash

# Install Python 3.7 so a virtual environment can be created
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.7 python3.7-venv python3.7-dev -y
