#!/bin/sh
fatal() { echo "$@"; exit 1; }
logged() { echo "+" "$@" ; "$@"; }
cmd() { logged "$@" || fatal "fail:" "$@"; }

# Download openjdk.
# After running the script, 'jdk' is symlink to a java-11 jdk
# This uses temurin, a prebuild binary
# developed by adoptium under eclipse umbrella.
# The RHEL java-11-openjdk-devel is probalby
# a wrapper around this.
#
# Adaptium also has docker images here:
# https://hub.docker.com/_/eclipse-temurin
# based on alpine or ubuntu, but you can copy
# content into other base image or prune it to a JRE.
#
# This script intended to simplify using same JDK
# in both laptop and container.
# See also https://adoptium.net/installation/
# https://adoptium.net/blog/2022/07/gpg-signed-releases/
#
# Script assumes a keyring file, that was constructed
# like so:
#
# KEY=3B04D753C9050D9A5D343F39843C48A565F8F04B
# gpg --keyserver keyserver.ubuntu.com --recv-keys $KEY
# gpg -o $KEY.gpg --export $KEY
# gpg --delete-keys $KEY
# following probably not needed when using gpgv:
# gpg --keyring ./$KEY.gpg --edit-key $KEY trust
# at this point, pick 5, ultimate trust
#
VERSION=11.0.18
BUILD=10

SILENT=--no-verbose
# https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.18%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.18_10.tar.gz
KEYRING="./3B04D753C9050D9A5D343F39843C48A565F8F04B.gpg"
FROM="https://github.com/adoptium/temurin11-binaries/releases/download/jdk-${VERSION}%2B${BUILD}/"
TGZFILE="OpenJDK11U-jdk_x64_linux_hotspot_${VERSION}_${BUILD}.tar.gz"
TGZURL="$FROM/$TGZFILE"
SIGFILE="$TGZFILE.sig"
SIGURL="$FROM/$SIGFILE"
DIR="jdk-${VERSION}+${BUILD}"
JDK=jdk
[ -f $TGZFILE ] || cmd wget $SILENT $TGZURL
[ -f $SIGFILE ] || cmd wget $SILENT $SIGURL
cmd gpgv --keyring $KEYRING $SIGFILE $TGZFILE
[ -d $DIR ] || tar xf $TGZFILE
[ -h $JDK ] && cmd rm "$JDK"
cmd ln -s "$DIR" "$JDK"

