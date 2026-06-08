---
name: verify-shell
description: Verify changes to this dotfiles repo without mutating $HOME — syntax-check edited zsh/bash files, run shellcheck if present, dry-run bootstrap, and smoke-load functions in a clean shell. Use after editing any shell module, script, or function here, before committing.
---

# Verify shell changes

This repo has no test suite. Run these read-only checks after any change. Skip
the steps that don't apply to what you touched; never run a real
`bootstrap`/`install-*` against the live `$HOME` to "test".

## 1. Syntax-check what you edited

```sh
# zsh modules (anything matching */*.zsh, and *.zsh.symlink entrypoints)
zsh -n system/programs.zsh
zsh -n zsh/zshrc.symlink

# bash scripts
bash -n script/bootstrap
bash -n script/update script/install-base script/install-desktop

# POSIX sh files sourced by both shells
sh -n shell/logo.sh.symlink
```

## 2. shellcheck (if installed)

```sh
command -v shellcheck >/dev/null && shellcheck script/* git/bin/git-* || \
  echo "shellcheck not installed — skipping"
```

`*.zsh` files are zsh, not POSIX — shellcheck them only with `-s bash` and treat
zsh-specific warnings as expected noise.

## 3. Smoke-load functions in a clean shell

```sh
zsh -ic 'source system/programs.zsh; type <fn>'   # confirms it parses & defines
zsh -ic 'source system/programs.zsh; <fn>'        # no args → expect usage on stderr, return 1
```

Confirm a missing-dependency path degrades gracefully (prints to stderr,
returns non-zero) rather than crashing.

## 4. Dry-run the installer (if you touched bootstrap / *.symlink / packages)

```sh
script/bootstrap --dry-run        # prints "would link …" — no $HOME mutation
script/update --check-updates     # network read-only version check
```

## 5. Config parse-checks (if you touched config)

```sh
git config --file git/gitconfig.symlink --list   # gitconfig parses
```

## 6. Stray-character guard for docs

```sh
grep -nP '[\x{FEFF}\x{200B}\x{00A0}]' <files>   # catch zero-width/nbsp in *.md
```

Report exactly what passed, what was skipped (and why), and any failures with
their output. Only call a change verified once the relevant checks above pass.
