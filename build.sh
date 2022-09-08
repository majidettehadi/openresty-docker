#!/usr/bin/env bash

. repo_env
docker build --force-rm --build-arg VERSION=$VERSION \
    -t majid7221/openresty:$VERSION .
