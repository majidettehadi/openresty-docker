#!/usr/bin/env bash

. env
docker build --force-rm --build-arg VERSION=$VERSION \
    -t majid7221/openresty:$VERSION .
