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

### ALIAS FOR APACHE ###
if [ "$OS" = "Ubuntu" ] || [ "$OS" = "Debian" ] ;then
    alias a2stop='$IFSUDO invoke-rc.d apache2 stop'
    alias a2start='$IFSUDO invoke-rc.d apache2 start'
    alias a2restart='$IFSUDO invoke-rc.d apache2 restart'
    alias a2reload='$IFSUDO invoke-rc.d apache2  reload'
    alias a2force='$IFSUDO invoke-rc.d apache2 force-reload'
elif [ "$OS" = "Fedora" ] || [ "$OS" = "Centos" ];then
    alias a2stop='$IFSUDO service httpd stop'
    alias a2start='$IFSUDO service httpd start'
    alias a2restart='$IFSUDO service httpd restart'
    alias a2reload='$IFSUDO service httpd reload'
    alias a2force='$IFSUDO service http dforce-reload'
fi

alias a2ensite='$IFSUDO a2ensite'
alias a2dissite='$IFSUDO a2dissite'
alias a2enmod='$IFSUDO a2enmod'
alias a2dismod='$IFSUDO a2dismod'