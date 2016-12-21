#!/bin/bash

script=""
machine=$(sudo dmidecode -t1 | grep 'Product Name');

clear
echo "Current machine details: ${machine}"
echo

echo "Please select an option from the menu:"
echo "--------------------------------------"
echo "0. Install Andrej's Additions (Run first usually)"
echo "1. Setup Zotac 4 Port (Ubuntu installation only)"
echo "2. Setup Zotac Nano (Lubuntu installation only)"
echo "---"
echo "3. Lubuntu - Setup Chrome ADS URL options (Existing Lubuntu installation only)"
echo "4. Ubuntu - Setup Chrome ADS URL options (Existing Ubuntu installation only)"
echo "---"
echo "5. Install Crash/Hang Fix (Existing Lubuntu installation only)"
echo "6. Change screen rotation (Existing Lubuntu installation only)"
echo "7. Re-install TeamViewer"
echo "8. Install Browser Check Patch
echo "---"
echo "D. Delete Desktop setup item"
echo "---"
echo "Q. Quit"
echo

read -n 1 -p "Choice?: " choice
echo
case ${choice} in
1)
    script="ak_zotac4port.sh"
;;
2)
    script="ak_zotacnano.sh"
;;
3)
    script="ak_chrome_patch_lubuntu.sh"
;;
4)
    script="ak_chrome_patch_ubuntu.sh"
;;
5)
    script="ak_crash_patch.sh"
;;
6)
    script="ak_zotacnano_rotation_fix.sh"
;;
7)
    script="reinstall_teamviewer.sh"
;;
8)
    script="chrome_check_patch.sh"
;;
0)
    script="install_andrejs_additions.sh"
;;
d|D)
    sudo rm -f /home/eze_zbox/Desktop/zotac-setup.desktop
    exit;
;;
*)
    echo && echo
    exit
;;
esac

rm -f patch.sh
wget -q -O patch.sh http://175.103.28.7/xkloud/zotac/${script} && result="OK" || result="FAIL"
if test ${result} != "OK";
then
    echo "Download of required script ${script} failed. Check internet connection."
    echo "If problem persists, ask Andrew Kirkland for assistance"
    echo "skype: djandiek"
    echo "email: andrew.kirkland@movielink.net.au"
    exit
fi;
chmod +x patch.sh
./patch.sh
rm patch.sh
