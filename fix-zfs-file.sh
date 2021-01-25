#!/bin/bash
set -e -o pipefail
. functions.sh

if [ "$1" == "" -o "$2" == "" ]; then
    echo "usage: $0 <absolute path to broken file> <path to backup file> <path to zfs raw device> <blocksize>"
    exit 1
fi
if [ "$3" == "" -o "$4" == "" ]; then
    echo "usage: $0 <absolute path to broken file> <path to backup file> <path to zfs raw device> <blocksize>"
    exit 1
fi

#TODO get the raw zfs device automatically

ABSPATH="$1"
BACKUPFILE="$2"
RAWDEVICE="$3"
BLOCKSIZE="$4"
FILESYSTEM=`get_filesystem "$ABSPATH"`

OFFSET_IN_BLOCKS=0
for VDA in `get_data_blocks "$ABSPATH"`; do
    echo "Processing data block $VDA"
    START=`echo $VDA|cut -d':' -f2`
    LENGTH=`echo $VDA|cut -d':' -f3|cut -d'=' -f1`
    START=$((16#$START))
    LENGTH=$((16#$LENGTH))

    echo "First block starting at $START and length $LENGTH of $RAWDEVICE"
    RAWSTART=$((START+LABELOFFSET))
    echo "Start + labeloffset = $RAWSTART"
    STARTBLOCK=$((RAWSTART/BLOCKSIZE))
    BLOCKS=$((LENGTH/BLOCKSIZE))

    #TODO: if the checksum is correct, skip block
    #TODO: calculate checksum of backup file block and bail out if it doesnt match

    echo "overwriting $BLOCKS blocks from $BACKUPFILE"
    dd if="$BACKUPFILE" of="$RAWDEVICE" bs="$BLOCKSIZE" count="$BLOCKS" skip="$OFFSET_IN_BLOCKS" seek="$STARTBLOCK" conv=notrunc
    OFFSET_IN_BLOCKS=$((OFFSET_IN_BLOCKS+BLOCKS))
done

echo "trying to read file now:"
cat "$ABSPATH" > /dev/null
echo "you should now scrub the pool and zpool clear the errors"