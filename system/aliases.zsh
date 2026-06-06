###      GENERAL ALIASES     ###
alias mkdir='nocorrect mkdir'
alias nano='nano -w -B'
alias home='cd ~'
alias desk='cd $(xdg-user-dir DESKTOP 2>/dev/null || echo ~)'
alias less='less -M'
alias grep='grep --color=auto'
alias git='nocorrect git'
alias ls='ls -FX --format=across --color=auto'
alias l='ls'
alias diffc='colordiff'

# history search — show entries matching a pattern with timestamps
alias hgg='fc -l -t "%F %T" 0 | grep'

# netstat with sudo if needed
alias netst="${IFSUDO:-sudo} netstat -tpav"

# encoding conversion
alias unix2dos='iconv -f UTF-8 -t UTF-16'
alias dos2unix='iconv -f UTF-16 -t UTF-8'

# tor-aware wget (requires torsocks installed)
if command -v torsocks &>/dev/null; then
    alias tget='torsocks wget'
fi

# firewall shortcuts
alias ban="${IFSUDO:-sudo} iptables -I INPUT -j DROP -s"
alias unban="${IFSUDO:-sudo} iptables -D INPUT -j DROP -s"

###     CHECKSUMS           ###
alias md5='md5sum'
alias sha1='sha1sum'
alias sha224='sha224sum'
alias sha256='sha256sum'
alias sha384='sha384sum'
alias sha512='sha512sum'

###      LAZINESS     ###
alias md='mkdir'
alias rd='rmdir'
alias cls='clear'
alias se="${IFSUDO:-sudo} $EDITOR"
alias top='htop'
alias mytop='htop -u $USER'
alias fecha='date "+%A %d, %B, %Y %l:%M %p %Z"'
alias p='cd ..'

###      SECURITY     ###
alias ln='ln -i'

###      PROCESSES     ###
alias psa='ps auxf'
alias psg='ps aux | grep --color=auto'

###      DISK SPACE     ###
alias dhu='du -sh'
alias dul='du -h | less'
alias dfh='df -h'

###      LISTING     ###
alias ll='ls -lF --color=tty --sort=size'
alias la='ls -laF --color=tty --sort=size'
alias count='ls -1 | wc -l'

###      PACKAGE MANAGER     ###
_distro=$(grep '^ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
_version=$(grep '^VERSION_ID=' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')

case "$_distro" in
    ubuntu|debian|raspbian)
        alias update="${IFSUDO:-sudo} apt-get update"
        alias instal="${IFSUDO:-sudo} apt-get install"
        alias upgrade="${IFSUDO:-sudo} apt-get upgrade"
        alias reinstall="${IFSUDO:-sudo} apt-get install --reinstall"
        alias afind='apt-cache search'
        alias afile='dpkg-query -S'
        alias ainfo='apt-cache show'
        alias linstall="${IFSUDO:-sudo} dpkg -i"
        alias uninstall="${IFSUDO:-sudo} apt-get remove"
        alias purge="${IFSUDO:-sudo} apt-get purge"
        ;;
    fedora)
        if [ "${_version:-0}" -gt 21 ] 2>/dev/null; then
            alias update="${IFSUDO:-sudo} dnf check-update"
            alias upgrade="${IFSUDO:-sudo} dnf update"
            alias instal="${IFSUDO:-sudo} dnf install"
            alias afind="${IFSUDO:-sudo} dnf search"
            alias ainfo="${IFSUDO:-sudo} dnf info"
            alias uninstall="${IFSUDO:-sudo} dnf remove"
            alias reinstall="${IFSUDO:-sudo} dnf reinstall"
            alias clean="${IFSUDO:-sudo} dnf clean all"
        else
            alias update="${IFSUDO:-sudo} yum check-update"
            alias upgrade="${IFSUDO:-sudo} yum update"
            alias instal="${IFSUDO:-sudo} yum install"
            alias linstall="${IFSUDO:-sudo} yum localinstall"
            alias afind="${IFSUDO:-sudo} yum search"
            alias ainfo="${IFSUDO:-sudo} yum info"
            alias uninstall="${IFSUDO:-sudo} yum remove"
            alias reinstall="${IFSUDO:-sudo} yum reinstall"
        fi
        ;;
esac
unset _distro _version

###      FILE EXTENSION ASSOCIATIONS (zsh only)    ###
if [[ -n "$ZSH_VERSION" ]]; then
    alias -s {gz,tgz}='tar -xzvf'
    alias -s bz2='tar -xjvf'
    alias -s xz='tar -xJvf'

    [[ -n "$BROWSER" ]]     && alias -s {html,org,php,com,net}="$BROWSER"
    [[ -n "$VISOR" ]]       && alias -s {png,pnm,bmp,jpg,jpeg,gif,webp}="$VISOR"
    [[ -n "$OFFICESUITE" ]] && alias -s {doc,docx,odt,ods,odp,xls,xlsx}="$OFFICESUITE"
    [[ -n "$EDITOR" ]]      && alias -s txt="$EDITOR"
    [[ -n "$PDFVIEWER" ]]   && alias -s pdf="$PDFVIEWER"
    [[ -n "$GIMP" ]]        && alias -s {xcf,psd}="$GIMP"
    [[ "$_distro" = "arch" ]] && alias -s PKGBUILD="$EDITOR"
fi
