#!/bin/bash

clear
sudo apt-get -qq install wget
cd ${HOME}
rm -f ak_menu.sh
wget -q http://175.103.28.7/xkloud/zotac/ak_menu.sh && result="OK" || result="FAIL"
if test ${result} != "OK";
then
    echo "Download of required script failed. Check internet connection."
    echo "If problem persists, ask Andrew Kirkland for assistance"
    echo "skype: djandiek"
    echo "email: andrew.kirkland@movielink.net.au"
    exit
fi;
chmod +x ak_menu.sh
./ak_menu.sh
echo
echo "Script complete"
rm -f ak_menu.sh

# wget http://175.103.28.7/xkloud/zotac/ak_installer.sh && chmod +x ak_installer.sh && ./ak_installer.sh
