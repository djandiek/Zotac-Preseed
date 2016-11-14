#!/bin/bash

if test ${GDMSESSION} != "ubuntu";
then
    echo "This setup script will only work if Ubuntu is installed. You are using ${GDMSESSION}"
    exit
fi;

clear
echo "This script does the final setup of the Zotac ADS."
echo ""
echo "ADS URL examples:"
echo "file:///var/www/ADS__STANDALONE_DATA/zbox/zbox_player.htm (default)"
echo "http://127.0.0.1:88/ads/ads.htm"
echo "http://10.100.0.1/ads/ads.php"
echo "http://192.168.1.224/ads/ads.php"
echo "http://192.168.1.226/ads/ads.php"
echo ""
read -p "Please enter the ADS URL (if known): " ads_url
echo
read -n 1 -p "Is this a Dual Port Rotated (portrait) setup? [y/n]: " -t 10 dualport

clear
echo "Cleaning up non-essential software"
sudo apt-get -qy purge unity-scope-imdb unity-scope-musicstores unity-scope-zotero unity-scope-click-autopilot \
unity-scope-deviantart unity-scope-gallica unity-scope-gdocs unity-scope-github unity-scope-googlenews \
unity-scope-launchpad unity-scope-mediascanner unity-scope-onlinemusic unity-scope-openweathermap \
unity-scope-soundcloud unity-scope-sshsearch unity-scope-yahoostock unity-lens-photos unity-lens-video \
unity-scope-audacious unity-scope-chromiumbookmarks unity-scope-clementine unity-scope-click unity-scope-colourlovers \
unity-scope-gdrive unity-scope-gmusicbrowser unity-scope-gourmet unity-scope-guayadeque unity-scope-mediascanner2 \
unity-scope-musique unity-scope-openclipart unity-scope-texdoc unity-scope-tomboy unity-scope-video-remote \
unity-scope-virtualbox unity-scope-yelp unity-webapps-service account-plugin-ubuntuone ubuntu-purchase-service \
gnome-games gbrainy libreoffice*
sudo apt-get -qy autoremove
sudo apt-get clean

clear
echo "Updating Ubuntu Installation (security patches etc)"
echo "This step will take several minutes"
sleep 1
sudo apt-get -qyf install software-properties-common
sudo add-apt-repository -y ppa:mc3man/trusty-media
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt-get update
sudo apt-get -qy dist-upgrade
sudo apt-get -qy upgrade

clear
echo "Installing additional software"
sudo ubuntu-drivers autoinstall
sudo apt-get -qy install unattended-upgrades build-essential ca-certificates curl ftp openssh-server openssl python tcpd wget arandr compiz compiz-plugins compizconfig-settings-manager dconf-tools mc unclutter

sudo dpkg --add-architecture i386
sudo apt-get -qy install libjpeg62:i386 libxinerama1:i386 libxrandr2:i386 libxtst6:i386
clear
echo "Setup auto-updates for security patches etc"
#sudo dpkg-reconfigure -plow unattended-upgrades
# Setup auto-updates for security patches etc
sudo echo 'APT::Periodic::Update-Package-Lists "7";' > /etc/apt/apt.conf.d/20auto-upgrades
sudo echo 'APT::Periodic::Unattended-Upgrade "7";' >> /etc/apt/apt.conf.d/20auto-upgrades
sudo echo 'APT::Periodic::AutocleanInterval "7";' >> /etc/apt/apt.conf.d/20auto-upgrades
sudo sed -i "s/Prompt=lts/Prompt=never/" /etc/update-manager/release-upgrades
sudo sed -i "s/\/\/Unattended-Upgrade::Automatic-Reboot \"false\"/Unattended-Upgrade::Automatic-Reboot \"true\"/" /etc/apt/apt.conf.d/50unattended-upgrades
sudo /etc/init.d/unattended-upgrades restart

# Install TeamViewer
clear
echo "Teamviewer Installation"
tv_installed=$(which teamviewer)
if test -z ${tv_installed};
then
    sudo apt-get -qy update
    sudo apt-get -qy purge teamviewer
    sudo updatedb
    locate teamviewer | xargs /bin/rm -rf
    wget http://175.103.28.7/xkloud/zotac/teamviewer_i386.deb
    sudo dpkg -i --force-depends teamviewer_i386.deb
    sudo apt-get -fy install
    echo "TeamViewer installed"
else
    read -n 1 -p "Teamviewer is already installed. Do you want to re-install it? [y/n]: " -t 10 tv_reinstall
    if test ${tv_reinstall} = "y" -o ${tv_reinstall} = "Y";
    then
        sudo apt-get -qy purge teamviewer
        sudo updatedb
        locate teamviewer | xargs /bin/rm -rf
        wget http://175.103.28.7/xkloud/zotac/teamviewer_i386.deb
        sudo dpkg -i --force-depends teamviewer_i386.deb
        sudo apt-get -fy install
        echo "TeamViewer re-installed"
    fi
fi

clear
echo "Installing Google Chrome"
rm -f linux_signing_key.pub
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -qy --force-yes -y google-chrome-stable

# Create Chrome auto-start item
echo "Create Chrome auto-start item"
mkdir -p ${HOME}/.config/autostart
cat << ADSEOF1 > ${HOME}/.config/autostart/00-ads-browser.desktop
[Desktop Entry]
Type=Application
ADSEOF1

echo "Exec=/usr/bin/google-chrome-stable --kiosk --incognito \"${ads_url}\"" >> ${HOME}/.config/autostart/00-ads-browser.desktop

cat << ADSEOF2 >> ${HOME}/.config/autostart/00-ads-browser.desktop
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_AU]=ADS browser in Kiosk Mode
Name=ADS browser in Kiosk Mode
Comment[en_AU]=Start ADS browser full screen
Comment=Start ADS browser full screen
ADSEOF2

# Change Ubuntu environment
echo "Tweaking environment"
gsettings set com.ubuntu.update-notifier no-show-notifications false
gsettings set org.gnome.desktop.background primary-color '#000000000000'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'none'
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background draw-background true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power button-power 'shutdown'
gsettings set org.gnome.desktop.lockdown disable-lock-screen 'true'
gsettings set org.onboard.window window-state-sticky true
gsettings set com.canonical.Unity.Launcher favorites "['application://ubiquity.desktop', 'application://nautilus.desktop', 'application://google-chrome.desktop', 'application://teamviewer-teamviewer11.desktop', 'unity://running-apps', 'unity://expo-icon', 'unity://devices']"

# Setup SSH root access
echo "Setup SSH root access"
DateTimeStamp=$(date '+%Y%m%d-%H%M%S');
sshd_backup="/etc/ssh/sshd_config.${DateTimeStamp}"
sudo cp /etc/ssh/sshd_config ${sshd_backup}
sudo sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /etc/ssh/sshd_config
sudo service ssh restart

# Disable Error Reporting
sudo sed -i "s/enabled=1/enabled=0/" /etc/default/apport

if test ${dualport} = "y" -o ${dualport} = "Y";
then
# Create xorg.conf for 2 port mirrored
cat << XORG_FILE_2PORT > /tmp/xorg
Section "Monitor"
    Identifier  "HDMI1"
    Option "PreferredMode" "1920x1080"
    Option "Position" "0 0"
EndSection

Section "Monitor"
    Identifier  "HDMI2"
    Option "PreferredMode" "1920x1080"
    Option "Position" "0 0"
EndSection

Section "Screen"
  Identifier   "Screen1"
  #Device       "intel"
  Monitor      "HDMI1"
  # This screen is in portrait mode
  Option "Rotate" "right"
EndSection

Section "Screen"
  Identifier   "Screen2"
  #Device       "intel"
  Monitor      "HDMI2"
  # This screen is in portrait mode
  Option "Rotate" "right"
EndSection
XORG_FILE_2PORT
sudo mv /tmp/xorg /etc/X11/xorg.conf
fi;

echo "Updating Locate DB"
sudo updatedb
echo "Updating time"
sudo ntpdate au.pool.ntp.org

clear
echo "Final steps to do manually:";
echo -e "\t1. When Chrome asks to be set as the default browser, accept the option and then close Chrome";
echo "Press 'Y' to continue"
input=""
while [ "$input" != "y" ]; do
    read -rsn1 input;
    if [ "$input" = "y" ]; then
        /usr/bin/google-chrome-stable &> /dev/null
    fi;
done

clear
echo "Final steps to do manually:";
echo -e "\t2. Configure TeamViewer as required. Once finished, exit TeamViewer\n";
echo "Press 'Y' to continue"
input=""
while [ "$input" != "y" ]; do
    read -rsn1 input;
    if [ "$input" = "y" ]; then
        sudo /usr/bin/teamviewer daemon start &> /dev/null
        /usr/bin/teamviewer &> /dev/null
    fi;
done

clear
echo "A reboot is required. Press 'Y' to continue... ";
echo "NOTE: When the system reboots, ensure EVERYTHING is tested!!!"
input=""
while [ "$input" != "y" ]; do
    read -rsn1 input;
    if [ "$input" = "y" ]; then
        sudo rm -f /etc/profile.d/zotac-setup.sh
        #sudo rm -f ${HOME}/Desktop/complete-setup.desktop
        sudo reboot
    fi;
done
