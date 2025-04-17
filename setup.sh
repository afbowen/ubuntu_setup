#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


echo "[1/9] Updating system..."
sudo apt update && sudo apt upgrade -y


printf "\n"
echo "[2/9] Installing APT packages..."
sudo apt install -y git curl tree python3-pip gnome-tweaks gnome-shell-extensions gnome-shell-extension-prefs gnome-shell-extension-manager stow kate


printf "\n"
echo "[3/9] Installing .dev packages..."
if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y /tmp/chrome.deb
  rm /tmp/chrome.deb
else
  echo "Google Chrome already installed."
fi

printf "\n"
if ! command -v slack &>/dev/null; then
  echo "Installing Slack..."
  wget -O /tmp/slack.deb https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.96/slack-desktop-4.41.96-amd64.deb
  sudo apt install -y /tmp/slack.deb
  rm /tmp/slack.deb
else
  echo "Slack already installed."
fi


printf "\n"
echo "[4/9] Setting up dotfiles..."
cd dotfiles
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
TARGET_DIR="$HOME"
stow -v -d "$DOTFILES_DIR" -t "$TARGET_DIR" bash git kate
source ~/.bashrc
cd ..


printf "\n"
echo "[5/9] Loading GNOME keybindings..."
dconf load /org/gnome/desktop/wm/keybindings/ < my-dconf-backups/desktop-wm-keybindings.conf
dconf load /org/gnome/shell/keybindings/ < my-dconf-backups/shell-keybindings.conf
dconf load /org/gnome/shell/extensions/dash-to-dock/ < my-dconf-backups/shell-extensions-dash-to-dock-keybindings.conf


printf "\n"
echo "[6/9] Installing GNOME extensions..."
pip3 install gnome-extensions-cli
gnome-extensions-cli install putWindow@clemens.lab21.org
gnome-extensions-cli install wsmatrix@martin.zurowietz.de
cp gnome_extensions/org.gnome.shell.extensions.org-lab21-putwindow.gschema.xml ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas
cp gnome_extensions/org.gnome.shell.extensions.wsmatrix.gschema.xml ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas
glib-compile-schemas ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas/
glib-compile-schemas ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/


printf "\n"
echo "[7/9] Applying GNOME settings..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop', 'slack.desktop', 'org.gnome.Calculator.desktop']"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


printf "\n"
echo "[8/9] Setting up /etc files..."
cd etc
sudo cp systemd/logind.conf /etc/systemd/logind.conf
cd ..


printf "\n"
echo "[9/9] Generating ed25519 SSH key if it doesn't exist..."

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$SSH_KEY" ]; then
  echo "Creating a new SSH key..."
  ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$SSH_KEY" -N ""
else
  echo "SSH key already exists at $SSH_KEY"
fi

echo
echo "Your public SSH key:"
cat "${SSH_KEY}.pub"
echo

printf "\n"
echo "Opening GitHub for you to manually enter your new SSH key..."
google-chrome "https://github.com/settings/ssh/new"

printf "\n"
read -p "🎉 Setup complete! Would you like to reboot now? (y/n): " REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  echo "Rebooting..."
  sleep 2
  sudo reboot
else
  echo "Reboot skipped."
fi
