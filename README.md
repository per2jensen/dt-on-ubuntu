# Compile darktable on Ubuntu
This is a collection of scripts for compiling different versions of DarkTable 
on different versions of Ubuntu. The versions follows what I am using on my 
workstation :-)

The package installation and Darktable compilation is done in virtual machines, so there
is no contamination of your computer, until you want to deploy there.


Dependencies
============
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
    Darktable is installed into /opt/darktable
      


What the scripts do:
====================
The compile script does the following:

*    creates/starts a VM called ubuntu<version>-DTcompile
*    clones Darktable from Github into the VM
*    adds llvm repoes to the VM's APT sources
*    adds llvm APT key into the VM
*    installs loads of necessary Ubuntu packages in the VM
*    builds and install Darktable in the VM
*    starts Darktable to print the --version info in the VM

The end result from running "darktable --version", should look something like this:

    this is darktable 3.2.1
    copyright (c) 2009-2020 johannes hanika
    darktable-dev@lists.darktable.org

    compile options:
    bit depth is 64 bit
    normal build
    SSE2 optimized codepath enabled
    OpenMP support enabled
    OpenCL support enabled
    Lua support enabled, API version 6.0.0
    Colord support enabled
    gPhoto2 support enabled
    GraphicsMagick support enabled
    ImageMagick support disabled
    OpenEXR support enabled



How to compile DT32 for Ubuntu 20.04 in a VM
============================================
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/20.04
    chmod u+x install_in_vm.sh
    ./install_in_vm.sh

Done :-)


Issues:
=======
*    Documentation is not compiled
 

Once you are happy that things work in the VM, consider changing
the compile script to your liking (set the INSTALL_PREFIX env variable)
and run the script to enjoy the DT goodness :-)
