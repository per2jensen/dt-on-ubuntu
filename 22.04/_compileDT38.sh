LOG="$HOME/DT38.log"

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

sudo apt install -y lld-13 llvm-13-dev llvm-13-runtime llvm-13 lldb-13 python3-lldb-13  \
   clang-13  clang-format-13 clang-tidy-13 clang-tools-13 python3-clang-13  \
   libc++-13-dev libc++1-13 \
   libc++abi-13-dev libc++abi1-13  \
   libclang-13-dev libclang1-13 liblldb-13-dev libllvm-13-ocaml-dev libomp-13-dev libomp5-13  \
   libopencl-clang-dev libopencl-clang12 opencl-c-headers opencl-headers libclang-common-13-dev nvidia-opencl-dev ocl-icd-opencl-dev \
   intltool cmake
if [ $? != "0" ]
then
    echo "1: Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libxml2-utils xsltproc libsaxon-java libpthread-workqueue0 libpthread-workqueue-dev  \
   libc6-dev libglib2.0-dev   \
   liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev  \
   libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev  \
   libexiv2-dev libpugixml-dev lua5.4 liblua5.4-0 liblua5.4-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev  \
   libgraphicsmagick1-dev imagemagick libmagick++-6.q16-dev libopenexr-dev libopenexr25 desktop-file-utils libgmic-dev
if [ $? != "0" ]
then
    echo "2: Package installation failed, exiting"  && exit
fi 

sudo apt install -y  libflickcurl-dev libraptor2-dev libopenjp2-7-dev libopenjp2-7 libosmgpsmap-1.0-dev libosmgpsmap-1.0-1  \
   libcolord-gtk-dev libcolord-gtk1 libcups2-dev libcups2  \
   libavif-bin libavif-dev libavif-gdk-pixbuf  \
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


# libexiv2 v 0.27.5:  https://build.opensuse.org/package/show/graphics:darktable:master/exiv2-non-suse


# get the source ready
if [[ -d $DT_SRC_FOLDER  ]]; then
  echo "darktable dir exists"
  cd $DT_SRC_FOLDER
  git pull --rebase
  RESULT=$?
  if [[ $RESULT != "0" ]]; then
    echo \"git pull --rebase\" failed, exiting
    exit 1
  fi
else
  git clone https://github.com/darktable-org/darktable.git $DT_SRC_FOLDER
  RESULT=$?
  if [[ $RESULT != "0" ]]; then
    echo \"git clone\" failed, exiting
    exit 1
  fi
  cd $DT_SRC_FOLDER
fi
git checkout ${RELEASE}  |tee -a $LOG
git submodule init  |tee -a $LOG
git submodule update  |tee -a $LOG


# build darktable
mv ${INSTALL_PREFIX} ${INSTALL_PREFIX}-org
./build.sh --prefix ${INSTALL_PREFIX} |tee -a $LOG
if [ "${PIPESTATUS[0]}" != "0" ]
then
    echo "Build failed, exiting"  && exit
fi


#install darktable
sudo cmake --build "$DT_SRC_FOLDER/build" --target install -- -j1   |tee -a $LOG
if [ "${PIPESTATUS[0]}" != "0" ]
then
    echo "Installation failed, exiting"  && exit
fi

# print --version info
${INSTALL_PREFIX}/bin/darktable --version  |tee -a $LOG
