# macOS dotfiles

## Summary:
This setup includes all the configuration necessary to turn macOS into a more productive environment for the keyboard-driven software connoiseur. This includes a tiling window manager, some `vim`-driven keybindings, and assorted terminal configurations. 

## Full Installation:
For an automatic(ish) install, run `init.sh` from inside this directory. `sudo` is not required. If any new shells or dialogs interrupt the installation process, installation will resume on completion of or `exit` from those processes.

## Installation Breakdown
While the full installation works swimmingly, most people will disagree with at least one part of my default configuration. To that end, here's a section-by-section run-through of the full installation:

1. __`.config` directory setup__:
```bash
# force rename to proper directory
if [ ! "$PWD" == "$HOME/.config" ]; then
  mv "$PWD" ~/.config/
fi
```

As spec'd out by the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), `~/.config` should be where configurations live. Many applications fail to follow this rule, but it's a good starting place for dotfiles.

2. __initialize subdirectories__:
```bash
git submodule init
git submodule update --remote
```

Some configurations are set up as their own remote submodules for better sharing between operating systems or forking as needed. At the moment, those are `oh-my-zsh` and Neovim configurations.

3. __fonts__:
```bash
curl -L https://github.com/be5invis/Iosevka/files/2300381/iosevka-term-with-fira-code-ligatures.zip | bsdtar -C ~/Library/Fonts -xvf-
```

Iosevka is my terminal font of choice, in part because of ligature support. But Terminal.app doesn't support ligatures, iTerm2 supports arbitary-length ligatures (at the cost of performance), and Kitty supports fixed-length ligatures. I prefer Kitty for the best mix of performance and ligature support, but Iosevka's ligatures need to be patched with those from Fira Code Mono for display in Kitty. The above command installs patched Iosevka as Ligaiosevka in much the same way that a manual Font Book installation would.

4. __dependency management (Homebrew)__:
```bash
if [ ! $(which brew) ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
```

Homebrew exposes the `brew` command for `apt` or `pacman`-like package installation and management for macOS.

5. __common dependencies__:
```bash
brew install ruby git fd bat neovim ripgrep htop fzf emojify httpie z tree
```

Using Homebrew, this line installs a number of useful tools. They are:

  * `ruby` and `git`: yes, macOS ships with built-in versions of both, but neither are kept up-to-date relative to their Homebrew counterparts. You can survive with outdated versions of both, but why bother?
  * `fd`: a drop-in replacement for `find` that's faster in just about every way. Integrates nicely with `fzf`, too.
  * `bat`: a faster, prettier, and more user-friendly replacement for `cat`.
  * `neovim`: my preferred editor when not using VS Code's Live Share features
  * `ripgrep`: a faster `grep` that also integrates closely with `neovim` and `fzf`. Called as `rg` from the terminal, saving you two keystrokes over `grep`
  * `htop`: like `top` for getting system info, but fancier. I have this running pretty much all the time to keep tabs on running processes and boost my hacker cred.
  * `fzf`: a general-purpose fuzzy finder. I use this as a replacement for manual `history` searching via the `CTRL-R` shortcut, and as a replacement for manual `cd`-ing to common directories via the `CTRL-G` shortcut provided by integration with `z`
  * `emojify`: this converts emoji shorthand (e.g. `:tada:`) into actual emoji. This is especially important for displaying [gitmoji](https://gist.github.com/rxaviers/7360908)-heavy `git` histories through commands like `git log --color | emojify | less`.
  * `httpie`: Like `curl`, but integrates directly with `jq` for `JSON` parsing and syntax higlighting, as well as defaulting to `application/json` content types for data transfer. Nice for testing `JSON` APIs, but not as versatile as raw `curl`.
  * `z`: a "frecency"-based file explorer used to jump directly to commonly-visited directories. This is used in conjunction with `fzf` for fast file system navigation.
  * `tree`: sometimes it's nice to see the nested directory structure of a project. `tree` is used to get a quick outline of the project structure (rather than manually `ls`-ing different directories).

6. __window management (`chunkwm` + `skhd`)__:
```bash
brew install koekeishiya/formulae/skhd
brew tap crisidev/homebrew-chunkwm
brew install chunkwm
brew services start chunkwm
brew services start skhd
```

Probably the most controversial section of this install: installing macOS's best (but not perfect) tiling window manager. Floating windows require the use of a mouse or trackpad, while tiling window managers seek to automatically allocate screen space when a new application or window is opened. When paired with a set of hotkey combinations, this makes the placement of application windows relative to other applications (and across workspaces) a keyboard-driven affair. This is a similar solution to `vim` or `tmux` splits, but across all applications. 

In this case, `chunkwm` is used as a binary-splitting tiling window manager, and `skhd` is the keyboard hotkey daemon that manages the hotkeys needed to move windows and navigate between tiles/workspaces. See the `.chunkwm` and `.skhd` configuration files for more information.

> An important note: `chunkwm` desktop switching will only work with full keyboard accessibility permissions granted, `csrutils` disabled from recovery mode, and `sudo chunkwm --install-sa` run without errors.

7. __terminal configuration (`oh-my-zsh`)__:
```bash
export ZSH="$HOME/.config/oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

My shell of choice is `zsh` over `bash` or `fish` (although `fish` is also a strong contender), and my shortcuts, plugins, and terminal themes are all managed through `oh-my-zsh`. At some point, I expect to set up `antigen` for plugin management, but this configuration is simple enough for the time being to get away with not using a dedicated terminal plugin manager.

8. __configuration symlinking__:
```bash
ln -sf ~/.config/.*rc ~
```

There's a bright future some day where all programs are configurable through the proper `.config` directory... but that future is not today. Some configuration files need to be placed in the `$HOME` directory, but we still want to manage those files through this repo. This step, then, symlinks any dotfile that ends in `rc` to the `$HOME` directory, since it just so that all offending programs installed by this setup happen to follow the `rc`-ending naming convention.

9. __Rust setup__:
```bash
if [ ! $(which cargo) ]; then
  curl https://sh.rustup.rs -sSf | sh
fi
```

I like working with Rust, and this command handles the installation of all of Rust's tools (`rustup`, `cargo`, etc). Ignore this bit if you aren't programming in Rust.

10. __Node setup__:
```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.zshrc
nvm install node
```

When working with JavaScript, I use `nvm` to manage node versions and global dependencies. This step sets up the required `nvm` command-line tools (including modifiying the proper `zsh` configuration files as necessary) and installing the latest version of `node`. 

11. __NeoVim providers__:
```bash
pip3 install --user neovim
npm install -g neovim
gem install neovim
```

Rather than requiring compilation gymnastics (like `vim`), NeoVim uses external "provider" packages to expose NeoVim internals to plugins written in languages other than VimScript. These commands intall those providers for Python3, JavaScript, and Ruby, respectively. Run `:checkhealth` to verify that all providers are installed correctly and included in `$PATH`.

> You'll note the lack of Python2 support here. This is an intentional choice, as it's `$CURRENT_YEAR`, and Python2 should go the way of the Dodo. If a package requires Python2, I won't be using that package.

12. __iTerm themes__:
```bash
cp ~/.config/iTerm2/com.googlecode.iterm2.plist ~/Library/Preferences/
```

While Kitty is my terminal of choice, this has been left here for posterity. The color theme is based on the same Spacgray theme used in this repo's `kitty.conf` and in NeoVim's `spacegray` plugin. iTerm themes do not include fonts or key mappings.

13. __Slack dark mode__:
```bash
cat ~/.config/slack-dark.js >> /Applications/Slack.app/Contents/Resources/app.asar.unpacked/src/static/ssb-interop.js
```

This is a hacky script that gives Slack something like a dark mode until they get their act together and build one themselves. Use only if you dislike the standard theme enough to nuke it forever.

14. __Karabiner__:

While not included in the install script, the `karabiner/karabiner.json` file allows re-mapping of keystrokes through the use of the manually-installed Karabiner Elements application. Included are maps for the built-in macbook pro, HHKB Pro 2, and OLKB Planck keyboards. Some of the highlights of these configurations:

  * All keyboards map `CMD` to `CTRL` when iTerm or Kitty is the application in the foreground. This allows for standard `nvim` commands to work with `CTRL` while maintaining OS-level `CMD` key bindings.
  * The default keyboard's `CAPS LOCK` is re-mapped to `CMD`.
  * All external keyboards map left `CTRL` to left `CMD`
  * Planck's right `ALT` is re-mapped to right `CMD`
  * The default keyboard is disabled when any external keyboard is active
