# AGENTS.md — `git/`

Git configuration and helper scripts. Read the root `AGENTS.md` first.

## Files

| File | Role |
|------|------|
| `gitconfig.symlink` | Linked to `~/.gitconfig`. Includes `~/.gitconfig.local` for private/identity settings; sets aliases, GPG signing, templatedir. |
| `gitconfig.local.symlink.example` | Template for the private include (name, email, signing key). The real `gitconfig.local.symlink` is gitignored. |
| `gitconfig.andromeda.symlink` | A named work/profile config variant. |
| `gitignore.symlink` | Global gitignore → `~/.gitignore` (referenced by `core.excludesfile`). |
| `gittemplate.symlink.example` / `git-templates.symlink/` | Commit/template dir (`init.templatedir`). |
| `aliases.zsh` | Shell-level `git*` aliases (`gitps`, `gitc`, …). Auto-loaded module. |
| `path.zsh` | Adds `git/bin` to `PATH` — this is the **only** dir put on `PATH`. |
| `bin/git-*` | Conventional-commit helper subcommands. |

## Commit conventions

- **Conventional Commits**: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`,
  `style:`, `test:`, and the project-local `localize:`.
- Commits are **GPG-signed** (`commit.gpgsign = true`; the `ci`/`comit` aliases
  also force `-S`).
- **Never** append `Co-Authored-By` or any AI-attribution trailer.
- Match the existing log style: lower-case, imperative, concise subject. Use a
  `scope` when it clarifies (`feat(logo): …`).

## The `git-*` helper scripts

Each `git/bin/git-<type>` is a tiny wrapper that builds a conventional-commit
message, exposed as `git <type>` because `git/bin` is on `PATH`. They share one
interface:

```sh
git feat                 # opens editor with "feat: " prefilled  (-e)
git feat add new helper  # commits "feat: add new helper"
git feat -s parser fix x # commits "feat(parser): fix x"   (-s = scoped)
```

To **add a new commit type**, copy an existing one (e.g. `git-feat`) to
`git/bin/git-<type>`, change the three `git commit -m "<type>: …"` strings,
`chmod +x` it, and add it to the table in the root `README.md`. Keep the
`-s`/scope and bare-prefix-with-`-e` behaviour identical for consistency.

## Editing gitconfig

- Identity, signing key and anything machine/account-specific belong in
  `~/.gitconfig.local` (via the `.example`), **not** in `gitconfig.symlink`.
- Preserve the pager settings (`core.pager`, per-command `pager.*`) — they are
  deliberate (`branch` paging is disabled, color forced on).

## Verifying

```sh
bash -n git/bin/git-<type>
git/bin/git-<type> -s scope test message   # dry-run on a scratch repo, not here
git config --file git/gitconfig.symlink --list   # parse-check the config
```
