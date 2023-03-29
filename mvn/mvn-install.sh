#!/bin/sh
fatal() { echo "$@"; exit 1; }
logged() { echo "+" "$@" ; "$@"; }
cmd() { logged "$@" || fatal "fail:" "$@"; }

# Download maven
# After running the script, 'mvn' is symlink to a mvn binary
#
# This script intended to simplify using same maven
# in both laptop and container.
#
#
VERSION=3.9.1

SILENT=--no-verbose
# https://dlcdn.apache.org/maven/maven-3/3.9.0/binaries/apache-maven-3.9.0-bin.zip
# downloaded from https://downloads.apache.org/maven/KEYS
# transformed with gpg --keyring ./KEYS.gpg --no-default-keyring --import KEYS
KEYRING="./KEYS.gpg"
FROM="https://dlcdn.apache.org/maven/maven-3/${VERSION}/binaries"
TGZFILE="apache-maven-${VERSION}-bin.tar.gz"
TGZURL="$FROM/$TGZFILE"
SIGFILE="$TGZFILE.asc"
SIGURL="$FROM/$SIGFILE"
DIR="apache-maven-${VERSION}"
MVN=mvn
[ -f $TGZFILE ] || cmd wget $SILENT $TGZURL
[ -f $SIGFILE ] || cmd wget $SILENT $SIGURL
cmd gpgv --keyring $KEYRING $SIGFILE $TGZFILE
[ -d $DIR ] || cmd tar xf $TGZFILE
cmd ln -s "$DIR" "$MVN"
