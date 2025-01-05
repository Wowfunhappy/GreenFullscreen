#!/bin/bash

set -e

PLUGIN_NAME="GreenFullscreen"

BUILD_DIR="./build"
mkdir -p "${BUILD_DIR}"

BUNDLE_DIR="$(cd "${BUILD_DIR}" && pwd)/${PLUGIN_NAME}.bundle"
mkdir -p "${BUNDLE_DIR}/Contents/MacOS"
mkdir -p "${BUNDLE_DIR}/Contents/Resources"

INSTALL_DIR="/Library/Application Support/SIMBL/Plugins"


# Compile the plugin
clang -dynamiclib -arch i386 -arch x86_64 -framework Cocoa -o "${BUILD_DIR}/${PLUGIN_NAME}" "$PLUGIN_NAME".m ZKSwizzle.m

# Copy the compiled plugin to the bundle
cp "${BUILD_DIR}/${PLUGIN_NAME}" "${BUNDLE_DIR}/Contents/MacOS/"

cp "./info.plist" "${BUNDLE_DIR}/Contents/info.plist"

# Use sudo to copy the bundle to the installation directory
echo "Copying bundle to ${INSTALL_DIR}..."
osascript -e "tell application \"Finder\" to move (POSIX file \"${BUNDLE_DIR}\" as alias) to (POSIX file \"${INSTALL_DIR}\" as alias) replacing True"

# Clean up the build directory
rm -rf "${BUILD_DIR}"

echo "Build complete. Plugin installed at ${INSTALL_DIR}/${PLUGIN_NAME}.bundle"
