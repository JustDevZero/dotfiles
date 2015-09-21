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


# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    export HOMEBIN="$HOME/bin"
    export PATH=$HOMEBIN:$PATH
fi


if [ -d "/opt/firefox" ]; then
    export FIREFOXBIN="/opt/firefox"
    export PATH=$FIREFOXBIN:$PATH
    export BROWSER=$FIREFOXBIN/firefox
fi


if [ -d "/opt/thunderbird" ]; then
    export THUNDERBIRDBIN="/opt/firefox"
    export PATH=$FIREFOXBIN:$PATH
fi


# Instructions about how to instal android-sdk on:
# http://www.if-not-true-then-false.com/2010/android-sdk-and-eclipse-adt-on-fedora-centos-red-hat-rhel/
# http://blog.sudobits.com/2011/07/27/android-sdk-for-ubuntu-11-0410-1011-10/
if [ -d "/opt/android/sdk" ]; then
    export ANDROID_TOOLS="/opt/android/sdk/tools"
    export ANDROID_PLATAFORM_TOOLS="/opt/android/sdk/platform-tools"
    export PATH=$ANDROID_TOOLS:$ANDROID_PLATAFORM_TOOLS:$PATH
fi


# Instructions about how to install Eclipse found on (it is usefull for every Linux system):
# http://www.if-not-true-then-false.com/2010/linux-install-eclipse-on-fedora-centos-red-hat-rhel/
if [ -d "/opt/eclipse" ]; then
    export ECLIPSE="/opt/eclipse"
    export PATH=$ECLIPSE:$PATH
fi

if [ -d "/opt/android/cmake/" ]; then
    export ANDROID_CMAKE="/opt/android/cmake/"
    export PATH=$ANDROID_CMAKE:$PATH
fi


# Instructions about where to download android-ndk.
# http://developer.android.com/sdk/ndk/index.html
if [ -d "/opt/android/ndk" ]; then
    export ANDROID_NDK="/opt/android/ndk"
fi
