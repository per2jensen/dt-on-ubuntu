##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

VM_NAME=ubuntu2004-DTcompile
VM_SIZE=8G
VM_IMAGE=20.04
DT_COMPILE_SCRIPT=DT34_compile.sh
INSTALL_PREFIX=/opt/darktable

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

echo start compiling Darktable in virtual machine ${VM_NAME}
sed s+##PREFIX##+${INSTALL_PREFIX}+ ${DT_COMPILE_SCRIPT} > ${DT_COMPILE_SCRIPT}.vm
multipass transfer ${DT_COMPILE_SCRIPT}.vm ${VM_NAME}:
multipass exec ${VM_NAME}  -- chmod u+x ${DT_COMPILE_SCRIPT}.vm
# in VM: install dependencies, compile and install, then print DT's --version info
multipass exec ${VM_NAME} -- ./${DT_COMPILE_SCRIPT}.vm



