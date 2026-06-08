function serve {
  local port="${1:-3000}"
  local ip
  ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
  printf 'Serving on http://%s:%s\n' "${ip:-localhost}" "$port"

  if command -v ruby &>/dev/null; then
    ruby -run -e httpd . -p "$port"
  elif command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v busybox &>/dev/null; then
    local _index="./index.html"
    local _created=0
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
    busybox httpd -f -p "$port"
    [ "$_created" -eq 1 ] && rm -f "$_index"
  else
    printf 'serve: no suitable HTTP server found (ruby, python3 or busybox required)\n' >&2
    return 1
  fi
}
