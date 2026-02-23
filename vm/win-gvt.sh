#!/bin/bash

# Arguments
ENABLE_GVT_GPU=true
ENABLE_QEMU_GPU=true # Integrated QEMU GPU
ENABLE_HUGEPAGES=true
ENABLE_NESTED_VIRT=false
WIN11_INSTALL=false
LG_SPICE_UNIX_SOCKET=true
LG_KVMFR_DEVICE=true
MEMORY="16"

GVT_PCI=0000:00:02.0
GVT_GUID=d12b8bbb-0fd9-4706-9548-90ca2c7055d3
GVT_MDEV_TYPE="i915-GVTg_V5_2"

smbios() {
    dmi_string="$1"
    dmi_value=$(dmidecode -s "$dmi_string")
    echo ${dmi_value//,/,,} # Escape comma
}

mdev() {
    mode="$1"
    mdev=$(dirname "$0")/mdev.sh

    if [ "$mode" = "create" ]; then
        $mdev $GVT_PCI $GVT_GUID $GVT_MDEV_TYPE
    elif [ "$mode" = "remove" ]; then
        $mdev $GVT_PCI $GVT_GUID
    else
        echo "Unknown GVT-g operation!"
    fi
}

usage() {
    echo "Windows VM Start script."
    echo "[-h] help"
    echo "[-d <true/false>] use GVT-g GPU ($ENABLE_GVT_GPU)"
    echo "[-n <true/false>] nested virtualization ($ENABLE_NESTED_VIRT)"
    echo "[-p <true/false>] use huge pages ($ENABLE_HUGEPAGES)"
    echo "[-m <gigabytes>] memory ($MEMORY)"
    echo "[-r <create/remove>] manage GVT-g"
    exit 1
}

while getopts 'hd:p:n:m:g:r' flag; do
    case "${flag}" in
        h) usage ;;
        d) ENABLE_GVT_GPU=${OPTARG} ;;
        p) ENABLE_HUGEPAGES=${OPTARG} ;;
        n) ENABLE_NESTED_VIRT=${OPTARG} ;;
        m) MEMORY=${OPTARG} ;;
        r) mdev $2; exit 1 ;;
        *) usage ;;
    esac
done

echo "TPM & Secure Boot: $WIN11_INSTALL"
echo "GVT-g GPU: $ENABLE_GVT_GPU"
echo "QEMU GPU: $ENABLE_QEMU_GPU"
echo "Nested Virtualization: $ENABLE_NESTED_VIRT"
echo "Huge-pages: $ENABLE_HUGEPAGES"
echo "Memory: ${MEMORY}G"
echo "LG Spice Unix Socket: $LG_SPICE_UNIX_SOCKET"
echo "LG KVMFR Device: $LG_KVMFR_DEVICE"


# VM INIT
OPTS=(-enable-kvm)

#OPTS+=(-runas $(whoami))

# Load kernel modules
modprobe kvmgt vfio_iommu_type1 mdev

# General
# `bcdedit.exe /set useplatformclock true` enables HPET timer in Windows and introduces stuttering (most noticable with mouse input over barrier)
# keep HPET enabled in QEMU, otherwise we get high idle CPU usage [does not drop clocks] (but disabled in Windows for above reason)
OPTS+=(-machine type=q35,kernel_irqchip=on,hpet=on) # 'kernel_irqchip=on' for qemu >=4.0
# Windows uses localtime by default, set UTC: reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
OPTS+=(-rtc driftfix=slew)

# CPU (Hyper-V Englightenments https://www.qemu.org/docs/master/system/i386/hyperv.html)
[[ "$ENABLE_NESTED_VIRT" = true ]] && nested=on || nested=off  # WSL2, Docker, etc.

# x2apic only sensible on VM with 255+ vCPUs, hv_stimer_direct causes boot freeze
OPTS+=(-cpu host,migratable=off,+invtsc,topoext,svm=$nested,x2apic=off,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vpindex,hv_runtime,hv_time,hv_synic,hv_stimer,hv_tlbflush,hv_ipi,hv_frequencies,hv_avic)
OPTS+=(-smp 4,sockets=1,cores=2,threads=2)

OPTS+=(-global kvm-pit.lost_tick_policy=discard) # required for AVIC (kernel 6.0)

# SMBIOS / DMI (decrease VM detection chance)
OPTS+=(-smbios type=0,vendor="$(smbios bios-vendor)",date="$(smbios bios-release-date)",version="$(smbios bios-version)") # 0=BIOS
OPTS+=(-smbios type=1,manufacturer="$(smbios system-manufacturer)",product="$(smbios system-product-name)",version="$(smbios system-version)",uuid="$(smbios system-uuid)",sku="$(smbios system-sku-number)",family="$(smbios system-family)") # 1=System
OPTS+=(-smbios type=2,manufacturer="$(smbios baseboard-manufacturer)",product="$(smbios baseboard-product-name)",version="$(smbios baseboard-version)") # 2=Baseboard

# RAM
OPTS+=(-m ${MEMORY}G)
if [ "$ENABLE_HUGEPAGES" = true ]; then
    # Clear cached memory to allow reserving
    sync # Save cached data to disk
    echo 3 > /proc/sys/vm/drop_caches # Drop all caches to free reserved memory
    echo 1 > /proc/sys/vm/compact_memory # Compact into contingous blocks

    # Make sure we can allocate enough memory
    if [ $(free --giga | awk '/Mem:/ { print $4 }') -le $MEMORY ]; then
        echo "[ERROR] Not enough free memory!"
        exit 2
    fi

    # 8192 2MB pages = 16GB
    # 16384 2MB pages = 32GB
    hugepages=$(( ${MEMORY} * 1024 / 2 ))
    echo "Huge Pages: ${hugepages}"
    echo $hugepages > /proc/sys/vm/nr_hugepages
    OPTS+=(-mem-path /dev/hugepages)
    OPTS+=(-mem-prealloc)
fi

# UEFI/BIOS
if [ "$WIN11_INSTALL" = true ]; then
    # Win11 requires Secure Boot for installation (available, not enabled)
    OPTS+=(-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.4m.fd)
else
    OPTS+=(-drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.4m.fd)
fi
OPTS+=(-drive if=pflash,format=raw,file=/home/jonpas/images/vm/OVMF_VARS-win-ovmf.4m.fd)

# Drives
OPTS+=(-device virtio-scsi-pci,id=scsi0)

# Create image: qemu-img create -f raw name.img 10G -o preallocation=full (-o cluster_size=16K for qcow2)
# Convert qcow2 to raw: qemu-img convert -p -O raw source.qcow2 target.img -o preallocation=full
# Resize image: qemu-img resize -f raw --preallocation=full source.img +5G
OPTS+=(-drive file=/home/jonpas/images/vm/win-virt.img,format=raw,index=0,media=disk,if=none,aio=io_uring,cache=none,id=drive0)
OPTS+=(-device scsi-hd,drive=drive0,bus=scsi0.0,rotation_rate=1,bootindex=1)

OPTS+=(-drive file=/home/jonpas/images/windows.iso,index=3,media=cdrom)
OPTS+=(-drive file=/home/jonpas/images/virtio-win.iso,index=4,media=cdrom)

# Install VirtIO driver if uninstalled (eg. Windows Update on bare metal)
# Source: https://superuser.com/questions/1057959/windows-10-in-kvm-change-boot-disk-to-virtio/1200899#1200899
# wmic logicaldisk get deviceid, volumename, description
# (not needed) drvload v:\vioscsi\w11\amd64\vioscsi.inf
# dism /image:c:\ /add-driver /driver:v:\vioscsi\w11\amd64\vioscsi.inf

# Network
OPTS+=(-nic user,model=virtio,smb=/home/jonpas/Downloads/)
#OPTS+=(-nic bridge,model=virtio,br=virbr0,mac=52:54:00:12:34:57)

# TPM (Win11 requires TPM 2.0 for installation)
if [ "$WIN11_INSTALL" = true ]; then
    OPTS+=(-chardev socket,id=chrtpm,path=/tmp/qemu-tpm0/swtpm.sock)
    OPTS+=(-tpmdev emulator,id=tpm0,chardev=chrtpm)
    OPTS+=(-device tpm-tis,tpmdev=tpm0)

    if [ ! -S /tmp/qemu-tpm0/swtpm.sock ]; then
        mkdir -p /tmp/qemu-tpm0
        swtpm socket --tpm2 --tpmstate dir=/tmp/qemu-tpm0 \
            --ctrl type=unixio,path=/tmp/qemu-tpm0/swtpm.sock \
            --daemon
    fi
fi

# GPU
if [ "$ENABLE_GVT_GPU" = true ]; then
    mdev create

    # pcie-root-port does not function well (unable to change resolution)
    OPTS+=(-device vfio-pci,sysfsdev=/sys/bus/mdev/devices/$GVT_GUID)
fi

if [ "$ENABLE_QEMU_GPU" = true ]; then
    OPTS+=(-vga std)
else
    OPTS+=(-vga none -nographic) # Disable QEMU VGA and graphics
fi

if [ "$LG_KVMFR_DEVICE" = true ]; then
    OPTS+=(-device ivshmem-plain,id=shmem0,memdev=looking-glass)
    OPTS+=(-object memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,size=32M,share=on)

    # Create KVMFR device
    modprobe kvmfr static_size_mb=32

    # Set owner of KVMFR device (wait to be created by modprobe, change owner)
    wait_time=10
    while [ ! -c /dev/kvmfr0 ] && [ $wait_time -gt 0 ]; do
        echo "Waiting for KVMFR device (timeout: ${wait_time}s)" && wait_time=$(($wait_time-5)) && sleep 5
    done &&
        if [ $wait_time -gt 0 ]; then
            chown jonpas:jonpas /dev/kvmfr0 &&
            echo "KVMFR device owner changed"
        else
            echo "[WARNING] KVMFR device timed out!"
        fi &
else
    OPTS+=(-device ivshmem-plain,memdev=ivshmem,bus=pcie.0)
    OPTS+=(-object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=32M)

    # Create shared memory
    if [ -f /dev/shm/looking-glass ]; then
        rm /dev/shm/looking-glass
    fi

    touch /dev/shm/looking-glass
    chown jonpas:jonpas /dev/shm/looking-glass
    chmod 660 /dev/shm/looking-glass
fi

# Spice connection
if [ "$LG_SPICE_UNIX_SOCKET" = true ]; then
    OPTS+=(-spice unix=on,addr=/run/user/1000/spice.sock,disable-ticketing=on) # Unix socket

    # Set owner of Unix socket file (remove if exists, wait to be created by QEMU, change owner)
    if [ -S /run/user/1000/spice.sock ]; then
        rm /run/user/1000/spice.sock
    fi

    wait_time=30 &&
    while [ ! -S /run/user/1000/spice.sock ] && [ $wait_time -gt 0 ]; do
        echo "Waiting for Spice socket (timeout: ${wait_time}s)" && wait_time=$(($wait_time-5)) && sleep 5
    done &&
        if [ $wait_time -gt 0 ]; then
            chown jonpas:jonpas /run/user/1000/spice.sock &&
            echo "Spice socket owner changed"
        else
            echo "[WARNING] Spice socket timed out!"
        fi &
else
    OPTS+=(-spice port=5900,addr=127.0.0.1,disable-ticketing=on) # TCP
fi

# Spice Agent (clipboard)
OPTS+=(-device virtio-serial-pci)
OPTS+=(-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0)
OPTS+=(-chardev spicevmc,id=spicechannel0,name=vdagent)

# Mouse & Keyboard (pass one always in case of lock-ups or network issues)
OPTS+=(-device virtio-mouse-pci)
OPTS+=(-device virtio-keyboard-pci)

# Sound
OPTS+=(-audiodev spice,id=spice)
OPTS+=(-device ich9-intel-hda)
OPTS+=(-device hda-micro,audiodev=spice)


# VM START
pkill -RTMIN+3 i3status-rs
echo "OPTS:${OPTS[@]}"
systemd-inhibit --what="sleep:handle-lid-switch" --who="win-gvt" --why="VM needs to be turned off" --mode="block" \
    qemu-system-x86_64 "${OPTS[@]}"


# VM DEINIT
# Memory
if [ "$ENABLE_HUGEPAGES" = true ]; then
    echo 0 > /proc/sys/vm/nr_hugepages
fi

# GPU
if [ "$ENABLE_GVT_GPU" = true ]; then
    mdev remove
fi

pkill -RTMIN+3 i3status-rs
exit 0
