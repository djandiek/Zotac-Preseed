#!/bin/bash

# Add browser check to cron
wget -q -O /opt/check_browser.sh http://175.103.28.7/xkloud/zotac/check_browser.sh
chmod +x /opt/check_browser.sh

crontab -l > /tmp/bootup
sed -i "/kiosk/d" /tmp/bootup
echo "*/10 * * * * /opt/check_browser.sh > /dev/null 2>&1 &" >> /tmp/bootup
crontab /tmp/bootup
rm -f /tmp/bootup
