#!/bin/bash

##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

VM_NAME=ubuntu2104-DTcompile
VM_SIZE=15G
VM_IMAGE=21.04
DT_COMPILE_SCRIPT=DT36_compile.sh
_COMPILE=_compileDT36.sh

# check if VM exists and is running
multipass list |egrep ${VM_NAME}
if [ $? == "0" ]
then
    multipass info ${VM_NAME} |egrep "State.*?Running"
    if [ $? != "0" ]
    then
        multipass start ${VM_NAME}
    fi
    multipass info ${VM_NAME} |egrep "State.*?Running"
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

echo update OS and start compiling Darktable in virtual machine ${VM_NAME}
multipass transfer ${DT_COMPILE_SCRIPT} ${_COMPILE} ${VM_NAME}:
multipass exec ${VM_NAME}  -- chmod u+x ${DT_COMPILE_SCRIPT} ${_COMPILE}
# in VM: install dependencies, compile and install, then print DT's --version info
multipass exec ${VM_NAME} -- ./${DT_COMPILE_SCRIPT}
 
