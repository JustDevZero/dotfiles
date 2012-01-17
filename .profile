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
    export HOMEBIN="$HOME/bin"
fi


# Instructions about how to instal android-sdk on:
# http://www.if-not-true-then-false.com/2010/android-sdk-and-eclipse-adt-on-fedora-centos-red-hat-rhel/
# http://blog.sudobits.com/2011/07/27/android-sdk-for-ubuntu-11-0410-1011-10/
if [ -d "/opt/android-sdk" ]; then
    export ANDROID_TOOLS="/opt/android-sdk/tools"
    export ANDROID_PLATAFORM_TOOLS="/opt/android-sdk/platform-tools"
fi


# Instructions about how to install Eclipse found on (it is usefull for every Linux system):
# http://www.if-not-true-then-false.com/2010/linux-install-eclipse-on-fedora-centos-red-hat-rhel/
if [ -d "/opt/eclipse" ]; then
    export ECLIPSE="/opt/eclipse"
fi


# Instructions about how to prepare an enviroment for phonegpa
# http://www.howtoforge.com/setting-up-an-android-app-build-environment-with-eclipse-android-sdk-phonegap-fedora-14
# http://www.howtoforge.com/setting-up-an-android-app-build-environment-with-eclipse-android-sdk-phonegap-ubuntu-11.04
if [ -d "$HOME/Desarrollo/phonegap-android/bin" ]; then
    export PHONEGAP="$HOME/Desarrollo/phonegap-android/bin"
fi


# Instructions about how to use android-cmake here
# http://code.google.com/p/android-cmake/
# themeph mirror on gitorious:  https://gitorious.org/android-cmake
if [ -d "$HOME/Proyectos/android-cmake/toolchain" ]; then
    export ANDTOOLCHAIN="$HOME/Proyectos/android-cmake/toolchain/android.toolchain.cmake"
fi

if [ -d "$HOME/Proyectos/android-cmake/" ]; then
    export ANDROID_CMAKE="$HOME/Proyectos/android-cmake/"
fi


# Instructions about where to download android-ndk.
# http://developer.android.com/sdk/ndk/index.html
if [ -d "$HOME/android-ndk" ]; then
    export ANDROID_NDK="$HOME/android-ndk"
fi

export ANDTOOLCHAIN=/home/mephiston/Proyectos/android-cmake/toolchain/android.toolchain.cmake
export ANDROID_CMAKE=/home/mephiston/Proyectos/android-cmake
export ANDROID_NDK=/home/mephiston/android-ndk


export PATH="$HOMEBIN:$ANDROID_TOOLS:$ANDROID_PLATAFORM_TOOLS:$ECLIPSE:$PHONEGAP:$ANDTOOLCHAIN:$ANDROID_CMAKE:$ANDROID_NDK:$PATH"
