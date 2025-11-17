#!/bin/bash
##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

source envvars


# Folder which already contains a darktable git checkout or should be used for a fresh one 
export DT_SRC_FOLDER="$HOME/git/darktable"

# the code name for Ubuntu used in LLVM's repos
export CODENAME_LLVM="lunar"

# shellcheck source=/dev/null
source "./$_COMPILE"
