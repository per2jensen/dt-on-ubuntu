#!/bin/bash

##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

# This script by default run the script to install a released version of darktable
#
# use the "-m" option to compile darktable master instead in the VM

source envvars

# Get the options
while [ -n "$1" ]; do
  case "$1" in
      --master|-m)
          DT_COMPILE_SCRIPT=master_compile.sh
          ;;
      --help|-h)
          echo "$0 --help|-h  [--master|-m]"
          echo " --master|-m, compile darktable master"
          echo " --help|-h, show this usage info"
          exit 
          ;;
      *)
          echo option \"$1\" not recognized, exiting
          exit
          ;;
  esac
  shift
done


# check if VM exists and is running
multipass list |grep -E ${VM_NAME}
if [ $? == "0" ]
then
    multipass info ${VM_NAME} |grep -E  "State.*?Running"
    if [ $? != "0" ]
    then
        multipass start ${VM_NAME}
    fi
    multipass info ${VM_NAME} |grep -E  "State.*?Running"
    if [ $? != "0" ]
    then
        echo "VM: ${VM_NAME}" does not start, exiting
        exit 1 
    fi
else
    # create the VM
    multipass launch -n ${VM_NAME} -d ${VM_SIZE} ${VM_IMAGE}
    if [ $? != "0" ]
    then
        echo "VM: ${VM_NAME}" does not start, exiting
        exit 1     
    fi
fi

echo execute script: \"${DT_COMPILE_SCRIPT}\" in virtual machine ${VM_NAME}
echo update OS and start compiling Darktable in virtual machine ${VM_NAME}
multipass transfer ${DT_COMPILE_SCRIPT} ${_COMPILE} envvars ${VM_NAME}:
multipass exec ${VM_NAME}  -- chmod u+x ${DT_COMPILE_SCRIPT} ${_COMPILE}
# in VM: install dependencies, compile and install, then print DT's --version info
multipass exec ${VM_NAME} -- ./${DT_COMPILE_SCRIPT}
