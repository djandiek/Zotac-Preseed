#!/bin/bash

clear

release=$(lsb_release --release | cut -f2);
release=$(echo -e "${release}" | tr -d '[:space:]')

sudo apt-get -qy purge teamviewer
sudo updatedb
locate teamviewer | xargs /bin/rm -rf
wget -q -O teamviewer_i386.deb http://175.103.28.7/xkloud/zotac/teamviewer_i386.deb
if [ $(echo "${release} > 14.04" | bc) -eq 1 ]
then
    apt install teamviewer_i386.deb
else
    sudo dpkg -i --force-depends teamviewer_i386.deb
    sudo apt-get -fy install
fi;

sudo /usr/bin/teamviewer daemon start &> /dev/null
sudo teamviewer passwd eze_zotac_ss
/usr/bin/teamviewer &> /dev/null
