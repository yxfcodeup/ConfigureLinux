#!/bin/bash - 
#===============================================================================
#
#          FILE: basic.sh
# 
#         USAGE: ./basic.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/12/2017 10:09
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1


echo "\n--------------------'root' permission--------------------"
while true
do
    read -p "Input which user will be given permission of 'root'(no input means over):" input_user
    case $input_user in
        "" )
            break
            ;;
        * )
            isexists=$(cat /etc/passwd |grep $input_user)
            if [ -z $isexists ]
            then
                echo "ERROR: this user is not existed!!!"
            else
                echo "${input_user}     ALL=(ALL)     ALL" >> /etc/sudoers
                tail -1 /etc/sudoers
            fi
            ;;
    esac
done
