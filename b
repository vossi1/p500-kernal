#!/bin/sh
acme -v p500kernal.b
diff -s kernal.bin p500fastboot.bin
cmp kernal.bin p500fastboot.bin