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
read -n 1 -p "What is the resolution width? [1280]: " x_res
echo ""
read -n 1 -p "What is the resolution height? [720]: " y_res
echo ""
read -n 1 -p "Is this a rotated (portrait) setup? [y/n]: " -t 10 rotated

if test -z ${x_res};
then
    x_res="1280"
fi
if test -z ${y_res};
then
    y_res="720"
fi

# Forcing resolution to be set correctly
hdmi_port=$(xrandr -q | grep HDMI | grep " connected" | cut -d' ' -f1);
if test -z ${hdmi_port};
then
    hdmi_port="HDMI1"
fi
echo '#!/bin/sh' > ~/resolution_fix
echo 'xrandr --newmode "${x_res}x${y_res}_60.00"   74.50  ${x_res} 1344 1472 1664  ${y_res} 723 728 748 -hsync +vsync' >> ~/resolution_fix
echo "xrandr --addmode ${hdmi_port[0]} \"${x_res}x${y_res}_60.00\"" >> ~/resolution_fix
if test ${rotated} = "y" -o ${rotated} = "Y";
then
    echo "xrandr --output ${hdmi_port[0]} --primary --mode \"${x_res}x${y_res}_60.00\" --rotate left" >> ~/resolution_fix
else
    echo "xrandr --output ${hdmi_port[0]} --primary --mode \"${x_res}x${y_res}_60.00\"" >> ~/resolution_fix
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
