#!/bin/bash

test_browser=$(pgrep -afl kiosk)

if [[ ! ${test_browser} =~ "http" ]];
then
    if [[ -e /home/eze_zbox/.config/lxsession/Lubuntu/autostart ]];
    then
        cmd=$(grep kiosk /home/eze_zbox/.config/lxsession/Lubuntu/autostart);
    fi;
    if [[ -e /home/eze_zbox/.config/autostart/00-ads-browser.desktop ]];
    then
        cmd=$(grep kiosk /home/eze_zbox/.config/autostart/00-ads-browser.desktop)
        cmd=$(echo ${cmd} | grep -oP '(?<=Exec=).+')
    fi;
    if [[ -n ${cmd}  ]];
    then
        `${cmd}` &
    fi;
fi;
