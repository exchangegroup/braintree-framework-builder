#!/bin/sh
#
# Copyright 2010-present Facebook.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ---------------------------------------------
#
# This script builds Braintree SDK.
#
# It is based on Facebook iOS SDK distributed at
# https://github.com/facebook/facebook-ios-sdk/downloads/FacebookSDK.framework.tgz.
#
# Script for building universal framework file is based on this Stackoverflow post:
#
# http://stackoverflow.com/a/26691080/297131
#
# Further reference:
#
#   https://gist.github.com/cconway25/7ff167c6f98da33c5352
#   https://gist.githubusercontent.com/cromandini/1a9c4aeab27ca84f5d79/raw/bab543867b63a2ea3c2d7a9b1312b6cf4bf5fbd0/universal-framework.sh
#
# The original Facebook SDK script was chagned by Evgenii Neumerzhitckii.
#
# ---------------------------------------------

. "${SDK_SCRIPT:-$(dirname "$0")}/common.sh"

BUILDCONFIGURATION=Debug
PROJECT_NAME=BraintreeFrameworkBuilder
FRAMEWORK_NAME=Braintree

# The directory where the universal framework is built
UNIVERSAL_OUTPUTFOLDER=${SDK_BUILD}/${BUILDCONFIGURATION}-universal

# 1. Build Device and Simulator versions
# ---------------------------------------------

test -d "$SDK_BUILD" \
  || mkdir -p "$SDK_BUILD" \
  || die "Could not create directory $SDK_BUILD"

cd "$SDK_ROOT"

function xcode_build_target() {
  echo "Compiling for platform: ${1} (${2}, ${3})."
  xcodebuild \
    -project $PROJECT_NAME.xcodeproj \
    -scheme $PROJECT_NAME \
    -sdk $1 \
    -configuration "${2}" \
    ONLY_ACTIVE_ARCH=NO \
    RUN_CLANG_STATIC_ANALYZER=NO \
    SYMROOT="$SDK_BUILD" \
    clean build \
    || die "XCode build failed for platform: ${1} (${2}, ${3})."
}

xcode_build_target iphonesimulator "${BUILDCONFIGURATION}"
xcode_build_target iphoneos "${BUILDCONFIGURATION}"

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
# ---------------------------------------------

test -d "$UNIVERSAL_OUTPUTFOLDER" \
  || mkdir -p "$UNIVERSAL_OUTPUTFOLDER" \
  || die "Could not create directory $UNIVERSAL_OUTPUTFOLDER"

cp -R "${SDK_BUILD}/${BUILDCONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy localization files.
# ---------------------------------------------

function copy_localization() {
  echo "Copying localization files from ${1} to ${2}.bundle."

  UI_LOCALIZATION_BUNDLE_NAME=${2}.bundle
  UI_LOCALIZATION_FOLDER="${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework/${UI_LOCALIZATION_BUNDLE_NAME}"

  test -d "$UI_LOCALIZATION_FOLDER" \
    || mkdir -p "$UI_LOCALIZATION_FOLDER" \
    || die "Could not create directory $UI_LOCALIZATION_FOLDER"

  UI_LOCALIZATION_SOURCE_FOLDER=$SDK_ROOT/${1}

  \cp -r \
    $UI_LOCALIZATION_SOURCE_FOLDER/*.lproj \
    $UI_LOCALIZATION_FOLDER/ \
    || die "Error copying localization files"
}

copy_localization "Braintree/UI/Localization" "Braintree-UI-Localization"
copy_localization "Braintree/Drop-In/Localization" "Braintree-Drop-In-Localization"

# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
# ---------------------------------------------

lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" \
  "${SDK_BUILD}/${BUILDCONFIGURATION}-iphonesimulator/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}" \
  "${SDK_BUILD}/${BUILDCONFIGURATION}-iphoneos/${FRAMEWORK_NAME}.framework/${FRAMEWORK_NAME}"

# Step 5. Convenience step to copy the framework to the project's directory
# ---------------------------------------------

cp -R "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework" "${SDK_BUILD}"

# Step 6. Convenience step to open the project's directory in Finder
# ---------------------------------------------

open "${SDK_BUILD}"
