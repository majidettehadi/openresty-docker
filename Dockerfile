FROM debian:bullseye

MAINTAINER majidettehadi

RUN set -ex \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        gcc \
        openssl \
        perl \
        libpcre3-dev \
        libxslt-dev \
        libgeoip-dev \
        libgd-dev \
        libssl-dev

WORKDIR /usr/local/src
ARG VERSION
RUN set -ex \
    && curl -LO "https://openresty.org/download/openresty-$VERSION.tar.gz" \
    && tar xvzf openresty-$VERSION.tar.gz \
    && rm openresty-$VERSION.tar.gz \
    && cd openresty-$VERSION \
    && ./configure \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_geoip_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_image_filter_module=dynamic \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-http_xslt_module=dynamic \
        --with-ipv6 \
        --with-mail \
        --with-mail_ssl_module \
        --with-md5-asm \
        --with-pcre-jit \
        --with-sha1-asm \
        --with-stream \
        --with-stream_ssl_module \
        --with-threads \
        --with-stream_geoip_module \
        --with-stream_realip_module \
    && make \
    && make install

WORKDIR /usr/local/src
ENV LUA_VERSION 0.16.1
RUN set -ex \
    && curl -L "https://github.com/ledgetech/lua-resty-http/archive/v$LUA_VERSION.tar.gz" -o lua-resty-http-$LUA_VERSION.tar.gz \
    && tar xvzf lua-resty-http-$LUA_VERSION.tar.gz \
    && cd lua-resty-http-$LUA_VERSION \
    && make \
    && make install

ENV PATH=$PATH:/usr/local/openresty/bin
WORKDIR /usr/local/openresty
VOLUME ["/usr/local/openresty/nginx/conf","/usr/local/openresty/nginx/logs"]
EXPOSE 80 443

CMD ["openresty", "-g", "daemon off;"]
