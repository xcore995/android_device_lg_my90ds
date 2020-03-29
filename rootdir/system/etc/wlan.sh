#!/bin/sh

while [ ! -f /sys/devices/platform/mt-wifi/net/wlan0/mtu ]
do
	if [[ $(getprop service.wcn.driver.ready) == "yes" ]]; 
        then
		echo 1 > /dev/wmtWifi
    fi
sleep 3
done

echo -c "LOADED"
