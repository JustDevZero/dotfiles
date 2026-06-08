---
name: add-package
description: Add a cross-distro package to this dotfiles repo — map it in script/packages.conf for apt/pacman/dnf, add the macOS brew equivalent, and wire it into install-base or install-desktop. Use when asked to make the dotfiles install a new tool/package.
---

# Add a package

Make the dotfiles install a new package across Debian/Ubuntu, Arch, Fedora and
macOS. Read `script/AGENTS.md` first.

## 1. Map the package name

Add one row to `script/packages.conf` (skip rows starting with `#`):

```
name|apt-package|pacman-package|dnf-package
```

- `name` is the **logical key** you reference from scripts (your choice; keep it
  descriptive, e.g. `image_viewer_wl`).
- The three columns are the real package name in each manager. Use the closest
  equivalent per distro; the active column is chosen by `$PKG_COL` in
  `detect-distro.sh`.
- Verify the real names exist (e.g. `apt-cache show <pkg>`, the Arch/Fedora
  package search) rather than guessing.

## 2. Wire it into an installer

Pick the right script:

- **Core CLI tool, every machine** → `script/install-base` (add the logical name
  to the `BASE_PKGS` list, or an `install_pkg <name>` call).
- **GUI / desktop tool** → `script/install-desktop`.

In the Linux branch call `install_pkg <name>`. In the macOS (`IS_MACOS`) branch
add the parallel `install_brew <formula>` or `install_brew_cask <cask>`.

## 3. Gate it if conditional (install-desktop only)

Use the existing detectors when a package only applies sometimes:

```sh
if is_wayland; then install_pkg image_viewer_wl; else install_pkg image_viewer_x11; fi
if is_gnome; then install_pkg pdf_gnome; else install_pkg pdf_fallback; fi
has_battery        && install_pkg battery_acpi
is_raspberry_pi    || install_pkg sensors
```

A missing mapping is **non-fatal**: `install_pkg` `warn`s and skips. Don't add
`fail` for an optional package.

## 4. New distro/column?

If the package needs a package manager not yet handled, add a `case` arm in
`script/detect-distro.sh` (match `/etc/os-release` `ID`, set `PKG_COL`, define
`install_cmd`), add the new column to **every** row in `packages.conf`, and
update the format comment at the top.

## 5. Document & verify

- If the package backs a documented feature/function, mention it where that
  feature is described in `README.md`.
- Verify without mutating the system:
  ```sh
  bash -n script/install-base script/install-desktop
  shellcheck script/*            # if available
  ```
  Sanity-check resolution by reading the `pkg()`/`PKG_COL` logic for the target
  distro; do **not** run a real install to "test" it.

## 6. Commit

`git feat add <package> to install-{base,desktop}` — conventional, GPG-signed,
no AI trailer.
