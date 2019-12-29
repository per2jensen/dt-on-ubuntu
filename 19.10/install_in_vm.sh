##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

VM_NAME=ubuntu1910
VM_SIZE=8G
VM_IMAGE=19.10
DT_COMPILE_SCRIPT=DT30_dependencies.sh
# INSTALL_PREFIX_DEFAULT=~\/darktable  can't make this work  with sed

multipass launch -n ${VM_NAME} -d ${VM_SIZE} ${VM_IMAGE}

if [ $? == "0" ]
then
    echo start compiling Darktable in virtual machine ${VM_NAME}
    sed -i "s/^INSTALL_PREFIX_DEFAULT=.*/INSTALL_PREFIX_DEFAULT=~\/darktable/" ${DT_COMPILE_SCRIPT}
    multipass transfer ${DT_COMPILE_SCRIPT} ${VM_NAME}:
    multipass exec ${VM_NAME}  -- chmod u+x ${DT_COMPILE_SCRIPT}
    # install dependencies, compile and install, then print DT's --version info
    multipass exec ${VM_NAME} -- ./${DT_COMPILE_SCRIPT}
else
    echo VM creation failed....
fi