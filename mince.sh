#!/bin/bash
# gpg encrypt archive and split into chunks
# $1 specifies base directory or compressed archive to encrypt.
# $2 is the recipients public key, eg. 'myfriend@his.isp.net'
set -e

CHUNK_SIZE=1000000
SCRATCH_DIR=~/scratch_space
TAR_REGEX='\.tar'

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

#check parameters entered are valid
[ $# -ne 2 ] && usage "Two parameters are required." && exit 1
if [ ! -d "$1" ] && [[ ! $1 =~ $TAR_REGEX ]]; then
    usage "$1 is not a directory or tar/tar.gz/tar.bz2 archive."
    exit 1
fi

#if 1st parameter is a directory, then tar it up in the scratch space
if [ -d "$1" ]; then
    absolute="`cd $1; pwd` "
    mkdir -p $SCRATCH_DIR
    cd $SCRATCH_DIR
    tar -cf $1.tar $absolute
    arch="${SCRATCH_DIR}/${1}.tar"
    created=true
    echo "Created temporary archive $arch"
else
    arch="`readlink -f $1`"
    created=false
    echo "Working with archive $arch"
fi

#call for GPG encryption and compression of the archive
target="${arch##*/}.gpg"
cd $SCRATCH_DIR
gpg --bzip2-compress-level 6 --compress-algo bzip2 --output $target --encrypt --recipient $2 $arch

#split .gpg file into chunks of size CHUNK_SIZE
outdir="${SCRATCH_DIR}/output"
mkdir -p outdir
cd outdir
split -b $CHUNK_SIZE ../$target
for x in *
do
    mv $x "${1}__$x"
done

#clean up - remove .gpg and temporary archive
cd $SCRATCH_DIR
rm $target
if [ $created == true ]; then
    echo "Removing temporary archive $arch"
    rm $arch
fi

echo "All file splits produced placed in $outdir"
