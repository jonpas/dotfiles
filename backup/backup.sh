#!/bin/bash
# Full system backup

# Backup destination
backdest=/opt/backup

# Exclude file location
exclude_file="./backup-exc.txt"

# Labels for backup name
pc=${HOSTNAME}
distro=$(cat /etc/*-release | grep "ID=" | awk -F"=" '{print $2}')
type=full
date=$(date "+%F")
backupfile="$backdest/$pc-$distro-$type-$date.tar.gz"

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
    # -p and --xattrs store all permissions and extended attributes.
    # Without both of these, many programs will stop working!
    # Remove verbose (-v) flag to speed up the process on slower terminals.
    tar -X $exclude_file --xattrs -czpvf $backupfile /
fi
