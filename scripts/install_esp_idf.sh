#!/bin/bash

sudo apt update
sudo apt install -y git wget make cmake gcc g++ python3 python3-pip python3-venv libncurses5-dev libncursesw5-dev flex bison gperf unzip
git clone --recursive https://github.com/espressif/esp-idf.git ~/esp/esp-idf
cd ~/esp/esp-idf
./install.sh
. ./export.sh
