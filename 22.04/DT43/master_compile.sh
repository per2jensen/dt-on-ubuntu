#!/bin/bash
##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

source envvars

# Directory where darktable "master" is installed
INSTALL_PREFIX="$HOME/programmer/darktable-master"

# Folder which already contains a darktable git checkout or should be used for a fresh one 
DT_SRC_FOLDER="$HOME/git/darktable"

# the code name for Ubuntu used in LLVM's repos
CODENAME_LLVM="jammy"

# use git master
RELEASE=master

# shellcheck source=/dev/null
source "./$_COMPILE"
