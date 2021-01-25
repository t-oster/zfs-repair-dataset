set -e
LABELOFFSET=$((0x400000))

#returns the zfs filesystem of a file
function get_filesystem {
    pushd `dirname $1` > /dev/null
    result=`df . |tail -n +2|cut -f1 -d' '`
    popd > /dev/null
    echo $result
}

# returns a list of VDA+checksum of the data blocks (device:start:length=checksum)
function get_data_blocks {
    INODE=`ls -i "$1"|cut -d' ' -f1`
    FILESYSTEM=`get_filesystem "$1"`
    #echo "$1 is on filesyste $FILESYSTEM inode $INODE"
    zdb -dddddd $FILESYSTEM/ $INODE|awk '{if ($2 == "L0") print $3$7}'|sed 's/cksum//'
}
