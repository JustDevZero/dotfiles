#
#       The MIT License
#
#       Copyright (c) Mephiston <meph.snake@gmail.com>
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


#####      PROGRAMS     #####

###    PROGRAM FOR EXTRACTING COMPRESSED ARCHIVES   ###
function extraer() { # decompress archive (to directory $2 if wished for and possible)
   if [ -f "$1" ] ; then
    case "$1" in
        *.tar.bz2|*.tbz2|*.tbz) mkdir -v "$2" 2>/dev/null ; tar xvjf "$1" -C "$2" ;;
        *.tar.gz | *.tgz) mkdir -v "$2" 2>/dev/null ; tar xvzf "$1" -C "$2" ;;
        *.tar.xz) mkdir -v "$2" 2>/dev/null ; tar xvJf "$1" ;;
        *.tar) mkdir -v "$2" 2>/dev/null ; tar xvf "$1" -C "$2" ;;
        *.rar) mkdir -v "$2" 2>/dev/null ; 7z x "$1" "$2" ;;
        *.zip) mkdir -v "$2" 2>/dev/null ; unzip "$1" -d "$2" ;;
        *.7z) mkdir -v "$2" 2>/dev/null ; 7z x "$1" -o"$2" ;;
        *.lzo) mkdir -v "$2" 2>/dev/null ; lzop -d "$1" -p"$2" ;;
        *.gz) gunzip "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.Z) uncompress "$1" ;;
        *.ace)                 unace x $1    ;;
        *.lha)                 lha e $1    ;;
        *.lz)                  lzip -dk $1 ;;
        *.xz|*.txz|*.lzma|*.tlz) xz -d "$1" ;;
        *) echo ""${1}" format not recognized." ;;
        esac
   else
    echo "Sorry, '$2' could not be decompressed."
    echo "Usage: ad <archive> <destination>"
    echo "Example: ad PKGBUILD.tar.bz2 ."
    echo "Valid archive types are:"
    echo "tar.bz2, tar.gz, tar.xz, tar, bz2,"
    echo "gz, tbz2, tbz, tgz, lzo, lha, ace, Z"
    echo "rar, zip, 7z, xz and lzma"
   fi
}
function comprimir() { # compress a file or folder
    case "$1" in
        tar.bz2|.tar.bz2) tar cvjf "${2%%/}.tar.bz2" "${2%%/}/" ;;
        tbz2|.tbz2) tar cvjf "${2%%/}.tbz2" "${2%%/}/" ;;
        tbz|.tbz) tar cvjf "${2%%/}.tbz" "${2%%/}/" ;;
        tar.xz) tar cvJf "${2%%/}.tar.gz" "${2%%/}/" ;;
        tar.gz|.tar.gz) tar cvzf "${2%%/}.tar.gz" "${2%%/}/" ;;
        tgz|.tgz) tar cvjf "${2%%/}.tgz" "${2%%/}/" ;;
        tar|.tar) tar cvf "${2%%/}.tar" "${2%%/}/" ;;
        rar|.rar) rar a "${2}.rar" "$2" ;;
        zip|.zip) zip -9 "${2}.zip" "$2" ;;
        7z|.7z) 7z a "${2}.7z" "$2" ;;
        lzo|.lzo) lzop -v "$2" ;;
        gz|.gz) gzip -v "$2" ;;
        bz2|.bz2) bzip2 -v "$2" ;;
        xz|.xz) xz -v "$2" ;;
        lzma|.lzma) lzma -v "$2" ;;
        *)  echo "ac(): compress a file or directory."
            echo "Usage: ac <archive type> <filename>"
            echo "Example: ac tar.bz2 PKGBUILD"
            echo "Please specify archive type and source."
            echo "Valid archive types are:"
            echo "tar.bz2, tar.gz, tar.gz, tar, bz2, gz, tbz2, tbz,"
            echo "tgz, lzo, rar, zip, 7z, xz and lzma." ;;
    esac
}

function listar() { # list content of archive but don't unpack
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2|*.tbz2|*.tbz) tar -jtf "$1" ;;
            *.tar.gz) tar -ztf "$1" ;;
            *.tar|*.tgz|*.tar.xz) tar -tf "$1" ;;
            *.gz) gzip -l "$1" ;;
            *.rar) rar vb "$1" ;;
            *.zip) unzip -l "$1" ;;
            *.7z) 7z l "$1" ;;
            *.lzo) lzop -l "$1" ;;
            *.ace) unace l $1    ;;
            *.xz|*.txz|*.lzma|*.tlz) xz -l "$1" ;;
         esac
    else
        echo "Sorry, '$1' is not a valid archive."
        echo "Valid archive types are:"
        echo "tar.bz2, tar.gz, tar.xz, tar, gz,"
        echo "tbz2, tbz, tgz, lzo, rar, ace"
        echo "zip, 7z, xz and lzma"
    fi
}
# Show some status info
function state() {
    print
    print "Date..: "$(date "+%Y-%m-%d %H:%M:%S")
    print "Shell.: Zsh $ZSH_VERSION (PID = $$, $SHLVL nests)"
    print "Term..: $TTY ($TERM), ${BAUD:+$BAUD bauds, }$COLUMNS x $LINES chars"
    print "Login.: $LOGNAME (UID = $EUID) on $HOST"
    print "System: $(cat /etc/[A-Za-z]*[_-][rv]e[lr]*)"
    print "Uptime:$(uptime)"
    print
}


###    PROGRAM FOR VIEW MANPAGES IN PDF   ###
function man2pdf() {
    if [ -z $1 ]; then
        echo "USAGE: man2pdf [manpage]"
    else
        if [ `find /usr/share/man -name $1\* | wc -l` -gt 0 ]; then
        out=/tmp/$1.pdf
        if [ ! -e $out ]; then
            man -t $1 | ps2pdf - > $out
        fi
        if [ -e $out ]; then
            /usr/bin/evince $out
        fi
    else
        echo "There is no manual entry for $1."
    fi
    fi
}


###    PROGRAM FOR MOUNTING ISO IMAGES ON /media   ###
miso () {
    [ ! -f "$1" ] && { echo "Provide a valid iso file"; return 1; }
    mountpoint="/media/${1//.iso}"
    $IFSUDO mkdir -p "$mountpoint"
    $IFSUDO mount -o loop "$1" "$mountpoint"

}

###    PROGRAM FOR UMOUNTING ISO IMAGES ON /media   ###
umiso () {
    mountpoint="/media/${1//.iso}"
    [ ! -d "$mountpoint" ] && { echo "Not a valid mount point"; return 1; }
    $IFSUDO umount "$mountpoint"
    $IFSUDO rm -ir "$mountpoint"

}


###      PROGRAM FOR CREATE ARCHIVES OF DIRECTORY     ###
mktar() { tar cvf "${1%%/}.tar" "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz" "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }
mkrar() { rar a "${1%%/}.rar" "${1%%/}/"; }
mkzip() { zip -r "${1%%/}.zip" "${1%%/}/"; }
mk7zp() { 7z a "${1%%/}.7z" "${1%%/}/"; }
mkiso() { mkisofs -r $1>$1.iso; }
mklz() { lzip -k9 $1 }
mkrzip() { rzip -k9 $1 }


###      VERSION OF THE MOST USED COMMAND MEME BY CHOMS    ###
most-used-command () {
    hist|awk '1 { if ( $1=="$IFSUDO") { print $1,$2 } else { print $1 } }'|sort|uniq -c|sort -rn|head -10
    }


###      PROGRAM FOR SCREENSHOTING WITH TIMESTAMP     ###
screenshot() {
if ! which scrot &>/dev/null; then
echo "${FUNCNAME[0]}(): First you must install 'scrot'"
return 1
fi
XDG_PICTURES_DIR=$(xdg-user-dir PICTURES)
mkdir -p "$XDG_PICTURES_DIR/Screenshots"
scrot "$XDG_PICTURES_DIR/Screenshots/screenshot_`date +%d%m%y%H%M%S`.png"
}

###      PROGRAM FOR AUTOMATING PROCESS     ###
function cdl { cd "$@" && ls; } #Go to the directory, and list it.
function ndir { ls -ld *(/om[1]) } #List the newest directory.
function nfile { ls *(.om[1]) } #List the newest file
function rmtype { rm -i *.$1(.) } #Remove files in specified format in a directory
function iprivate { print Your private IP is: ${${$(LC_ALL=C /sbin/ifconfig eth0)[7]}:gs/addr://} } #Gives your private ip, with nice format, change to your interface if needed.
function lenght { print -rl $HOME/${(l:$1::?:)~:-}* } # List files with lenght superior than specified.
function age { ls -tald **/*(m-$1) } # List files with age younger than specified.
function rmspace { for a in ./**/*\ *(Dod); do mv $a ${a:h}/${a:t:gs/ /_}; done }
function lower { zmv '(*)' '${(L)1}'  }
function uper { zmv '(*)' '${(U)1}' }
function watchssh { watch -n 1 'ps aux | grep ssh | grep -v grep' }
#function capitalize { zmv '(**/)(*).(#i)mp3' '$1$2.mp3'  && zmv '* *' '$f:gs/ /_'} #capitalize all mp3 files, need to be improved for use with any extension
function battery {  upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage"|grep percentage|awk '{print $2}' }

# Check new ip and whatch if changed.
function myip {
    if [ ! -f "$HOME/.lastip" ]; then
        wget -q http://quinaeslamevaip.info/txt/ -O "$HOME/.lastip"
    else
        lastip=$(cat "$HOME/.lastip")
        newip=$(wget http://quinaeslamevaip.info/txt/ -q -O -)
        if [ "$lastip" != "$newip"  ]; then
            echo "Your ip has changed from $lastip to:"
            sed s"=$lastip=$newip="g -i $HOME/.lastip
        fi
    fi
    cat $HOME/.lastip
}

### This write the backward on the LBUFFER automagically
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
