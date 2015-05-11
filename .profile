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
    #include .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        . "$HOME/.zshrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    export HOMEBIN="$HOME/bin"
    export $PATH=$HOMEBIN
fi


# Instructions about how to instal android-sdk on:
# http://www.if-not-true-then-false.com/2010/android-sdk-and-eclipse-adt-on-fedora-centos-red-hat-rhel/
# http://blog.sudobits.com/2011/07/27/android-sdk-for-ubuntu-11-0410-1011-10/
if [ -d "/opt/android/sdk" ]; then
    export ANDROID_TOOLS="/opt/android/sdk/tools"
    export ANDROID_PLATAFORM_TOOLS="/opt/android/sdk/platform-tools"
    export $PATH:$ANDROID_TOOLS:$ANDROID_PLATAFORM_TOOLS
fi


# Instructions about how to install Eclipse found on (it is usefull for every Linux system):
# http://www.if-not-true-then-false.com/2010/linux-install-eclipse-on-fedora-centos-red-hat-rhel/
if [ -d "/opt/eclipse" ]; then
    export ECLIPSE="/opt/eclipse"
    export $PATH=$ECLIPSE:$PATH
fi

if [ -d "/opt/android/cmake/" ]; then
    export ANDROID_CMAKE="/opt/android/cmake/"
    export $PATH=$ANDROID_CMAKE:$PATH
fi


# Instructions about where to download android-ndk.
# http://developer.android.com/sdk/ndk/index.html
if [ -d "/opt/android/ndk" ]; then
    export ANDROID_NDK="/opt/android/ndk"
fi
