build-libcurl-ios
=================
Build libcurl for iOS development.
This script will generate static library for armv7 armv7s arm64 i386 and x86_64.
New Xcode7 bitcode feature supported.

Script only, please download libcurl from here: http://curl.haxx.se/download.html
Tested iOS SDK 9.0 and MacOSX 10.11
Tested curl 7.44.0

Usage
=================
```
curl -O http://curl.haxx.se/download/curl-7.44.0.tar.gz
tar xf curl-7.44.0.tar.gz
cd curl-7.44.0
curl https://raw.githubusercontent.com/sinofool/build-libcurl-ios/master/build_libcurl_dist.sh |bash
......
```
Find the result libcurl-ios-dist on your desktop.


Binary
=================
You can find a prebuild binary here: https://sinofool.net/dl/libcurl-ios-dist.tar.bz2

Double check the binary file before use:
SHA1:
993c9bb75d798a886749e7801d5f54c494dbf6fb  libcurl-ios-dist.tar.bz2

GnuPG: (My Key ID: 9BE18853)
https://sinofool.net/dl/libcurl-ios-dist.tar.bz2.sig

