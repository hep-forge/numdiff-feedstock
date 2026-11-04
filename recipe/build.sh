#! /usr/bin/bash
set -e

# setmode.c does `typedef enum {false = 0, true = 1} bool;` -- a pre-C99
# bool polyfill that fails under GCC's modern default C standard, where
# true/false/bool are reserved keywords. Force an older standard rather
# than patch upstream source.
export CFLAGS="${CFLAGS} -std=gnu11"

# macOS: no native-language support. With it numdiff links libintl, and its
# osx-arm64 build took libintl 1.x while the ROOT/xFitter stack there holds
# libintl < 1.0, so xfitter could not install both.
EXTRA_ARGS=()
if [[ "$(uname)" == "Darwin" ]]; then
  EXTRA_ARGS+=(--disable-nls)
fi
./configure --prefix="${PREFIX}" "${EXTRA_ARGS[@]}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu)
make -j"$NPROC"
make install
