FROM brutalgg/ubuntu
LABEL mainitainer="LanCache.Net Team <team@lancache.net>"

ARG DEBIAN_FRONTEND=noninteractive
COPY overlay/ /
ENV DOCUMENT_ROOT=html

RUN \
# Update and get dependencies
  apt-get update && \
  apt-get install -y \
  nginx \
  inotify-tools \
  && \
# Other things
  sed -i -e '/sendfile on;/a\        client_max_body_size 0\;' /etc/nginx/nginx.conf && \
  sed -i -e 's/gzip on/#gzip on/' /etc/nginx/nginx.conf && \
  sed -i -e 's/gzip_disable/#gzip_disable/' /etc/nginx/nginx.conf && \
  rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default && \
  mkdir -p /etc/nginx/sites-enabled/ && \
  for SITE in /etc/nginx/sites-available/*; do [ -e "$SITE" ] || continue; ln -s $SITE /etc/nginx/sites-enabled/`basename $SITE`; done && \
  mkdir -p /var/www/html && \
  chmod 777 /var/www/html /var/lib/nginx /etc/DOCUMENT_ROOT && \
  chmod -R 777 /var/log/nginx && \
  chmod 755 /var/www && \
  chmod -R 666 /etc/nginx/sites-* /etc/nginx/conf.d/* && \
  # Cleanup
  apt-get -y autoremove && \
  apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf var/tmp/*

EXPOSE 80
