#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -eux -o pipefail

TARGET_DIR="%PLATFORMS.REMOTE.SCRATCH_DIR%/%PLATFORMS.REMOTE.PROJECT%/%PLATFORMS.REMOTE.USER%/"

#######################################
# Cleanup files from the workflow.
# Globals:
#   None
# Arguments:
#   Directory that contains a folder with the expid name
# Outputs:
#   None
#######################################
clean() {
  delete_me=$1
  if [ -d "${delete_me}" ] && [ "${delete_me}" != "/" ]; then
    rm -rvf "${delete_me}"
  fi
}

clean "${TARGET_DIR}"
