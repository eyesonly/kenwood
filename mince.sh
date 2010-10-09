#!/bin/sh
# encrypt.sh
# gpg encrypt archive and chunk
# $1 specifies base directory or compressed archive to encrypt.
# some code was inspired by http://elalonde.blogspot.com/2009/02/from-pgp-to-free-transitioning-from-pgp.html

set -e

CHUNK_SIZE=1000000
SCRATCH_DIR=~/scratch_space

usage() {
echo "ERROR: $*"
echo "usage: "
echo " mince.sh DIRECTORY or FILE.tar.gz or FILE.tar.b2"
}

# find_files() {
# find . -type f ! -name "*.pgp" ! -name .DS_Store ! -name "*.gpg" ! -name "*.sda.exe"
# }

[ $# -ne 1 ] && usage "Missing required directory argument." && exit
[ ! -d "$1" ] && usage "$1 is not a directory." && exit

# cd "$1"

# find_files | while read file ; do
# [ -e "$file.gpg" ] && rm -f "$file.gpg"
# echo "Encrypting: $file"
# gpg -u user@domain.ext -r user@domain.ext --sign --encrypt "$file"
# echo " Created: $file.gpg"
# echo " Removing: $file"
# rm -f "$file"
# done