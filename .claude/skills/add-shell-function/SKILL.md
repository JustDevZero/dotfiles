---
name: add-shell-function
description: Add a new interactive shell function to this dotfiles repo (system/programs.zsh), following the repo's guard/IFSUDO/bilingual/cross-platform conventions, and keep the README in sync. Use when asked to add a helper, command, or shell function to the dotfiles.
---

# Add a shell function

Add a new interactive function to `system/programs.zsh` the way this repo does
it, then document and verify it.

## 1. Decide placement

- **General function** (works in bash-like and zsh): place it in the main body
  of `system/programs.zsh`, near related functions.
- **Needs zsh-only features** (extended globbing, `zmv`, `zle`): place it inside
  the `if [[ -n "$ZSH_VERSION" ]]` … `fi` block.
- Aliases (not functions) go in `system/aliases.zsh` instead.

Read `system/AGENTS.md` for the full conventions before editing.

## 2. Write it to the pattern

```zsh
name() {
  local arg="${1:?usage: name <arg>}"   # validate args; usage goes to stderr
  dotfiles_require tool1 tool2 || return 1   # hard dependencies
  # work; on failure: printf 'name: <reason>\n' >&2; return 1
}
```

Checklist:
- [ ] Lower-case name; no clash with an existing function/alias/command
      (`grep -n 'name()' system/*.zsh`).
- [ ] Args validated with `${1:?usage: …}`; **all** usage/error text to `>&2`.
- [ ] External tools guarded with `dotfiles_require` / `dotfiles_has`; provide a
      fallback chain when reasonable (cf. `serve`, `json`).
- [ ] `return` on failure — **never `exit`** (it kills the user's shell).
- [ ] Cross-platform: branch on `[[ "$(uname -s)" == Darwin ]]` and
      `$WAYLAND_DISPLAY`/`$XDG_SESSION_TYPE` where relevant.
- [ ] Privilege escalation via `${IFSUDO:-sudo}`, never bare `sudo`.
- [ ] Machine-specific values read as `${VAR:-default}` and added to
      `shell/localrc.template`.

## 3. Bilingual alias (if the verb has an obvious Spanish name)

Add it to the `case "$_dotfiles_lang" in es*)` block at the bottom of
`programs.zsh` (e.g. `alias extraer=extract`).

## 4. Document

Add a row to the **function table** in `README.md` (`| \`name <arg>\` | … |`).
If you added a `~/.localrc` tunable, also document it in the README variable
table and in `shell/localrc.template`.

## 5. Verify (or invoke the `verify-shell` skill)

```sh
zsh -n system/programs.zsh
zsh -ic 'source system/programs.zsh; type name; name'   # expect usage on no args
```

## 6. Commit

Conventional commit, GPG-signed, no AI trailer:
`git feat add <name> shell function` (or `git/bin/git-feat`).
