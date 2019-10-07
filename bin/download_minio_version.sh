#!/bin/bash

set -e

VERSION=$1
ARCH=$2

if [[ $ARCH == "arm" ]]; then
    echo " >> Compiling form ARM"

    cd /tmp
    git clone https://github.com/minio/mc.git -b $VERSION
    cd mc
    GOOS=linux GOARCH=arm64 go build -tags kqueue -o /usr/bin/mc
    chmod +x /usr/bin/mc
    rm -rf /tmp/mc

    exit 0
fi

echo " >> Downloading Minio Client in version '${VERSION}'"
wget "https://dl.minio.io/client/mc/release/linux-amd64/mc.${VERSION}" -O /usr/bin/mc || wget "https://dl.minio.io/client/mc/release/linux-amd64/archive/mc.${VERSION}" -O /usr/bin/mc || exit 1
chmod +x /usr/bin/mc
