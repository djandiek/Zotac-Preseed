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
echo "Patch done. Reboot required. Rebooting now..."
sleep 3
sudo reboot
