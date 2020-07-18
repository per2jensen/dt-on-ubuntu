##
## Author: Per Jensen
## Contact: per2jensen@gmail.com
## Licensed under the Apache License 2.0
##

# Change this if you want to run the compile script directly on your machine
INSTALL_PREFIX=~/darktable

##############################33
##  Master
################################

mkdir -p ~/git
cd ~/git
git clone git://github.com/darktable-org/darktable.git
cd darktable
git checkout master
git submodule init
git submodule update



sudo echo deb http://apt.llvm.org/eoan/ llvm-toolchain-eoan main > /etc/apt/sources.list.d/llvm.list
sudo echo deb-src http://apt.llvm.org/eoan/ llvm-toolchain-eoan main >> /etc/apt/sources.list.d/llvm.list
sudo wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421
sudo apt update

sudo apt install -y python3-lldb-10
sudo apt install -y lld-10 llvm-dev-10 llvm-runtime-10 llvm-10 python-clang-10 lldb-10
sudo apt install -y clang-format-10 clang-tidy-10 clang-tools-10 clang-10 libc++-10-dev libc++1-10 libc++abi-10-dev libc++abi1-10
sudo apt install -y libclang-10-dev libclang1-10 liblldb-10-dev libllvm-10-ocaml-dev libomp-10-dev libomp5-10
sudo apt install -y intltool cmake
sudo apt install -y xsltproc libsaxon-java python-jsonschema  libpthread-workqueue0 libpthread-workqueue-dev

sudo apt install -y libc6-dev libglib2.0-dev 
sudo apt install -y liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev
sudo apt install -y libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev
sudo apt install -y libexiv2-dev libpugixml-dev lua5.3 liblua5.3-0   liblua5.3-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev
sudo apt install -y libgraphicsmagick1-dev imagemagick libopenexr-dev libopenexr24   desktop-file-utils 
sudo apt install -y libxml2-utils libflickcurl-dev libopenjp2-7-dev libopenjp2-7 libosmgpsmap-1.0-dev libosmgpsmap-1.0-1
sudo apt install -y libcolord-gtk-dev libcolord-gtk1 libcups2-dev libcups2
sudo apt install -y libsecret-1-dev libsecret-1-0 
sudo apt install -y libimage-exiftool-perl xlstproc

./build.sh --prefix ${INSTALL_PREFIX}

if [ $? != "0" ]
then
    echo "Configuration failed, exiting"  && exit
fi

cmake --build "~/git/darktable/build" --target install -- -j1

${INSTALL_PREFIX}/bin/darktable --version


