#!/bin/bash
# Full system backup

# Backup destination
backdest=/backups

# Exclude file location
exclude_file="./backup-exc.txt"

# Labels for backup name
distro=$(cat /etc/*-release | grep "ID=" | awk -F"=" '{print $2}')
date=$(date +%Y%m%dT%H%M%S)
backupfile="$backdest/fsbackup_$(hostname)_$distro_$date.tar.gz"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Must run as root!"
    exit 1
fi

# Prompt if sure
echo -n "Are you sure you would like to begin backup? (y/n): "
read executeback

# Check if exclude file exists
if [ -f $exclude_file ]; then
    echo -n "Using exclude file: $exclude_file, continue? (y/n): "
else
    echo -n "No exclude file exists, continue? (y/n): "
fi

read continue
if [ $continue == "n" ]; then
    exit 0
fi

if [ $executeback = "y" ]; then
    mkdir -p /backups

    # -p and --xattrs store all permissions and extended attributes.
    # Without both of these, many programs will stop working!
    # Verbose (-v) flag slows the process on slower terminals
    if [ "$1" = "-v" ]; then
        tar -X $exclude_file --xattrs -czpvf $backupfile /
    else
        tar -X $exclude_file --xattrs -czpf $backupfile /
    fi
fi
