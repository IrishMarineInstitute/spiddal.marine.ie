#!/bin/sh
file=/home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-openweathermap.json
touch $file.new >/dev/null 2>&1;
chmod 644 $file.new
curl -m 5 -s api.openweathermap.org/data/2.5/weather?q=Spiddal,IE\&units=metric\&APPID=$(cat /etc/openweathermap.key) > $file.new && chmod 644 $file.new && mv $file.new $file
