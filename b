#!/bin/sh
acme -v p500kernal.b
diff -s kernal.bin original/901234-02.bin
cmp kernal.bin original/901234-02.bin