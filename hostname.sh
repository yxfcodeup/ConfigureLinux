#!/bin/bash - 
#===============================================================================
#
#          FILE: hostname.sh
# 
#         USAGE: ./hostname.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/18/2017 17:07
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1
IS_DEFAULT=$2

echo "--------------------hostname--------------------"
host_name="wiself"
host_name_file="/etc/hostname"

if [ false == $IS_DEFAULT ]
then
    read -p "Input the hostname will be used[${host_name}]: " hn_tmp
    if [ -z $hn_tmp ]
    then
        host_name=$host_name
    else
        host_name=$hn_tmp
    fi

    read -p "Input the file name where hostname will be placed[${host_name_file}]: " hnf_tmp
    if [ -z $hnf_tmp ]
    then
        host_name_file=$host_name_file
    else
        host_name_file=$hnf_tmp
    fi
fi

echo "echo ${host_name} > ${host_name_file}"
echo ${host_name} > ${host_name_file}
