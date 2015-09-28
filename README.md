This is the nginx configuration and html page for spiddal.marine.ie

Installation
------------

    mkdir -p /home/dmuser/sites
    cd /home/dmuser/sites
    git clone https://github.com/IrishMarineInstitute/spiddal.marine.ie.git
    cd spiddal.marine.ie
    sudo cp spiddal.marine.ie.conf /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/spiddal.marine.ie.conf /etc/nginx/sites-enabled
    sudo service nginx reload

On the firewall gateway proxy, copy the proxy config

    sudo cp spiddal.marine.ie.proxy.conf /etc/nginx/sites-available/
    sudo ln -s /etc/nginx/sites-available/spiddal.marine.ie.proxy.conf /etc/nginx/sites-enabled
    sudo service nginx reload

Developing the Dashboard
------------------------
Use the index-dev.html when editing the freeboard dashboard. The updated dashboard can be saved to dashboard-dev.json.
When happy with changes, save to dashboard.json after setting allow_edit: false, so that the main page
does not appear editable.


Generating the Data Documentation page
--------------------------------------

    pandoc -o html/data.html -t html5 -H header.html -A footer.html data.md
