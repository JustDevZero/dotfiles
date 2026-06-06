### APACHE ###
# systemctl works everywhere today — no distro branching needed
if command -v apache2 &>/dev/null || command -v httpd &>/dev/null; then
    _apache_svc=$(command -v apache2 &>/dev/null && echo apache2 || echo httpd)
    alias a2stop="${IFSUDO:-sudo} systemctl stop $_apache_svc"
    alias a2start="${IFSUDO:-sudo} systemctl start $_apache_svc"
    alias a2restart="${IFSUDO:-sudo} systemctl restart $_apache_svc"
    alias a2reload="${IFSUDO:-sudo} systemctl reload $_apache_svc"
    alias a2status="${IFSUDO:-sudo} systemctl status $_apache_svc"
    unset _apache_svc
fi

# Debian/Ubuntu apache2 site/module helpers
alias a2ensite="${IFSUDO:-sudo} a2ensite"
alias a2dissite="${IFSUDO:-sudo} a2dissite"
alias a2enmod="${IFSUDO:-sudo} a2enmod"
alias a2dismod="${IFSUDO:-sudo} a2dismod"
