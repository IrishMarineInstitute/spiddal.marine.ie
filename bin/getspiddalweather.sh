#!/bin/sh
http_proxy=10.0.5.55:80 curl -m 5 -s api.openweathermap.org/data/2.5/weather?q=Spiddal,IE\&units=metric\&APPID=$(cat /etc/openweathermap.key) > /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-openweathermap.json.new && mv /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-openweathermap.json.new /home/dmuser/sites/spiddal.marine.ie/html/data/spiddal-openweathermap.json
