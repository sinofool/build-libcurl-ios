libcurl for iOS
=================
Build libcurl for iOS development.  
This script will generate static library for armv7 armv7s arm64 i386 and x86_64.  
Bitcode support.  
OpenSSL and Darwin native ssl support.  
  
Script only, please download libcurl from here: http://curl.haxx.se/download.html  
Tested Xcode 8.2.1 on macOS 10.12.4  
Tested curl 7.54.0 

Usage
=================
```
curl -O http://curl.haxx.se/download/curl-7.54.0.tar.gz
tar xf curl-7.54.0.tar.gz
cd curl-7.54.0
curl https://raw.githubusercontent.com/sinofool/build-libcurl-ios/master/build_libcurl_dist.sh |bash
......
```
Find the result libcurl-ios-dist on your desktop.

curl-7.52.1 issue
=================
7.52.1 is the latest release but have an issue to build with darwinssl

https://github.com/curl/curl/issues/1172

https://github.com/curl/curl/commit/8db3afe16c0916ea5acf6aed6e7cf02f06cc8677

The fix have commited to curl just one day after release, which should be avaliable for the next patch release.

Workaround for this issue is:
- patch it with the commit (See darwinssl-fix-iOS-build.patch extacted)
- Or, use openssl with: ```
../build_libcurl_dist.sh openssl
```

OpenSSL
=================
The script link with native ssl by default (--with-darwinssl).  
To use OpenSSL, use https://github.com/sinofool/build-openssl-ios/ to build OpenSSL for iOS first, in curl source directory run:
```
curl https://raw.githubusercontent.com/sinofool/build-libcurl-ios/master/build_libcurl_dist.sh openssl |bash
```

Binary (Not updated yet)
=================
Following binary is curl-7.47.1, I will release 7.52.1 binaries after a longer test.

You can find a prebuild binary (with OpenSSL) here: https://sinofool.net/dl/libcurl-ios-dist.tar.bz2

Double check the binary file before use:
```
SHA1:
993c9bb75d798a886749e7801d5f54c494dbf6fb  libcurl-ios-dist.tar.bz2

GnuPG: (My Key ID: 9BE18853)
https://sinofool.net/dl/libcurl-ios-dist.tar.bz2.sig
```
