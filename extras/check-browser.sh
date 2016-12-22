#!/bin/bash

test_browser=$(pgrep -afl kiosk)

if [[ ! ${test_browser} =~ "kiosk" ]];
then
    if [[ -e ${HOME}/.config/lxsession/Lubuntu/autostart ]];
    then
        cmd=$(grep kiosk ${HOME}/.config/lxsession/Lubuntu/autostart);
    fi;
    autostart_file=$(ls -1 ${HOME}/.config/autostart/ads_* 2>/dev/null);
    if [[ -e ${autostart_file[0]} ]];
    then
        cmd=$(grep kiosk ${autostart_file[0]})
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
