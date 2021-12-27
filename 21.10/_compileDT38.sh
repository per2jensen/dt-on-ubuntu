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
   clang-12  clang-format-12 clang-tidy-12 clang-tools-12 python-clang  \
   libc++-12-dev libc++1-12 \
   libc++abi-12-dev libc++abi1-12  \
   libclang-12-dev libclang1-12 liblldb-12-dev libllvm-12-ocaml-dev libomp-12-dev libomp5-12  \
   libopencl-clang-dev libopencl-clang12 opencl-c-headers opencl-headers libclang-common-12-dev nvidia-opencl-dev ocl-icd-opencl-dev \
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
   libavif-bin libavif-dev libavif-gdk-pixbuf  \
   libsecret-1-dev libsecret-1-0   \
   libimage-exiftool-perl liblua5.4-0 liblua5.4-dev

if [ $? != "0" ]
then
    echo "Package installation failed, exiting"  && exit
fi 


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
git checkout ${RELEASE}
git submodule init
git submodule update



# build darktable
sudo ./build.sh --clean-all
./build.sh --prefix ${INSTALL_PREFIX}  | tee dt-build.log
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
