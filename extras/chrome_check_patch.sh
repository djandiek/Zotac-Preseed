#!/bin/bash

# Add browser check to cron
wget -q -O ${HOME}/check-browser.sh http://175.103.28.7/xkloud/zotac/check-browser.sh
sudo mv ${HOME}/check-browser.sh /opt/check-browser.sh
chmod +x /opt/check-browser.sh

cronfile='/etc/cron.d/check-browser'
sudo echo "SHELL=/bin/bash" > ${cronfile}
sudo echo "PATH=${PATH}" >> ${cronfile}
sudo echo "# Check browser is running every 10 minutes" >> ${cronfile}
sudo echo "*/10 * * * * ${USER} /opt/check-browser.sh > /dev/null 2>&1 &" >> ${cronfile}

ugroup=$(id -gn ${USER});
sudo chmod u=rw,g=r,o=r ${cronfile}
sudo chown ${USER}:${ugroup} ${cronfile}

echo ""
echo "Browser check script installed to ${cronfile}"
