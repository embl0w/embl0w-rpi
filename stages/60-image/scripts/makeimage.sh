#!/bin/bash

DISKIMAGE=${1-disk.img}
DISKSIZE=${2-1024}
PARTSIZE=${3-256}
shift 3

truncate -s ${DISKSIZE}M $DISKIMAGE

sfdisk $DISKIMAGE <<EOF
label: dos
size=${PARTSIZE}M,type=0x0c,bootable
EOF

mformat -i $DISKIMAGE@@1M -t $PARTSIZE -h 64 -s 32 -F ::
