#!/bin/bash
set -e -o pipefail
. functions.sh

#TESTFILE=longtext.txt
TESTFILE=Stripes.jpg
POOLNAME=testpool
BLOCKSIZE=4096
DUMMYDISK=/tmp/testpool-disk1
POOLNAME=testpool

echo "getting address of $TESTFILE"
ABSPATH="/$POOLNAME/testfiles/$TESTFILE"
for VDA in `get_data_blocks "$ABSPATH"`; do
    FIRSTBLOCK="$VDA"
    echo "First VDA: $FIRSTBLOCK"
    START=`echo $FIRSTBLOCK|cut -d':' -f2`
    LENGTH=`echo $FIRSTBLOCK|cut -d':' -f3|cut -d'=' -f1`
    START=$((16#$START))
    LENGTH=$((16#$LENGTH))

    echo "First block starting at $START and length $LENGTH of $DUMMYDISK"
    RAWSTART=$((START+LABELOFFSET))
    echo "Start + labeloffset = $RAWSTART"
    STARTBLOCK=$((RAWSTART/BLOCKSIZE))

    #echo "reading first block"
    #dd if=$DUMMYDISK of=/tmp/tt skip=$STARTBLOCK bs=$BLOCKSIZE count=1
    #echo "result:"
    #cat /tmp/tt

    echo "corrupting the first block"
    dd conv=notrunc if=/dev/zero of=$DUMMYDISK seek=$STARTBLOCK bs=$BLOCKSIZE count=1
    break
done

echo "re-importing pool to clear cache"
zpool export testpool
zpool import testpool -d $DUMMYDISK

echo "trying to open the file, should give an error"
cat "$ABSPATH" > /dev/null || true
echo "confirm:"
zpool status $POOLNAME -v

