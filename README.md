build-libcurl-ios
=================

Build libcurl for iOS development.
Includes armv7 armv7s arm64 i386 and x86_64 support.

Script only, please download libcurl from here: http://curl.haxx.se/download.html
Tested iOS SDK 7.1 and MacOSX 10.9
Tested curl 7.35.0

Usage
=================
```
curl -O http://curl.haxx.se/download/curl-7.35.0.tar.gz
tar xf curl-7.35.0.tar.gz
cd curl-7.35.0
curl https://raw.githubusercontent.com/sinofool/build-libcurl-ios/master/build_libcurl_dist.sh |bash
......
```
Find the result libcurl-ios-dist on your desktop.
