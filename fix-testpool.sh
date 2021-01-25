#!/bin/bash
set -e -o pipefail

./fix-zfs-file.sh /testpool/testfiles/Stripes.jpg testfiles/Stripes.jpg /tmp/testpool-disk1 4096