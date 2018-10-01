#!/usr/bin/env bash
WDIR=`pwd`

buildRoot=/home/makerpm/rpmbuild
targetAppName="liteide"
targetVersion="x34.2"

case $1 in
  --clear|-c)
    rm -rf ${buildRoot}/BUILD/*
    rm -rf ${buildRoot}/BUILDROOT/*
    rm -rf ${buildRoot}/SOURCES/*
    rm -rf ${buildRoot}/SPECS/*

    exit 0
  ;;

  --appName|-a)
    if ! [ "$2" = "" ]; then
      targetAppName=$2
      shift
    fi
    shift
  ;;

  --version|-v)
    if ! [ "$2" = "" ]; then
      targetVersion=$2
      shift
    fi
    shift
  ;;
esac


cd ${buildRoot}/SPECS/${targetAppName}/${targetVersion}
cp *.patch "${buildRoot}/SOURCES/"

specFile="${targetAppName}.spec"
spectool -g -R ${specFile}
rpmbuild -ba ${specFile}
