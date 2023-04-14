#!/bin/bash

set -eux -o pipefail

cd %PROJDIR%

echo "Copying the mHM Singularity image mhm.sif via scp: %PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%:%PLATFORMS.REMOTE.SCRATCH_DIR%"

scp mhm.sif %PLATFORMS.REMOTE.USER%@%PLATFORMS.REMOTE.HOST%:%PLATFORMS.REMOTE.SCRATCH_DIR%

echo "SYNC_TO_REMOTE complete!"