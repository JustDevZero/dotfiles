function serve {
  local port="${1:-3000}"
  local ip
  ip=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}')
  echo "Serving on http://${ip:-localhost}:$port"

  if command -v ruby &>/dev/null; then
    ruby -run -e httpd . -p "$port"
  else
    python3 -m http.server "$port"
  fi
}
