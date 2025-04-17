# Adam's Ubuntu Config

This directory contains config info for Adam's preferred Ubuntu configuration. This configuration
includes dotfiles like `.bashrc`, GNOME config (via `dconf`), and GNOME extension install and
config.


## dotfiles
- `.bashrc`: environmental variables available in every terminal session.
- `.bash_aliases`: command aliases available in every terminal session.
- `.gitconfig`: git configuration (name, email, etc).
- `.config/katerc`: kate configuration (word wrap, line numbers, theme).


## gnome-settings
Contains a subset (individual files) of the larger GNOME `dconf.conf` file. As of now, the only
tweaks made are for keyboard shortcuts, editing or removing those that conflict with the
Put Windows extension as we've configured it (e.g. `super+a` was used to show all applications,
but has been remapped to put a window on the left half of the screen).

### Updates
- `super+a`
  - Originally defined in `/org/gnome/shell/keybindings/toggle-application-view`
  - Also visible through GNOME `Settings->Keyboard->Keyboard Shortcuts->System->Show all applications`
  - Status: REMOVED
    - Hitting `super` on it's own cycles through `show all applications` and `show the overview`,
      this extra shortcut is unnecessary.
- `super+s`
  - Originally defined in `/org/gnome/shell/keybindings/toggle-overview`
  - Also visible through GNOME `Settings->Keyboard->Keyboard Shortcuts->System->Show the overview`
  - Status: REMOVED
    - Hitting `super` on it's own cycles through `show all applications` and `show the overview`,
      this extra shortcut is unnecessary.
- `super+d`
  - Originally defined in `/org/gnome/desktop/wm/keybindings/show-desktop`
  - Not visible through GNOME settings.
  - Status: REMOVED
    - Hitting `ctrl+super+d` does the same thing, this extra options for the same shortcut is
      unnecessary.
- `super+q`
  - Originally defined in `/org/gnome/shell/extensions/dash-to-dock/shortcut-text`
  - Not visible through GNOME settings.
  - Status: REASSIGNED to `super+~` (~ is `)
    - This isn't something that's commonly used, but re-assigned instead of removing.

### Dump and Load Commands
#### super+d
```
dconf dump /org/gnome/desktop/wm/keybindings/ > my-dconf-backups/desktop-wm-keybindings.conf
dconf load /org/gnome/desktop/wm/keybindings/ < my-dconf-backups/desktop-wm-keybindings.conf
```

#### super+a, super+s
```
dconf dump /org/gnome/shell/keybindings/ > my-dconf-backups/shell-keybindings.conf
dconf load /org/gnome/shell/keybindings/ < my-dconf-backups/shell-keybindings.conf
```

#### super+q
```
dconf dump /org/gnome/shell/extensions/dash-to-dock/ > my-dconf-backups/shell-extensions-dash-to-dock-keybindings.conf
dconf load /org/gnome/shell/extensions/dash-to-dock/ < my-dconf-backups/shell-extensions-dash-to-dock-keybindings.conf
```


## gnome-extensions
These are core extensions that make it easier to maintain and navigate a structured workspace. Note
that this directory contains the entire extension directory, not just the config. This seemed to be
the easier way to deploy the extension with the preferred config.

- Put Windows (`putWindow@clemens.lab21.org`)
  - Enables window tiling from keyboard shortcuts.
  - By default, use the <super> key and numeric keypad (e.g.
  - Edited `schema/org.gnome.shell.extensions.org-lab21-putwindow.gschema.xml` to also include an
    option for <super> and "WSAD" keys. For instance, the default for putting a window in the top
    left corner is `['<Super>KP_0']`, but the updated schema is `['<Super>KP_0', '<Super>q']`.
- Workspace Matrix (`wsmatrix@martin.zurowietz.de`)
  - Used to create workspaces


## Updating the Username
Ubuntu doesn't allow you to create a username with a `.` character in it (e.g. `john.smith`). The
account name can be changed after creation, although not from within the account. In order to
update it without doing so from a separate account, we can do it as a `root` user from the grub
menu.

1. Reboot the machine.
2. In the grub menu, select `Advanced options for Ubuntu`.
3. Select a recovery mode option.
4. In the Recovery Menu, select `root`.
5. Create the new login name.
   ```
   usermod -l adam.bowen adam
   ```
6. Set the new home directory path and move the contents.
   ```
   usermod -d /home/adam.bowen -m adam.bowen
   ```
7. Rename the primary group to match the new username.
   ```
   groupmod -n adam.bowen adam
   ```
8. Set the display name (likely already set properly during Ubuntu installation).
   ```
   chfn -f "Adam Bowen" adam.bowen
   ```
