INSTALL_PREFIX_DEFAULT=~/darktable

mkdir -p ~/git
cd ~/git
git clone git://github.com/darktable-org/darktable.git
cd darktable
git checkout tags/release-3.0.0
git submodule init
git submodule update



sudo echo deb http://apt.llvm.org/eoan/ llvm-toolchain-eoan main > /etc/apt/sources.list.d/llvm.list
sudo echo deb-src http://apt.llvm.org/eoan/ llvm-toolchain-eoan main >> /etc/apt/sources.list.d/llvm.list
sudo wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421
sudo apt-get update

sudo apt-get install -y python-lldb-10 --fix-broken
sudo apt-get install -y lld llvm-dev llvm-runtime llvm python-clang lldb
sudo apt-get install -y clang-format clang-tidy clang-tools clang clangd libc++-dev libc++1 libc++abi-dev libc++abi1
sudo apt-get install -y libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5
sudo apt-get install -y intltool cmake
sudo apt-get install -y xsltproc libsaxon-java python-jsonschema  libpthread-workqueue0 libpthread-workqueue-dev

sudo apt-get install -y libc6-dev libglib2.0-dev 
sudo apt-get install -y liblensfun-dev libcurl4-openssl-dev libjpeg8-dev libtiff-dev liblcms2-dev libjson-glib-dev
sudo apt-get install -y libgtk-3-0 libgtk-3-dev libxml2-dev libxml2 librsvg2-2 librsvg2-dev libsqlite3-dev
sudo apt-get install -y libexiv2-dev libpugixml-dev lua5.3 liblua5.3-0   liblua5.3-dev libgphoto2-6 libgphoto2-dev colord libcolord-dev
sudo apt-get install -y libgraphicsmagick1-dev imagemagick libopenexr-dev libopenexr23   desktop-file-utils 
sudo apt-get install -y libxml2-utils libflickcurl-dev libopenjp2-7-dev libopenjp2-7 libosmgpsmap-1.0-dev libosmgpsmap-1.0-1
sudo apt-get install -y libcolord-gtk-dev libcolord-gtk1 libcups2-dev libcups2
sudo apt-get install -y libsecret-1-dev libsecret-1-0 

./build.sh --prefix ${INSTALL_PREFIX_DEFAULT}

cmake --build "~/git/darktable/build" --target install -- -j1

${INSTALL_PREFIX_DEFAULT}/bin/darktable --version


