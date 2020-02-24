#!/bin/bash

if [ -n "$2" ]; then
  export BUILD_DIR_PATH=$2
else
  export BUILD_DIR_PATH="$HOME/projects/virtual-flight-throttle/build"
fi

echo "[i] start build ipa..."

~/flutter/bin/flutter build ipa
cp ./build/app/outputs/bundle/release/app-release.ipa "$BUILD_DIR_PATH"/ipa/vft-flight-throttle-"$1".ipa

echo "[o] succeed build ipa with version $1"
