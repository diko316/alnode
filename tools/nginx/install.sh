cd /tmp || exit 1
curl -o nginx-${NGINX_VERSION}.tar.gz -sSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz || exit 1
tar -zxf nginx-${NGINX_VERSION}.tar.gz || exit 1
cd nginx-${NGINX_VERSION} || exit 1
./configure \
    --with-cc-opt="-Wno-maybe-uninitialized -Wno-pointer-sign" \
    --with-poll_module \
    --with-select_module \
    --with-stream \
    --with-mail=dynamic \
    --with-pcre \
    --with-ipv6 \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_sub_module \
    --with-http_secure_link_module \
    --with-stream_ssl_module \
        --prefix=/etc/nginx \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx || exit 1
make || exit 1
make install || exit 1
mkdir -p /etc/nginx/conf/conf.d || exit 1
cp -f /opt/tools/nginx/conf/nginx.conf /etc/nginx/conf/nginx.conf || exit 1
cp -f /opt/tools/nginx/conf/app.conf /etc/nginx/conf/conf.d/app.conf || exit 1

exit 0
