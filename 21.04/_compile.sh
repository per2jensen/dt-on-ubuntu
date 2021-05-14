#########################
# don't change below
#########################
echo user compiling: 
id

# get the source ready
if [[ -d $DT_SRC_FOLDER  ]]; then
  echo "darktable dir exists"
  cd $DT_SRC_FOLDER
  git pull --rebase
else
  mkdir -p $DT_SRC_FOLDER
  git clone git://github.com/darktable-org/darktable.git $DT_SRC_FOLDER
  cd $DT_SRC_FOLDER
fi
git checkout ${BRANCH}
git submodule init
git submodule update


# install loads of dependencies
sudo sh -c 'echo deb     http://apt.llvm.org/focal/ llvm-toolchain-focal main > /etc/apt/sources.list.d/llvm.list'
sudo sh -c 'echo deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main >> /etc/apt/sources.list.d/llvm.list'
sudo wget -O -    https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
sudo apt update && sudo apt upgrade -y

sudo apt install -y lld-11 llvm-11-dev llvm-11-runtime llvm-11 lldb-11 python3-lldb-11  \
   clang-11  clang-format-11 clang-tidy-11 clang-tools-11 python-clang  \
   libc++-11-dev libc++1-11 \
   libc++abi-11-dev libc++abi1-11  \
   libclang-11-dev libclang1-11 liblldb-11-dev libllvm-11-ocaml-dev libomp-11-dev libomp5-11  \
   libopencl-clang-dev libopencl-clang11 opencl-c-headers opencl-headers libclang-common-11-dev  \
   intltool cmake
if [ $? != "0" ]
then
    echo "Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libxml2-utils xsltproc libsaxon-java libpthread-workqueue0 libpthread-workqueue-dev  \
   libc6-dev libglib2.0-dev   \
   liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev  \
   libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev  \
   libexiv2-dev libpugixml-dev lua5.3 liblua5.3-0 liblua5.3-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev  \
   libgraphicsmagick1-dev imagemagick libmagick++-6.q16-dev libopenexr-dev libopenexr25 desktop-file-utils libgmic-dev
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


# build darktable
./build.sh --prefix ${INSTALL_PREFIX} | tee dt-build.log
if [ $? != "0" ]
then
    echo "Build failed, exiting"  && exit
fi


#install darktable
sudo cmake --build "$DT_SRC_FOLDER/build" --target install -- -j1
if [ $? != "0" ]
then
    echo "Installation failed, exiting"  && exit
fi

# print --version info
${INSTALL_PREFIX}/bin/darktable --version
