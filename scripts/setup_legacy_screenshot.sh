#!/bin/bash

# Manual Procedure
# sudo apt install gnome-screenshot
# nano ~/.local/share/applications/gnome-screenshot-legacy.desktop
# (paste desktop entry from below)
# chmod +x ~/.local/share/applications/gnome-screenshot-legacy.desktop

# Ensure gnome-screenshot is installed
sudo apt update
sudo apt install -y gnome-screenshot

# Create the .desktop launcher
LAUNCHER_PATH="$HOME/.local/share/applications/gnome-screenshot-legacy.desktop"

mkdir -p "$(dirname "$LAUNCHER_PATH")"

cat > "$LAUNCHER_PATH" <<EOF
[Desktop Entry]
Name=Screenshot (Classic)
Comment=Take a screenshot and choose where to save
Exec=gnome-screenshot -i
Icon=applets-screenshooter
Terminal=false
Type=Application
Categories=Utility;
StartupNotify=true
EOF

# Make the launcher executable
chmod +x "$LAUNCHER_PATH"

# Add to dock (if not already present)
DOCK_FILE="$HOME/.config/dconf/user"

# Use gsettings to add to favorites
CURRENT_FAVORITES=$(gsettings get org.gnome.shell favorite-apps)

if [[ "$CURRENT_FAVORITES" != *"gnome-screenshot-legacy.desktop"* ]]; then
    UPDATED_FAVORITES=$(echo "$CURRENT_FAVORITES" | sed "s/]$/, 'gnome-screenshot-legacy.desktop']/")
    gsettings set org.gnome.shell favorite-apps "$UPDATED_FAVORITES"
    echo "✅ Added Screenshot (Classic) to the dock."
else
    echo "ℹ️ Screenshot (Classic) is already in the dock."
fi

echo "✅ Setup complete! You can now launch Screenshot (Classic) from your dock."
