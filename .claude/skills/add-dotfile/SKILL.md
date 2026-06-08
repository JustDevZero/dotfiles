---
name: add-dotfile
description: Add a new config file or topic to this dotfiles repo so bootstrap symlinks it into $HOME, handling special targets and private/template variants. Use when asked to track a new dotfile, rc file, or app config in the dotfiles.
---

# Add a dotfile / config

Track a new configuration file so `script/bootstrap` links it into `$HOME`. Read
the root `AGENTS.md` "symlink model" section first.

## 1. Place the file with a `.symlink` suffix

- Put it in the relevant topic directory (or create a new one), named
  `something.symlink`. **Depth matters**: `bootstrap` only finds `*.symlink` at
  the repo root or **one level deep** (`find -maxdepth 2`).
- Default mapping: `topic/name.symlink` → `~/.name` (leading dot added,
  `.symlink` dropped). So `foo/bar.symlink` links to `~/.bar`.

## 2. Non-default target? Add a special case

If the file must land somewhere other than `~/.name` (e.g. under
`~/.config/...`), add an arm to the `case` in `install_dotfiles()` in
`script/bootstrap`, mirroring the existing ones:

```sh
mytool.conf.symlink)
  mkdir -p "$HOME/.config/mytool"
  dst="$HOME/.config/mytool/mytool.conf" ;;
```

(See how `starship.toml.symlink`, `config.toml.symlink`, `logo.sh.symlink` are
handled.)

## 3. Private / templated config?

If the file holds secrets or per-machine identity:

- Commit a template named `name.symlink.example` (the `.example` suffix means
  `bootstrap` does **not** link it).
- Add the real linked filename to `.gitignore` so the user's filled-in copy is
  never committed (cf. `git/gitconfig.local.symlink`).
- Have the main config `include`/source the private one (cf. `gitconfig.symlink`
  including `~/.gitconfig.local`).

## 4. Shell module instead of a symlink?

If what you're adding is shell behaviour (aliases/functions/PATH), you usually
do **not** want a `*.symlink` — drop a `*.zsh` in the topic dir and the zsh
loader auto-sources it (`path.zsh` = PATH fragment, `completion.zsh` =
completion styles, anything else = a normal module). See root `AGENTS.md`.

## 5. Document & verify

- Add the topic/file to the structure section of `README.md` if it's a new area.
- Preview the linking without mutating `$HOME`:
  ```sh
  bash -n script/bootstrap
  script/bootstrap --dry-run        # confirm it prints "would link <dst> -> <src>"
  ```

## 6. Commit

`git feat track <name> config` (or `git chore: …`) — conventional, GPG-signed,
no AI trailer.
