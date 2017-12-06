#!/bin/sh -e
sudo apt-get update
sudo apt-get install -y autofs && sudo rm -f /etc/auto.misc

mkdir -p /home/dmuser/sites
cd /home/dmuser/sites
if [ -d spiddal.marine.ie ]; then
  cd spiddal.marine.ie
  git pull
else
  git clone https://github.com/IrishMarineInstitute/spiddal.marine.ie.git
  cd spiddal.marine.ie
fi
sudo cp auto.master auto.spidvid.nfs /etc/
sudo mkdir -p /opt/data/spidvid
sudo service autofs reload
sudo cp spiddal.marine.ie.conf /etc/nginx/sites-available/
sudo ln -s -f /etc/nginx/sites-available/spiddal.marine.ie.conf /etc/nginx/sites-enabled
sudo service nginx reload
