#!/bin/sh -e
sudo apt-get update
sudo apt-get install -y autofs && sudo rm -f /etc/auto.misc

BASE_DIR=/home/dmuser/sites
SITE_DIR=$BASE_DIR/spiddal.marine.ie
mkdir -p $BASE_DIR
if [ -d $SITE_DIR ]; then
  cd $SITE_DIR
  git pull
else
  cd $BASE_DIR
  git clone https://github.com/IrishMarineInstitute/spiddal.marine.ie.git
fi
if [ -d $SITE_DIR/html/ido.js ]; then
  cd $SITE_DIR/html/ido.js
  git clone https://github.com/IrishMarineInstitute/ido.js
else
  cd $SITE_DIR/html
  git clone https://github.com/IrishMarineInstitute/ido.js
fi

cd $SITE_DIR
sudo cp auto.master auto.spidvid.nfs /etc/
sudo mkdir -p /opt/data/spidvid
sudo service autofs reload
sudo cp spiddal.marine.ie.conf /etc/nginx/sites-available/
sudo cp default.conf /etc/nginx/sites-available/default
sudo ln -s -f /etc/nginx/sites-available/spiddal.marine.ie.conf /etc/nginx/sites-enabled
sudo service nginx reload
