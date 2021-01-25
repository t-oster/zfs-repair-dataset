This is a proof-of-concept. Please do not use if you not fully understand the source or are very desperate.

The aim of this project is to create a tool as suggested in the follwing articles:

 - https://github.com/openzfs/zfs/issues/7912
 - https://serverfault.com/questions/658819/zfs-recover-or-repair-a-corrupted-file-in-a-snapshot-from-backup
 - https://www.illumos.org/issues/2021

If you have a non-redundant zpool with data-errors and a healthy backup of the corrupted files, this tool
can overwrite the corrupt data on disk and thus fix the errors.

Right now we have the following limitations:
 - Pool must be a single vdev (stripe may work, need testing. Could be adapted to mirrors?)
 - The file in question must be on an uncompressed dataset

Demo:    
    sudo ./create-testpool.sh
    sudo ./corrupt-testpool.sh
    sudo ./fix-testpool.sh
    sudo ./destroy-testpool.sh

Usage:
    sudo ./fix-zfs-file.sh <path to broken file> <path to healthy file> <path to raw-device> <blocksize>