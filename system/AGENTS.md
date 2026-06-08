# AGENTS.md — `system/`

General shell aliases, functions and profile shared across machines. Read the
root `AGENTS.md` first.

## Files

| File | Role |
|------|------|
| `programs.zsh` | All interactive shell **functions** (extract, serve, myip, todo, res, ansible/ssh helpers, …) plus the bilingual alias block. Sourced **only by zsh**. |
| `aliases.zsh` | General aliases, including the zsh `alias -s` suffix associations driven by `~/.localrc` vars (`$BROWSER`, `$VISOR`, …). |
| `programs.zsh` zsh-only block | Functions using zsh globbing/zmv live under `if [[ -n "$ZSH_VERSION" ]]`. |
| `profile.symlink` | Linked to `~/.profile`. |
| `psqlrc.symlink`, `htoprc.symlink` | Tool rc files linked into `$HOME`. |
| `servers.zsh`, `programs.zsh` | auto-loaded as `*.zsh` modules by the loader. |

## Function conventions (the pattern to copy)

Every function in `programs.zsh` follows this shape:

```zsh
name() {
  local arg="${1:?usage: name <arg>}"   # validate; usage to stderr via :?
  dotfiles_require some_tool || return 1 # hard dependency check
  # ... do the work ...
  # on failure: printf 'name: <what failed>\n' >&2; return 1
}
```

Rules:

- **Never `exit`** — these run in the user's interactive shell; `exit` kills it.
  Always `return <n>`.
- **All usage/error text to stderr** (`>&2`).
- **Guard external tools**: `dotfiles_require a b c` (fails if any missing) or
  `dotfiles_has cmd` for an `if`-branch fallback. Prefer providing a fallback
  chain (e.g. `serve` tries ruby → python3 → busybox; `json` tries jq → python3).
- **OS / environment branching** uses `[[ "$(uname -s)" == Darwin ]]` for macOS
  and `$WAYLAND_DISPLAY` / `$XDG_SESSION_TYPE` for the display server, mirroring
  `afk`, `screenshot`, `battery`, `res`.
- **Privilege escalation**: `${IFSUDO:-sudo}` (see `mountiso`/`umountiso`).
- **zsh-only features** (extended globbing, `zmv`, `zle` widgets) go inside the
  `if [[ -n "$ZSH_VERSION" ]]` block. Everything outside it must be plain
  POSIX-ish shell that zsh can run — but note the file is never sourced by bash,
  so zsh syntax like `${=var}` word-splitting is fine.
- **Machine-specific config** is read from env vars with a default
  (`${RES_MODE_A:-}`, `${PROJECTS:-…}`) and documented in
  `shell/localrc.template`.

## Bilingual aliases

English function names are always defined. Spanish convenience aliases are added
at the bottom of `programs.zsh` only when `DOTFILES_LANG` (or `LANG`) starts with
`es`:

```zsh
case "$_dotfiles_lang" in
  es*)
    alias extraer=extract
    alias comprimir=compress
    alias listar=listarchive
    ;;
esac
```

If you add a user-facing verb with an obvious Spanish name, add its `es` alias
here too.

## After adding/changing a function

1. Add or update its row in the **README function table** (root `README.md`).
2. If it introduces a tunable, add it to `shell/localrc.template`.
3. Syntax + smoke test:
   ```sh
   zsh -n system/programs.zsh
   zsh -ic 'source system/programs.zsh; type <fn>; <fn> --help-ish-invocation'
   ```

See the `add-shell-function` skill, which automates the full flow.
