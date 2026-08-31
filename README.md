# Compile darktable on Ubuntu

This repository contains scripts for compiling different versions of darktable on different Ubuntu releases.

The versions generally follow what I use on my own systems.

There are two main ways to use the scripts:

1. Build a released version of darktable in a Multipass VM for testing.
2. Follow darktable Git master for a bleeding-edge build.

Building in a VM first makes it easy to verify the toolchain and dependencies without affecting the host system.

# Dependencies

## KVM

KVM must be installed for Multipass to work.

See:

https://www.tecmint.com/install-kvm-on-ubuntu/

## Multipass

The scripts use Ubuntu Multipass, and all compilation activity takes place inside a virtual machine.

You can also create your own Ubuntu VM and run the compile script there.

Install Multipass on Ubuntu with:

```
sudo snap install multipass
```

## darktable source location

darktable is cloned inside the VM to:

```
/home/ubuntu/git/darktable
```

## Installation location

darktable is installed inside the VM under:

```
/home/ubuntu/programmer/darktable-<version>
```

# Current tested release

The current tested release is:

```
darktable 5.6.1
Ubuntu 24.04 LTS
```

The Ubuntu 24.04 build uses LLVM/Clang 20 from the standard Ubuntu repositories.

No external LLVM repository is required.

OpenCL is enabled and has been tested with an NVIDIA RTX 4070 SUPER.

AI support is enabled.

The resulting build reports:

```
darktable 5.6.1 [linux]
Copyright (C) 2012-2026 Johannes Hanika and other contributors.

Compile options:
  Bit depth              -> 64 bit
  Exiv2                  -> 0.27.6
  Lensfun                -> 0.3.4
  Debug                  -> DISABLED
  SSE2 optimizations     -> ENABLED
  OpenMP                 -> ENABLED
  OpenCL                 -> ENABLED
  Lua                    -> ENABLED  - API version 9.7.0
  Colord                 -> ENABLED
  gPhoto2                -> ENABLED  - Camera tethering is available
  OSMGpsMap              -> ENABLED  - Map view is available
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
  AI                     -> ENABLED
```

Release:

https://github.com/per2jensen/dt-on-ubuntu/releases/tag/DT561-2404

# What the scripts do

The VM installation script:

* creates or starts the Multipass VM
* transfers the build scripts and environment settings into the VM
* installs the required Ubuntu packages
* clones the darktable Git repository
* checks out the selected release
* initializes and updates the Git submodules
* builds darktable
* installs darktable
* runs `darktable --version` to show the resulting feature set

# How to compile darktable 5.6.1 for Ubuntu 24.04 in a VM

Clone the repository:

```
git clone https://github.com/per2jensen/dt-on-ubuntu.git
cd dt-on-ubuntu/24.04/DT561
```

Make the launcher executable:

```
chmod u+x install_in_vm.sh
```

Start the build:

```
./install_in_vm.sh
```

The script will create the Multipass VM if it does not already exist.

# Rebuilding in a fresh VM

If an old build VM exists and you want to test from a completely fresh Ubuntu installation:

```
multipass stop ubuntu2404-DTcompile
multipass delete ubuntu2404-DTcompile
multipass purge
```

Then run:

```
./install_in_vm.sh
```

again.

# Shell access to the build VM

To enter the VM:

```
multipass shell ubuntu2404-DTcompile
```

The build log for darktable 5.6.1 is:

```
less DT-5.6.1.log
```

The log contains the output from configuration and compilation.

# Build directly on your machine

Once the build has been tested successfully in the VM, the same scripts can be used directly on the host.

Review the variables in `envvars`, in particular:

* `DT_SRC_FOLDER`
* `INSTALL_PREFIX`

Then run:

```
./DTcompile.sh
```

# Follow Git master

The same setup can be used to compile darktable Git master:

```
git clone https://github.com/per2jensen/dt-on-ubuntu.git
cd dt-on-ubuntu/24.04/DT561
chmod u+x master_compile.sh
./master_compile.sh
```

Edit the variables in `envvars` to match your preferred source and installation locations.

# OpenCL for Intel Iris on Ubuntu 26.04

On a laptop with Intel Iris graphics running Ubuntu 26.04, OpenCL has also been tested using Intel's GPU packages.

The Intel documentation used was:

https://dgpu-docs.osgc.infra-host.com/driver/client/overview.html

At the time of testing, the documentation did not explicitly list Ubuntu 26.04 as supported, but OpenCL worked successfully with an Intel Iris Xe GPU.

Example output:

```
[opencl_init] found 1 platform
[opencl_init] found 1 device

DEVICE: 'Intel(R) Iris(R) Xe Graphics'
DEVICE VERSION: OpenCL 3.0 NEO

[opencl_init] FINALLY: opencl PREFERENCE=ON is AVAILABLE and ENABLED.
```

This Intel-specific setup is separate from the standard Ubuntu 24.04 / NVIDIA build described above.

# Documentation

darktable documentation itself is not compiled by these scripts.

# Links

darktable website:

https://www.darktable.org/

darktable on GitHub:

https://github.com/darktable-org/darktable

darktable on Pixls.us:

https://discuss.pixls.us/
