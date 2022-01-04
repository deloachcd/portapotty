#!/usr/bin/env bash
set -euo pipefail

SRC="$1"
DST="$2"
for binary in ${SRC}; do
    ln -sf ${PWD}/${binary} ${DST}/$(basename ${binary})
done
