# A trivial Linux kernel module to execute WBINVD on demand (`cat /proc/wbinvd`)


WBINVD (Write Back and INValidate Cache) is an x86 instruction to asynchronously purge the cache (with write-back)

more info about WBINVD: http://www.felixcloutier.com/x86/WBINVD.html
```
make && make test
```
