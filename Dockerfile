FROM debian:bullseye

ARG VERSION

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libpcre3-dev \
        zlib1g-dev \
        libgeoip-dev \
        libssl-dev \
        perl \
        build-essential \
        make

WORKDIR /usr/local/src
RUN set -ex \
    && curl -LO https://openresty.org/download/openresty-$VERSION.tar.gz \
    && tar -xvf openresty$VERSION.tar.gz \
    && rm openresty$VERSION.tar.gz \
    && cd openresty-$VERSION \
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

WORKDIR /usr/local/openresty

ENV PATH=$PATH:/usr/local/openresty/bin

VOLUME ["/usr/local/openresty/nginx/conf","/usr/local/openresty/nginx/logs"]

EXPOSE 80 443

CMD ["openresty", "-g", "daemon off;"]
