#!/bin/bash
set -e

programname=$0

function yellow { echo -e "\e[33m$@\e[0m"; }
function red { echo -e "\e[31m$@\e[0m"; }

function lvm_exist {
  vg_name=$(dmsetup ls | grep $1 | awk '{print $1}' | sed 's/--/-/g' | cut -d - -f1-2)
  
  if [ -z "$vg_name" ]
  then
     read -p 'Volume Group: ' vg_name
     yellow "Logical Volume $1 does not exist ..... "
     yellow "Creating a sample LV $1 with 1GB size on $vg_name"
     sleep 2s
     lvcreate -L1G -n $1 $vg_name || { red "Could not create LV"; exit 1; }
     yellow "LV has been created, please try to remove the VDS from Control panel"
  else
     yellow "LV exists .."
  fi
}

function usage {
     echo "usage: $programname [lvm_name]"
     exit 1 
}

if [[ $# -eq 0 ]]; 
then 
  usage
else
  lvm_exist $1
fi
