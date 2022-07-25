#!/bin/bash
echo $HOME
sudo apt-get update
sudo apt -y -q=2 install jq

cat /etc/fstab | grep "VolGroup00\|iris01vg"
if [[ ${?}  -ne  0 ]]; then
curl -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2020-06-01" | jq > irisMetadata.txt
vm_gen=$(cat irisMetadata.txt |jq .compute.vmSize |tr -d '"' |awk -F_ '{print $3}')
echo "Generation of Virtual Machine"
echo $vm_gen

        if [[ $vm_gen -eq v4 ]]; then
                echo "Version v4"
                BLACKLIST="/dev/sda"
        else
                echo "Version V5"
                BLACKLIST="/dev/sda|/dev/sdb"
        fi
        echo "List of default drives that will be ignored"
        echo ${BLACKLIST}
        DISKS=($(ls /dev/sd*|egrep -v "${BLACKLIST}|[0-9]$"))
        echo "Below disks will be checked if they are mounted"
        echo ${DISKS[@]}
        i=0
        for disk in "${DISKS[@]}";
        do
                echo "Checking for disk ${disk}"
                isFormatted=$(lsblk -no KNAME,FSTYPE ${disk} |wc -w)
                if [[ ${isFormatted} -eq 1 ]];
                then
                        echo "Drive ${disk} is NOT FORMATTED"
                        sudo mkdir /ultratestdrive_${i}
                        sudo mkfs.xfs -b size=4096 ${disk}
                        sudo mount ${disk} /ultratestdrive_${i}
                        ((i=i+1))
                else
                        echo "DRIVE ${disk} is FORMATTED"
                fi


        done

fi
