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
