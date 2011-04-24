# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

DISTRO=`cat /etc/issue|head -n 1|awk '{print $2}'`

if [ "$DISTRO" = "natty" ]; then
    export LANG=es_ES.UTF-8
    setxkbmap es
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#if running zsh...
if [ -n "$ZSH_VERSION" ]; then
    #include .bashrc
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    export HOMEBIN="$HOME/bin
    if [ -d "$HOME/bin/private" ]; then
        export PRIVBIN=$HOME/bin/private
    fi
    if [ -d "$HOME/bin/public" ]; then
        export PRIVBIN=$HOME/bin/private
    fi

fi



if [ -d "$HOME/Desarrollo/android-sdk" ]; then
    export ANDROID_TOOLS="$HOME/Desarrollo/android-sdk/tools"
    export ANDROID_PLATAFORM_TOOLS="$HOME/Desarrollo/android-sdk/platform-tools"
fi

if [ -d "$HOME/Desarrollo/eclipse" ]; then
    export ECLIPSE="$HOME/Desarrollo/eclipse"
fi

if [ -d "$HOME/Desarrollo/phonegap-android/bin" ]; then
    export PHONEGAP="$HOME/Desarrollo/phonegap-android/bin"
fi

export PATH="$HOMEBIN:$ANDROID_TOOLS:$ANDROID_PLATAFORM_TOOLS:$ECLIPSE:$PHONEGAP:$PATH"
