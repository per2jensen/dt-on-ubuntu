##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

# Change this if you want to run the compile script directly on your machine
INSTALL_PREFIX=##PREFIX##

##############################33
##  Master
################################

mkdir -p ~/git
cd ~/git
git clone git://github.com/darktable-org/darktable.git
cd darktable
git checkout darktable-3.2.x
git submodule init
git submodule update


sudo echo deb http://apt.llvm.org/eoan/ llvm-toolchain-eoan main > /etc/apt/sources.list.d/llvm.list
sudo echo deb-src http://apt.llvm.org/eoan/ llvm-toolchain-eoan main >> /etc/apt/sources.list.d/llvm.list
sudo wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421
sudo apt update && sudo apt upgrade

sudo apt install -y lld-10 llvm-dev llvm-runtime llvm-10 lldb-10 python3-lldb-10  \
   clang-10  clang-format-10 clang-tidy-10 clang-tools-10 python-clang  \
   libc++-10-dev libc++1-10 \
   libc++abi-10-dev libc++abi1-10  \
   libclang-10-dev libclang1-10 liblldb-10-dev libllvm-10-ocaml-dev libomp-10-dev libomp5-10  \
   libopencl-clang-dev libopencl-clang10 opencl-c-headers opencl-headers libclang-common-10-dev  \
   intltool cmake
if [ $? != "0" ]
then
    echo "Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libxml2-utils xsltproc libsaxon-java libpthread-workqueue0 libpthread-workqueue-dev  \
   libc6-dev libglib2.0-dev   \
   liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev  \
   libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev  \
   libexiv2-dev libpugixml-dev lua5.3 liblua5.3-0   liblua5.3-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev  \
   libgraphicsmagick1-dev imagemagick libmagick++-6.q16-dev libopenexr-dev libopenexr24   desktop-file-utils
if [ $? != "0" ]
then
    echo "Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libflickcurl-dev libraptor2-dev libopenjp2-7-dev libopenjp2-7 libosmgpsmap-1.0-dev libosmgpsmap-1.0-1  \
   libcolord-gtk-dev libcolord-gtk1 libcups2-dev libcups2  \
   libsecret-1-dev libsecret-1-0   \
   libimage-exiftool-perl 
if [ $? != "0" ]
then
    echo "Package installation failed, exiting"  && exit
fi 


./build.sh --prefix ${INSTALL_PREFIX} | tee dt-build.log
if [ $? != "0" ]
then
    echo "Build failed, exiting"  && exit
fi


sudo cmake --build "/home/ubuntu/git/darktable/build" --target install -- -j1
if [ $? != "0" ]
then
    echo "Installation failed, exiting"  && exit
fi

${INSTALL_PREFIX}/bin/darktable --version


