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

The end result from running "darktable --version" on the latest supported build, is:
````
darktable 4.6.0
Copyright (C) 2012-2023 Johannes Hanika and other contributors.

Compile options:
  Bit depth              -> 64 bit
  Debug                  -> DISABLED
  SSE2 optimizations     -> ENABLED
  OpenMP                 -> ENABLED
  OpenCL                 -> ENABLED
  Lua                    -> ENABLED  - API version 9.2.0
  Colord                 -> ENABLED
  gPhoto2                -> ENABLED
  GMIC                   -> ENABLED  - Compressed LUTs are supported
  GraphicsMagick         -> ENABLED
  ImageMagick            -> DISABLED
  libavif                -> ENABLED
  libheif                -> ENABLED
  libjxl                 -> ENABLED
  OpenJPEG               -> ENABLED
  OpenEXR                -> ENABLED
  WebP                   -> ENABLED

See https://www.darktable.org/resources/ for detailed documentation.
See https://github.com/darktable-org/darktable/issues/new/choose to report bugs.
````

# How to compile Darktable 4.6.0 for Ubuntu 23.10 in a VM

````
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/23.10/DT46
    chmod u+x install_in_vm.sh
    ./install_in_vm.sh
````

If you have an old VM lying around and want to start from a fresh, do this:

````
    multipass stop   ubuntu2310-DTcompile
    multipass delete ubuntu2310-DTcompile
    multipass purge 
````

# Shell access to VM to see the buildlog

````
# become the 'ubuntu' user in the VM
multipass shell ubuntu2310-DTcompile  

# view the output captued from 'configure' and 'make'
less DT-4.6.0.log
````

# Output from 'configure'

The full log file has been saved in git ("[DT-4.6.0.log](https://github.com/per2jensen/dt-on-ubuntu/blob/master/23.04/DT44/_compile.sh])", for viewing if you are interested

````
-- ----------------------------------------------------------------------------------
--  Libraw 0.21.1 configuration            <http://www.libraw.org>
-- 
--  Libraw will be compiled with OpenMP support .................. YES
--  Libraw will be compiled with LCMS support .................... NO
--  Libraw will be compiled with example command-line programs ... NO
--  Libraw will be compiled with RedCine codec support ........... NO
--  Libraw will be compiled with DNG deflate codec support ....... YES
--  Libraw will be compiled with DNG lossy codec support ......... YES
--  Libraw will be compiled with RawSpeed support ................ NO
--  Libraw will be compiled with debug message from dcraw ........ NO
--  Libraw will be compiled with Foveon X3F support .............. NO
--  Libraw will be compiled with Raspberry Pi RAW support ........ NO
--  Libraw will be compiled as a static library
-- -------------------------------------------------------

-- The following features have been enabled:

 * OpenMP-based threading, used for parallelization of the library
 * XML reading, used for loading of data/cameras.xml
 * Lossy JPEG decoding, used for DNG Lossy JPEG compression decoding
 * ZLIB decoding, used for DNG Deflate compression decoding

-- The following OPTIONAL packages have been found:

 * FFI
 * Terminfo
 * zstd
 * LLVM
 * Gettext
 * XMLLINT, command line XML tool, <http://xmlsoft.org/>
   Used for validation of data/cameras.xml
 * Gphoto2 (required version >= 2.5)
 * OpenEXR (required version >= 3.0)
 * JXL (required version >= 0.7.0)
 * WebP (required version >= 0.3.0)
 * libavif
 * libheif
 * PortMidi, Portable MIDI library, <https://github.com/PortMidi/portmidi>
   Used for hardware MIDI input devices
 * OpenJPEG
 * IsoCodes (required version >= 3.66)
 * Libsecret
 * GraphicsMagick
 * GMIC
 * ICU
 * Lua54 (required version >= 5.4)
 * OSMGpsMap
 * Colord
 * ColordGTK
 * Cups
 * SDL2, low level access to audio, keyboard, mouse, joystick, and graphics hardware, <https://www.libsdl.org/>
 * X11

-- The following REQUIRED packages have been found:

 * GTK3 (required version >= 3.24.15)
 * Threads
 * Imath
 * LensFun
 * Sqlite3 (required version >= 3.15)
 * GIO
 * GThread
 * GModule
 * PangoCairo
 * Rsvg2
 * LibXml2
 * PNG
 * TIFF
 * LCMS2
 * JsonGlib
 * Exiv2 (required version >= 0.25)
 * Pugixml (required version >= 1.2), Light-weight, simple and fast XML parser, <http://pugixml.org/>
   Used for loading of data/cameras.xml
 * CURL (required version >= 7.56)
 * Glib
 * ZLIB, software library used for data compression
   Used for decoding DNG Deflate compression
 * JPEG, free library for handling the JPEG image data format, implements a JPEG codec
   Used for decoding DNG Lossy JPEG compression
 * OpenMP, Open Multi-Processing, <https://www.openmp.org/>
   Used for parallelization of the library
````

## Build on your machine
Once you are happy that things work in the VM, consider changing
the compile script to your liking (set the INSTALL_PREFIX env variable in 22-04/DT42/DT42_compile.sh)
and run the script to enjoy the DT goodness :-)

# How to follow Git Master, to be on the bleeding edge
    git clone https://github.com/per2jensen/dt-on-ubuntu.git
    cd dt-on-ubuntu/22.04/DT42
    chmod u+x master_compile.sh
    ./master_compile.sh

Edit the environment variables in the script to your taste.


## Docs
Documentation is not compiled
  
# Links
  [Darktable website](https://www.darktable.org/)
  
  [Darktable on github](https://github.com/darktable-org/darktable)
  
  [Darktable on Pixls.us](https://discuss.pixls.us/c/software/darktable/19)
