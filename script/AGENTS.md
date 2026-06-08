# AGENTS.md — `script/`

Installation, update and package-management scripts. This is the **only** place
that may install software or touch the network. Read the root `AGENTS.md` first.

## Files

| File | Role |
|------|------|
| `lib.sh` | Shared logging helpers — **source, never execute**. Provides `info/success/warn/fail`. |
| `detect-distro.sh` | Source-only. Sets `$_distro`, `$_version`, `$PKG_COL`, and defines `install_cmd()` per distro. |
| `packages.conf` | Package-name map, one row per logical package. |
| `install` | POSIX-sh **remote** bootstrap — meant to be piped (`curl … | sh`). Clones/updates the repo into `${DOTFILES:-$HOME/.dotfiles}` then `exec`s `bootstrap`. Keep it POSIX sh (no bashisms) so it runs under sh/bash/zsh. |
| `bootstrap` | Top-level **local** installer: installs tools, links `*.symlink`, bootstraps emacs, applies macOS defaults, then runs `update`. Assumes it runs from inside the cloned repo. |
| `install-base` | Core CLI tools on any machine. |
| `install-desktop` | GUI tools, auto-detected by display server / DE / hardware. |
| `update` | Updates the repo, submodules, and the external tools (uv, mise, starship, bofh-excuses). |
| `uninstall` | Reverses bootstrap. |

## Conventions (every script)

```sh
#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/lib.sh"
cd "$(dirname "$0")/.."
DOTFILES_ROOT="$(pwd -P)"
```

- Report progress only through `info` (in-progress), `success` (done), `warn`
  (skippable failure), `fail` (fatal — it `exit 1`s). Don't `echo` raw status.
- **Optional steps `warn` and continue; only truly fatal conditions `fail`.**
  An install step that fails should not abort the whole bootstrap.
- Guard external commands with `command -v <cmd> &>/dev/null`.
- Honour `--dry-run`: when set, print `info "would …"` instead of acting. Every
  mutating function in `bootstrap` already follows this; match it.
- Privilege escalation in scripts uses `sudo` directly inside the distro
  `install_cmd()` (see `detect-distro.sh`); interactive functions use `IFSUDO`.

## Adding a package (use the `add-package` skill)

1. Add a row to `packages.conf`:
   ```
   name|apt-package|pacman-package|dnf-package
   ```
   `name` is the logical key you reference in code. Columns map to the package
   manager's real name. Leave a column's value as the closest equivalent; the
   `pkg()` lookup column is chosen by `$PKG_COL` per distro.
2. Reference it from `install-base` (core) or `install-desktop` (GUI) via
   `install_pkg <name>`. For macOS add a parallel `install_brew <formula>` /
   `install_brew_cask <cask>` call in the `IS_MACOS` branch.
3. If a package only applies to some environments, gate it with the existing
   detectors in `install-desktop`: `is_macos`, `is_wayland`, `is_gnome`,
   `is_raspberry_pi`, `has_battery`.
4. A missing mapping is non-fatal — `install_pkg` `warn`s and skips.

## Adding a new distro

Add a `case` arm in `detect-distro.sh` matching the distro's `ID` from
`/etc/os-release`, set `PKG_COL` to a (possibly new) column index, and define
`install_cmd()`. If you add a column, add it to every row in `packages.conf`
and update the format comment at the top.

## Adding an installer step to bootstrap

Write a self-contained `install_<thing>()` that: returns early if already
installed (`success "<thing> already installed"`), honours `--dry-run`, and
`warn`s (not `fail`s) on failure. Then call it from the main install sequence
near the other `install_*` calls. If it pulls from the network, it belongs here
— never in a startup module.

## Verifying

```sh
bash -n script/<file>           # syntax
shellcheck script/<file>        # if available
script/bootstrap --dry-run      # full link preview, no mutations
script/update --check-updates   # network read-only
```

Never run a real `bootstrap`/`install-*` against the live `$HOME` to "test" —
use `--dry-run`, or inspect the resolved package names with the `pkg()` logic.
