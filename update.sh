#!/bin/sh
. ./inc
#tsc -b
#GIT_LOC=https://gitlab.com/b95token/erc20TokenGen
VERSION=$(cat version)
increment_version $VERSION > version
VERSION=$(cat version)
gitpush