#!/bin/bash

ENABLE_PASSTHROUGH_GPU=true
ENABLE_PASSTHROUGH_MOUSEKEYBOARD=false # Configuration or latency-free (will disable it in case of crash)
ENABLE_PASSTHROUGH_USB_CONTROLLER=false
ENABLE_PASSTHROUGH_USB_DEVICES=true # Joystick, Throttle, Gamepad (only if controller not passed)
ENABLE_PASSTHROUGH_WHEEL=false # Separate from other USB devices
ENABLE_PASSTHROUGH_AUDIO=false # qemu-patched solves most issues
ENABLE_QEMU_GPU=false # Integrated QEMU GPU
ENABLE_HUGEPAGES=true
MEMORY="16G"


if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = true ]; then
    echo "USB Device Pass-Through disabled! Controller being passed."
    ENABLE_PASSTHROUGH_USB_DEVICES=false
fi


rebind() {
    dev="$1"
    driver="$2"

    # Unbind
    if [ -e /sys/bus/pci/devices/$dev/driver ]; then
        echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
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


# VM INIT
OPTS=""

#OPTS+=" -runas jonpas"

# General
OPTS+=" -enable-kvm"
OPTS+=" -M pc-q35-3.0" # 'pc-q35-3.0' for qemu-patched 3.0+, 'q35' for qemu <3.0
OPTS+=" -rtc base=localtime" # Windows uses localtime

# CPU
OPTS+=" -cpu host,kvm=off,hv_vendor_id=0123456789ab,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff"
OPTS+=" -smp 4,sockets=1,cores=4,threads=1"
for i in $(seq 0 3); do
    OPTS+=" -vcpu vcpunum=$i,affinity=$i" # Pin virtual CPU cores to actual CPU cores (qemu-patched)
done

# RAM
OPTS+=" -m $MEMORY"
if [ "$ENABLE_HUGEPAGES" = true ]; then
    echo 8400 > /proc/sys/vm/nr_hugepages
    OPTS+=" -mem-path /dev/hugepages"
fi

# UEFI/BIOS
OPTS+=" -drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/OVMF_CODE.fd"
OPTS+=" -drive if=pflash,format=raw,file=/home/jonpas/images/vm/OVMF_VARS-win10-ovmf.fd"

# Drives
OPTS+=" -device virtio-scsi-pci"
OPTS+=" -drive file=/home/jonpas/images/vm/win10-ovmf.qcow2,format=qcow2,index=0,media=disk,if=virtio"
OPTS+=" -drive file=/home/jonpas/Data/images/vm/data.qcow2,format=qcow2,index=1,media=disk,if=virtio"
OPTS+=" -drive file=/home/jonpas/Data/images/windows10.iso,index=2,media=cdrom"
OPTS+=" -drive file=/home/jonpas/Data/images/virtio-win.iso,index=3,media=cdrom"

# Network
OPTS+=" -net none"
OPTS+=" -net nic,model=virtio" # 'virtio' may cause connection drop after a while without 'fix_virtio' patch (in qemu-patched)
OPTS+=" -net user" #,smb=/home/jonpas/Storage/"

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    OPTS+=" -device pcie-root-port,chassis=0,bus=pcie.0,slot=0,id=root1"
    OPTS+=" -set device.root1.speed=8"
    OPTS+=" -set device.root1.width=16"

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

# Mouse & Keyboard (pass one always in case of lock-ups or network issues)
if [ "$ENABLE_PASSTHROUGH_MOUSEKEYBOARD" = true ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x046d,productid=0xc332" # Logitech G502 Mouse
    OPTS+=" -usb -device usb-host,vendorid=0x046d,productid=0xc24d" # Logitech G710 Keyboard
else
    OPTS+=" -usb -device usb-host,vendorid=0x0458,productid=0x0154" # KYE Systems Bluetooth Mouse

    # evdev (lctrl + rctrl to swap, no macro keys)
    OPTS+=" -object input-linux,id=kbd,evdev=/dev/input/by-id/usb-Logitech_Logitech_G710_Keyboard-event-kbd,grab_all=on,repeat=on" # Logitech G710 Keyboard
fi

# USB
if [ "$ENABLE_PASSTHROUGH_USB_CONTROLLER" = true ]; then
    rebind 0000:06:00.0 vfio-pci # PCIe USB Card
    OPTS+=" -device vfio-pci,host=06:00.0,bus=root.1"
fi

if [ "$ENABLE_PASSTHROUGH_USB_DEVICES" = true ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x131d,productid=0x0158" # Natural Point TrackIR 5 Pro Head Tracker
    OPTS+=" -usb -device usb-host,vendorid=0x0810,productid=0x0003" # Trust USB Gamepad
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb10a" # ThurstMaster T.16000M Joystick
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb687" # ThrustMaster TWCS Throttle
fi

if [ "$ENABLE_PASSTHROUGH_WHEEL" = true ]; then
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb677" # Thrustmaster T150 FFB Wheel (ID 1 - Linux reads it as either ID)
    OPTS+=" -usb -device usb-host,vendorid=0x044f,productid=0xb65d" # Thrustmaster T150 FFB Wheel (ID 2 - Linux reads it as either ID)
fi

# Sound
if [ "$ENABLE_PASSTHROUGH_AUDIO" = true ]; then
    rebind 0000:00:1b.0 vfio-pci # Audio
    OPTS+=" -device vfio-pci,host=00:1b.0,bus=root.1,addr=00.3"
else
    OPTS+=" -soundhw hda" # 'hda' for qemu-patched, 'ac97' otherwise
fi


# VM START
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
    rebind 0000:06:00.0 xhci_hcd # PCIe USB Card
fi

# Sound
if [ "$ENABLE_PASSTHROUGH_AUDIO" = true ]; then
    rebind 0000:00:1b.0 snd_hda_intel # Audio
fi

# GPU
if [ "$ENABLE_PASSTHROUGH_GPU" = true ]; then
    rebind 0000:01:00.0 nvidia # GPU
    rebind 0000:01:00.1 snd_hda_intel # GPU Audio
fi

exit 0
