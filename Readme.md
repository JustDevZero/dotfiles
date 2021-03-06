# dotfiles

Copyright 2015 Daniel Ripoll <info@danielripoll.es>

This stuff is free software; you can redistribute it and/or modify
it under the terms of the MIT Licence, checkout [License.md](https://github.com/JustDevZero/dotfiles/blob/master/License.md)

# How to install

Go to your $HOME with your favorite terminal/tty.

1. git clone --recursive https://github.com/justdevzero/dotfiles.git .dotfiles
2. cd .dotfiles/script
3. ./bootstrap
4. enjoy
5. report bugs if you detect something weird. KTHX


# Changelog:

2015-09-24 Daniel Ripoll <info@danielripoll.es>
 * Changed the way of the installation of this dotfiles in a MORE clever way.

2015-05:11 Daniel Ripoll  <info@danielripol.es>

 * Deleted ogg converters, and conky config to https://github.com/JustDevZero/deprecated-scripts

2012-11-24  Daniel Ripoll  <info@danielripol.es>

 * Added zsh-syntax-highlight


2010-04-26  Mephiston  <meph.snake@gmail.com>

 * Added most-used-command and ubuntu-9.10-script

2010-04-16  Mephiston  <meph.snake@gmail.com>

 * Added miso, umiso, and man2pdf

2010-01-02  Mephiston  <meph.snake@gmail.com>

 * Separated projects of ogg2mp3, one with lame & normalize, another with ffmpeg.
 * Separated project for ogg2mp3 with zsh instead of bash.
 * Added twitter, identi.ca, and syncronized captability with one only command (look in .zprograms for twit, identica, and twitden)
 * Separated file for completion styles
 * Changed HISTFILE name to .zsh_history that is more Z-logical :P, increased the max commands in history to 50.000 for having better stadistics and losing less comands.
 * Added autoextension stuf in .zaliases.


2009-12-30  Mephiston  <meph.snake@gmail.com>

 * Added ogg2mp3 script, compatible with bash.

This repository is used for puting my config files, with a few scripts, you can use this files with the terms indicated about.
If a file uses some other license, will be specified in the begining of it.

The aliases.zsh and programs.zsh contains alias and functions, for programs that maybe are not installed by default. Please take in mind to read them as I can always forget to write it here..

Programs that are used:
zsh
most
libreoffice
gimp
gawk
recode
htop
nano
git
rar, unrar, unace, ncompress, bunzip2, gunzip, p7zip, p7zip-plugins, lha.
mkisofs
scrot
curl

Needed for man2pdf:
groff
groff-base
man2html
texlive
