#
#       The MIT License
#
#       Copyright (c) Daniel Ripoll, <info@danielripoll.es>, <http://danielripoll.es>
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

###      GENERAL ALIAS     ###
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
alias nano='nano -w -B'
alias home='cd ~'
alias desk='cd ~/Desktop'
alias hist="grep '$1' ~/.zsh_history"
alias less='less -M'
alias grep='grep --color=auto'
alias nestat='$IFSUDO netstat -tpav'
alias unix2dos='recode lat1..ibmpc'
alias dos2unix='recode ibmpc..lat1'
alias ls='ls -FX --format=across --color=auto'
alias l='ls'
alias hgg='fc -l 0|grep'  # Very often I want to see a bunch of history entries instead of simply searching back
alias diffc='colordiff'
alias pget='http_proxy=127.0.0.1:8118 wget' #wget behind proxy
alias myproxy="http_proxy=127.0.0.1:8118 http://quinaeslamevaip.info/txt/" #Used for knowing the ip
alias ban='iptables -I INPUT -j DROP -s'
alias unban='iptables -D INPUT -j DROP -s'

###     ALIAS FOR CHECKSUMS           ###
alias md5='md5sum'
alias sha1='sha1sum'
alias ha224='sha224sum'
alias sha256='sha256sum'
alias sha384='sha384sum'
alias sha512='sha512sum'

###      ALIAS FOR OWNER LAZYNESS     ###
alias md='mkdir'
alias rd='rmdir'
alias cls='clear'
alias se='$IFSUDO $EDITOR'
alias top='htop'
alias mytop='htop -u $USER'
alias fecha='date "+%A %d, %B, %Y %l:%M %p %Z"' #date in spanish format
alias p="cd .."

###      ALIAS FOR SECURITY     ###
#alias rm='rm -i'
#alias mv='mv -i'
alias ln='ln -i'

###      ALIAS FOR PROCESS SNAPSHOT     ###
alias psa='ps auxf'
alias psg='ps aux | grep --color=auto $1'  #It requires an argument

###      ALIAS FOR SPACE USAGE     ###
alias dhu='du -sh'
alias dul='du -h | less'
alias dfh='df -h'


###      ALIAS FOR LISTING     ###
alias ll='ls -lF --color=tty --sort=size'
alias la='ls -laF --color=tty --sort=size'
alias count='(ls -1 /$(pwd) | wc -l)'


###      ALIAS FOR APTITUDE AND APT-GET, and YUM     ###
DISTRO=`grep '^NAME' /etc/os-release|sed s'?=? ?'|sed s'?"??'g|awk '{print $2}'`
VERSION=`grep '^VERSION_ID' /etc/os-release |sed s'?=? ?'|sed s'?"??'g|awk '{print $2}'`
if [ "$DISTRO" = "Ubuntu" ] || [ "$DISTRO" = "Debian" ] || [ "$DISTRO" = "Raspbian" ];then
    alias update='$IFSUDO apt-get update'
    alias instal='$IFSUDO apt-get install'
    alias insta='$IFSUDO aptitude install'
    alias upgrade='$IFSUDO apt-get upgrade'
    alias reinstall='$IFSUDO aptitude reinstall'
    alias afind='$IFSUDO aptitude search'
    alias afile='dpkg-query -S'
    alias ainfo='$IFSUDO apt-cache show'
    alias linstall='$IFSUDO dpkg -i'
    alias uninstall='$IFSUDO apt-get remove'
    alias purge='$IFSUDO apt-get purge'
elif [ "$DISTRO" = "Fedora" ]; then
    if [ "$VERSION" = "22" ]; then
      alias update='$IFSUDO dnf check-update'
      alias upgrade='$IFSUDO dnf update'
      alias instal='$IFSUDO dnf install'
      alias afind='$IFSUDO dnf search'
      alias ainfo='$IFSUDO dnf info'
      alias remove='$IFSUDO dnf remove'
      alias uninstall='$IFSUDO dnf reinstall'
      alias clean='$IFSUDO dnf clean'
    else
      alias update='$IFSUDO yum check-update'
      alias upgrade='$IFSUDO yum update'
      alias instal='$IFSUDO yum install'
      alias linstall='$IFSUDO yum localinstall'
      alias afind='$IFSUDO yum search'
      alias ainfo='$IFSUDO yum info'
      alias uninstall='$IFSUDO yum remove'
      alias reinstall='$IFSUDO yum reinstall'
    fi
fi

###      SET UP AUTO EXTENSION STUFF    ###
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf

if [ -n "$BROWSER" ]; then
    alias -s html=$BROWSER
    alias -s org=$BROWSER
    alias -s php=$BROWSER
    alias -s com=$BROWSER
    alias -s net=$BROWSER
fi

if [ -n "$VISOR" ]; then
    alias -s png=$VISOR
    alias -s pnm=$VISOR
    alias -s bmp=$VISOR
    alias -s jpg=$VISOR
    alias -s gif=$VISOR
fi

if [ -n "$OFFICESUITE" ]; then
   alias -s sxw=$OFFICESUITE
   alias -s doc=$OFFICESUITE
   alias -s odt=$OFFICESUITE
   alias -s ods=$OFFICESUITE
   alias -s odp=$OFFICESUITE
   alias -s xls=$OFFICESUITE
   alias -s xlsx=$OFFICESUITE
fi

if [ -n "$EDITOR" ]; then
    alias -s txt=$EDITOR
fi

if [ -n "$PDFVIEWER" ]; then
    alias -s pdf=$PDFVIEWER
fi

if [ -n "$GIMP" ]; then
    alias -s xcf=$GIMP
    alias -s psd=$GIMP
fi


if [ -n "$GIMP" ]; then
    alias -s xcf=$GIMP
    alias -s psd=$GIMP
fi

if [ "$OS" = "Arch" ];then
    alias -s PKGBUILD=$EDITOR
fi
