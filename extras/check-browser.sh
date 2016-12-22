#!/bin/bash

test_browser=$(pgrep -afl kiosk)

if [[ ! ${test_browser} =~ "kiosk" ]];
then
    if [[ -e ${HOME}/.config/lxsession/Lubuntu/autostart ]];
    then
        cmd=$(grep kiosk ${HOME}/.config/lxsession/Lubuntu/autostart);
    fi;
    if [[ -e ${HOME}/.config/autostart/00-ads-browser.desktop ]];
    then
        cmd=$(grep kiosk ${HOME}/.config/autostart/00-ads-browser.desktop)
        cmd=$(echo ${cmd} | grep -oP '(?<=Exec=).+')
    fi;
    if [[ -n ${cmd}  ]];
    then
        pkill -f chrome
        sleep 3
        logger "Browser FAILED. Restarting..."
        `${cmd}` &
    fi;
fi;
