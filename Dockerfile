# Runtime Envs: README.md

FROM majid7221/debian:stretch

RUN set -ex\
    && wget -qO /tmp/pubkey.gpg https://openresty.org/package/pubkey.gpg \
    && apt-key add /tmp/pubkey.gpg \
    && rm /tmp/pubkey.gpg \
    && add-apt-repository -y "deb http://openresty.org/package/debian $(lsb_release -sc) openresty" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        openresty \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="$PATH:/usr/local/openresty/luajit/bin:/usr/local/openresty/nginx/sbin:/usr/local/openresty/bin"

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/openresty", "-g", "daemon off;"]
