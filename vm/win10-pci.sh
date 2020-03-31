#!/bin/bash

# Arguments
ENABLE_PASSTHROUGH_MOUSEKEYBOARD=false # Configuration or latency-free (will disable it in case of crash)
ENABLE_PASSTHROUGH_USB_CONTROLLER=true
ENABLE_PASSTHROUGH_WHEEL=false # Separate from other USB devices
ENABLE_PASSTHROUGH_AUDIO=false # qemu-patched solves most issues
ENABLE_EVDEV_MOUSE=false
ENABLE_PASSTHROUGH_GPU=true
ENABLE_QEMU_GPU=false # Integrated QEMU GPU
ENABLE_HUGEPAGES=true
ENABLE_LOOKINGGLASS=true
LG_SPICE_UNIX_SOCKET=true
MEMORY="12"

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
    exit 1
}

while getopts 'hp:c:w:a:k:e:m:g:' flag; do
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


# Helpers
rebind() {
    dev="$1"
    driver="$2"
    removeid="$3"

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
        vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
        device=$(cat /sys/bus/pci/devices/$dev/device)
        echo $vendor $device > /sys/bus/pci/drivers/$driver/new_id
    else
        echo $dev > /sys/bus/pci/drivers/$driver/bind
    fi
}

start_lookingglass_helpers() {
    # Looking Glass client
    if ! pgrep "looking-glass" > /dev/null; then
        looking-glass-client &
    fi

    # VM Switcher
    if ! pgrep -f "$(dirname $0)/vm-switch.py" > /dev/null; then
        sleep 5 && # Wait for things to initialize to prevent threading errors
        $(dirname $0)/vm-switch.py &
    fi
}


# VM INIT
OPTS=""

#OPTS+=" -runas jonpas"

# General
OPTS+=" -enable-kvm"
OPTS+=" -machine type=q35,kernel_irqchip=on" # 'kernel_irqchip=on' for qemu >=4.0
OPTS+=" -rtc base=localtime" # Windows uses localtime
OPTS+=" -monitor stdio"

# CPU
OPTS+=" -cpu host,migratable=no,+invtsc,kvm=off,hv_vendor_id=0123456789ab,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff"
OPTS+=" -smp 4,sockets=1,cores=4,threads=1"

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

    # 8400 2MB pages = 16GB (+ overhead = multiplier 50)
    hugepages=$(( ${MEMORY} * 1050 / 2 ))
    echo "Huge Pages: ${hugepages}"
    echo $hugepages > /proc/sys/vm/nr_hugepages
    OPTS+=" -mem-path /dev/hugepages"
    OPTS+=" -mem-prealloc"
fi

# UEFI/BIOS
OPTS+=" -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd"
OPTS+=" -drive if=pflash,format=raw,file=/home/jonpas/images/vm/OVMF_VARS-win10-ovmf.fd"

# Drives
# Create image: qemu-img create -f raw name.img 10G -o preallocation=full (-o cluster_size=16K for qcow2)
# Convert qcow2 to raw: qemu-img convert -p -O raw source.qcow2 target.img -o preallocation=full
OPTS+=" -drive file=/home/jonpas/images/vm/win10-ovmf.img,format=raw,index=0,media=disk,if=virtio,aio=native,cache=none"
OPTS+=" -drive file=/home/jonpas/Data/images/vm/data.qcow2,format=qcow2,index=1,media=disk,if=virtio,aio=native,cache=none"
OPTS+=" -drive file=/home/jonpas/Data/images/windows10.iso,index=2,media=cdrom"
OPTS+=" -drive file=/home/jonpas/Data/images/virtio-win.iso,index=3,media=cdrom"

# Network
OPTS+=" -net none"
OPTS+=" -net nic,model=virtio" # 'virtio' may cause connection drop after a while without 'fix_virtio' patch (in qemu >=4.0)
OPTS+=" -net user" #,smb=/home/jonpas/Storage/"

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    OPTS+=" -device pcie-root-port,chassis=0,bus=pcie.0,slot=0,id=root1"

    rebind 0000:01:00.0 vfio-pci # GPU
    OPTS+=" -device vfio-pci,host=01:00.0,bus=root1,addr=00.0,multifunction=on"
    rebind 0000:01:00.1 vfio-pci # GPU Audio
    OPTS+=" -device vfio-pci,host=01:00.1,bus=root1,addr=00.1"
fi

if [ "$ENABLE_QEMU_GPU" = false ]; then
    OPTS+=" -vga none" # Disable QEMU GPU
else
    OPTS+=" -usb -device usb-tablet" # Prevent mouse grabbing on QEMU VGA
fi

if [ "$ENABLE_LOOKINGGLASS" = true ]; then
    OPTS+=" -device ivshmem-plain,memdev=ivshmem,bus=pcie.0"
    OPTS+=" -object memory-backend-file,id=ivshmem,share=on,mem-path=/dev/shm/looking-glass,size=32M"

    # Create shared memory
    if [ -f /dev/shm/looking-glass ]; then
        rm /dev/shm/looking-glass
    fi

    touch /dev/shm/looking-glass
    chown jonpas:jonpas /dev/shm/looking-glass
    chmod 660 /dev/shm/looking-glass

    # Spice connection
    if [ "$LG_SPICE_UNIX_SOCKET" = true ]; then
        OPTS+=" -spice gl=on,unix,addr=/run/user/1000/spice.sock,disable-ticketing" # Unix socket

        # Set owner of Unix socket file (remove if exists, wait to be created by QEMU, change owner)
        if [ -S /run/user/1000/spice.sock ]; then
            rm /run/user/1000/spice.sock
        fi
        while [ ! -S /run/user/1000/spice.sock ]; do
            sleep 1
        done &&
        chown jonpas:jonpas /run/user/1000/spice.sock &&
        echo "Spice socket owner changed" &&
        start_lookingglass_helpers &
    else
        OPTS+=" -spice port=5900,addr=127.0.0.1,disable-ticketing" # TCP
        start_lookingglass_helpers
    fi

    # Spice Agent (clipboard)
    OPTS+=" -device virtio-serial"
    OPTS+=" -chardev spicevmc,id=vdagent,debug=0,name=vdagent"
    OPTS+=" -device virtserialport,chardev=vdagent,name=com.redhat.spice.0"
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
    OPTS+=" -object input-linux,id=kbd,evdev=/dev/input/by-path/pci-0000:00:14.0-usb-0:10:1.0-event-kbd,grab_all=on,repeat=on" # Logitech G710 Keyboard

    if [ "$ENABLE_EVDEV_MOUSE" = true ]; then
        OPTS+=" -object input-linux,id=mouse,evdev=/dev/input/by-path/pci-0000:00:14.0-usb-0:3:1.0-event-mouse"
    fi
fi

# USB Controller (extension card)
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = true ]; then
    rebind 0000:06:00.0 vfio-pci # PCIe USB Card
    OPTS+=" -device vfio-pci,host=06:00.0,bus=root1,addr=00.4"
fi

# USB devices (connected to USB controller)
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = false ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x131d,productid=0x0158" # Natural Point TrackIR 5 Pro Head Tracker
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb10a" # ThrustMaster T.16000M Joystick
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb687" # ThrustMaster TWCS Throttle
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
    rebind 0000:00:1b.0 vfio-pci # Audio
    OPTS+=" -device vfio-pci,host=00:1b.0,bus=root1,addr=00.3"
else
    OPTS+=" -device ich9-intel-hda"
    OPTS+=" -device hda-micro,audiodev=hda"
    OPTS+=" -audiodev pa,id=hda,server=/run/user/1000/pulse/native" # Pulseaudio
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
    rebind 0000:06:00.0 xhci_hcd true # PCIe USB Card (remove ID)
fi

# Sound
if [ "$ENABLE_PASSTHROUGH_AUDIO" = true ]; then
    rebind 0000:00:1b.0 snd_hda_intel # Audio
fi

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    rebind 0000:01:00.0 nvidia # GPU
    rebind 0000:01:00.1 snd_hda_intel # GPU Audio

    if [ "$ENABLE_LOOKINGGLASS" = true ]; then
        # VM Switcher close
        if pgrep -f "$(dirname $0)/vm-switch.py" > /dev/null; then
            kill -SIGINT $(pgrep -f "$(dirname $0)/vm-switch.py")
        fi

        # Looking Glass client close
        if pgrep "looking-glass" > /dev/null; then
            kill -SIGINT $(pgrep "looking-glass")
        fi
    fi
fi

pkill -RTMIN+3 i3blocks
exit 0
