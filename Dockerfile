FROM alpine

ENV NODE_VERSION=5.11.1 NPM_VERSION=latest NGINX_VERSION=1.10.0

RUN cd /tmp && \
	apk add --no-cache curl python linux-headers paxctl libgcc libstdc++ openssl-dev pcre-dev zlib-dev build-base gnupg && \
	curl -o node-v${NODE_VERSION}.tar.gz -SsL https://nodejs.org/dist/latest-v5.x/node-v${NODE_VERSION}.tar.gz && \
	tar -zxf node-v${NODE_VERSION}.tar.gz && \
	cd node-v${NODE_VERSION} && \
	export GYP_DEFINES="linux_use_gold_flags=0" && \
	./configure --prefix=/usr && \
	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
	paxctl -cm out/Release/mksnapshot && \
	make -j${NPROC} && \
	make install && \
	paxctl -cm /usr/bin/node && \
	if [ -x /usr/bin/npm ]; then \
		npm install -g npm@${NPM_VERSION} && \
		find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
	fi && \
	cd /tmp && \
	curl -o nginx-${NGINX_VERSION}.tar.gz -sSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	tar -zxf nginx-${NGINX_VERSION}.tar.gz && \
	cd nginx-${NGINX_VERSION} && \
	./configure \
	        --with-http_ssl_module \
        	--with-http_gzip_static_module \
		--with-poll_module \
		--with-select_module \
		--with-stream \
		--with-mail=dynamic \
		--with-ipv6 \
		--with-http_gzip_static_module \
		--with-stream_ssl_module \
	        --prefix=/etc/nginx \
        	--http-log-path=/var/log/nginx/access.log \
	        --error-log-path=/var/log/nginx/error.log \
        	--sbin-path=/usr/local/sbin/nginx && \
	make && \
	make install && \
	cd / && \
	apk del curl python linux-headers paxctl build-base gnupg && \
	rm -rf /etc/ssl \
		/usr/share/man \
		/tmp/* \
		/var/cache/apk/* \
		/root/.npm \
		/root/.node-gyp \
		/root/.gnupg \
		/usr/lib/node_modules/npm/man \
		/usr/lib/node_modules/npm/doc \
		/usr/lib/node_modules/npm/html
	
CMD /bin/sh
