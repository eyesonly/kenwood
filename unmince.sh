#!/bin/bash
# reassemble an archive from chunks of a file that have been gpg-encrypted
# $1 specifies the first file produced from the mincing process, eg, file__xaa
set -e

SCRATCH_DIR=~/scratch_space
REGEX='__xaa'

usage() {
    echo "ERROR: "
    echo " $*"
    echo "USAGE: "
    echo " unmince.sh file$REGEX"
    echo "WHERE: "
    echo " file$$REGEX is the first file produced by the mince script"
}

#check parameters
[ $# -ne 1 ] && usage "Only one parameter is required" && exit 1
if [ -d "$1" ] || [[ ! $1 =~ '_xaa' ]]; then
    usage "$1 cannot be a directory and must end in _xaa."
    exit 1
fi


#combine all chunks of the file
sourcepath="`readlink -f $1`"
pathonly="`dirname $sourcepath`"

just=${sourcepath##*/}
basenam=${just%$REGEX}

indir="${SCRATCH_DIR}/input"
mkdir -p $indir
cd $indir
[ -e $indir/combined.gpg ] && rm $indir/combined.gpg
for x in $pathonly/$basenam*
do
  cat $x >> combined.gpg
done

#decrypt the .gpg file
gpg  --decrypt combined.gpg


#> combined.gpg
#echo "basename is $basenam"

# if [ ! -d "$1" ] && [[ ! $1 =~ $TAR_REGEX ]]; then
#     usage "$1 is not a directory or tar/tar.gz/tar.bz2 archive."
#     exit 1
# fi

# #if 1st parameter is a directory, then tar it up in the scratch space
# if [ -d "$1" ]; then
#     absolute="`cd $1; pwd` "
#     mkdir -p $SCRATCH_DIR
#     cd $SCRATCH_DIR
#     tar -cf $1.tar $absolute
#     arch="${SCRATCH_DIR}/${1}.tar"
#     created=true
#     echo "Created temporary archive $arch"
# else
#     arch="`readlink -f $1`"
#     created=false
#     echo "Working with existing archive $arch"
# fi

# #call for GPG encryption and compression of the archive
# target="${arch##*/}.gpg"
# cd $SCRATCH_DIR
# gpg --bzip2-compress-level 6 --compress-algo bzip2 --output $target --encrypt --recipient $2 $arch

# #split .gpg file into chunks of size CHUNK_SIZE
# outdir="${SCRATCH_DIR}/output"
# mkdir -p outdir
# cd outdir
# split -b $CHUNK_SIZE ../$target
# for x in *
# do
#     mv $x "${1}__$x"
# done

# #clean up - remove .gpg and temporary archive
# cd $SCRATCH_DIR
# rm $target
# if [ $created == true ]; then
#     echo "Removing temporary archive $arch"
#     rm $arch
# fi

# echo "All file splits produced placed in $outdir"
