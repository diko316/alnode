FROM alpine:latest

ENV NODE_VERSION=5.11.1 NPM_VERSION=latest NGINX_VERSION=1.10.0 PROJECT_ROOT=/opt/app APP_SOURCE=/opt/app-source APP_TOOLS=/opt/tools

EXPOSE 3000

COPY ./tools /opt/tools

RUN mkdir -p $PROJECT_ROOT && \
	mkdir -p $APP_SOURCE && \
	ln -s $APP_TOOLS/installer/install.sh /usr/local/bin/auto-build && \
	ln -s $APP_TOOLS/installer/install-cleanup.sh /usr/local/bin/auto-cleanup && \
	ln -s $APP_TOOLS/watcher/auto-sync.sh /usr/local/bin/auto-sync && \
	ln -s $APP_TOOLS/watcher/sync.sh /usr/local/bin/source-sync && \
	ln -s $APP_TOOLS/nginx/start.sh /usr/local/bin/run-nginx && \
	auto-build \
		--apk-permanent \
			bash \
			git \
			curl \
			inotify-tools \
			rsync \
		--apk \
			pcre-dev \
			zlib-dev \
			openssl-dev \
		--build-tools \
		--no-cleanup && \
	$APP_TOOLS/node/install.sh && \
	rm $APP_TOOLS/node/install.sh && \
	$APP_TOOLS/nginx/install.sh && \
	rm $APP_TOOLS/nginx/install.sh && \
	auto-cleanup

#	cd /tmp && \
#	curl -o node-v${NODE_VERSION}.tar.gz -SsL https://nodejs.org/dist/latest-v5.x/node-v${NODE_VERSION}.tar.gz && \
#	tar -zxf node-v${NODE_VERSION}.tar.gz && \
#	cd node-v${NODE_VERSION} && \
#	export GYP_DEFINES="linux_use_gold_flags=0" && \
#	./configure --prefix=/usr && \
#	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
#	make -j${NPROC} -C out mksnapshot BUILDTYPE=Release && \
#	paxctl -cm out/Release/mksnapshot && \
#	make -j${NPROC} && \
#	make install && \
#	paxctl -cm /usr/bin/node && \
#	if [ -x /usr/bin/npm ]; then \
#		npm install -g npm@${NPM_VERSION} && \
#		find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf; \
#	fi && \
#	cd /tmp && \
#	curl -o nginx-${NGINX_VERSION}.tar.gz -sSL http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
#	tar -zxf nginx-${NGINX_VERSION}.tar.gz && \
#	cd nginx-${NGINX_VERSION} && \
#	./configure \
#		--with-cc-opt="-Wno-maybe-uninitialized -Wno-pointer-sign" \
#		--with-poll_module \
#		--with-select_module \
#		--with-stream \
#		--with-mail=dynamic \
#		--with-ipv6 \
#		--with-http_v2_module \
#		--with-http_ssl_module \
#		--with-http_stub_status_module \
#		--with-http_gzip_static_module \
#		--with-http_realip_module \
#		--with-http_sub_module \
#		--with-http_secure_link_module \
#		--with-stream_ssl_module \
#	        --prefix=/etc/nginx \
#        	--http-log-path=/var/log/nginx/access.log \
#	        --error-log-path=/var/log/nginx/error.log \
#        	--sbin-path=/usr/local/sbin/nginx && \
#	make && \
#	make install && \
#	mkdir -p /etc/nginx/conf/conf.d && \
#	cp -f /opt/tools/nginx/conf/nginx.conf /etc/nginx/conf/nginx.conf && \
#	cp -f /opt/tools/nginx/conf/app.conf /etc/nginx/conf/conf.d/app.conf && \




WORKDIR $PROJECT_ROOT

CMD /bin/sh
