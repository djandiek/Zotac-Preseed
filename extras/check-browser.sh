#!/bin/bash

test_browser=$(pgrep -afl kiosk)

if [[ ! ${test_browser} =~ "kiosk" ]];
then
    if [[ -e ${HOME}/.config/lxsession/Lubuntu/autostart ]];
    then
        cmd=$(grep kiosk ${HOME}/.config/lxsession/Lubuntu/autostart);
    fi;

    autostart_data=$(grep -r --include=\*.desktop "${HOME}/.config/autostart" -e "kiosk" | cut -d: -f2-);

    if [[ -n ${autostart_data} ]];
    then
        cmd=$(echo ${autostart_data[0]} | grep -oP '(?<=Exec=).+')
    fi;
    if [[ -n ${cmd}  ]];
    then
        pkill -f chrome
        sleep 3
        logger "Browser FAILED. Restarting... using ${cmd}"
        `DISPLAY=:0 ${cmd}` &
    fi;
fi;
