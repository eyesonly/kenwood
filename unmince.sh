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
    echo " file$REGEX is the first file produced by the mince script"
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
indir="${SCRATCH_DIR}/reconstituted"
mkdir -p $indir
cd $indir
[ -e $indir/combined.gpg ] && rm $indir/combined.gpg
for x in $pathonly/$basenam*
do
    cat $x >> combined.gpg
done

#decrypt the .gpg file
echo "Commencing GPG decryption, please be patient"
gpg --output $basenam --decrypt combined.gpg

#tidy up - remove the gpg file
rm combined.gpg

echo "The reconstituted archive $indir/$basenam was created"
