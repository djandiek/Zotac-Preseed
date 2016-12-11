#!/bin/bash

sudo apt-get -qy purge teamviewer
sudo updatedb
locate teamviewer | xargs /bin/rm -rf
wget -q -O teamviewer_i386.deb http://175.103.28.7/xkloud/zotac/teamviewer_i386.deb
sudo dpkg -i --force-depends teamviewer_i386.deb
sudo apt-get -fy install

sudo /usr/bin/teamviewer daemon start &> /dev/null
