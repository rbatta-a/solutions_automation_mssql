#!/bin/bash

# Determine the OS type
OS=$(uname)

if [ "$OS" = "Linux" ]; then
    # Check Linux distribution from /etc/os-release
    if [ -f "/etc/os-release" ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "Cannot determine Linux distribution. /etc/os-release not found."
        exit 1
    fi

    case "$DISTRO" in
        ubuntu)
            echo "Running on Ubuntu"
            # Commands specific to Ubuntu
            (
            echo d # Delete  partition
            echo   # default partition
            echo n # Add a new partition
            echo   # default partition
            echo   # default
            echo   # default 
            echo w # Write changes
            ) | fdisk /dev/sda
            pvresize /dev/sda3
            lvextend -r -L +20G /dev/mapper/sysvg-var
            lvextend -r -L +10G /dev/mapper/sysvg-root
            lvextend -r -L +5G /dev/mapper/sysvg-opt
            lvextend -r -L +5G /dev/mapper/sysvg-home
            lvextend -r -L +5G /dev/mapper/sysvg-tmp
            lvextend -r -L +5G /dev/mapper/sysvg-log
            ;;
        rhel)
            echo "Running on Red Hat Enterprise Linux"
            # Commands specific to RHEL
            /usr/sbin/pvresize /dev/sdb
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_root
            /sbin/lvextend -L +20G -r /dev/mapper/sysvg-lv_home
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_var
            /sbin/lvextend -L +15G -r /dev/mapper/sysvg-lv_log
            /sbin/lvextend -L +15G -r /dev/mapper/sysvg-lv_audit
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_tmp 
            /sbin/lvextend -L +5G -r /dev/mapper/sysvg-lv_opt 
            /sbin/swapoff /dev/mapper/sysvg-lv_swap
            /sbin/lvextend -L +10G  /dev/mapper/sysvg-lv_swap
            /usr/sbin/mkswap /dev/mapper/sysvg-lv_swap
            /sbin/swapon /dev/mapper/sysvg-lv_swap
            ;;
        rocky)
            echo "Running on Rocky Linux"
            # Commands specific to Rocky
            /usr/sbin/pvresize /dev/sdb
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_root
            /sbin/lvextend -L +20G -r /dev/mapper/sysvg-lv_home
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_var
            /sbin/lvextend -L +15G -r /dev/mapper/sysvg-lv_log
            /sbin/lvextend -L +15G -r /dev/mapper/sysvg-lv_audit
            /sbin/lvextend -L +10G -r /dev/mapper/sysvg-lv_tmp 
            /sbin/lvextend -L +5G -r /dev/mapper/sysvg-lv_opt 
            /sbin/swapoff /dev/mapper/sysvg-lv_swap
            /sbin/lvextend -L +10G  /dev/mapper/sysvg-lv_swap
            /usr/sbin/mkswap /dev/mapper/sysvg-lv_swap
            /sbin/swapon /dev/mapper/sysvg-lv_swap
            ;;
        *)
            echo "Unknown Linux distribution: $DISTRO"
            # Default or fallback commands for unknown distros
            ;;
    esac
else
    echo "Unknown operating system: $OS"
    # Default or fallback commands for unknown OS
fi