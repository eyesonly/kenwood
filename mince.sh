#!/bin/bash
# gpg encrypt archive and split into chunks
# $1 specifies base directory or compressed archive to encrypt.
# $2 is the recipients public key, eg. 'myfriend@his.isp.net'
set -e

CHUNK_SIZE=1000000
SCRATCH_DIR=~/scratch_space
TAR_REGEX='*tar*'

usage() {
echo "ERROR: "
echo " $*"
echo "USAGE: "
echo " mince.sh DIRECTORY/ARCHIVE PUBLIC_KEY_NAME"
echo "EXAMPLE: "
echo " ./mince.sh directory 'myfriend@her.isp.net'"
echo "FURTHER COMMENTS: "
echo " if an ARCHIVE is supplied instead of a directory, it must have a name like file.tar or file.tar.gz or file.tar.bz2 "
}

# find_files() {
# find . -type f ! -name "*.pgp" ! -name .DS_Store ! -name "*.gpg" ! -name "*.sda.exe"
# }

[[ $1 =~ $TAR_REGEX ]] && echo "matches!"
[[ ! $1 =~ $TAR_REGEX ]] && echo "does not match"

#check parameters entered are valid
[ $# -ne 1 ] && usage "Missing required directory or archive argument." && exit 1
 if [ ! -d "$1" ] && [[ ! $1 =~ $TAR_REGEX ]]; then
  usage "$1 is not a directory or tar/tar.gz/tar.bz2 archive."
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
target="${SCRATCH_DIR}/${1}.gpg"
gpg --encrypt --recipient 'myfriend@his.isp.net' foo.txt


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