#! /usr/bin/bash
set -e

# setmode.c does `typedef enum {false = 0, true = 1} bool;` -- a pre-C99
# bool polyfill that fails under GCC's modern default C standard, where
# true/false/bool are reserved keywords. Force an older standard rather
# than patch upstream source.
export CFLAGS="${CFLAGS} -std=gnu11"

./configure --prefix="${PREFIX}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
