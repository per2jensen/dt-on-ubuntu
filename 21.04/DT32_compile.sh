#!/bin/bash
##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

# Change this if you want to run the compile script directly on your machine
INSTALL_PREFIX="/opt/darktable"
# Folder which already contains a darktable git checkout or should be used for a fresh one 
DT_SRC_FOLDER="$HOME/darktable"
# Branch to use
BRANCH=darktable-3.2.1

source ./_compile.sh
