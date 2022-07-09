#! /bin/bash

source envvars

#########################
# don't change below
#########################
echo user compiling: 
id
# install loads of dependencies
echo Fetch llvm-snapshot-gpg.key
curl https://apt.llvm.org/llvm-snapshot.gpg.key|gpg --dearmor > llvm-snapshot-keyring.gpg
if [ $? != "0" ]
then
    echo "Downloading llvm gpg key failed, exiting"  && exit
fi
sudo mv llvm-snapshot-keyring.gpg /usr/share/keyrings/

sudo sh -c "echo deb     [signed-by=/usr/share/keyrings/llvm-snapshot-keyring.gpg]  http://apt.llvm.org/${CODENAME_LLVM}/ llvm-toolchain-${CODENAME_LLVM} main > /etc/apt/sources.list.d/llvm.list"
sudo sh -c "echo deb-src [signed-by=/usr/share/keyrings/llvm-snapshot-keyring.gpg]  http://apt.llvm.org/${CODENAME_LLVM}/ llvm-toolchain-${CODENAME_LLVM} main > /etc/apt/sources.list.d/llvm-src.list"
sudo apt update && sudo apt upgrade -y

sudo apt install -y lld-12 llvm-12-dev llvm-12-runtime llvm-12 lldb-12 python3-lldb-12  \
   clang-12  clang-format-12 clang-tidy-12 clang-tools-12 python3-clang-12  \
   libc++-12-dev libc++1-12 \
   libc++abi-12-dev libc++abi1-12  \
   libclang-12-dev libclang1-12 liblldb-12-dev libllvm-12-ocaml-dev libomp-12-dev libomp5-12  \
   libopencl-clang-dev libopencl-clang10 opencl-c-headers opencl-headers libclang-common-12-dev nvidia-opencl-dev ocl-icd-opencl-dev \
   intltool cmake
if [ $? != "0" ]
then
    echo "1: Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libxml2-utils xsltproc libsaxon-java libpthread-workqueue0 libpthread-workqueue-dev  \
   libc6-dev libglib2.0-dev   \
   liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev  \
   libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev  \
   libexiv2-dev libpugixml-dev lua5.3 liblua5.3-0 liblua5.3-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev  \
   libgraphicsmagick1-dev imagemagick libmagick++-6.q16-dev libopenexr-dev libopenexr24 desktop-file-utils libgmic-dev
if [ $? != "0" ]
then
    echo "2: Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libflickcurl-dev libraptor2-dev libopenjp2-7-dev libopenjp2-7 libosmgpsmap-1.0-dev libosmgpsmap-1.0-1  \
   libcolord-gtk-dev libcolord-gtk1 libcups2-dev libcups2  \
   libavifile-0.7-bin libavifile-0.7-dev libavifile-0.7-common libavifile-0.7c2 \
   libsecret-1-dev libsecret-1-0   \
   libimage-exiftool-perl

if [ $? != "0" ]
then
    echo "3: Package installation failed, exiting"  && exit
fi 

sudo apt install -y  dh-make debhelper libheif-dev libportmidi-dev libsdl2-dev

if [ $? != "0" ]
then
    echo "4: Package installation failed, exiting"  && exit
fi 

# see here: https://github.blog/2022-04-12-git-security-vulnerability-announced/
# if installing outside $HOME, prefix next line with sudo
git config --global --add safe.directory "${DT_SRC_FOLDER}"

if [[ -d "$DT_SRC_FOLDER"  ]]; then
    rm -fr "${DT_SRC_FOLDER}"
fi

git clone https://github.com/darktable-org/darktable.git "$DT_SRC_FOLDER" 2>&1|tee -a "$LOG" 
if [[ "${PIPESTATUS[0]}" != "0" ]]; then
  echo \"git clone\" failed, exiting
  exit 1
fi

cd "$DT_SRC_FOLDER"
git checkout "${RELEASE}" 2>&1|tee -a "$LOG" 
if [[ "${PIPESTATUS[0]}" != "0" ]]; then
  echo \"git checkout\" failed, exiting
  exit 1
fi

git submodule init   2>&1|tee -a "$LOG"
if [[ "${PIPESTATUS[0]}" != "0" ]]; then
  echo \"git submodule init\" failed, exiting
  exit 1
fi

git submodule update 2>&1|tee -a "$LOG"
if [[ "${PIPESTATUS[0]}" != "0" ]]; then
  echo \"git sumodule update\" failed, exiting
  exit 1
fi

# build darktable
mv "${INSTALL_PREFIX}" "${INSTALL_PREFIX}"-org
./build.sh --prefix "${INSTALL_PREFIX}" 2>&1|tee -a "$LOG"
if [ "${PIPESTATUS[0]}" != "0" ]
then
    echo "Build failed, exiting"  && exit
fi

    
#install darktable
# if installing outside $HOME, prefix next line with sudo
cmake --build "$DT_SRC_FOLDER/build" --target install -- -j1  2>&1 |tee -a "$LOG"
if [ "${PIPESTATUS[0]}" != "0" ]
then
    echo "Installation failed, exiting"  && exit
fi

# print --version info
"${INSTALL_PREFIX}/bin/darktable" --version  2>&1|tee -a "$LOG"
