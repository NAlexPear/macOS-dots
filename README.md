# macOS dotfiles

This setup includes all the configuration necessary to turn macOS into a more productive environment for the keyboard-driven software connoiseur. This includes a tiling window manager, some `vim`-driven keybindings, and assorted terminal configurations. 

## Installation
For an automatic(ish) install, run `init.sh` from inside this directory. `sudo` is not required. If any new shells or dialogs interrupt the installation process, installation will resume on completion of or `exit` from those processes.

## Errata
1. `chunkwm` desktop switching will only work with full keyboard accessibilty permissions granted, `csrutils` disabled from recovery mode, and `sudo chunkwm --install-sa` run without errors.
2. iTerm themes do not include fonts or key mappings. Iosevka Term is recommended for both ASCII and non-ASCII fonts.
3. `nvim` requires `:PlugInstall` to be run on first boot. Run `:checkhealth` to verify that all providers are correctly included in `$PATH` and that all remote extensions installed successfully.
