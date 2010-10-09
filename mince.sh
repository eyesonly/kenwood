#!/bin/bash
# mince.sh
# gpg encrypt archive and split into chunk
# $1 specifies base directory or compressed archive to encrypt.

set -e

CHUNK_SIZE=1000000
SCRATCH_DIR=~/scratch_space
TARGZ_REGEX='*.tar.gz'
TARBZ_REGEX='*.tar.bz2'

usage() {
echo "ERROR: $*"
echo "usage: "
echo " mince.sh DIRECTORY   or    "
echo " mince.sh FILE.tar[.gz|bz2] "
}

# find_files() {
# find . -type f ! -name "*.pgp" ! -name .DS_Store ! -name "*.gpg" ! -name "*.sda.exe"
# }

#check parameters entered are valid
[ $# -ne 1 ] && usage "Missing required directory or archive argument." && exit 1
 if [ ! -d "$1" ] && [[ ! $1 =~ $TARGZ_REGEX ]] && [[ ! $1 =~ $TARBZ_REGEX ]]; then
  usage "$1 is not a directory or tar.gz/bz2 archive."
  exit 1
 fi

#if it is a directory, then tar it up in the scratch space
if [ -d "$1" ]; then
    absolute="`cd $1; pwd` "
    mkdir -p $SCRATCH_DIR
    cd $SCRATCH_DIR
    tar -cf $1.tar $absolute
    arch="${SCRATCH_DIR}/${1}.tar"
    created=true
    echo "Created temporary archive $arch"
else
  arch=$1
  created=false
  echo "Working with archive $arch"
fi

#call for GPG encryption and compression of the archive


echo "State of created flag: $created"

# cd "$1"

# find_files | while read file ; do
# [ -e "$file.gpg" ] && rm -f "$file.gpg"
# echo "Encrypting: $file"
# gpg -u user@domain.ext -r user@domain.ext --sign --encrypt "$file"
# echo " Created: $file.gpg"
# echo " Removing: $file"
# rm -f "$file"
# done