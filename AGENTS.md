# AGENTS.md

Guide for AI agents and contributors working on this dotfiles repository. Read
this before changing anything. Subdirectories with their own conventions have a
nested `AGENTS.md` (`script/`, `system/`, `git/`) — read the nested one too when
working there.

## What this repo is

Personal cross-platform dotfiles for zsh, bash, git, vim, emacs, ruby, python
and macOS. The design goal is a **modular, deterministic, network-free shell
startup**: the zsh entrypoint sources small topic modules, never installs
anything, never touches the network and never rewrites `PATH` on every prompt.
Installation/update/network work lives exclusively in `script/`.

It must work on Linux (Debian/Ubuntu/Raspbian, Arch/Manjaro, Fedora) **and**
macOS, and degrade gracefully when an optional tool is missing.

## Golden rules

1. **Never hard-depend on a command.** Guard every external tool with
   `dotfiles_has <cmd>` / `dotfiles_require <cmd>` (functions) or `command -v`
   (scripts). A function on a machine missing its tool must print a usage or error
   message to stderr and `return 1`, never crash the shell.
2. **Keep startup cheap.** Nothing sourced at shell startup may hit the network,
   install software, or do slow work. That belongs in `script/`.
3. **Cross-platform first.** Branch on `uname -s` (`Darwin` = macOS) and on the
   session type (`$WAYLAND_DISPLAY`, `$XDG_SESSION_TYPE`) rather than assuming
   one OS. macOS uses Homebrew; Linux uses the distro package manager via
   `script/detect-distro.sh` + `script/packages.conf`.
4. **Machine-specific values go in `~/.localrc`**, never committed. It is created
   from `shell/localrc.template` on bootstrap and sourced early by both shells.
   When you add a tunable, document it in the template *and* in `README.md`.
5. **Respect `IFSUDO`.** Use `${IFSUDO:-sudo}` for privilege escalation so root
   users (who get `IFSUDO=""`) are not forced through sudo.
6. **Keep `README.md` in sync.** It carries the canonical function table, the
   bootstrap flag table, and the `~/.localrc` variable table. Any new function,
   flag, package or tunable must be reflected there in the same change.
7. **English** for all code, comments, commit messages and docs (the repo is
   uniformly English even though the maintainer works in Spanish).

## Repository layout

```
AGENTS.md       — this file
README.md       — user-facing docs; canonical function/flag/var tables
bash/           — bashrc, bash aliases (portable; never sources *.zsh)
emacs/          — emacs init (use-package, MELPA)
funny/          — fun functions (excuse, reverse)
git/            — gitconfig, gitignore, git aliases, semantic-commit scripts  [AGENTS.md]
macos/          — macOS Sequoia defaults script
mise/           — default tool versions (Ruby)
python/         — uv integration
ruby/           — mise integration, gemrc, irbrc
script/         — install (remote), bootstrap, update, install-base, install-desktop, packages.conf  [AGENTS.md]
servers/        — Apache/server aliases
shell/          — shared login banner (logo.sh), localrc.template
starship/       — Starship prompt config
system/         — general aliases, shell functions, profile  [AGENTS.md]
vim/            — vimrc
zsh/            — zshrc entrypoint, config, completion, bindkeys, prompt, plugins
```

## The two mechanisms you must understand

### 1. The symlink model

Any file named `*.symlink` is linked into `$HOME` by `script/bootstrap`. The
default mapping is `topic/name.symlink` → `~/.name` (the leading dot is added,
the `.symlink` suffix dropped). There are **special-cased targets** in
`bootstrap`'s `install_dotfiles()`:

| Source | Linked to |
|--------|-----------|
| `shell/logo.sh.symlink` | `~/logo.sh` |
| `starship/starship.toml.symlink` | `~/.config/starship.toml` |
| `mise/config.toml.symlink` | `~/.config/mise/config.toml` |

`find` runs with `-maxdepth 2`, so a `*.symlink` must live at the repo root or
one level deep. Files ending in `.example` (e.g. `gitconfig.local.symlink.example`)
are **templates, not linked** — they show the shape of a private file the user
copies and fills in. `.gitignore` excludes the real private versions.

### 2. The zsh module loader

`zsh/zshrc.symlink` is the entrypoint. After exporting a few vars and sourcing
`~/.localrc`, for interactive shells it auto-sources **every `*/*.zsh` in the
repo except `*/plugins/*`**, in this order:

1. `*/path.zsh` files first (PATH fragments)
2. all other modules (except `completion.zsh`)
3. `compinit`, then `*/completion.zsh` files

**Consequence:** to add shell behaviour you just drop a `*.zsh` file in a topic
directory (or edit an existing one) — it is picked up automatically, no
registration needed. Name a file `path.zsh` if it must run before everything
else; name it `completion.zsh` if it defines completion styles.

Bash is independent: `bash/bashrc.symlink` only sources `bash/aliases.bash` and
`~/.localrc`. It never sources `*.zsh`, so **zsh-only syntax is safe in `.zsh`
files** but anything meant for both shells must be POSIX/bash-compatible and
live in a shared location.

## Where things go (decision guide)

| You want to add… | Put it in | Skill |
|---|---|---|
| A shell function (interactive helper) | `system/programs.zsh` | `add-shell-function` |
| A shell alias | the relevant `*/aliases.zsh` (`system/`, `git/`, `servers/`) | — |
| A cross-distro package + its install | `script/packages.conf` + `install-base`/`install-desktop` | `add-package` |
| A new config file linked into `$HOME` | a `*.symlink` in a topic dir | `add-dotfile` |
| A new tunable | `shell/localrc.template` + read it with a `${VAR:-default}` + `README.md` | — |
| A PATH addition | a `path.zsh` in the topic dir | — |
| Install/update/network logic | `script/` (never a startup module) | — |

## House style

- **Functions** (`system/programs.zsh`): lower-case names; validate args with
  `local x="${1:?usage: name <arg>}"`; guard tools with `dotfiles_require`;
  errors and usage to **stderr**; `return` non-zero on failure (never `exit` —
  it would kill the user's shell). zsh-only functions go inside the
  `if [[ -n "$ZSH_VERSION" ]]` block. See `system/AGENTS.md`.
- **Scripts** (`script/`): `#!/usr/bin/env bash`, `set -euo pipefail`,
  `source "$(dirname "$0")/lib.sh"`, and report progress with
  `info/success/warn/fail`. Support `--dry-run` where it makes sense; degrade
  with `warn` rather than `fail` for optional steps. See `script/AGENTS.md`.
- **Bilingual aliases**: English names are always defined; Spanish aliases are
  added only when `DOTFILES_LANG=es` (see the `LANGUAGE ALIASES` block at the
  bottom of `system/programs.zsh`).
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`,
  `chore:`, `style:`, `test:`). Commits are GPG-signed. **Never** add a
  `Co-Authored-By` or any AI-attribution trailer. Helper scripts in `git/bin/`
  (`git feat`, `git fix`, …) generate these messages. See `git/AGENTS.md`.

## Verifying changes

There is no test suite and `shellcheck` may not be installed. Minimum bar before
considering a change done (the `verify-shell` skill automates this):

```sh
zsh -n  system/programs.zsh          # syntax-check edited zsh modules
bash -n script/bootstrap             # syntax-check edited bash scripts
shellcheck script/*                  # if available
script/bootstrap --dry-run           # preview linking without touching $HOME
zsh -ic 'autoload -Uz colors; source system/programs.zsh; type todo'  # smoke-load
```

For a function, also source it in a clean shell and run it once. Prefer
`--dry-run` / read-only checks over anything that mutates `$HOME` or installs
packages.

## Gotchas

- Editing a repo file that is symlinked into `$HOME` takes effect immediately in
  new shells — but the repo file itself is the source of truth; never edit the
  `~/.` symlink target's resolved copy expecting it to differ.
- `system/programs.zsh` is sourced **only by zsh**; do not put bash-incompatible
  syntax in files that bash also reads (`bash/aliases.bash`, `shell/logo.sh.symlink`,
  `shell/localrc.template`).
- `shell/logo.sh.symlink` must stay POSIX `sh`-compatible: it is sourced by both
  bash and zsh as the login banner.
- A new `*.symlink` deeper than one level below the repo root will **not** be
  linked (`find -maxdepth 2`).
- Don't reintroduce a top-level `bin/` on `PATH` expecting it to be picked up —
  only `git/bin` is added to `PATH` (by `git/path.zsh`). Standalone helpers are
  generally better as auto-loaded functions in `system/programs.zsh`.
