function serve {
  port="${1:-3000}"
  echo "Serving on:"
  ip=$(ip addr |grep 192|sed s'?/? ?'|head -n1|awk '{print $2}')
  echo "http://$ip:$port"
  ruby -run -e httpd . -p $port
}
