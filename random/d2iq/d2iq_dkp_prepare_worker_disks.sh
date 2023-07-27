#!/bin/bash
##### intention of this script is to prepare the d2iq K8s worker node disk layouts
##### only tested on Ubuntu 20.04 so far
##### devices must not be already mounted!
##### includes some efforts to provide safety and prevent damage
##### still should be tested and reviewed properly before execution
##### RUN WITH ROOT PRIVILIGES

##### expected disk layout
#####    300 GB disks:
######## 8 x 12GB - /mnt/disks/100000{1-9}
######## 3 x 33GB - /mnt/disks/110000{1-3}
######## 1 x 104GB - /mnt/disks/1110001
######## 45GB Disk: unconfigured (for rook-ceph object storage)

function constants() {
    disk_size=300G
    raw_block_size=45G
}

# do we even need to run anymore?
function isVGalreadyPresent() {
    DKP_VG=$(vgdisplay | grep 'VG Name' | awk '{print $3}')
}

# devices must not be already mounted
function isAlreadyMounted() {
    RAW_BLK_DEVICE_MOUNT_PATH=$(lsblk | grep $raw_block_size | awk '{print $7}')
    BLK_DEVICE_MOUNT_PATH=$(lsblk | grep $disk_size | awk '{print $7}')
}

# add some safety in case there are multiple 300GB volumes
function countBlockDevices() {
    AMOUNT_BLOCK_DEVICES=$(lsblk | grep $disk_size | awk '{print $1}' | wc -l)
}

# assign block device
function assignBlockDevice() {
    BLK_DEVICE=$(lsblk | grep $disk_size | awk '{print $1}')
    echo $BLK_DEVICE is the block device to be partitioned
}

# assign raw block device
function assignRawBlockDevice() {
    RAW_BLK_DEVICE=$(lsblk | grep $raw_block_size | awk '{print $1}')
    echo $RAW_BLK_DEVICE is the block device to be partitioned
}

# partition block device
function partitionBlockDevice() {
    (echo o; echo n;echo p;echo 1;echo ; echo ;echo w;) | fdisk /dev/$BLK_DEVICE 
    sleep 2
}

# confirm partition device to carve
function assignPartDevice() {
    PART_DEVICE=${BLK_DEVICE}1
    echo $PART_DEVICE is the partitioned device
}

# install logical volume manager toolset 
# NOTE: not needed on Ubuntu systems # sudo yum install -y lvm2
# create physical volume & volume group 
function createPV() {
    pvcreate /dev/${PART_DEVICE} 
}

function createVG() {
    vgcreate dkp /dev/${PART_DEVICE}    
}

# create logical volumes
function createLV() {
    lvcreate -L 12G -n small001 dkp
    lvcreate -L 12G -n small002 dkp
    lvcreate -L 12G -n small003 dkp
    lvcreate -L 12G -n small004 dkp
    lvcreate -L 12G -n small005 dkp
    lvcreate -L 12G -n small006 dkp
    lvcreate -L 12G -n small007 dkp
    lvcreate -L 12G -n small008 dkp
    lvcreate -L 12G -n small009 dkp
    lvcreate -L 33G -n medium001 dkp
    lvcreate -L 33G -n medium002 dkp
    lvcreate -L 33G -n medium003 dkp
    lvcreate -L 104G -n large001 dkp
}

# create file systems for logical volumes
function makeFS() {
    mkfs -t xfs /dev/mapper/dkp-small001
    mkfs -t xfs /dev/mapper/dkp-small002
    mkfs -t xfs /dev/mapper/dkp-small003
    mkfs -t xfs /dev/mapper/dkp-small004
    mkfs -t xfs /dev/mapper/dkp-small005
    mkfs -t xfs /dev/mapper/dkp-small006
    mkfs -t xfs /dev/mapper/dkp-small007
    mkfs -t xfs /dev/mapper/dkp-small008
    mkfs -t xfs /dev/mapper/dkp-small009
    mkfs -t xfs /dev/mapper/dkp-medium001
    mkfs -t xfs /dev/mapper/dkp-medium002
    mkfs -t xfs /dev/mapper/dkp-medium003
    mkfs -t xfs /dev/mapper/dkp-large001
}

# create directories for logical volumes 
function createDir() {
    if [[ ! -e /mnt/disks ]]
    then
        mkdir -p /mnt/disks 
    fi

    for dir in 1000001 1000002 1000003 1000004 1000005 1000006 1000007 1000008 1000009 1100001 1100002 1100003 1110001
    do
        if [[ ! -e /mnt/disks/$dir ]]
        then
            echo "creating /mnt/disks/$dir"
            mkdir /mnt/disks/$dir
        else
            echo "/mnt/disks/$dir already exists"
        fi
    done
}

# mount logical volumes to their respective mount points
function mountLV() {
    mount -t xfs /dev/mapper/dkp-small001 /mnt/disks/1000001
    mount -t xfs /dev/mapper/dkp-small002 /mnt/disks/1000002
    mount -t xfs /dev/mapper/dkp-small003 /mnt/disks/1000003
    mount -t xfs /dev/mapper/dkp-small004 /mnt/disks/1000004
    mount -t xfs /dev/mapper/dkp-small005 /mnt/disks/1000005
    mount -t xfs /dev/mapper/dkp-small006 /mnt/disks/1000006
    mount -t xfs /dev/mapper/dkp-small007 /mnt/disks/1000007
    mount -t xfs /dev/mapper/dkp-small008 /mnt/disks/1000008
    mount -t xfs /dev/mapper/dkp-small009 /mnt/disks/1000009
    mount -t xfs /dev/mapper/dkp-medium001 /mnt/disks/1100001
    mount -t xfs /dev/mapper/dkp-medium002 /mnt/disks/1100002
    mount -t xfs /dev/mapper/dkp-medium003 /mnt/disks/1100003
    mount -t xfs /dev/mapper/dkp-large001 /mnt/disks/1110001
}

# confirm disk config
function printOutput() {
    df -h | grep /dev/mapper
}

function main() {
    constants

    # skip further processing if volume group already exists
    isVGalreadyPresent
    if [[ $DKP_VG == "dkp" ]]
    then
        echo 'seems like Volume group "dkp" already exists'
        echo "nothing to do here"
        exit 0
    fi

    # if there is more than one block device with a size of 300GB things will go wrong
    # this would require to manually define the block device name
    countBlockDevices
    if [[ $AMOUNT_BLOCK_DEVICES > 1 ]]
    then
        echo "more than one block device with a size of $disk_size found"
        echo "you need to more precisely define your block device"
        exit 0
    fi

    # check if 300 GB block device exists
    assignBlockDevice
    if [[ -z $BLK_DEVICE ]]
    then
        echo "no block device with a size of $disk_size found"
        exit 0
    fi

    # check if 45 GB block device exists
    assignRawBlockDevice
    if [[ -z $RAW_BLK_DEVICE ]]
    then
        echo "no block device with a size of $raw_block_size found"
        exit 0
    fi

    isAlreadyMounted
    if [[ ( -n $RAW_BLK_DEVICE_MOUNT_PATH ) || ( -n $BLK_DEVICE_MOUNT_PATH ) ]]
    then
        echo "one of the devices is already mounted - first unmount devices"
        exit 0
    fi

    # go ahead when all tests have been passed
    partitionBlockDevice
    assignPartDevice
    createPV
    createVG
    createLV
    makeFS
    createDir
    mountLV
    printOutput
}

main "$@"
