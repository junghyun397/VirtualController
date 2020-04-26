#!/bin/bash

if [ -n "$2" ]; then
  export BUILD_DIR_PATH=$2
else
  mkdir build
  export BUILD_DIR_PATH="./build"
fi

if [ -n "$3" ]; then
  export BUNDLETOOL_PATH=$3
else
  export BUNDLETOOL_PATH="$HOME/Android/bundletool-all-0.12.0.jar"
fi

echo "[i] start build appbundle..."

flutter build appbundle

cp ./build/app/outputs/bundle/release/app-release.aab "$BUILD_DIR_PATH"/appbundle/vft-flight-throttle-"$1".aab

echo "[o] succeed build appbundle."

echo "[i] start build mono-apks..."

java -jar "$BUNDLETOOL_PATH" build-apks --bundle=./build/app/outputs/bundle/release/app-release.aab --output="$BUILD_DIR_PATH"/apk/vft-flight-throttle-"$1".apks --mode=universal
unzip "$BUILD_DIR_PATH"/apk/vft-flight-throttle-"$1".apks -d "$BUILD_DIR_PATH"/apk/

echo "[o] succeed build mono-apks."

rm "$BUILD_DIR_PATH"/apk/toc.pb
rm "$BUILD_DIR_PATH"/apk/vft-flight-throttle-"$1".apks

mv "$BUILD_DIR_PATH"/apk/universal.apk "$BUILD_DIR_PATH"/apk/vft-flight-throttle-"$1".apk

echo "[o] succeed build appbundle and apk with version $1"
