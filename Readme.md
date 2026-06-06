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

Then links all `*.symlink` files to `$HOME`, bootstraps Emacs packages, and on
macOS automatically applies the defaults from `macos/set-defaults.sh`.

### Bootstrap options

| Flag | Behaviour |
|------|-----------|
| `--dry-run` | Preview changes without applying them |
| `--backup` | Move conflicting files to `*.backup` |
| `--skip-existing` | Keep existing files untouched |
| `--force` | Replace conflicting files |

---

## Updating

```sh
script/update
```

Updates the dotfiles repo, all submodules, uv, mise, starship and bofh-excuses.
The bootstrap script calls this automatically at the end.

---

## Structure

```
bash/       — bashrc, bash aliases
emacs/      — emacs init (use-package based, MELPA)
funny/      — fun shell functions (excuse, reverse)
git/        — gitconfig, gitignore, git aliases, semantic commit scripts
macos/      — macOS Sequoia defaults script
python/     — uv integration
ruby/       — mise integration, gemrc, irbrc
script/     — bootstrap and update scripts
servers/    — Apache/server aliases
shell/      — shared login banner (logo.sh)
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

### Login banner

Lives at `~/logo.sh` after bootstrap. Works in bash and zsh, uses `lm-sensors`
when available and falls back to Raspberry Pi thermal sensors. Enable with:

```sh
export DOTFILES_SHOW_LOGO=1
```

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

## macOS

On macOS, `script/bootstrap` applies the defaults automatically. To run manually:

```sh
bash ~/.dotfiles/macos/set-defaults.sh
```

Configures Sequoia defaults: tap-to-click, fast key repeat, hidden files visible,
file extensions always shown, Dock auto-hide, screenshots to Desktop, TextEdit
in plain text mode, no autocorrect or auto-capitalisation.

---

## TODO

- [ ] Review and modernise `zsh/prompt.zsh` — currently only loads Starship,
      could add fallback prompt with git info for machines without Starship
- [ ] Consider migrating Emacs config to a dedicated repo with a proper
      `init.el` / `early-init.el` structure (straight.el or elpaca)
- [ ] Add `shell/` module tests — verify logo.sh works on both bash and zsh
      and that thermal fallbacks work correctly on Raspberry Pi
- [ ] Review `system/programs.zsh` for further modernisation (not touched in
      this pass)
- [ ] Add support for Arch Linux in `system/aliases.zsh` package manager block
- [ ] Evaluate adding `~/.config/mise/config.toml` to the repo for default
      Ruby version across machines
- [ ] `script/bootstrap` — add `--update-only` flag to skip installs and
      jump straight to `script/update`
