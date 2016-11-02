FROM ubuntu:16.04
RUN apt-get -y update
RUN apt-get -y install nginx-extras build-essential libpcre3-dev libssl-dev libgeoip-dev libpq-dev libxslt1-dev libgd2-xpm-dev
RUN apt-get -y install wget
RUN wget -c https://openresty.org/download/openresty-1.9.15.1.tar.gz
RUN tar zxvf openresty-1.9.15.1.tar.gz
RUN cd openresty-1.9.15.1 && ./configure \
             --sbin-path=/usr/sbin/nginx \
             --conf-path=/etc/nginx/nginx.conf \
             --error-log-path=/var/log/nginx/error.log \
             --http-client-body-temp-path=/var/lib/nginx/body \
             --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
             --http-log-path=/var/log/nginx/access.log \
             --http-proxy-temp-path=/var/lib/nginx/proxy \
             --http-scgi-temp-path=/var/lib/nginx/scgi \
             --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
             --lock-path=/var/lock/nginx.lock \
             --pid-path=/var/run/nginx.pid \
             --with-sha1=/usr/include/openssl \
             --with-md5=/usr/include/openssl \
             --with-http_stub_status_module \
             --with-http_secure_link_module \
             --with-luajit \
             --with-pcre-jit \
             --with-debug \
             --with-http_auth_request_module \
             --with-http_addition_module \
             --with-http_gunzip_module \
             --with-http_image_filter_module \
             --with-http_dav_module \
             --with-http_flv_module \
             --with-http_geoip_module \
             --with-http_gzip_static_module \
             --with-http_realip_module \
             --with-http_stub_status_module \
             --with-http_ssl_module \
             --with-http_sub_module \
             --with-http_xslt_module \
             --with-ipv6 \
             --with-http_postgres_module \
           && make && make install && apt-get -y autoclean && apt-get -y remove
RUN wget http://luarocks.org/releases/luarocks-2.4.1.tar.gz
RUN apt-get -y update
RUN apt-get -y install unzip
RUN tar zxpf luarocks-2.4.1.tar.gz && cd luarocks-2.4.1 && ./configure --prefix=/usr/local/openresty/luajit --with-lua=/usr/local/openresty/luajit/ --lua-suffix=jit --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && make bootstrap && make install
RUN ln -s -f /usr/local/openresty/luajit/bin/luarocks /usr/bin/luarocks
RUN ln -s -f /usr/local/openresty/luajit/bin/luajit /usr/bin/lua

RUN luarocks install luasocket
RUN apt-get install -y libcurl3 libcurl3-gnutls libcurl4-openssl-dev git
RUN git config --global url.https://github.com/.insteadOf git://github.com/
RUN luarocks install luasec
RUN luarocks install lua-cassandra
RUN luarocks install lua-curl

COPY ./nginx.conf /etc/nginx/nginx.conf
RUN mkdir /lua
COPY *.lua /lua/
RUN mv /lua/om_observation_handler2.lua /lua/om_observation_handler.lua && mv /lua/om_timeseries_handler2.lua /lua/om_timeseries_handler.lua
RUN mkdir -p /var/www/sensor-observation-service
COPY sos-xml /var/www/sensor-observation-service/xml
WORKDIR /etc/nginx
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]
EXPOSE 80
EXPOSE 443
CMD ["nginx"]

