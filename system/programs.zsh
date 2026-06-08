#
#       The MIT License
#
#       Copyright (c) Daniel Ripoll <i@danielripoll.es>
#
#       Permission is hereby granted, free of charge, to any person obtaining a copy
#       of this software and associated documentation files (the "Software"), to deal
#       in the Software without restriction, including without limitation the rights
#       to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#       copies of the Software, and to permit persons to whom the Software is
#       furnished to do so, subject to the following conditions:
#
#       The above copyright notice and this permission notice shall be included in
#       all copies or substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#       IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#       FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#       AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#       LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#       OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#       THE SOFTWARE.

dotfiles_has() {
  command -v "$1" >/dev/null 2>&1
}

dotfiles_require() {
  local command_name
  for command_name in "$@"; do
    if ! dotfiles_has "$command_name"; then
      printf '%s: command not found\n' "$command_name" >&2
      return 1
    fi
  done
}

extract() {
  local archive=$1
  local destination=${2:-.}

  if [[ -z "$archive" || ! -f "$archive" ]]; then
    printf 'Usage: extract <archive> [destination]\n' >&2
    return 1
  fi

  mkdir -p "$destination"

  case "$archive" in
    *.tar.bz2|*.tbz2|*.tbz) dotfiles_require tar && tar xjf "$archive" -C "$destination" ;;
    *.tar.gz|*.tgz) dotfiles_require tar && tar xzf "$archive" -C "$destination" ;;
    *.tar.xz|*.txz) dotfiles_require tar && tar xJf "$archive" -C "$destination" ;;
    *.tar) dotfiles_require tar && tar xf "$archive" -C "$destination" ;;
    *.rar) dotfiles_require 7z && 7z x "$archive" -o"$destination" ;;
    *.zip) dotfiles_require unzip && unzip "$archive" -d "$destination" ;;
    *.7z) dotfiles_require 7z && 7z x "$archive" -o"$destination" ;;
    *.lzo) dotfiles_require lzop && lzop -d "$archive" -p"$destination" ;;
    *.gz) dotfiles_require gunzip && gunzip "$archive" ;;
    *.bz2) dotfiles_require bunzip2 && bunzip2 "$archive" ;;
    *.Z) dotfiles_require uncompress && uncompress "$archive" ;;
    *.ace) dotfiles_require unace && unace x "$archive" ;;
    *.lha) dotfiles_require lha && lha e "$archive" ;;
    *.lz) dotfiles_require lzip && lzip -dk "$archive" ;;
    *.xz|*.lzma|*.tlz) dotfiles_require xz && xz -d "$archive" ;;
    *)
      printf 'extract: unsupported archive type: %s\n' "$archive" >&2
      return 1
      ;;
  esac
}

compress() {
  local format=$1
  local source=$2
  local base

  if [[ -z "$format" || -z "$source" ]]; then
    printf 'Usage: compress <format> <file-or-directory>\n' >&2
    return 1
  fi

  base="${source%%/}"

  case "$format" in
    tar.bz2|.tar.bz2) dotfiles_require tar && tar cjf "$base.tar.bz2" "$base" ;;
    tbz2|.tbz2) dotfiles_require tar && tar cjf "$base.tbz2" "$base" ;;
    tbz|.tbz) dotfiles_require tar && tar cjf "$base.tbz" "$base" ;;
    tar.xz|.tar.xz) dotfiles_require tar && tar cJf "$base.tar.xz" "$base" ;;
    tar.gz|.tar.gz) dotfiles_require tar && tar czf "$base.tar.gz" "$base" ;;
    tgz|.tgz) dotfiles_require tar && tar czf "$base.tgz" "$base" ;;
    tar|.tar) dotfiles_require tar && tar cf "$base.tar" "$base" ;;
    rar|.rar) dotfiles_require rar && rar a "$base.rar" "$base" ;;
    zip|.zip) dotfiles_require zip && zip -r "$base.zip" "$base" ;;
    7z|.7z) dotfiles_require 7z && 7z a "$base.7z" "$base" ;;
    lzo|.lzo) dotfiles_require lzop && lzop -v "$base" ;;
    gz|.gz) dotfiles_require gzip && gzip -v "$base" ;;
    bz2|.bz2) dotfiles_require bzip2 && bzip2 -v "$base" ;;
    xz|.xz) dotfiles_require xz && xz -v "$base" ;;
    lzma|.lzma) dotfiles_require lzma && lzma -v "$base" ;;
    lz|.lz) dotfiles_require lzip && lzip -k9 "$base" ;;
    rzip|.rzip) dotfiles_require rzip && rzip -k9 "$base" ;;
    iso|.iso) dotfiles_require mkisofs && mkisofs -r "$base" >"$base.iso" ;;
    *)
      printf 'compress: unsupported format: %s\n' "$format" >&2
      return 1
      ;;
  esac
}

afk() {
  # macOS
  if [[ "$(uname -s)" = "Darwin" ]]; then
    pmset displaysleepnow
    return
  fi

  # systemd (moderno)
  if dotfiles_has loginctl; then
    loginctl lock-session
    return
  fi

  if dotfiles_has cinnamon-screensaver-command && pidof -s cinnamon-screensaver >/dev/null 2>&1; then
    cinnamon-screensaver-command -l
    return
  fi

  if dotfiles_has gnome-screensaver-command && pidof -s gnome-screensaver >/dev/null 2>&1; then
    gnome-screensaver-command -l
    return
  fi

  if dotfiles_has dde-lock && pidof -s dde-session-daemon >/dev/null 2>&1; then
    dde-lock
    return
  fi

  if dotfiles_has i3lock-fancy; then
    i3lock-fancy
    return
  fi

  printf 'afk: no supported screen locker found\n' >&2
  return 1
}

listarchive() {
  local archive=$1

  if [[ -z "$archive" || ! -f "$archive" ]]; then
    printf 'Usage: listarchive <archive>\n' >&2
    return 1
  fi

  case "$archive" in
    *.tar.bz2|*.tbz2|*.tbz) dotfiles_require tar && tar -jtf "$archive" ;;
    *.tar.gz|*.tgz) dotfiles_require tar && tar -ztf "$archive" ;;
    *.tar|*.tar.xz|*.txz) dotfiles_require tar && tar -tf "$archive" ;;
    *.gz) dotfiles_require gzip && gzip -l "$archive" ;;
    *.rar) dotfiles_require rar && rar vb "$archive" ;;
    *.zip) dotfiles_require unzip && unzip -l "$archive" ;;
    *.7z) dotfiles_require 7z && 7z l "$archive" ;;
    *.lzo) dotfiles_require lzop && lzop -l "$archive" ;;
    *.ace) dotfiles_require unace && unace l "$archive" ;;
    *.xz|*.lzma|*.tlz) dotfiles_require xz && xz -l "$archive" ;;
    *)
      printf 'listarchive: unsupported archive type: %s\n' "$archive" >&2
      return 1
      ;;
  esac
}

state() {
  printf '\n'
  printf 'Date..: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')"
  printf 'Shell.: Zsh %s (PID = %s, %s nests)\n' "$ZSH_VERSION" "$$" "$SHLVL"
  printf 'Term..: %s (%s), %s x %s chars\n' "${TTY:-unknown}" "${TERM:-unknown}" "${COLUMNS:-?}" "${LINES:-?}"
  printf 'Login.: %s (UID = %s) on %s\n' "${LOGNAME:-unknown}" "$EUID" "${HOST:-$(hostname)}"
  if [[ -r /etc/os-release ]]; then
    printf 'System: %s\n' "$(. /etc/os-release && printf '%s %s' "${NAME:-Linux}" "${VERSION_ID:-}")"
  else
    printf 'System: %s\n' "$(uname -sr)"
  fi
  printf 'Uptime:%s\n' "$(uptime)"
  printf '\n'
}

man2pdf() {
  local page=$1
  local out

  if [[ -z "$page" ]]; then
    printf 'Usage: man2pdf <manpage>\n' >&2
    return 1
  fi

  dotfiles_require man ps2pdf || return 1

  out="/tmp/${page}.pdf"
  if [[ ! -e "$out" ]]; then
    man -t "$page" | ps2pdf - "$out" || return 1
  fi

  if dotfiles_has xdg-open; then
    xdg-open "$out" >/dev/null 2>&1
  elif dotfiles_has open; then
    open "$out"
  elif dotfiles_has evince; then
    evince "$out" >/dev/null 2>&1
  else
    printf '%s\n' "$out"
  fi
}

mountiso() {
  local iso=$1
  local mountpoint

  [ -f "$iso" ] || { printf 'Usage: mountiso <iso-file>\n' >&2; return 1; }
  mountpoint="/media/${${iso##*/}%.iso}"
  ${IFSUDO:-sudo} mkdir -p "$mountpoint"
  ${IFSUDO:-sudo} mount -o loop "$iso" "$mountpoint"
}

umountiso() {
  local iso=$1
  local mountpoint="/media/${${iso##*/}%.iso}"

  [ -d "$mountpoint" ] || { printf 'umountiso: not a valid mount point: %s\n' "$mountpoint" >&2; return 1; }
  ${IFSUDO:-sudo} umount "$mountpoint"
  ${IFSUDO:-sudo} rmdir "$mountpoint"
}

extar()  { extract "$1"; }
extgz()  { extract "$1"; }
exzip()  { extract "$1"; }
exrar()  { extract "$1"; }
ex7z()   { extract "$1"; }

mktar()  { compress tar   "$1"; }
mktgz()  { compress tgz   "$1"; }
mktbz()  { compress tbz2  "$1"; }
mkrar()  { compress rar   "$1"; }
mkzip()  { compress zip   "$1"; }
mk7zp()  { compress 7z    "$1"; }
mkiso()  { compress iso   "$1"; }
mklz()   { compress lz    "$1"; }
mkrzip() { compress rzip  "$1"; }

most-used-command() {
  # fc -l con timestamps produce: "N  YYYY-MM-DD HH:MM:SS  comando args"
  # el comando está en el campo $4
  fc -l -t "%F %T" 1 2>/dev/null | awk '{print $4}' | sort | uniq -c | sort -rn | head -10
}

screenshot() {
  local pictures_dir
  local screenshots_dir
  local out

  if dotfiles_has xdg-user-dir; then
    pictures_dir="$(xdg-user-dir PICTURES)"
  else
    pictures_dir="$HOME/Pictures"
  fi

  screenshots_dir="$pictures_dir/Screenshots"
  mkdir -p "$screenshots_dir"
  out="$screenshots_dir/screenshot_$(date +%Y%m%d%H%M%S).png"

  if [[ "$(uname -s)" = "Darwin" ]]; then
    screencapture -x "$out"
  elif [[ "${XDG_SESSION_TYPE:-}" = "wayland" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    dotfiles_require grim || return 1
    grim "$out"
  else
    dotfiles_require scrot || return 1
    scrot "$out"
  fi
}

cdl() { cd "$@" && ls; }
iprivate() {
  local ip_addr=""

  if dotfiles_has ip; then
    ip_addr="$(ip -o -4 addr show scope global 2>/dev/null | awk '
      $2 !~ /^(lo|docker|br-|virbr|veth|tailscale|zt)/ {
        sub(/\/.*/, "", $4)
        print $4
        exit
      }
    ')"
  fi

  if [[ -z "$ip_addr" ]] && dotfiles_has hostname; then
    ip_addr="$(hostname -I 2>/dev/null | awk '{print $1}')"
  fi

  if [[ -n "$ip_addr" ]]; then
    printf 'Your private IP is: %s\n' "$ip_addr"
  else
    printf 'iprivate: could not determine private IP\n' >&2
    return 1
  fi
}

if [[ -n "$ZSH_VERSION" ]]; then

ndir() {
  local newest=(*(/om[1]))
  [[ ${#newest} -gt 0 ]] && ls -ld "$newest[1]" || printf 'ndir: no directories found\n' >&2
}
nfile() {
  local newest=(*(.om[1]))
  [[ ${#newest} -gt 0 ]] && ls "$newest[1]" || printf 'nfile: no files found\n' >&2
}
rmtype() {
  [[ -n "$1" ]] || { printf 'Usage: rmtype <extension>\n' >&2; return 1; }
  local files=(*."$1"(.N))
  [[ ${#files} -gt 0 ]] && rm -i "${files[@]}" || printf 'rmtype: no .%s files found\n' "$1" >&2
}
length() { printf '%s\n' "$HOME"/${(l:$1::?:)~:-}*; }
age() {
  [[ "$1" =~ ^[0-9]+$ ]] || { printf 'Usage: age <days>\n' >&2; return 1; }
  ls -tald **/*(m-"$1")
}
rmspace() { for a in ./**/*\ *(Dod); do mv -- "$a" "${a:h}/${a:t:gs/ /_}"; done; }
lower() { autoload -Uz zmv && zmv '(*)' '${(L)1}'; }
uper() { autoload -Uz zmv && zmv '(*)' '${(U)1}'; }

fi # end zsh-only block
watchssh() { dotfiles_require watch && watch -n 1 'ps aux | grep ssh | grep -v grep'; }

battery() {
  local battery_device
  local capacity_file
  local status_file
  local capacity
  local battery_status

  if dotfiles_has acpi; then
    acpi | sed -E 's/^.*ing, //'
  elif dotfiles_has upower; then
    battery_device="$(upower -e 2>/dev/null | grep '/battery_' | head -n 1)"
    if [[ -n "$battery_device" ]]; then
      upower -i "$battery_device" 2>/dev/null | awk '
        /state:/ { state = $2 }
        /percentage:/ { percentage = $2 }
        END {
          if (percentage != "") {
            if (state != "") printf "%s, %s\n", state, percentage
            else print percentage
          }
        }
      '
      return
    fi
  fi

  for capacity_file in /sys/class/power_supply/BAT*/capacity; do
    [[ -r "$capacity_file" ]] || continue
    status_file="${capacity_file%/capacity}/status"
    capacity="$(<"$capacity_file")"
    battery_status=""
    [[ -r "$status_file" ]] && battery_status="$(<"$status_file")"
    if [[ -n "$battery_status" ]]; then
      printf '%s, %s%%\n' "$battery_status" "$capacity"
    else
      printf '%s%%\n' "$capacity"
    fi
    return
  done

  printf 'battery: no battery information found\n' >&2
  return 1
}

myip() {
  local cache_file="${HOME}/.lastip"
  local newip

  dotfiles_require curl || return 1

  newip="$(curl -fsS --max-time 5 https://api.ipify.org 2>/dev/null)" || {
    [[ -r "$cache_file" ]] && cat "$cache_file"
    return 1
  }

  if [[ -r "$cache_file" ]]; then
    local lastip
    lastip="$(<"$cache_file")"
    if [[ "$lastip" != "$newip" ]]; then
      printf 'Your ip has changed from %s to:\n' "$lastip"
    fi
  fi

  printf '%s\n' "$newip"
  printf '%s\n' "$newip" >"$cache_file"
}

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}


if [[ -o interactive ]]; then
  zle -N rationalise-dot
  bindkey . rationalise-dot
fi

mkcd() {
  mkdir -p "$1" && cd "$1"
}

bak() {
  local target="${1:?usage: bak <file>}"
  cp -a "$target" "${target}.bak" && printf 'backed up: %s → %s.bak\n' "$target" "$target"
}

up() {
  local n="${1:-1}"
  local path=""
  for (( i=0; i<n; i++ )); do path+="../"; done
  cd "$path"
}

port() {
  local p="${1:?usage: port <number>}"
  if command -v ss &>/dev/null; then
    ss -tlnp "sport = :$p"
  elif command -v lsof &>/dev/null; then
    lsof -iTCP:"$p" -sTCP:LISTEN -n -P
  else
    printf 'port: requires ss or lsof\n' >&2
    return 1
  fi
}

weather() {
  local location="${1:-Palma}"
  dotfiles_require curl || return 1
  curl -fsSL "https://wttr.in/${location// /+}?lang=es" 2>/dev/null || \
    printf 'weather: could not reach wttr.in\n' >&2
}

psgrep() {
  local term="${1:?usage: psgrep <pattern>}"
  ps aux | grep -v grep | grep -i "$term"
}

retry() {
  local n="${1:?usage: retry <times> <command...>}"
  shift
  local i=1
  until "$@"; do
    (( i++ ))
    if (( i > n )); then
      printf 'retry: command failed after %d attempts\n' "$n" >&2
      return 1
    fi
    printf 'retry: attempt %d/%d failed, retrying...\n' "$((i-1))" "$n" >&2
    sleep 1
  done
}

epoch() {
  if [[ -z "$1" ]]; then
    date +%s
  elif [[ "$1" =~ ^[0-9]+$ ]]; then
    date -d "@$1" 2>/dev/null || date -r "$1"
  else
    printf 'epoch: usage: epoch [unix_timestamp]\n' >&2
    return 1
  fi
}

dsize() {
  du -sh "${1:-.}"/* 2>/dev/null | sort -h
}

tmpdir() {
  local dir
  dir="$(mktemp -d)"
  printf 'tmpdir: %s\n' "$dir"
  cd "$dir"
}

sslcheck() {
  local host="${1:?usage: sslcheck <host[:port]>}"
  local port="${host##*:}"
  [[ "$port" == "$host" ]] && port=443
  host="${host%%:*}"
  dotfiles_require openssl || return 1
  echo | openssl s_client -servername "$host" -connect "${host}:${port}" 2>/dev/null \
    | openssl x509 -noout -subject -dates 2>/dev/null \
    || printf 'sslcheck: could not retrieve certificate for %s:%s\n' "$host" "$port" >&2
}

passgen() {
  local len="${1:-32}"
  LC_ALL=C tr -dc 'A-Za-z0-9!@#$%^&*()-_=+[]{}' </dev/urandom | head -c "$len"
  printf '\n'
}

gitignore() {
  local lang="${1:?usage: gitignore <language>}"
  dotfiles_require curl || return 1
  curl -fsS "https://www.toptal.com/developers/gitignore/api/${lang}" 2>/dev/null \
    || printf 'gitignore: template not found for "%s"\n' "$lang" >&2
}

b64enc() {
  if [[ -n "$1" ]]; then
    printf '%s' "$1" | base64
  else
    base64
  fi
}

b64dec() {
  if [[ -n "$1" ]]; then
    printf '%s' "$1" | base64 --decode 2>/dev/null || printf '%s' "$1" | base64 -d
  else
    base64 --decode 2>/dev/null || base64 -d
  fi
}

json() {
  if command -v jq &>/dev/null; then
    if [[ -n "$1" ]]; then
      jq . "$1"
    else
      jq .
    fi
  else
    if [[ -n "$1" ]]; then
      python3 -m json.tool "$1"
    else
      python3 -m json.tool
    fi
  fi
}

todo() {
  local task="${*:?usage: todo <task description>}"
  local desktop=""

  if dotfiles_has xdg-user-dir; then
    desktop="$(xdg-user-dir DESKTOP 2>/dev/null)"
  fi
  [[ -n "$desktop" && -d "$desktop" ]] || desktop="$HOME/Desktop"

  mkdir -p "$desktop"
  touch "$desktop/$task" && printf 'todo: %s/%s\n' "$desktop" "$task"
}

# Translate a high-level (backend, output, WxH[@Hz]) mode into a tool argv,
# one argument per line (so args containing spaces survive). Used by `res`.
_res_args() {
  local backend=$1 output=$2 spec=$3
  local wxh="${spec%@*}" hz="" modetoken
  [[ "$spec" == *@* ]] && hz="${spec#*@}"
  modetoken="$wxh"; [[ -n "$hz" ]] && modetoken="$wxh@$hz"

  case "$backend" in
    xrandr|gnome-randr)
      printf '%s\n' --output "$output" --mode "$wxh"
      [[ -n "$hz" ]] && printf '%s\n' --rate "$hz" ;;
    wlr-randr)
      printf '%s\n' --output "$output" --mode "$modetoken" ;;
    kscreen-doctor)
      printf '%s\n' "output.$output.mode.$modetoken" ;;
    displayplacer)
      if [[ -n "$hz" ]]; then
        printf '%s\n' "id:$output res:$wxh hz:$hz"
      else
        printf '%s\n' "id:$output res:$wxh"
      fi ;;
  esac
}

res() {
  # Pick a display-control backend for the current platform/session.
  #   macOS            -> displayplacer
  #   Linux/Wayland    -> wlr-randr | gnome-randr | kscreen-doctor
  #   Linux/X11        -> xrandr  (covers XFCE, LXQt and GNOME-on-Xorg)
  local backend=""

  if [[ "$(uname -s)" == "Darwin" ]]; then
    if ! dotfiles_has displayplacer; then
      printf 'res: displayplacer not found — install with: brew install displayplacer\n' >&2
      return 1
    fi
    backend=displayplacer
  elif [[ "${XDG_SESSION_TYPE:-}" == "wayland" || -n "${WAYLAND_DISPLAY:-}" ]]; then
    if dotfiles_has wlr-randr; then
      backend=wlr-randr
    elif dotfiles_has gnome-randr; then
      backend=gnome-randr
    elif dotfiles_has kscreen-doctor; then
      backend=kscreen-doctor
    else
      printf 'res: no Wayland resolution tool found (tried wlr-randr, gnome-randr, kscreen-doctor).\n' >&2
      printf 'res: GNOME on Wayland has no standard CLI — use Settings, or install gnome-randr.\n' >&2
      return 1
    fi
  elif dotfiles_has xrandr; then
    backend=xrandr
  else
    printf 'res: no supported tool found (need displayplacer, xrandr or wlr-randr).\n' >&2
    return 1
  fi

  # Build the two toggle commands as argv arrays. Two ways to configure, in
  # ~/.localrc (raw wins if both are set):
  #   High-level: RES_OUTPUT + RES_A/RES_B as "WxH" (or "WxH@Hz"); res builds
  #               the backend-specific command for you.
  #   Raw:        RES_MODE_A/RES_MODE_B as native arguments for the backend.
  local -a cmd_a cmd_b

  if [[ -n "${RES_MODE_A:-}" && -n "${RES_MODE_B:-}" ]]; then
    # displayplacer wants one quoted argument; randr-family want split flags.
    if [[ "$backend" == displayplacer ]]; then
      cmd_a=("$RES_MODE_A"); cmd_b=("$RES_MODE_B")
    else
      cmd_a=(${=RES_MODE_A}); cmd_b=(${=RES_MODE_B})
    fi
  elif [[ -n "${RES_OUTPUT:-}" && -n "${RES_A:-}" && -n "${RES_B:-}" ]]; then
    cmd_a=("${(@f)$(_res_args "$backend" "$RES_OUTPUT" "$RES_A")}")
    cmd_b=("${(@f)$(_res_args "$backend" "$RES_OUTPUT" "$RES_B")}")
  else
    printf 'res: configure ~/.localrc to enable toggling (%s backend):\n' "$backend" >&2
    printf 'res:   high-level — RES_OUTPUT + RES_A/RES_B (e.g. RES_A="1920x1080")\n' >&2
    printf 'res:   or raw      — RES_MODE_A/RES_MODE_B (native %s arguments)\n' "$backend" >&2
    printf 'res: current display layout:\n' >&2
    case "$backend" in
      displayplacer)  displayplacer list ;;
      kscreen-doctor) kscreen-doctor -o ;;
      *)              "$backend" ;;
    esac
    return
  fi

  local state="${TMPDIR:-/tmp}/.res_state" next
  local -a cmd
  if [[ -r "$state" && "$(<"$state")" == A ]]; then
    cmd=("${cmd_b[@]}"); next=B
  else
    cmd=("${cmd_a[@]}"); next=A
  fi

  "$backend" "${cmd[@]}" && printf '%s' "$next" >"$state"
}

# ---------------------------------------------------------------------------
# Ansible
# ---------------------------------------------------------------------------
if command -v ansible &>/dev/null; then
  alias ans='ansible'
  alias ansp='ansible-playbook --diff'

  ansping() {
    local host="${1:?usage: ansping <host|group>}"
    ansible "$host" -m ping
  }

  ansfacts() {
    local host="${1:?usage: ansfacts <host|group>}"
    ansible "$host" -m setup
  }

  ansvault() {
    local file="${1:?usage: ansvault <file>}"
    if grep -q '^\$ANSIBLE_VAULT;' "$file" 2>/dev/null; then
      ansible-vault decrypt "$file"
    else
      ansible-vault encrypt "$file"
    fi
  }
fi

# ---------------------------------------------------------------------------
# SSH helpers
# ---------------------------------------------------------------------------
sshping() {
  local host="${1:?usage: sshping <host>}"
  ssh -o ConnectTimeout=5 -o BatchMode=yes "$host" true 2>/dev/null \
    && printf '%s: ok\n' "$host" \
    || printf '%s: unreachable\n' "$host" >&2
}

known_hosts_del() {
  local host="${1:?usage: known_hosts_del <host>}"
  ssh-keygen -R "$host" 2>/dev/null && printf 'removed %s from known_hosts\n' "$host"
}

###      LANGUAGE ALIASES      ###
_dotfiles_lang="${DOTFILES_LANG:-${LANG:-en}}"
case "$_dotfiles_lang" in
  es*)
    alias extraer=extract
    alias comprimir=compress
    alias listar=listarchive
    ;;
esac
unset _dotfiles_lang

temp() {
  if command -v sensors &>/dev/null; then
    sensors | awk '
      /^[^:]+:/ && !/^(Adapter|Bus)/ { device=$0; next }
      /°C/ {
        label=$1; sub(/:$/, "", label)
        match($0, /[+-]?[0-9]+\.[0-9]+°C/)
        val=substr($0, RSTART, RLENGTH)
        printf "  %-30s %s\n", label, val
      }
    '
  elif [ -x /usr/bin/vcgencmd ]; then
    echo "  CPU  $(/usr/bin/vcgencmd measure_temp | tr -d 'temp=')"
  elif [ -x /opt/vc/bin/vcgencmd ]; then
    echo "  CPU  $(/opt/vc/bin/vcgencmd measure_temp | tr -d 'temp=')"
  else
    echo "temp: no supported temperature tool found (install lm-sensors)" >&2
    return 1
  fi
}
