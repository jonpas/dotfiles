#!/bin/bash

ENABLE_PASSTHROUGH=true
ENABLE_QEMU_VGA=false
ENABLE_HUGEPAGES=false
MEMORY="8G"

rebind() {
    dev="$1"
    driver="$2"
    vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
    device=$(cat /sys/bus/pci/devices/$dev/device)

    # Unbind
    if [ -e /sys/bus/pci/devices/$dev/driver ]; then
        echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
    fi
    
    # Bind
    if [ "$driver" = "vfio-pci" ]; then
        echo $vendor $device > /sys/bus/pci/drivers/$driver/new_id
    else
        echo $dev > /sys/bus/pci/drivers/$driver/bind
    fi
}

# DEVICE PASSTHROUGH
if [ "$ENABLE_PASSTHROUGH" = true ]; then
    rebind 0000:01:00.0 vfio-pci # GPU
    rebind 0000:01:00.1 vfio-pci # GPU Audio
    rebind 0000:06:00.0 vfio-pci # PCIe USB Card
fi

if [ "$ENABLE_HUGEPAGES" = true ]; then
    echo 4200 > /proc/sys/vm/nr_hugepages
fi

# VM INITIALISATION
OPTS=""

#OPTS+=" -runas jonpas"

OPTS+=" -enable-kvm"
OPTS+=" -M q35"

OPTS+=" -cpu host,kvm=off,hv_vendor_id=0123456789ab"
OPTS+=" -smp 4,sockets=1,cores=4,threads=1"

OPTS+=" -m $MEMORY"
if [ "$ENABLE_HUGEPAGES" = true ]; then
    OPTS+=" -mem-path /dev/hugepages_qemu"
fi

OPTS+=" -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd"
OPTS+=" -drive if=pflash,format=raw,file=/home/jonpas/images/vm/OVMF_VARS-win10-ovmf.fd"

OPTS+=" -device virtio-scsi-pci"
OPTS+=" -drive file=/home/jonpas/images/vm/win10-ovmf.qcow2,format=qcow2,index=0,media=disk,if=virtio"
OPTS+=" -drive file=/home/jonpas/Data/images/vm/data.qcow2,format=qcow2,index=1,media=disk,if=virtio"
OPTS+=" -drive file=/home/jonpas/Data/images/windows10.iso,index=2,media=cdrom"
OPTS+=" -drive file=/home/jonpas/Data/images/virtio-win.iso,index=3,media=cdrom"

OPTS+=" -net none"
OPTS+=" -net nic"
OPTS+=" -net user"
#OPTS+=" -net user,smb=/home/jonpas/Storage/"

if [ "$ENABLE_PASSTHROUGH" = true ]; then
    OPTS+=" -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1"
    OPTS+=" -device vfio-pci,host=01:00.0,bus=root.1,addr=00.0,multifunction=on,x-vga=on"
    OPTS+=" -device vfio-pci,host=01:00.1,bus=root.1,addr=00.1"

    OPTS+=" -device vfio-pci,host=06:00.0,bus=root.1"
fi

if [ "$ENABLE_QEMU_VGA" = false ]; then
    OPTS+=" -vga none"
fi

OPTS+=" -soundhw ac97"

qemu-system-x86_64 $OPTS

if [ "$ENABLE_HUGEPAGES" = true ]; then
    echo 50 > /proc/sys/vm/nr_hugepages
fi

if [ "$ENABLE_PASSTHROUGH" = true ]; then
    rebind 0000:06:00.0 xhci_hcd
fi

exit 0
