# Compile darktable on Ubuntu
This is a collection of scripts for compiling different versions of DarkTable 
on different versions of Ubuntu. The versions follows what I am using on my 
workstation :-)

There are 2 ways to install Darktable:
  1. Darktable releases can be installed in a VM for trying it out.
  
  2. Follow Git Master on your computer using the script for that.


# Dependencies
* KVM 

    kvm must be installed in order for multipass to work
    Take a look here: https://www.tecmint.com/install-kvm-on-ubuntu/

* Multipass
    
    The scrips requires Ubuntu Multipass to be installed, as all activity
    takes place within a virtual machine. You can of course create your own 
    Ubuntu VM and fire off the "compile script" there.

    Multipass is a snap away on Ubuntu: 
        snap install --classic multipass

* DT clone location

    DT is cloned to this location within the VM: /home/ubuntu/git/darktable

* Installation
    Darktable is installed into /opt/darktable within the VM.
      


# What the scripts do:
The compile script does the following:

*    creates/starts a VM called ubuntu<version>-DTcompile
*    clones Darktable from Github into the VM
*    adds llvm repoes to the VM's APT sources
*    adds llvm APT key into the VM
*    installs loads of necessary Ubuntu packages in the VM
*    builds and install Darktable in the VM
*    starts Darktable to print the --version info in the VM

The end result from running "darktable --version", is this:
````
this is darktable 3.6.0
copyright (c) 2009-2021 johannes hanika
darktable-dev@lists.darktable.org

compile options:
  bit depth is 64 bit
  normal build
  SSE2 optimized codepath enabled
  OpenMP support enabled
  OpenCL support enabled
  Lua support enabled, API version 7.0.0
  Colord support enabled
  gPhoto2 support enabled
  GraphicsMagick support enabled
  ImageMagick support disabled
  OpenEXR support enabled
````
 

# How to compile Darktable 3.6.0 for Ubuntu 21.04 in a VM
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/21.04
    chmod u+x install_in_vm.sh
    ./install_in_vm.sh


If you have an old VM lying around and want to start from a fresh, do this.

    multipass stop   ubuntu2104-DTcompile
    multipass delete ubuntu2104-DTcompile
    multipass purge 


## Build on your machine
Once you are happy that things work in the VM, consider changing
the compile script to your liking (set the INSTALL_PREFIX env variable in DT34_compile.sh)
and run the script to enjoy the DT goodness :-)



# How to follow Git Master, to be on the bleeding edge
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/20.04
    chmod u+x master_compile.sh
    ./master_compile.sh

Edit the environment variables in the script to your taste.



# Issues:
*    Documentation is not compiled
