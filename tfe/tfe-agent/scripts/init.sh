#!/bin/sh
set -e
echo "===agent inithooks.sh==="
echo "init terraform hooks in /cache/data/hooks..."
mkdir -p /cache/data/hooks
cd /cache/data/hooks
rm -rf terraform-*
cp /scripts/terraform-* .
chmod +x terraform-*
ls /cache/data/hooks

# install tools: conftest
cd /tmp
mkdir -p /cache/bin

LATEST_VERSION=0.62.0
ARCH=$(uname -m)
case $ARCH in
    x86_64)    CONFTEST_ARCH="x86_64" ;;
    aarch64)   CONFTEST_ARCH="arm64" ;;
    armv7l)    CONFTEST_ARCH="armv6" ;;
    armv6l)    CONFTEST_ARCH="armv6" ;;
    *)         CONFTEST_ARCH="x86_64" ;;
esac
CONFTEST_FILE=conftest_${LATEST_VERSION}_linux_${CONFTEST_ARCH}.tar.gz
if [ ! -f /cache/bin/conftest ]; then
    echo "install conftest as $CONFTEST_FILE..."
    rm -f conftest_*.tar.gz
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${LATEST_VERSION}/${CONFTEST_FILE}"
    tar xzf "$CONFTEST_FILE"
    mv conftest /cache/bin/
else
    /cache/bin/conftest --version
fi

if [ -d "/policies" ]; then
    echo "✓ Policies directory mounted:"
    /cache/bin/conftest verify --policy /policies
else
    echo "✗ Policies directory not found"
fi
