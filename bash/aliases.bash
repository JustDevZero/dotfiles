alias targz='tar -czvf'
alias untargz='tar -xzvf'
alias cd..='cd ..'

# CPU/GPU temperature — lm-sensors primero, fallback a vcgencmd (RPi)
if command -v sensors &>/dev/null; then
    alias temp='sensors'
elif [ -x /usr/bin/vcgencmd ]; then
    alias temp='/usr/bin/vcgencmd measure_temp'
elif [ -x /opt/vc/bin/vcgencmd ]; then
    alias temp='/opt/vc/bin/vcgencmd measure_temp'
fi
