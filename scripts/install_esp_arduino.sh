#!/bin/bash

# Set USB permissions to allow serial companion (overwrite file if it exists)
USB_RULES_FILE="/etc/udev/rules.d/50-myusb.rules"
echo 'KERNEL=="ttyUSB[0-9]*",MODE="0666"' > "$USB_RULES_FILE"
echo 'KERNEL=="ttyACM[0-9]*",MODE="0666"' >> "$USB_RULES_FILE"


# ARDUINO CLI #

# Retrieve Arduino CLI
wget -qO arduino-cli.tar.gz https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz

# Extract Arduino CLI to /usr/local/bin
sudo tar xf arduino-cli.tar.gz -C /usr/local/bin arduino-cli

# Check Arduino CLI version to verify install
arduino-cli version

# Remove Arduino CLI install archive
rm -rf arduino-cli.tar.gz

# Set up configuration file
arduino-cli config init

# Add ESP32 package link to Arduino CLI config .yaml
ARDUINO_CFG_FILE="/home/$USER/.arduino15/arduino-cli.yaml"
cat <<EOL > "$ARDUINO_CFG_FILE"
board_manager:
  additional_urls:
   - https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
EOL

# Install ESP32 packages
arduino-cli core update-index
arduino-cli board listall
arduino-cli core install esp32:esp32@2.0.6

# Install `pyserial` (required for ESP32 to build and upload)
pip3 install pyserial
