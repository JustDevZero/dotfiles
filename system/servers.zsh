_serve_needs_sudo() {
  local port=$1
  [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -lt 1024 ]
}

_serve_ruby() {
  local port="${1:-3000}"
  local sudo_cmd=""
  _serve_needs_sudo "$port" && sudo_cmd="${IFSUDO:-sudo}"
  ${sudo_cmd:+$sudo_cmd} ruby -run -e httpd . -p "$port"
}

_serve_python() {
  local port="${1:-3000}"
  local sudo_cmd=""
  _serve_needs_sudo "$port" && sudo_cmd="${IFSUDO:-sudo}"
  ${sudo_cmd:+$sudo_cmd} python3 -m http.server "$port"
}

_serve_busybox() {
  local port="${1:-3000}"
  local _index="./index.html"
  local _created=0
  local sudo_cmd=""
  _serve_needs_sudo "$port" && sudo_cmd="${IFSUDO:-sudo}"

  if [ ! -f "$_index" ]; then
    printf '<html><body><h1>Index of %s</h1><ul>' "$(pwd)" > "$_index"
    find . -maxdepth 1 -not -name '.' | sort | while read -r f; do
      f="${f#./}"
      printf '<li><a href="%s">%s</a></li>' "$f" "$f" >> "$_index"
    done
    printf '</ul></body></html>' >> "$_index"
    _created=1
  fi
  trap '[ "$_created" -eq 1 ] && rm -f "$_index"' EXIT INT TERM
  ${sudo_cmd:+$sudo_cmd} busybox httpd -f -p "$port"
  [ "$_created" -eq 1 ] && rm -f "$_index"
}

serve() {
  local port="${1:-3000}"
  local ip
  ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
  printf 'Serving on http://%s:%s\n' "${ip:-localhost}" "$port"

  if command -v ruby &>/dev/null; then
    _serve_ruby "$port"
  elif command -v python3 &>/dev/null; then
    _serve_python "$port"
  elif command -v busybox &>/dev/null; then
    _serve_busybox "$port"
  else
    printf 'serve: no suitable HTTP server found (ruby, python3 or busybox required)\n' >&2
    return 1
  fi
}
