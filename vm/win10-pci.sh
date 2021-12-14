#!/bin/bash

# Arguments
ENABLE_PASSTHROUGH_MOUSEKEYBOARD=false # Configuration or latency-free (will disable it in case of crash)
ENABLE_PASSTHROUGH_USB_CONTROLLER=true
ENABLE_PASSTHROUGH_WHEEL=true # Separate from other USB devices
ENABLE_PASSTHROUGH_AUDIO=false # qemu-patched solves most issues
ENABLE_EVDEV_MOUSE=false
ENABLE_PASSTHROUGH_GPU=true
ENABLE_QEMU_GPU=false # Integrated QEMU GPU
ENABLE_HUGEPAGES=true
ENABLE_LOOKINGGLASS=true
LG_SPICE_UNIX_SOCKET=true
LG_KVMFR_DEVICE=true
MEMORY="32"

PCI_GPU_VIDEO=0000:0a:00.0
PCI_GPU_AUDIO=0000:0a:00.1

rebind() {
    dev="$1"
    driver="$2"
    removeid="$3"
    vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
    device=$(cat /sys/bus/pci/devices/$dev/device)

    # Unbind
    if [ -e /sys/bus/pci/devices/$dev/driver ]; then
        echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
    fi
    if [ "$removeid" = true ]; then
        # Remove ID (required for XHCI rebind)
        echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/remove_id
    fi

    # Bind
    if [ "$driver" = "vfio-pci" ]; then
        echo $vendor $device > /sys/bus/pci/drivers/$driver/new_id
    else
        if [ "$driver" = "nvidia" ] && [ ! -e /sys/bus/pci/drivers/nvidia ]; then
            # Special nvidia handling, version 495 nvidia-modprobe does not seem to create system files unless an
            # unbound GPU is available but it does automatically eat the unbound GPU!
            nvidia-modprobe && sleep 5
        else
            echo $dev > /sys/bus/pci/drivers/$driver/bind
        fi
    fi
}

rebind_gpu() {
    driver="$1"

    if [ "$driver" = "nvidia" ]; then
        rebind $PCI_GPU_VIDEO nvidia
        rebind $PCI_GPU_AUDIO snd_hda_intel
    elif [ "$driver" = "nouveau" ]; then
        rebind $PCI_GPU_VIDEO nouveau
        rebind $PCI_GPU_AUDIO snd_hda_intel
    elif [ "$driver" = "vfio" ] || [ "$driver" = "vfio-pci" ]; then
        rebind $PCI_GPU_VIDEO vfio-pci true
        rebind $PCI_GPU_AUDIO vfio-pci true
    else
        echo "Unknown GPU driver!"
    fi

    exit 1
}

usage() {
    echo "Windows 10 GPU-Passthrough VM Start script."
    echo "[-h] help"
    echo "[-p <true/false>] use huge pages"
    echo "[-c <true/false>] pass-through USB controller"
    echo "[-w <true/false>] pass-through wheel (in USB controller)"
    echo "[-a <true/false>] pass-through audio"
    echo "[-k <true/false>] pass-through mouse/keyboard"
    echo "[-e <true/false>] evdev pass-through mouse"
    echo "[-m <gigabytes>] memory"
    echo "[-g <true/false>] use Looking Glass"
    echo "[-r <vfio/nvidia/nouveau>] set pass-through GPU driver"
    exit 1
}

while getopts 'hp:c:w:a:k:e:m:g:r' flag; do
    case "${flag}" in
        h) usage ;;
        p) ENABLE_HUGEPAGES=${OPTARG} ;;
        c) ENABLE_PASSTHROUGH_USB_CONTROLLER=${OPTARG} ;;
        w) ENABLE_PASSTHROUGH_WHEEL=${OPTARG} ;;
        a) ENABLE_PASSTHROUGH_AUDIO=${OPTARG} ;;
        k) ENABLE_PASSTHROUGH_MOUSEKEYBOARD=${OPTARG} ;;
        e) ENABLE_EVDEV_MOUSE=${OPTARG} ;;
        m) MEMORY=${OPTARG} ;;
        g) ENABLE_LOOKINGGLASS=${OPTARG} ;;
        r) rebind_gpu $2 ;;
        *) usage ;;
    esac
done

echo "Huge-pages: $ENABLE_HUGEPAGES"
echo "Pass-Through Wheel: $ENABLE_PASSTHROUGH_WHEEL"
echo "Pass-Through Audio: $ENABLE_PASSTHROUGH_AUDIO"
echo "Pass-Through Mouse/Keyboard: $ENABLE_PASSTHROUGH_MOUSEKEYBOARD"
echo "Pass-Through USB Controller: $ENABLE_PASSTHROUGH_USB_CONTROLLER"
echo "Evdev Mouse: $ENABLE_EVDEV_MOUSE"
echo "Memory: ${MEMORY}G"
echo "Looking Glass: $ENABLE_LOOKINGGLASS"
if [ "$ENABLE_LOOKINGGLASS" = true ]; then
    echo "Spice Unix Socket: $LG_SPICE_UNIX_SOCKET"
fi


# VM INIT
OPTS=""

#OPTS+=" -runas jonpas"

# General
OPTS+=" -enable-kvm"
OPTS+=" -machine type=q35,kernel_irqchip=on" # 'kernel_irqchip=on' for qemu >=4.0
OPTS+=" -rtc base=localtime" # Windows uses localtime

# CPU
OPTS+=" -cpu host,migratable=no,+invtsc,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,topoext"
OPTS+=" -smp 16,sockets=1,cores=8,threads=2"
# `bcdedit.exe /set useplatformclock true` enables HPET timer in Windows and introduces stuttering (most noticable with mouse input over barrier)

# RAM
OPTS+=" -m ${MEMORY}G"
if [ "$ENABLE_HUGEPAGES" = true ]; then
    # Clear cached memory to allow reserving
    sync # Save cached data to disk
    echo 3 > /proc/sys/vm/drop_caches # Drop all caches to free reserved memory
    echo 1 > /proc/sys/vm/compact_memory # Compact into contingous blocks

    # Make sure we can allocate enough memory
    if [ $(free --giga | awk '/Mem:/ { print $4 }') -le $MEMORY ]; then
        echo "Error! Not enough free memory!"
        exit 2
    fi

    # 8192 2MB pages = 16GB
    # 16384 2MB pages = 32GB
    hugepages=$(( ${MEMORY} * 1024 / 2 ))
    echo "Huge Pages: ${hugepages}"
    echo $hugepages > /proc/sys/vm/nr_hugepages
    OPTS+=" -mem-path /dev/hugepages"
    OPTS+=" -mem-prealloc"
fi

# UEFI/BIOS
OPTS+=" -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd"
OPTS+=" -drive if=pflash,format=raw,file=/home/jonpas/images/vm/OVMF_VARS-win10-ovmf.fd"

# Drives
OPTS+=" -device virtio-scsi-pci,id=scsi0"

OPTS+=" -drive file=/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S3Z2NB2KA62661K,format=raw,index=0,if=none,aio=native,cache=none,id=drive0" # 'scsi-block' requires '/by-id/'
OPTS+=" -device scsi-hd,drive=drive0,bus=scsi0.0,bootindex=1,rotation_rate=1" # 'scsi-block' for stats and SMART inside guest, 'scsi-hd' for discard/trim

OPTS+=" -drive file=/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S4J4NM0R706278T,format=raw,index=1,if=none,aio=native,cache=none,id=drive1" # 'scsi-block' requires '/by-id/'
OPTS+=" -device scsi-hd,drive=drive1,bus=scsi0.0,rotation_rate=1" # 'scsi-block' for stats and SMART inside guest, 'scsi-hd' for discard/trim

# Create image: qemu-img create -f raw name.img 10G -o preallocation=full (-o cluster_size=16K for qcow2)
# Convert qcow2 to raw: qemu-img convert -p -O raw source.qcow2 target.img -o preallocation=full
# Resize image: qemu-img resize -f raw --preallocation=full source.img +5G
#OPTS+=" -device virtio-scsi-pci,id=scsi1"
#OPTS+=" -drive file=/home/jonpas/Data/images/vm/data.img,format=raw,index=2,media=disk,if=none,aio=native,cache=none,id=drive2"
#OPTS+=" -device scsi-hd,drive=drive2,bus=scsi1.0,rotation_rate=7200"

OPTS+=" -drive file=/home/jonpas/images/windows10.iso,index=3,media=cdrom"
OPTS+=" -drive file=/home/jonpas/images/virtio-win.iso,index=4,media=cdrom"

# Network
OPTS+=" -net none"
OPTS+=" -net nic,model=virtio" # 'virtio' may cause connection drop after a while without 'fix_virtio' patch (in qemu >=4.0)
OPTS+=" -net bridge,br=bridge0" # -net user #,smb=/home/jonpas/Storage/"

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    OPTS+=" -device pcie-root-port,chassis=0,bus=pcie.0,slot=0,id=root1"

    rebind $PCI_GPU_VIDEO vfio-pci
    OPTS+=" -device vfio-pci,host=$(echo $PCI_GPU_VIDEO | cut -c 6-),bus=root1,addr=00.0,multifunction=on"
    rebind $PCI_GPU_AUDIO vfio-pci
    OPTS+=" -device vfio-pci,host=$(echo $PCI_GPU_AUDIO | cut -c 6-),bus=root1,addr=00.1"
fi

if [ "$ENABLE_QEMU_GPU" = false ]; then
    OPTS+=" -vga none -nographic" # Disable QEMU VGA and graphics
else
    OPTS+=" -usb -device usb-tablet" # Prevent mouse grabbing on QEMU VGA
fi

if [ "$ENABLE_LOOKINGGLASS" = true ]; then
    if [ "$LG_KVMFR_DEVICE" = true ]; then
        OPTS+=" -device ivshmem-plain,id=shmem0,memdev=looking-glass"
        OPTS+=" -object memory-backend-file,id=looking-glass,mem-path=/dev/kvmfr0,size=32M,share=yes"

        # Create KVMFR device
        modprobe kvmfr static_size_mb=32

        # Set owner of KVMFR device (remove if exists, wait to be created by QEMU, change owner)
        while [ ! -c /dev/kvmfr0 ]; do
            sleep 1
        done &&
        chown jonpas:jonpas /dev/kvmfr0 &&
        echo "KVMFR device owner changed" &
    else
        OPTS+=" -device ivshmem-plain,memdev=ivshmem,bus=pcie.0"
        OPTS+=" -object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=32M"

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
        OPTS+=" -spice unix=on,addr=/run/user/1000/spice.sock,disable-ticketing=on" # Unix socket

        # Set owner of Unix socket file (remove if exists, wait to be created by QEMU, change owner)
        if [ -S /run/user/1000/spice.sock ]; then
            rm /run/user/1000/spice.sock
        fi
        while [ ! -S /run/user/1000/spice.sock ]; do
            sleep 1
        done &&
        chown jonpas:jonpas /run/user/1000/spice.sock &&
        echo "Spice socket owner changed" &
    else
        OPTS+=" -spice port=5900,addr=127.0.0.1,disable-ticketing=on" # TCP
    fi

    # Spice Agent (clipboard)
    OPTS+=" -device virtio-serial-pci"
    OPTS+=" -device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
    OPTS+=" -chardev spicevmc,id=spicechannel0,name=vdagent"
fi

# Mouse & Keyboard (pass one always in case of lock-ups or network issues)
OPTS+=" -device virtio-mouse-pci"
OPTS+=" -device virtio-keyboard-pci"
if [ "$ENABLE_PASSTHROUGH_MOUSEKEYBOARD" = true ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x046d,productid=0xc332" # Logitech G502 Mouse
    OPTS+=" -usb -device usb-host,vendorid=0x046d,productid=0xc24d" # Logitech G710 Keyboard
else
    # Secondary mouse (connected to USB controller - internal)
    if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = false ]; then
        OPTS+=" -usb -device usb-host,vendorid=0x0458,productid=0x0154" # KYE Systems Bluetooth Mouse
    fi

    # evdev (lctrl + rctrl to swap, no macro keys)
    OPTS+=" -object input-linux,id=kbd,evdev=/dev/input/by-path/pci-0000:0d:00.3-usb-0:4:1.0-event-kbd,grab_all=on,repeat=on" # Logitech G710 Keyboard

    if [ "$ENABLE_EVDEV_MOUSE" = true ]; then
        OPTS+=" -object input-linux,id=mouse,evdev=/dev/input/by-path/pci-0000:07:00.1-usb-0:3:1.0-event-mouse" # Logitech G502 Mouse
    fi
fi

# USB Controller (extension card)
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = true ]; then
    rebind 0000:05:00.0 vfio-pci # PCIe USB Card
    OPTS+=" -device vfio-pci,host=05:00.0,bus=root1,addr=00.4"
fi

# USB devices (connected to USB controller)
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = false ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x131d,productid=0x0158" # Natural Point TrackIR 5 Pro Head Tracker
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb10a" # ThrustMaster T.16000M Joystick
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb687" # ThrustMaster TWCS Throttle
    OPTS+=" -usb -device usb-host,vendorid=0x06a3,productid=0x0763" # Saitek (Logitech) G Flight Rudder Pedal
fi

# USB devices (not connected to USB controller)
OPTS+=" -usb -device usb-host,vendorid=0x0810,productid=0x0003" # Trust USB Gamepad

if [ "$ENABLE_PASSTHROUGH_WHEEL" = true ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb677" # Thrustmaster T150 FFB Wheel (ID 1 - Linux reads it as either ID)
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb65d" # Thrustmaster T150 FFB Wheel (ID 2 - Linux reads it as either ID)
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb676" # Thrustmaster T150 FFB Wheel (Bootloader - Firmware update)
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb660" # Thrustmaster TH8A Shifter (T500 RS Gear shift)
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb672" # Thrustmaster TH8A Shifter (Bootloader - Firmeware update)
fi

# Sound
if [ "$ENABLE_PASSTHROUGH_AUDIO" = true ]; then
    rebind 0000:0d:00.4 vfio-pci # Audio
    OPTS+=" -device vfio-pci,host=00:0d.0,bus=root1,addr=00.3"
else
    OPTS+=" -device ich9-intel-hda"
    # 'hda' requires buffer-length and timer-period parameters to avoid noticable delays
    OPTS+=" -device hda-micro,audiodev=hda" # Speaker + Microphone
    #OPTS+=" -audiodev pa,id=hda,server=unix:/tmp/pulse-socket,out.buffer-length=512,timer-period=1000" # PulseAudio + 44100 Hz in Windows (timer-period broken with QEMU 6.0)
    OPTS+=" -audiodev pa,id=hda,server=unix:/tmp/pulse-socket" # PulseAudio + 44100 Hz in Windows
    # 'usb-audio' has 5.1 support, but crackles a bit
    #OPTS+=" -device usb-audio,audiodev=usb,multi=on" # Speaker only
    #OPTS+=" -audiodev pa,id=usb,server=unix:/tmp/pulse-socket,out.mixing-engine=off,out.buffer-length=512,timer-period=1000" # PulseAudio
    # 'unix:/tmp/pulse-socket' requires following in PulseAudio configuration ('~/.config/pulse/default.pa'):
    # load-module module-native-protocol-unix auth-anonymous=1 socket=/tmp/pulse-socket
fi


# VM START
pkill -RTMIN+3 i3blocks
qemu-system-x86_64 $OPTS


# VM DEINIT
# Memory
if [ "$ENABLE_HUGEPAGES" = true ]; then
    echo 0 > /proc/sys/vm/nr_hugepages
fi

# Mouse & Keyboard
if [ "$ENABLE_PASSTHROUGH_MOUSEKEYBOARD" = true ]; then
    ../i3/keyboard.sh # Keyboard layout gets reset on return from pass-through
fi

# USB
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = true ]; then
    rebind 0000:05:00.0 xhci_hcd true # PCIe USB Card (remove ID)
fi

# Sound
if [ "$ENABLE_PASSTHROUGH_AUDIO" = true ]; then
    rebind 0000:0d:00.4 snd_hda_intel # Audio
fi

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    rebind $PCI_GPU_VIDEO nvidia
    rebind $PCI_GPU_AUDIO snd_hda_intel
fi

pkill -RTMIN+3 i3blocks
exit 0
