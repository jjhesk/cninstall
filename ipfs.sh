#!/bin/bash
# shellcheck disable=SC2016
set -e

VERSION="v0.12.0-rc1"
PACKAGE_NAME="go-ipfs_$VERSION_linux-amd64.tar.gz"
MIRROR_PACKAGE="https://gitcode.net/mirrors/ipfs/go-ipfs/-/archive/$VERSION/$PACKAGE_NAME"

MIRROR_CHINA="https://studygolang.com/dl/golang"
[ -z "$GOROOT" ] && GOROOT="$HOME/.go"
[ -z "$GOPATH" ] && GOPATH="$HOME/go"

OS="$(uname -s)"
ARCH="$(uname -m)"

case $OS in
    "Linux")
        case $ARCH in
        "x86_64")
            ARCH=amd64
            ;;
        "aarch64")
            ARCH=arm64
            ;;
        "armv6")
            ARCH=armv6l
            ;;
        "armv8")
            ARCH=arm64
            ;;
        .*386.*)
            ARCH=386
            ;;
        esac
        PLATFORM="linux-$ARCH"
    ;;
    "Darwin")
        PLATFORM="darwin-amd64"
    ;;
esac

print_help() {
    echo "Usage: bash goinstall.sh OPTIONS"
    echo -e "\nOPTIONS:"
    echo -e "  --remove\tRemove currently installed version"
    echo -e "  --version\tSpecify a version number to install"
}

if [ -z "$PLATFORM" ]; then
    echo "Your operating system is not supported by the script."
    exit 1
fi

wget $MIRROR_PACKAGE

tar -xvzf $PACKAGE_NAME

cd go-ipfs

sudo bash install.sh

ipfs --version
# set port to other port other than 8080
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/9001
# see all the listening ports
# https://www.cyberciti.biz/faq/unix-linux-check-if-port-is-in-use-command/
sudo lsof -i -P -n | grep LISTEN
# https://thegraph.academy/indexers/security-precautions/
