function serve {
  local port="${1:-3000}"
  local ip
  ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
  printf 'Serving on http://%s:%s\n' "${ip:-localhost}" "$port"

  if command -v ruby &>/dev/null; then
    ruby -run -e httpd . -p "$port"
  elif command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v busybox &>/dev/null && busybox httpd --help &>/dev/null; then
    busybox httpd -f -p "$port"
  else
    printf 'serve: no suitable HTTP server found (ruby, python3 or busybox required)\n' >&2
    return 1
  fi
}
