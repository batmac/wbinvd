# A trivial Linux kernel module to execute WBINVD on demand (`cat /proc/wbinvd`)
[![Build Status](https://travis-ci.org/batmac/wbinvd.svg?branch=master)](https://travis-ci.org/batmac/wbinvd)


WBINVD (Write Back and INValidate Cache) is an x86 instruction to asynchronously purge the cache (with write-back)

more info about WBINVD: http://www.felixcloutier.com/x86/WBINVD.html
```
make && make test
```
