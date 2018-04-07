FROM alpine:3.6

ENV NODE_VERSION=8.11.1 NPM_VERSION=5.6.0 NGINX_VERSION=1.11.9 PROJECT_ROOT=/opt/app APP_SOURCE=/opt/app-source APP_TOOLS=/opt/tools

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
			openssl-dev \
			zlib-dev \
		--apk \
			musl-dev \
			pcre-dev \
		--build-tools \
		--no-cleanup && \
	$APP_TOOLS/node/install.sh && \
	rm $APP_TOOLS/node/install.sh && \
	$APP_TOOLS/nginx/install.sh && \
	rm $APP_TOOLS/nginx/install.sh && \
	auto-cleanup

WORKDIR $PROJECT_ROOT

CMD /bin/sh
