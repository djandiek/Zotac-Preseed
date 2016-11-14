#!/bin/bash

if test ${GDMSESSION} != "Lubuntu";
then
    echo "This script will only work if Lubuntu is installed. You are using ${GDMSESSION}"
    exit
fi;

gcs=$(which google-chrome-stable)
if test -z ${gcs};
then
    echo "This script requires Google Chrome to have been already installed."
    exit
fi
clear
echo "ADS URL examples:"
echo "http://127.0.0.1:88/zbox/zbox_player.htm [default], use for stand-alone (CLOUD) Zotac playiung full-screen movie in a loop"
echo "http://127.0.0.1:88/ads/ads.htm , use for stand-alone (CLOUD) Zotac playing Default_Presentation"
echo "http://10.100.0.1/ads/ads.php , use for Zotac with local ADS server (non-CLOUD)"
echo "http://192.168.1.224/ads/ads.php , use for Zotac with Nick's 224 ADS server (non-CLOUD)"
echo "http://192.168.1.226/ads/ads.php , use for Zotac with Nick's 226 ADS server (non-CLOUD)"
echo "file:///var/www/ADS__STANDALONE_DATA/zbox/zbox_player.htm"
echo ""
read -p "Please enter the ADS URL (if known): " ads_url

if test -z ${ads_url};
then
    ads_url="http://127.0.0.1:88/zbox/zbox_player.htm"
fi

#read -p "How often in minutes should the browser restart (default: 60): " mins
#if test -z ${mins};
#then
#    mins=60
#fi
#secs=$(echo "${mins}*60" |bc)

# Adding Chrome to Autostart
if grep -Fq "google-chrome-stable" ~/.config/lxsession/Lubuntu/autostart
then
    echo "Removing existing Chrome command from Autostart"
    sed -i "/google-chrome-stable/d" ~/.config/lxsession/Lubuntu/autostart
fi
#if grep -Fq "browser-loop" ~/.config/lxsession/Lubuntu/autostart
#then
#    sed -i "/browser-loop/d" ~/.config/lxsession/Lubuntu/autostart
#fi

echo "Adding Chrome to Autostart"
echo "/usr/bin/google-chrome-stable --kiosk --incognito ${ads_url}" >> ~/.config/lxsession/Lubuntu/autostart

#echo "#!/bin/bash" > /tmp/browser-loop
#echo "while [ 1 = 1 ]; do" >> /tmp/browser-loop
#echo "pkill -f chrome" >> /tmp/browser-loop
#echo "sleep 1" >> /tmp/browser-loop
#echo "/usr/bin/google-chrome-stable --disable-gpu --kiosk --incognito ${ads_url} &" >> /tmp/browser-loop
#echo "sleep ${secs}" >> /tmp/browser-loop
#echo "done" >> /tmp/browser-loop
#
#sudo mv /tmp/browser-loop /opt/browser-loop.sh
#sudo chmod +x /opt/browser-loop.sh
#echo "/opt/browser-loop.sh &" >> ~/.config/lxsession/Lubuntu/autostart
echo "Done"

# Andrew Pain fix
echo "options i915_bdw enable_rc6=0 semaphores=1 fastboot=0 enable_fbc=0 powersave=0" > /tmp/i915.conf
sudo mv /tmp/i915.conf /etc/modprobe.d/i915.conf
sudo update-initramfs -u
sudo mkdir -p /etc/X11/xorg.conf.d
cat << X11FIX > /tmp/20-intel.conf
Section "Extensions"
    Option  "XVideo"    "Disable"
EndSection

Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "AccelMethod" "sna"
    Option      "TearFree" "true"
    Option      "DRI" "true"
EndSection
X11FIX

# Set max_cstate=1 in GRUB
sudo mv /tmp/20-intel.conf /etc/X11/xorg.conf.d/20-intel.conf
cp /etc/default/grub ~/grub.default
sudo sed -i -E "s/GRUB_CMDLINE_LINUX_DEFAULT.+$/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash intel_idle.max_cstate=1\"/" /etc/default/grub
sudo sed -i -E "s/GRUB_TIMEOUT=.+$/GRUB_TIMEOUT=3/" /etc/default/grub
sudo update-grub
echo "Reboot required. Rebooting now..."
sleep 3
sudo reboot
