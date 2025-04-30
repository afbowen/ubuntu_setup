#!/bin/bash

#############
# CONSTANTS #
#############

# Default install path for GUI source code and virtual environment
INSTALL_DIR_PATH=~/venv

# Absolute path to Python 3.7 virtual environment in which app must run
VENV_PATH="$INSTALL_DIR_PATH/gui_venv"

# Absolute path of directory containing this script
THIS_DIR="$(dirname "$(realpath "$0")")"
REQUIREMENTS_PATH="$THIS_DIR/gui_requirements.txt"



########
# MAIN #
########

# Create directory for venv and GUI tool if it doesn't exist already
if [ ! -d "$INSTALL_DIR_PATH" ]; then
    printf "Directory $INSTALL_DIR_PATH does not exist. Creating it..."
    mkdir -p "$INSTALL_DIR_PATH"
fi

# Create a Python 3.7 virtual environment (venv) in install directory if it does not exist
if [ -d "$VENV_PATH" ]; then
    printf "Virtual environment already exists at $VENV_PATH\n"
else
    printf "Virtual environment not found. Creating at $VENV_PATH...\n"
    python3.7 -m venv "$VENV_PATH"
fi

# Install correct versions of dependencies in venv as needed
printf "Activating the virtual environment and installing dependencies...\n"
source "$VENV_PATH/bin/activate"

if [ -f "$REQUIREMENTS_PATH" ]; then
    pip install -r "$REQUIREMENTS_PATH"
    printf "Dependencies installed successfully.\n"
else
    printf "ERROR: requirements.txt file not found at $REQUIREMENTS_PATH\n"
    exit 1
fi

# Deactivate the virtual environment after setup
deactivate
