#!/bin/bash -euo pipefail

readonly XCODE_DEV="$(xcode-select -p)"
export DEVROOT="${XCODE_DEV}/Toolchains/XcodeDefault.xctoolchain"
DFT_DIST_DIR=${HOME}/Desktop/libcurl-ios-dist
DIST_DIR=${DIST_DIR:-$DFT_DIST_DIR}

function check_curl_ver() {
echo "#include \"include/curl/curlver.h\"
#if LIBCURL_VERSION_MAJOR < 7 || LIBCURL_VERSION_MINOR < 55
#error Required curl 7.40.0+; See http://curl.haxx.se/docs/adv_20150108A.html
#error Supported minimal version is 7.55.0 for header file changes, see Issue #12 (https://github.com/sinofool/build-libcurl-ios/issues/12)
#endif"|gcc -c -o /dev/null -xc -||exit 9
}

function build_for_arch() {
  ARCH=$1
  HOST=$2
  SYSROOT=$3
  PREFIX=$4
  IPHONEOS_DEPLOYMENT_TARGET="6.0"
  export PATH="${DEVROOT}/usr/bin/:${PATH}"
  export CFLAGS="-DCURL_BUILD_IOS -arch ${ARCH} -pipe -Os -gdwarf-2 -isysroot ${SYSROOT} -miphoneos-version-min=${IPHONEOS_DEPLOYMENT_TARGET} -fembed-bitcode"
  export LDFLAGS="-arch ${ARCH} -isysroot ${SYSROOT}"
  ./configure --disable-shared --without-zlib --enable-static --enable-ipv6 ${SSL_FLAG} --host="${HOST}" --prefix=${PREFIX} && make -j8 && make install
}

if [ "${1:-''}" == "openssl" ]
then
  if [ ! -d ${HOME}/Desktop/openssl-ios-dist ]
  then
    echo "Please use https://github.com/sinofool/build-openssl-ios/ to build OpenSSL for iOS first"
    exit 8
  fi
  export SSL_FLAG=--with-ssl=${HOME}/Desktop/openssl-ios-dist
else
  check_curl_ver
  export SSL_FLAG=--with-darwinssl
fi

TMP_DIR=/tmp/build_libcurl_$$

build_for_arch i386 i386-apple-darwin ${XCODE_DEV}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk ${TMP_DIR}/i386 || exit 1
build_for_arch x86_64 x86_64-apple-darwin ${XCODE_DEV}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk ${TMP_DIR}/x86_64 || exit 2
build_for_arch arm64 arm-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/arm64 || exit 3
build_for_arch armv7s armv7s-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/armv7s || exit 4
build_for_arch armv7 armv7-apple-darwin ${XCODE_DEV}/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk ${TMP_DIR}/armv7 || exit 5

mkdir -p ${TMP_DIR}/lib/
${DEVROOT}/usr/bin/lipo \
  -arch x86_64 ${TMP_DIR}/x86_64/lib/libcurl.a \
  -arch armv7 ${TMP_DIR}/armv7/lib/libcurl.a \
  -arch armv7s ${TMP_DIR}/armv7s/lib/libcurl.a \
  -arch arm64 ${TMP_DIR}/arm64/lib/libcurl.a \
  -output ${TMP_DIR}/lib/libcurl.a -create

cp -r ${TMP_DIR}/arm64/include ${TMP_DIR}/

mkdir -p ${DIST_DIR}
cp -r ${TMP_DIR}/include ${TMP_DIR}/lib ${DIST_DIR}

