#!/bin/bash
set -euo pipefail

app=build/Build/Products/Release/WubiVoice.app
shared="$app/Contents/SharedSupport"
user=$(mktemp -d /private/tmp/wubivoice-rime-test.XXXXXX)
binary=/private/tmp/wubivoice-rime-snapshot
trap 'rm -rf "$user"; rm -f "$binary"' EXIT

cp "$shared/wubivoice.default.custom.yaml" "$user/default.custom.yaml"

c++ -std=c++17 tests/rime_snapshot.cc \
  -I librime/src -I librime/include \
  lib/librime.1.dylib \
  -Wl,-rpath,"$PWD/lib" \
  -o "$binary"

"$binary" "$shared" "$user" tests/fixtures/wubi_snapshots.tsv
