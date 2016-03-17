#!/bin/bash

############
# GET OPTS #
############

function usage {
  echo "-c <number> - Specifies how many clients to start up"
  echo "-n: to activate NAT Network (default: false)"
  echo "-s: to start VM's on creation (default: false)"
  echo "-r: to remove any prior matching VMs before creation (default: false)"
  exit
}

nat=false
start=false
remove=false

while getopts ":rnsc:" opt; do
  case $opt in
    c)
      PXE_COUNT=$OPTARG
      ;;
    n)
      nat=true
      ;;
    s)
      start=true
      ;;
    r)
      remove=true
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done


######################
# DEPLOY PXE CLIENTS #
######################
if [ $PXE_COUNT ]
  then
    for (( i=1; i <= $PXE_COUNT; i++ ))
      do
        vmName="node-$i"

        if $remove ; then
            VBoxManage controlvm $vmName poweroff
            VBoxManage unregistervm $vmName --delete 
        fi

        mac=$(printf "%0.12x" "$i";);
        if [[ ! -e $vmName.vdi ]]; then # check to see if PXE vm already exists
            echo "deploying pxe: $i"
            VBoxManage createvm --name $vmName --register;
            VBoxManage createhd --filename $vmName --size 8192;
            VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAHCI
            VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vmName.vdi
            VBoxManage modifyvm $vmName --ostype Ubuntu --boot1 net --memory 1024;
            VBoxManage modifyvm $vmName --nic1 intnet --intnet1 prov --nicpromisc1 allow-all;
            VBoxManage modifyvm $vmName --nictype1 82540EM --macaddress1 $mac --nicspeed1 125000;

            if $nat ; then
              VBoxManage modifyvm $vmName --nic2 nat --nicpromisc2 allow-all;
              VBoxManage modifyvm $vmName --nictype2 82540EM;
            fi
            
            if $start ; then
            VBoxManage startvm $vmName --type headless;
            fi

        fi
        echo $mac
      done
fi
