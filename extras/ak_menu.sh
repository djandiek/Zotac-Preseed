#!/bin/bash

script=""
machine=$(sudo dmidecode -t1 | grep 'Product Name');

os=$(ls /usr/bin/*session)
if [[ "${os}" =~ "lxsession" ]];
then
    os="lubuntu"
else
    os="ubuntu"
fi;

clear
echo "Current machine details: ${machine}"
echo

echo "Please select an option from the menu:"
echo "--------------------------------------"
echo ""
echo -e "\e[1mF. Full Setup (Andrej's stuff first, then Andrew's. No need for 0, 1 or 2 when this option is selected)\e[0m\n"
echo "---"
echo "0. Install Andrej's Additions (Run before option 1 or 2)"
if [[ "${os}" =~ "lubuntu" ]];
then
    echo -e "\e[2m1. Setup Zotac 4 Port (Ubuntu installation only)\e[0m"
    echo "2. Setup Zotac Nano (Lubuntu installation only)"
    echo "---"
    echo "3. Install Crash/Hang Fix (Existing Lubuntu installation only)"
    echo "4. Change screen rotation (Existing Lubuntu installation only)"
else
    echo "1. Setup Zotac 4 Port (Ubuntu installation only)"
    echo -e "\e[2m2. Setup Zotac Nano (Lubuntu installation only)\e[0m\n"
    echo "---"
    echo -e "\e[2m3. Install Crash/Hang Fix (Existing Lubuntu installation only)\e[0m"
    echo -e "\e[2m4. Change screen rotation (Existing Lubuntu installation only)\e[0m"
fi;
echo "5. Re-install TeamViewer"
echo "6. Install Browser Check Patch"
if [[ ! "${os}" =~ "lubuntu" ]];
then
    echo "---"
    echo "D. Delete Desktop setup item"
fi;
echo "---"
echo "Q. Quit"
echo

read -n 1 -p "Choice?: " choice
echo
case ${choice} in
f|F)
    script="ak_full_install.sh"
;;
1)
    script="ak_zotac4port.sh"
;;
2)
    script="ak_zotacnano.sh"
;;
3)
    script="ak_crash_patch.sh"
;;
4)
    script="ak_zotacnano_rotation_fix.sh"
;;
5)
    script="reinstall_teamviewer.sh"
;;
6)
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
