#!/bin/bash - 
#===============================================================================
#
#          FILE: download.sh
# 
#         USAGE: ./download.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/11/2017 16:49
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1
DOWN_DIR="${WORK_DIR}/download"
if [ ! -d ${DOWN_DIR} ]
then
    mkdir ${DOWN_DIR}
fi
chmod 777 ${DOWN_DIR}

cd $DOWN_DIR
wget http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz?AuthParam=1494574769_25c7b400f985c33ebc20c76ef447559e
