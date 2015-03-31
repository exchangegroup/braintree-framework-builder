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
# The original Facebook SDK script was chagned by Evgenii Neumerzhitckii.
#
# ---------------------------------------------

# The directory containing this script
pushd "$(dirname $BASH_SOURCE[0])" >/dev/null
SDK_SCRIPT=$(pwd)
popd >/dev/null

# The root directory where the SDK for iOS is cloned
SDK_ROOT=$(dirname "$SDK_SCRIPT")

# The directory where the target is built
SDK_BUILD=$SDK_ROOT/mybuild

# Call this when there is an error.  This does not return.
function die() {
  echo ""
  echo "FATAL: $*" >&2
  show_summary
  exit 1
}


