#!/usr/bin/env bash

# Push image according to repo name
set -x
. build.properties
docker push $REPO_NAME:latest
