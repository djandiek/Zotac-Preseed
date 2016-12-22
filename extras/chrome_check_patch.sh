#!/bin/bash

# Add browser check to cron
wget -q -O ${HOME}/check-browser.sh http://175.103.28.7/xkloud/zotac/check-browser.sh
sudo mv ${HOME}/check-browser.sh /opt/check-browser.sh
chmod +x /opt/check-browser.sh

cronfile='/etc/cron.d/check-browser'
tmpfile="${HOME}/check-browser"
echo "SHELL=/bin/bash" > ${tmpfile}
echo "PATH=${PATH}" >> ${tmpfile}
echo "# Check browser is running every 10 minutes" >> ${tmpfile}
echo "*/10 * * * * ${USER} /opt/check-browser.sh > /dev/null 2>&1 &" >> ${tmpfile}

sudo mv ${tmpfile} ${cronfile}
sudo chmod u=rw,g=r,o=r ${cronfile}
sudo chown root:root ${cronfile}

echo ""
echo "Browser check script installed to ${cronfile}"
