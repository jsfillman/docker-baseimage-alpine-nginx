FROM ghcr.io/linuxserver/baseimage-alpine:3.13-version-9b18d773

# install packages
RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache \
	apache2-utils \
	git \
	libressl3.1-libssl \
	logrotate \
	nano \
	nginx \
	openssl && \
 echo "**** configure nginx ****" && \
 echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
	/etc/nginx/fastcgi_params && \
 rm -f /etc/nginx/conf.d/default.conf && \
 echo "**** fix logrotate ****" && \
 sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
 sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
	/etc/periodic/daily/logrotate

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
