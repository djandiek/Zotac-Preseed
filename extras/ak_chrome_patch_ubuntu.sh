#!/bin/bash

os=$(ls /usr/bin/*session)
if [[ "${os}" =~ "lxsession" ]];
then
    os="lubuntu"
else
    os="ubuntu"
fi;
if test ${os} != "ubuntu";
then
    echo "This script will only work if Ubuntu is installed. You are using ${os}"
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

# Adding Chrome to Autostart
# Create Chrome auto-start item
echo "Create Chrome auto-start item"
mkdir -p /home/eze_zbox/.config/autostart
cat << ADSEOF1 > /home/eze_zbox/.config/autostart/00-ads-browser.desktop
[Desktop Entry]
Type=Application
ADSEOF1

echo "Exec=/usr/bin/google-chrome-stable --kiosk --incognito \"${ads_url}\"" >> /home/eze_zbox/.config/autostart/00-ads-browser.desktop

cat << ADSEOF2 >> /home/eze_zbox/.config/autostart/00-ads-browser.desktop
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=ADS browser in Kiosk Mode
Name=ADS browser in Kiosk Mode
Comment[en_AU]=Start ADS browser full screen
Comment=Start ADS browser full screen
ADSEOF2

echo "Reboot required. Rebooting now..."
sleep 3
sudo reboot
