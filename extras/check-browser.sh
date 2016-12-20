#!/bin/bash

test_browser=$(pgrep -afl kiosk)

if [[ ! ${test_browser} =~ "http" ]];
then
    if [[ ${GDMSESSION} =~ "Lubuntu" ]];
    then
        cmd=$(grep kiosk /home/eze_zbox/.config/lxsession/Lubuntu/autostart);
    else
        cmd=$(grep kiosk /home/eze_zbox/.config/autostart/00-ads-browser.desktop)
        cmd=$(echo ${cmd} | grep -oP '(?<=Exec=).+')
    fi;
    `${cmd}` &
fi;
