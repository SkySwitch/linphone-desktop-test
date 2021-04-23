#!/usr/bin/env bash
##
## Copyright (c) 2010-2020 Belledonne Communications SARL.
##
## This file is part of linphone-desktop
## (see https://www.linphone.org).
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.
##

for i in 16 32 128 256 512 1024
do
  mkdir -p hicolor.iconset
  inkscape -z --export-type=png --export-filename=hicolor.iconset/icon_${i}x${i}.png -w $i -h $i ../../../assets/images/linphone_logo.svg
  let j=i/2
  cp hicolor.iconset/icon_${i}x${i}.png hicolor.iconset/icon_${j}x${j}@2x.png
done
iconutil -c icns hicolor.iconset -o linphone.icns
