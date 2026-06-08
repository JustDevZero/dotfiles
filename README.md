# dotfiles

Personal dotfiles for zsh, bash, git, vim, emacs, ruby, python and macOS.
Maintained by Daniel Ripoll — https://github.com/JustDevZero

---

## Installation

```sh
git clone --recursive https://github.com/JustDevZero/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap --backup
```

The bootstrap script installs the following tools if not present:
- **uv** — fast Python package and environment manager
- **mise** — polyglot version manager (used for Ruby)
- **Starship** — cross-shell prompt
- **bofh-devops-excuses** — cloned to `~/.bofh-excuses`

Then links all `*.symlink` files to `$HOME`, bootstraps Emacs packages, copies
`shell/localrc.template` to `~/.localrc` if it does not exist, and on macOS
automatically applies the defaults from `macos/set-defaults.sh`.

### Bootstrap options

| Flag | Behaviour |
|------|-----------|
| `--dry-run` | Preview changes without applying them |
| `--backup` | Move conflicting files to `*.backup` |
| `--skip-existing` | Keep existing files untouched |
| `--force` | Replace conflicting files |
| `--update-only` | Skip installs, run `script/update` only |
| `--desktop` | Force desktop package install (auto-detected if graphical session present) |

### Base packages

Install core CLI tools on any machine:

```sh
script/install-base
```

Installs: `curl`, `wget`, `zip`, `unzip`, `p7zip`, `unrar`, `lzip`, `lzop`, `xz`, `watch`, `htop`, `git`.
On macOS uses Homebrew. On Linux uses the distro package manager.

### Desktop packages

`script/install-desktop` runs automatically during bootstrap when a graphical
session is detected (`$DISPLAY` or `$WAYLAND_DISPLAY`). To force it manually:

```sh
script/bootstrap --desktop
script/install-desktop          # standalone
```

Detects automatically:
- **Display server** — Wayland (`grim`, `imv`) or X11 (`scrot`, `feh`)
- **Desktop environment** — GNOME 3+ (`papers`) or other (`evince`)
- **Battery** — installs `acpi` and `upower` only if a battery is present
- **Raspberry Pi** — skips `lm-sensors` (uses `vcgencmd` instead)
- **macOS** — uses brew casks: `libreoffice`, `gimp`, `inkscape`, `stats`, `osx-cpu-temp`

Package names per distro are defined in `script/packages.conf`.

### Machine-specific config

Bootstrap creates `~/.localrc` from `shell/localrc.template` on first run.
Edit it to set machine-specific values — it is never tracked by git:

| Variable | Purpose |
|----------|---------|
| `DOTFILES_LANG` | Shell function language: `en` (default) or `es` |
| `DOTFILES_SHOW_LOGO` | Show login banner (`1` to enable) |
| `IFSUDO` | Privilege prefix for package commands (default: `sudo`) |
| `EDITOR` | Default editor (auto-detected: emacs or vim) |
| `BROWSER` | Browser for `.html` file associations |
| `VISOR` | Image viewer for `.png/.jpg/…` associations |
| `PDFVIEWER` | PDF viewer for `.pdf` associations |
| `OFFICESUITE` | Office suite for `.doc/.xls/…` associations |
| `GIMP` | GIMP path for `.xcf/.psd` associations |
| `SVG_EDITOR` | SVG editor for `.svg` associations |
| `PROJECTS` | Base path for code projects |
| `PAGER` | Pager (default: `less`) |

---

## Updating

```sh
script/update                   # update everything
script/update --check-updates   # check for new version without updating
```

Updates the dotfiles repo, all submodules, uv, mise, starship and bofh-excuses.
The bootstrap script calls this automatically at the end.

`--check-updates` fetches tags from remote and compares the current version
against `origin/master` — prints a warning if a newer tag is available.

---

## Structure

```
bash/       — bashrc, bash aliases
emacs/      — emacs init (use-package based, MELPA)
funny/      — fun shell functions (excuse, reverse)
git/        — gitconfig, gitignore, git aliases, semantic commit scripts
macos/      — macOS Sequoia defaults script
mise/       — default tool versions (Ruby 3.3)
python/     — uv integration
ruby/       — mise integration, gemrc, irbrc
script/     — bootstrap, update, install-base, install-desktop, packages.conf
servers/    — Apache/server aliases
shell/      — shared login banner (logo.sh), localrc.template
starship/   — Starship prompt config
system/     — general aliases, programs, profile
vim/        — vimrc
zsh/        — zshrc, config, completion, bindkeys, prompt, plugins
```

---

## Shell layout

The zsh entrypoint is a modular loader — it does not touch the network, does not
install dependencies and does not regenerate PATH on every startup. Machine-specific
values go in `~/.localrc`.

Bash is portable by default and shares the same optional login banner as zsh.

### Prompt

Powered by [Starship](https://starship.rs). Shows:
- `user@host` — always visible, critical for SSH sessions
- Current directory
- Git branch and status
- Active language version (Python, Ruby, Node, Go)
- Kubernetes context when relevant
- Command duration for slow commands

Falls back to a minimal prompt with git branch when Starship is not available.

### Login banner

Lives at `~/logo.sh` after bootstrap. Works in bash and zsh. Shows host, kernel,
temperature, memory, uptime, and IPv4/IPv6 (only if available). Enable with:

```sh
export DOTFILES_SHOW_LOGO=1
```

Temperature sources (in order of preference):
- `lm-sensors` — Linux desktop/server
- `vcgencmd` — Raspberry Pi (both `/usr/bin` and `/opt/vc/bin`)
- `osx-cpu-temp` — macOS

### History

Both shells record timestamps in history:
- **bash**: `HISTTIMEFORMAT="%F %T"`
- **zsh**: `setopt EXTENDED_HISTORY` + `alias history='fc -l -t "%F %T" 1'`

### BOFH excuses

```sh
excuse        # random DevOps excuse in English
excuse es     # random DevOps excuse in Spanish
```

Source: https://github.com/JustDevZero/bofh-devops-excuses

---

## Key tools

| Tool | Purpose |
|------|---------|
| [uv](https://github.com/astral-sh/uv) | Python package and venv management |
| [mise](https://mise.jdx.dev) | Ruby (and other language) version management |
| [Starship](https://starship.rs) | Cross-shell prompt |
| [zsh-fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Zsh syntax highlighting |
| [Corfu](https://github.com/minad/corfu) | Emacs completion (via MELPA) |

---

## Shell functions

Functions are defined in `system/programs.zsh`. English names are always
available. Set `DOTFILES_LANG=es` in `~/.localrc` to also enable Spanish aliases
(`extraer`, `comprimir`, `listar`).

| Function | Description |
|----------|-------------|
| `extract <file>` | Extract any archive (tar, zip, 7z, rar, gz, bz2, xz…) |
| `compress <fmt> <file>` | Compress a file or directory to the given format |
| `listarchive <file>` | List contents of an archive without extracting |
| `afk` | Lock the screen (macOS, systemd, GNOME, i3) |
| `battery` | Show battery status (acpi, upower, or sysfs fallback) |
| `myip` | Show current public IP, cached for comparison |
| `iprivate` | Show current private IP |
| `state` | Show shell, terminal, login and system info |
| `man2pdf <page>` | Convert a man page to PDF and open it |
| `mountiso <file>` | Mount an ISO image under `/media` |
| `umountiso <file>` | Unmount a previously mounted ISO |
| `screenshot` | Take a screenshot (Wayland: `grim`, X11: `scrot`, macOS: `screencapture`) |
| `watchssh` | Watch active SSH connections in real time (`watch -n1 ps aux \| grep ssh`) |
| `cdl <dir>` | `cd` into a directory and list its contents |
| `most-used-command` | Show the 10 most used shell commands from history |
| `extar/extgz/exzip/exrar/ex7z` | Shorthand wrappers for `extract` |
| `mktar/mktgz/mktbz/mkzip/mk7zp/…` | Shorthand wrappers for `compress` |

### zsh-only functions

These require zsh and are only loaded when running under zsh:

| Function | Description |
|----------|-------------|
| `ndir` | Show the most recently modified directory |
| `nfile` | Show the most recently modified file |
| `rmtype <ext>` | Remove all files with the given extension (interactive) |
| `age <days>` | List files modified within the last N days |
| `rmspace` | Rename files replacing spaces with underscores |
| `lower` | Rename files in current directory to lowercase |
| `uper` | Rename files in current directory to uppercase |

---

## macOS

Configures Sequoia defaults automatically on bootstrap: tap-to-click, fast key
repeat, hidden files visible, file extensions always shown, Dock auto-hide,
screenshots to Desktop, TextEdit in plain text mode, no autocorrect or
auto-capitalisation.

---
