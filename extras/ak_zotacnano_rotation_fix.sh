#!/bin/bash

os=$(ls /usr/bin/*session)
if [[ "${os}" =~ "lxsession" ]];
then
    os="lubuntu"
else
    os="ubuntu"
fi;
if test ${os} != "lubuntu";
then
    echo "This script will only work if Lubuntu is installed. You are using ${os}"
    exit
fi;
clear
read -n 1 -p "Is this a rotated (portrait) setup? [y/n]: " -t 10 rotated
echo ""

# Forcing resolution to 1280x720
echo "#!/bin/sh" > ~/resolution_fix
echo 'xrandr --newmode "1280x720_60.00"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync' >> ~/resolution_fix
echo 'xrandr --addmode HDMI1 "1280x720_60.00"' >> ~/resolution_fix
if test ${rotated} = "y" -o ${rotated} = "Y";
then
    echo 'xrandr --output HDMI1 --primary --mode "1280x720_60.00" --rotate left' >> ~/resolution_fix
else
    echo 'xrandr --output HDMI1 --primary --mode "1280x720_60.00"' >> ~/resolution_fix
fi
chmod +x ~/resolution_fix
sudo mv ~/resolution_fix /opt/resolution_fix.sh
if grep -Fq "resolution_fix" ~/.config/lxsession/Lubuntu/autostart
then
    echo "Removing existing resolution fix from Autostart"
    sed -i "/resolution_fix/d" ~/.config/lxsession/Lubuntu/autostart
fi
echo "/opt/resolution_fix.sh" >> ~/.config/lxsession/Lubuntu/autostart

echo "Reboot required. Rebooting now..."
sleep 3
sudo reboot
