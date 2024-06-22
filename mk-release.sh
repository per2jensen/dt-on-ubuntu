#! /bin/bash
#
# Make release tar file
#
# This is for DT421
#
# $1 is the tag to package

if [ -z "${1}" ]; then echo "tag not given, exiting"; exit; fi
echo tag to create release from: \""$1"\"

TAG=$(grep -E -o "^DT[0-9]{3}-[0-9]{4}$" <<< "$1")
if [[ "$TAG" == "" ]]; then
    echo "TAG \"$1\" does not match required tag patten, exiting"
    exit 1
fi

DIR="/tmp/dt-on-ubuntu"
TARFILE="dt-on-ubuntu-${1}.tar.gz"

if [[ -e "$DIR" ]]; then rm -fr "$DIR" || exit 1; fi
if [[ -f "/tmp/$TARFILE" ]]; then rm "/tmp/$TARFILE" || exit 1; fi

cd /tmp || exit 1
git clone https://github.com/per2jensen/dt-on-ubuntu.git || exit 1
#git clone ~/git/dt-on-ubuntu || exit 1
cd dt-on-ubuntu || exit 1

git  checkout "tags/$1" -b "release-$1" || exit 1
rm -fr "$DIR/.git"
rm -fr "$DIR/.github"
rm -fr "$DIR/19.10"
rm -fr "$DIR/20.04"
rm -fr "$DIR/21.04"
rm -fr "$DIR/21.10"
rm -fr "$DIR/22.04"
rm -fr "$DIR/22.04"
rm -fr "$DIR/23.04"
rm -fr "$DIR/23.10"
rm -fr "$DIR/24.04/DT46"

rm mk-release.sh

echo "This package is built from tag: $1" > VERSION
cd $DIR/.. || exit 1
tar czvf "$TARFILE" dt-on-ubuntu
if [[ "$?" != "0" ]]; then
  echo "tar ops failed, exiting"
  exit 1
fi

echo SHA256:
sha256sum "$TARFILE"
if [[ "$?" != "0" ]]; then
  echo "sha256  ops failed, exiting"
  exit 1
fi

echo "SUCCESS: a release tarball from tag: \"$TAG\" was produced"
