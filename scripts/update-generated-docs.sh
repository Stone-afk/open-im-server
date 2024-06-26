#!/usr/bin/env bash
# Copyright © 2023 OpenIM. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file is not intended to be run automatically. It is meant to be run
# immediately before exporting docs. We do not want to check these documents in
# by default.





OPENIM_ROOT=$(dirname "${BASH_SOURCE[0]}")/..
source "${OPENIM_ROOT}/scripts/lib/init.sh"

openim::golang::setup_env

BINS=(
  gendocs
  genopenimdocs
  genman
  genyaml
)
make -C "${OPENIM_ROOT}" WHAT="${BINS[*]}"

openim::util::ensure-temp-dir

openim::util::gen-docs "${OPENIM_TEMP}"

# remove all of the old docs
openim::util::remove-gen-docs

# Copy fresh docs into the repo.
# the shopt is so that we get docs/.generated_docs from the glob.
shopt -s dotglob
cp -af "${OPENIM_TEMP}"/* "${OPENIM_ROOT}"
shopt -u dotglob
