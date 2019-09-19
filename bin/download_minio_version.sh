#!/bin/bash

VERSION=$1

echo " >> Downloading Minio Client in version '${VERSION}'"
wget "https://dl.minio.io/client/mc/release/linux-amd64/mc.${VERSION}" -O /usr/bin/mc || wget "https://dl.minio.io/client/mc/release/linux-amd64/archive/${VERSION}" -O /usr/bin/mc || exit 1
chmod +x /usr/bin/mc
