#!/bin/bash

export DEVROOT=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain

function build_for_arch() {
  ARCH=$1
  HOST=$2
  SYSROOT=$3
  PREFIX=$4
  IPHONEOS_DEPLOYMENT_TARGET="4.3"
  export CC="${DEVROOT}/usr/bin/clang"
  export CFLAGS="-arch ${ARCH} -pipe -Os -gdwarf-2 -isysroot ${SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
  export LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT}"
  ./configure --disable-shared --enable-static --host="${HOST}" --prefix=${PREFIX} && make -j8 && make install
}

TMP_DIR=/tmp/build_libcurl_$$

build_for_arch i386 i386-apple-darwin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk ${TMP_DIR}/i386
build_for_arch x86_64 x86_64-apple-darwin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator7.1.sdk ${TMP_DIR}/x86_64
build_for_arch arm64 arm-apple-darwin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk ${TMP_DIR}/arm64
build_for_arch armv7s armv7s-apple-darwin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk ${TMP_DIR}/armv7s
build_for_arch armv7 armv7-apple-darwin /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.1.sdk ${TMP_DIR}/armv7

${DEVROOT}/usr/bin/lipo \
	-arch i386 ${TMP_DIR}/i386/lib/libcurl.a \
	-arch x86_64 ${TMP_DIR}/x86_64/lib/libcurl.a \
	-arch armv7 ${TMP_DIR}/armv7/lib/libcurl.a \
	-arch armv7s ${TMP_DIR}/armv7s/lib/libcurl.a \
	-arch arm64 ${TMP_DIR}/arm64/lib/libcurl.a \
	-output ${TMP_DIR}/libcurl.a -create

cp -r ${TMP_DIR}/armv7s/include ${TMP_DIR}/
curl -O https://raw.githubusercontent.com/sinofool/build-curl-ios/master/patch-include.patch
patch ${TMP_DIR}/include/curl/curlbuild.h < patch-include.patch

DIST_DIR=${HOME}/libcurl-ios-dist
mkdir ${DIST_DIR}
cp -r ${TMP_DIR}/include ${TMP_DIR}/libcurl.a ${DIST_DIR}

