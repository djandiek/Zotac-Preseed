#!/bin/bash

# Add browser check to cron
wget -q -O ~/check-browser.sh http://175.103.28.7/xkloud/zotac/check-browser.sh
sudo mv ~/check-browser.sh /opt/check-browser.sh
chmod +x /opt/check-browser.sh

crontab -l > /tmp/bootup
sed -i "/check-browser/d" /tmp/bootup
echo "*/10 * * * * /opt/check-browser.sh > /dev/null 2>&1 &" >> /tmp/bootup
crontab /tmp/bootup
rm -f /tmp/bootup
