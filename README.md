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
      
# Opencl for Intel Iris on Ubuntu 26.04

To get opencl going on my laptop with an Intel Iris equipped cpu, I found this Intel web page:

```txt
https://dgpu-docs.osgc.infra-host.com/driver/client/overview.html
```

Even though it does not show support for Ubuntu 26.04 May 29, 2026, it works :-)

I followed the simple steps which included adding a ppa to my repo settings (which I normally do not do) and ended up with this result:

```bash
~$ programmer/darktable-5.4.1/bin/darktable -d opencl
darktable 5.4.1
Copyright (C) 2012-2026 Johannes Hanika and other contributors.

Compile options:
  Bit depth              -> 64 bit
  Exiv2                  -> 0.28.8
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
  LibRaw                 -> ENABLED  - Version 0.22.0-Release
  OpenJPEG               -> ENABLED
  OpenEXR                -> ENABLED
  WebP                   -> ENABLED

See https://www.darktable.org/resources/ for detailed documentation.
See https://github.com/darktable-org/darktable/issues/new/choose to report bugs.

     0.0002 [dt starting]
 programmer/darktable-5.4.1/bin/darktable -d opencl
     0.4237 [opencl_init] opencl library 'libOpenCL' found on your system and loaded, preference 'default path'
     1.7255 [opencl_init] found 1 platform
[opencl_init] found 1 device

[dt_opencl_device_init]
   DEVICE:                   0: 'Intel(R) Iris(R) Xe Graphics'
   CONF KEY:                 cldevice_v5_intelropenclgraphicsintelririsrxegraphics
   PLATFORM, VENDOR & ID:    Intel(R) OpenCL Graphics, Intel(R) Corporation, ID=32902
   CANONICAL NAME:           intelropenclgraphicsintelririsrxegraphics
   DRIVER VERSION:           26.18.38308.1
   DEVICE VERSION:           OpenCL 3.0 NEO 
   DEVICE_TYPE:              GPU, unified mem
   GLOBAL MEM SIZE:          28917 MB
   MAX MEM ALLOC:            4096 MB
   MAX IMAGE SIZE:           16384 x 16384
   MAX CONSTANT BUFFER:      4194296 KB
   ADDRESS ALIGN:            128
   COMPUTE UNITS:            80
   MAX WORK GROUP SIZE:      512
   MAX WORK ITEM DIMENSIONS: 3
   MAX WORK ITEM SIZES:      [ 512 512 512 ]
   ASYNC PIXELPIPE:          NO
   PINNED MEMORY TRANSFER:   NO
   AVOID ATOMICS:            NO
   MICRO NAP:                250
   ROUNDUP WIDTH & HEIGHT    16x16
   CHECK EVENT HANDLES:      128
   TILING ADVANTAGE:         0.000
   DEFAULT DEVICE:           NO
   KERNEL BUILD DIRECTORY:   /home/pj/programmer/darktable-5.4.1/share/darktable/kernels
   KERNEL DIRECTORY:         /home/pj/.cache/darktable/cached_v5_kernels_for_IntelROpenCLGraphicsIntelRIrisRXeGraphics_2618383081
   CL COMPILER OPTION:       
   CL COMPILER COMMAND:      -w  -DINTEL=1 -I"/home/pj/programmer/darktable-5.4.1/share/darktable/kernels"
   KERNEL LOADING TIME:       0.0381 sec
[opencl_init] OpenCL successfully initialized. internal numbers and names of available devices:
[opencl_init]		0	'Intel(R) OpenCL Graphics Intel(R) Iris(R) Xe Graphics'
     1.7642 [opencl_init] FINALLY: opencl PREFERENCE=ON is AVAILABLE and ENABLED.
[opencl_init] opencl_scheduling_profile: 'default'
[opencl_init] opencl_device_priority: '+0/+0/+0/+0/+0'
[opencl_init] opencl_mandatory_timeout: 20000
[opencl_update_priorities] these are your device priorities:
[opencl_update_priorities] 		image	preview	export	thumbs	preview2
[dt_opencl_update_priorities]		0	0	0	0	0
[opencl_update_priorities] show if opencl use is mandatory for a given pixelpipe:
[opencl_update_priorities] 		image	preview	export	thumbs	preview2
[opencl_update_priorities]		1	1	1	1	1
[opencl_synchronization_timeout] synchronization timeout set to 200
   UNIFIED MEM SIZE:         7810 MB reserved for 'intelropenclgraphicsintelririsrxegraphics' id=0[opencl_update_priorities] these are your device priorities:
[opencl_update_priorities] 		image	preview	export	thumbs	preview2
[dt_opencl_update_priorities]		0	0	0	0	0
[opencl_update_priorities] show if opencl use is mandatory for a given pixelpipe:
[opencl_update_priorities] 		image	preview	export	thumbs	preview2
[opencl_update_priorities]		1	1	1	1	1
[opencl_synchronization_timeout] synchronization timeout set to 200
 [opencl_summary_statistics] device 'Intel(R) OpenCL Graphics Intel(R) Iris(R) Xe Graphics' id=0: 598 out of 598 events were successful and 0 events lost. max event=93
```

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
~$ programmer/darktable-5.4.1/bin/darktable --version
darktable 5.4.1
Copyright (C) 2012-2026 Johannes Hanika and other contributors.

Compile options:
  Bit depth              -> 64 bit
  Exiv2                  -> 0.28.8
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
  LibRaw                 -> ENABLED  - Version 0.22.0-Release
  OpenJPEG               -> ENABLED
  OpenEXR                -> ENABLED
  WebP                   -> ENABLED

See https://www.darktable.org/resources/ for detailed documentation.
See https://github.com/darktable-org/darktable/issues/new/choose to report bugs.

````

# How to compile Darktable 5.4.1 for Ubuntu 26.04 in a VM

````
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/26.04/DT541
    chmod u+x install_in_vm.sh
    ./install_in_vm.sh
````

If you have an old VM lying around and want to start from a fresh, do this:

````
    multipass stop   ubuntu2604-DTcompile
    multipass delete ubuntu2604-DTcompile
    multipass purge 
````

## Shell access to VM to see the buildlog

````
# become the 'ubuntu' user in the VM
multipass shell ubuntu2604-DTcompile  

# view the output captued from 'configure' and 'make'
less DT-5.4.1.log
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
    cd dt-on-ubuntu/26.04/DT541
    chmod u+x master_compile.sh
    ./master_compile.sh

Edit the environment variables to your taste.


# Docs
Documentation is not compiled
  
# Links
  [Darktable website](https://www.darktable.org/)
  
  [Darktable on github](https://github.com/darktable-org/darktable)
  
  [Darktable on Pixls.us](https://discuss.pixls.us/c/software/darktable/19)
