#!/bin/bash

#		ogg2mp3 written in bash
#		version 0.1
#		Copyright 2009 Mephiston <meph.snake@gmail.com>
#		
#		This program is free software; you can redistribute it and/or modify
#		it under the terms of the GNU General Public License as published by
#		the Free Software Foundation; either version 2.1.1 of the License, or
#		(at your option) any later version.
#		
#		This program is distributed in the hope that it will be useful,
#		but WITHOUT ANY WARRANTY; without even the implied warranty of
#		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#		GNU General Public License for more details.
#		
#		You should have received a copy of the GNU General Public License
#		along with this program; if not, get a copy on http://www.gnu.org/licenses/gpl.txt

# ---------------- Generic utilities ---------------- #
# The main purpose of this script is to easily conver OGG files into MP3 files.
# Because some devices don't accept ogg format.
# This script converts massively the ogg files of your actual directory.

# ---------------- Instructions ---------------- #
# For using this script you must have installed Bash, lame, and oggdec.
# As optional extra you can decide to use normalize-audio.
# If you don't want to normalize audio files, you must comment lines refering to normalize-audio.


if ! which oggdec &>/dev/null; then
echo "ogg2mp3: You must install first 'vorbis-tools'"

elif ! which lame &>/dev/null; then
echo "ogg2mp3: You must install first 'lame'. "

elif ! which normalize-audio &>/dev/null; then
echo "ogg2mp3: You must install first 'normalize-audio'. "

else
echo "ogg2mp3 v0.1"
echo "Author: Mephiston"
#Erasing spaces between words
rename 'y/\ /_/' *.ogg

#Uppercase to lowercase
rename 'y/A-Z/a-z/' *.ogg

#Converting ogg files to wav format.
for archivo in *.ogg; do oggdec $archivo; done

#If you don't want to normalize audio, just comment this line'
normalize-audio -m *.wav

for archivo in *.wav; do
	#A variable, for giving name to files
	wavname="$(basename "$archivo" .wav)"
	#Now it checks if bitrate is supplied.
	#If not supplied it will use a default value.
	if [ -z "$1" ]
	then
		echo "Bitrate value not supplied. Default:: 160kbps."
		echo "Note: If you want to specify some specify bitrate, just write 'ogg2mp3 bitrate-desired' "
		lame -b 160 "$wavname.wav" "$wavname.mp3"
	else
		lame -b $1 "$wavname.wav" "$wavname.mp3"
	fi
	#Now it checks if exists some errors.
	#If all is correct delete the wav.
	if [ $? -eq 0 ]
	then
		rm -f "$wavname.wav"
	fi
done
fi

