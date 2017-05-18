#!/bin/bash - 
#===============================================================================
#
#          FILE: repo.sh
# 
#         USAGE: ./repo.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/12/2017 10:12
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1
bak_time=$(date +%Y%m%d%H)
bak_dir="/etc/yum.repos.d/bak_${bak_time}"

cd /etc/yum.repos.d/
mkdir $bak_dir
mv ./*.repo $bak_dir
#mv CentOS-Base.repo CentOS-Base.repo.bak
wget -O CentOS-Ali.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm

yum clean all
yum makecache

yum install yum-axelget
yum install yum-plugin-fastestmirror

yum update

cd $WORK_DIR
