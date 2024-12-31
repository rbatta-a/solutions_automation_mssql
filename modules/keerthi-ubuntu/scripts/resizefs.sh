#!/bin/bash
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
