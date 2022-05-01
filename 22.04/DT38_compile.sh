#!/bin/bash
##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

# Change this if you want to run the compile script directly on your machine
# Release to use
export RELEASE=release-3.8.1

export VERSION=$(echo $RELEASE|grep -E -o '\-.*')
export INSTALL_PREFIX="$HOME/programmer/darktable${VERSION}"

# Folder which already contains a darktable git checkout or should be used for a fresh one 
export DT_SRC_FOLDER="$HOME/git/darktable"

# the code name for Ubuntu used in LLVM's repos
export CODENAME_LLVM="jammy"

# FIXME don't hardcode here
./_compileDT38.sh

