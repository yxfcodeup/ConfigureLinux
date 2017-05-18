#!/bin/bash - 
#===============================================================================
#
#          FILE: static_ip.sh
# 
#         USAGE: ./static_ip.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/18/2017 14:20
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1
IS_DEFAULT=$2

echo ""
echo "--------------------static ip--------------------"
sip="192.168.1.111"
netfile="/etc/sysconfig/network-scripts/ifcfg-eno16777736"
netfile="/home/ployo/workspace/ConfigureLinux.local/ifcfg-eno16777736"

if [ false == $IS_DEFAULT ]
then
    read -p "Input which ip address will be set[${sip}]: " sip_tmp
    if [ -z $sip_tmp ]
    then
        sip=$sip
    else
        sip=$sip_tmp
    fi
fi
echo "Static ip is ${sip}"
gateway="${sip%\.*}.1"
echo "Gateway is ${gateway}"

if [ false == $IS_DEFAULT ]
then
    while true
    do
        read -p "Input where ip will be set[${netfile}]: " netset
        if [ -z $netset ]
        then
            netfile=$netfile
        else
            netfile=$netset
        fi

        if [ -e $netfile ]
        then
            if [ -f $netfile ]
            then
                if [ -w $netfile ]
                then
                    break
                else
                    echo "${netfile} will be given a write permission!"
                    chmod o+w $netfile
                fi
            else
                echo "${netfile} is not a general file!"
            fi
        else
            echo "${netfile} is not existed!"
        fi
    done
fi
echo "Network config file is '${netfile}'"

name_str=$(grep -w "NAME" ${netfile})
uuid_str=$(grep -w "UUID" ${netfile})
device_str=$(grep -w "DEVICE" ${netfile})

echo 'TYPE="Ethernet"' > $netfile
echo 'BOOTPROTO="none"' >> $netfile
echo 'DEFROUTE="yes"' >> $netfile
echo 'IPV4_FAILURE_FATAL="no"' >> $netfile
echo 'IPV6INIT="yes"' >> $netfile
echo 'IPV6_AUTOCONF="yes"' >> $netfile
echo 'IPV6_DEFROUTE="yes"' >> $netfile
echo 'IPV6_FAILURE_FATAL="no"' >> $netfile
echo ${name_str} >> $netfile
echo ${uuid_str} >> $netfile
echo ${device_str} >> $netfile
echo 'ONBOOT="yes"' >> $netfile
echo "IPADDR=\"${sip}\"" >> $netfile
echo 'PREFIX="24"' >> $netfile
echo "GATEWAY=\"${gateway}\"" >> $netfile
echo 'DNS2="114.114.114.114"' >> $netfile
echo 'DNS3="223.5.5.5"' >> $netfile
echo 'PEERDNS="yes"' >> $netfile
echo 'PEERROUTES="yes"' >> $netfile
echo 'IPV6_PEERDNS="yes"' >> $netfile
echo 'IPV6_PEERROUTES="yes"' >> $netfile
echo 'IPV6_PRIVACY="no"' >> $netfile

cat $netfile
