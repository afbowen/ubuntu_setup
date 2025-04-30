#!/bin/bash

# Manual Procedure
# gsettings get org.gnome.desktop.peripherals.keyboard numlock-state
# gsettings set org.gnome.desktop.peripherals.keyboard numlock-state "true"
# (log out, log in)


gsettings get org.gnome.desktop.peripherals.keyboard numlock-state
gsettings set org.gnome.desktop.peripherals.keyboard numlock-state "true"

echo "Done. To apply update, log out and log in."
