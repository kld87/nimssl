# About

These are my notes for getting nim to statically link openssl for windows .exes and .dlls It's a real pain but I eventually got it working in both Windows and Linux per below.

**important**: make sure to test on a computer that doesn't have nim installed (re: dependencies being in PATH)

will need to update commands/paths/etc. below to reflect openssl version being used + working directories

## Step One

Download/extract the latest OpenSSL 1.1... build via: https://github.com/openssl/openssl/releases

## Windows Method

Install https://www.msys2.org/ then:
- open it up and install deps per below
- pacman -S mingw-w64-ucrt-x86_64-gcc
- pacman -S mingw-w64-ucrt-x86_64-make
- close and reopen MSYS2 UCRT64 **as admin**

Building OpenSSL: 
- ./Configure mingw64 --prefix=/c/code/openssl-111t-mingw64
- mingw32-make.exe
- mingw32-make.exe install

Compile the example file with (update paths as needed):

```
nim c --d:mingw --cpu=amd64 --threads:on --passC:"-I/c/code/openssl-111t-mingw64/include/" --passL:"-L/c/code/openssl-111t-mingw64/lib/" --dynlibOverride:crypto- --dynlibOverride:ssl- --passl:-lssl --passl:-lcrypto --passl:-lws2_32 --passl:-static -d:noOpenSSLHacks -d:ssl -d:sslVersion:'(' -d:nimDisableCertificateValidation nimssl.nim
```

## Linux cross-compile for Windows


Assuming debian-like, install:

- build-essential mingw-64

Building OpenSSL:
- ./Configure --cross-compile-prefix=x86_64-w64-mingw32- mingw64 --prefix=/opt/openssl-111n-mingw64
- make
- make install

Compiling

```
nim c --d:mingw --cpu=amd64 --threads:on --passC:"-I/opt/openssl-111n-mingw64/include/" --passL:"-L/opt/openssl-111n-mingw64/lib/" --dynlibOverride:crypto- --dynlibOverride:ssl- --passl:-lssl --passl:-lcrypto --passl:-lws2_32 --passl:-static -d:noOpenSSLHacks -d:ssl -d:sslVersion:'(' -d:nimDisableCertificateValidation nimssl.nim
```

## References

* https://nim-lang.github.io/Nim/openssl.html
* https://xmonader.github.io/nim/2018/12/06/nim-good-ok-hard.html
* https://gist.github.com/artynet/ee042155c93fc110e9422b5d458d9c6b
* https://gist.github.com/udnaan/80c5ad125fc4702309b9
* https://github.com/nim-lang/Nim/issues/15220
* https://nim-lang.org/docs/net.html (nimDisableCertificateValidation)

