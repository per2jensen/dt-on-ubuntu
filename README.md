# Compile darktable on Ubuntu
This is a collection of scripts for compiling different versions of DarkTable 
on different versions of Ubuntu. The versions follows what I am using on my 
workstation :-)

There are 2 ways to install Darktable:
  1. Darktable releases can be installed in a VM for trying it out.

        It is easy to build on your local machine, but trying out in a VM first is nice.
  
  2. Follow Git Master on your computer using the script for that.


# Dependencies
* KVM 

    kvm must be installed in order for multipass to work
    Take a look here: https://www.tecmint.com/install-kvm-on-ubuntu/

* Multipass
    
    The scripts require Ubuntu Multipass to be installed, as all activity
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

The end result from running "darktable --version" on the latest supported build, is:

````
darktable 5.4.0
Copyright (C) 2012-2025 Johannes Hanika and other contributors.

Compile options:
  Bit depth              -> 64 bit
  Exiv2                  -> 0.27.6
  Lensfun                -> 0.3.4
  Debug                  -> DISABLED
  SSE2 optimizations     -> ENABLED
  OpenMP                 -> ENABLED
  OpenCL                 -> ENABLED
  Lua                    -> ENABLED  - API version 9.6.0
  Colord                 -> ENABLED
  gPhoto2                -> ENABLED
  OSMGpsMap              -> ENABLED  - map view is available
  GMIC                   -> ENABLED  - Compressed LUTs are supported
  GraphicsMagick         -> ENABLED
  ImageMagick            -> DISABLED
  libavif                -> ENABLED
  libheif                -> ENABLED
  libjxl                 -> ENABLED
  LibRaw                 -> ENABLED  - Version 0.22.0-PreRC1
  OpenJPEG               -> ENABLED
  OpenEXR                -> ENABLED
  WebP                   -> ENABLED

See https://www.darktable.org/resources/ for detailed documentation.
See https://github.com/darktable-org/darktable/issues/new/choose to report bugs.
````

# How to compile Darktable 5.4.0 for Ubuntu 24.04 in a VM

````
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/24.04/DT54
    chmod u+x install_in_vm.sh
    ./install_in_vm.sh
````

If you have an old VM lying around and want to start from a fresh, do this:

````
    multipass stop   ubuntu2404-DTcompile
    multipass delete ubuntu2404-DTcompile
    multipass purge 
````

## Shell access to VM to see the buildlog

````
# become the 'ubuntu' user in the VM
multipass shell ubuntu2404-DTcompile  

# view the output captued from 'configure' and 'make'
less DT-5.4.0.log
````

## Output from 'configure'

The full log file has been saved in git ("[DT-5.4.0.log](https://github.com/per2jensen/dt-on-ubuntu/blob/master/24.04/DT54/doc/DT-5.4.0.log)", for viewing if you are interested

# Build on your machine

Once you are happy that things work in the VM, consider changing a couple of env vars in `envvars`:

- DT_SRC_FOLDER
- INSTALL_PREFIX

and run the DTcompile.sh to enjoy the DT goodness :-)

# How to follow Git Master, to be on the bleeding edge

    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/24.04/DT54
    chmod u+x master_compile.sh
    ./master_compile.sh

Edit the environment variables to your taste.


# Docs
Documentation is not compiled
  
# Links
  [Darktable website](https://www.darktable.org/)
  
  [Darktable on github](https://github.com/darktable-org/darktable)
  
  [Darktable on Pixls.us](https://discuss.pixls.us/c/software/darktable/19)
