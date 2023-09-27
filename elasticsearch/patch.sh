#!/usr/bin/env bash

VERSION='6.8.22'

rm -rf elasticsearch
git clone --depth 1 -b v${VERSION} https://github.com/elastic/helm-charts sources
mv sources/elasticsearch .
rm -rf sources
patch -p1 --no-backup < kubernetesAPI.patch
patch -p1 --no-backup < globalValues.patch
