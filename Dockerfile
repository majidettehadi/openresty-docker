# Runtime Envs: README.md

FROM majid7221/debian:stretch

ARG RESTY_VERSION=1.13.6.2

RUN set -ex\
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libpcre3-dev \
        zlib1g-dev \
        libgeoip-dev \
        libssl-dev \
        perl \
        build-essential \
        make \
    && curl https://openresty.org/download/openresty-$RESTY_VERSION.tar.gz -o openresty.tar.gz \
    && tar -xvf openresty.tar.gz \
    && cd openresty-$RESTY_VERSION \
    && ./configure \
        --with-http_geoip_module \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_realip_module \
        --with-stream_geoip_module \
    && make \
    && make install \
    && apt-get purge -y --auto-remove \
        libpcre3-dev \
        zlib1g-dev \
        libgeoip-dev \
        libssl-dev \
        perl \
        build-essential \
        make \
    && rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/local/openresty/bin:/usr/local/openresty/nginx/sbin:$PATH

VOLUME ["/usr/local/openresty/nginx/conf"]
VOLUME ["/usr/local/openresty/nginx/logs"]

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/openresty", "-g", "daemon off;"]
