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

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

singularity inspect --all mhm.sif

# git clone only the directories for mHM test data
# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository
# https://askubuntu.com/questions/460885/how-to-clone-only-some-directories-from-a-git-repository

if [[ ! -d "data" ]]; then
  echo "Creating the data directories by cloning it from mHM Git repository"
  mkdir data
  cd data
  git init
  git remote add -f upstream https://github.com/mhm-ufz/mHM.git

  git config core.sparseCheckout true

  echo "test_domain/" >> .git/info/sparse-checkout
  echo "test_domain_2/" >> .git/info/sparse-checkout
  echo "mhm.nml" >> .git/info/sparse-checkout
  echo "mhm_outputs.nml" >> .git/info/sparse-checkout
  echo "mhm_parameter.nml" >> .git/info/sparse-checkout
  echo "mrm_outputs.nml" >> .git/info/sparse-checkout

  git pull upstream v5.12.0
  mv *.nml ../
fi

cd %PLATFORMS.REMOTE.SCRATCH_DIR%

# Create Singularity sandboxes
echo "Creating singularity sandboxes"
for START_DATE in %EXPERIMENT.DATELIST%
do
  EVAL_PERIOD_START="${START_DATE:0:4}"
  EVAL_PERIOD_DURATION_YEARS="%MHM.EVAL_PERIOD_DURATION_YEARS%"
  EVAL_PERIOD_END=$((EVAL_PERIOD_START+EVAL_PERIOD_DURATION_YEARS))
  MHM_DATA_DIR="data_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
  if [[ ! -d "${MHM_DATA_DIR}" ]]; then
    echo "Copying data directory for the start date ${EVAL_PERIOD_START}, to data_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
    cp -r data "${MHM_DATA_DIR}"
  fi

MHM_SINGULARITY_SANDBOX_DIR="mhm_${EVAL_PERIOD_START}_${EVAL_PERIOD_END}"
echo "Creating singularity sandbox ${MHM_SINGULARITY_SANDBOX_DIR}"
if [[ ! -d "${MHM_SINGULARITY_SANDBOX_DIR}" ]]; then
  echo "Creating new singularity sandbox ${MHM_SINGULARITY_SANDBOX_DIR}"
  singularity build --sandbox "${MHM_SINGULARITY_SANDBOX_DIR}" mhm.sif
fi
done

echo "REMOTE_SETUP complete!"
