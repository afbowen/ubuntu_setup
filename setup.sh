#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/11] Updating system..."
sudo apt update && sudo apt upgrade -y


printf "\n"
echo "[2/11] Installing APT packages..."
sudo apt install -y git curl tree python3-pip gnome-tweaks gnome-shell-extensions gnome-shell-extension-prefs gnome-shell-extension-manager stow kate numlockx putty grip net-tools minicom


printf "\n"
echo "[3/11] Installing .dev packages..."
echo "Installing Google Chrome..."
if ! command -v google-chrome &>/dev/null; then
  echo "Installing Google Chrome..."
  wget -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y /tmp/chrome.deb
  rm /tmp/chrome.deb
else
  echo "Google Chrome already installed."
fi


printf "\n"
echo "Installing Slack..."
if ! command -v slack &>/dev/null; then
  echo "Installing Slack..."
  wget -O /tmp/slack.deb https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.96/slack-desktop-4.41.96-amd64.deb
  sudo apt install -y /tmp/slack.deb
  rm /tmp/slack.deb
else
  echo "Slack already installed."
fi


printf "\n"
echo "[4/11] Setting up dotfiles..."
cd dotfiles
DOTFILES_DIR="$SCRIPT_DIR/dotfiles"
TARGET_DIR="$HOME"
stow -v -d "$DOTFILES_DIR" -t "$TARGET_DIR" bash git
ln -sf ~/git/ubuntu_setup/dotfiles/kate/.config/katerc ~/.config/katerc

source ~/.bashrc
cd ..


printf "\n"
echo "[5/11] Loading GNOME keybindings..."
dconf load /org/gnome/desktop/wm/keybindings/ < my-dconf-backups/desktop-wm-keybindings.conf
dconf load /org/gnome/shell/keybindings/ < my-dconf-backups/shell-keybindings.conf
dconf load /org/gnome/shell/extensions/dash-to-dock/ < my-dconf-backups/shell-extensions-dash-to-dock-keybindings.conf


printf "\n"
echo "[6/11] Installing GNOME extensions..."
pip3 install gnome-extensions-cli
echo yes | gnome-extensions-cli install putWindow@clemens.lab21.org
gnome-extensions-cli install wsmatrix@martin.zurowietz.de
# mkdir -p ~/.local/share/gnome-shell/extensions/
cp gnome_extensions/org.gnome.shell.extensions.org-lab21-putwindow.gschema.xml ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas
cp gnome_extensions/org.gnome.shell.extensions.wsmatrix.gschema.xml ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas
glib-compile-schemas ~/.local/share/gnome-shell/extensions/putWindow@clemens.lab21.org/schemas/
glib-compile-schemas ~/.local/share/gnome-shell/extensions/wsmatrix@martin.zurowietz.de/schemas/
# gnome-extensions enable putWindow@clemens.lab21.org
# gnome-extensions enable wsmatrix@martin.zurowietz.de

# gsettings set org.gnome.shell.extensions.dash-to-dock shortcut "['<Super>\`']"
# ~/.config/dconf/user


printf "\n"
echo "[7/11] Applying GNOME settings..."
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
gsettings set org.gnome.shell favorite-apps \
"['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop', 'slack.desktop', 'org.gnome.Calculator.desktop']"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


printf "\n"
echo "[8/11] Setting up /etc files..."
cd etc
sudo cp systemd/logind.conf /etc/systemd/logind.conf  # Lid when docked settings
cd ..


printf "\n"
echo "[9/11] Setting up /etc files..."
numlockx on
cd pkg_cfg
cp putty/sessions/* ~/.putty/sessions/
cd ..


printf "\n"
echo "[9/11] Cloning this repository to ~/git/ubuntu_setup..."
mkdir ~/git/
git clone git@github.com:afbowen/ubuntu_setup.git


printf "\n"
echo "[10/11] Creating ~/shared directory for LAN file transfers..."
mkdir ~/shared


printf "\n"
echo "[11/11] Generating ed25519 SSH key if it doesn't exist..."

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ ! -f "$SSH_KEY" ]; then
  echo "Creating a new SSH key..."
  ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f "$SSH_KEY" -N ""
else
  echo "SSH key already exists at $SSH_KEY"
fi

printf "\n"
echo "Your public SSH key:"
cat "${SSH_KEY}.pub"
echo

printf "\n"
echo "Opening GitHub for you to manually enter your new SSH key..."
google-chrome "https://github.com/settings/ssh/new" &


printf "\n"
read -p "🎉 Setup complete! Would you like to reboot now? (y/n): " REBOOT_CHOICE
if [[ "$REBOOT_CHOICE" =~ ^[Yy]$ ]]; then
  echo "Rebooting..."
  sleep 2
  sudo reboot
else
  echo "Reboot skipped."
fi
