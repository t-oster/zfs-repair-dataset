#!/bin/bash
set -e -o pipefail
. functions.sh

POOLNAME=testpool
FILESYSTEM=/
DUMMYDISK=/tmp/testpool-disk1
BLOCKSIZE=4096
POOLSIZE=$((64*1042*1024))
POOLSIZE_IN_BLOCKS=$((POOLSIZE/BLOCKSIZE))



echo "creating dummy disk $DUMMYDISK"
dd of="$DUMMYDISK" if=/dev/zero bs=$BLOCKSIZE count=$POOLSIZE_IN_BLOCKS
echo "creating pool $POOLNAME"
zpool create -o ashift=12 $POOLNAME $DUMMYDISK
zpool status $POOLNAME

echo "copying testfiles"
cp -r testfiles "/$POOLNAME/"