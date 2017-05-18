#!/bin/bash - 
#===============================================================================
#
#          FILE: install.sh
# 
#         USAGE: ./install.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/08/2017 11:17
#      REVISION:  ---
#===============================================================================

set -o errexit                              
:<<! 
If a command has a non-zero exit status, execute the ERR trap (if set), and exit.This mode is disabled while reading profiles.
Same as set -e. 
!

set -o nounset                              
:<<!
Treat unset variables as an error.
Same as set -u.
!

plan=$1

#source /etc/profile

#------------------------------------------------------------------------------
# FUNCTION: getCurrentPath
# DESCRIPTION: Get the path of current path.
#------------------------------------------------------------------------------
function getCurrentPath()
{
    local _tmp_=`echo $0|grep "^/"`
    _tdir_=
    if test "${_tmp_}"
    then
        _tdir_=$(dirname $0)
    else 
        _tdir_=$(dirname `pwd`/$0)
    fi
    _tag_="/."
    _ttt_=${_tdir_:${#_tdir_}-2:${#_tdir_}}
    if [ "$_tag_" = "$_ttt_" ]
    then
        echo ${_tdir_:0:-2}
    else
        echo ${_tdir_}
    fi
}

_TMP_=$(dirname `pwd`/$0)
WORK_DIR=${_TMP_%/\.}
FILE_NAME=$(basename $0)
LOG_DIR="${WORK_DIR}/logs"
LOG_FILE="${LOG_DIR}/${FILE_NAME}.log"
if [ ! -d ${LOG_DIR} ]
then
    mkdir ${LOG_DIR}
fi
chmod 777 ${LOG_DIR}



IS_DEFAULT=true
CONFIGS=("basic" "repo" "basic_packages")

while true
do
    case $plan in 
        all|--all|-a )
            CONFIGS=("basic" "static_ip" "hostname" "repo" "basic_packages" "firewall" "ssh")
            IS_DEFAULT=false
            break
            ;;
        basic|--basic|-b|default|--default|-d )
            CONFIGS=("basic" "repo" "basic_packages" "firewall" "ssh")
            IS_DEFAULT=true
            break
            ;;
        * )
            echo "argument is error"
            exit 1
            ;;
    esac
done
exit 1
echo "\n--------------------'root' permission--------------------"
while true
do
    read -p "Do you use default configuration?[Y/N] " df
    case $df in
        [Yy]* )
            IS_DEFAULT=true
            break
            ;;
        [Nn]* )
            IS_DEFAULT=false
            CONFIGS=("vim")
            break
            ;;
        "" )
            IS_DEFAULT=true
            break
            ;;
        * )
            echo "Invalid selection: " $df 
            ;;
    esac
done

if $IS_DEFAULT
then
    echo ${CONFIGS[@]}
else
    echo ${CONFIGS[@]}
fi

for val in ${CONFIGS[@]}
do
    if [ $val == "basic" ]
    then
        echo "bash ${WORK_DIR}/basic.sh $WORK_DIR"
        #bash ${WORK_DIR}/basic.sh $WORK_DIR
    elif [ $val == "repo" ]
    then
        echo "bash ${WORK_DIR}/repo.sh $WORK_DIR"
        #bash ${WORK_DIR}/repo.sh $WORK_DIR
    elif [ $val == "basic_packages" ]
    then
        echo "bash ${WORK_DIR}/basic_packages.sh $WORK_DIR"
    fi
done

chmod 755 ${WORK_DIR}/download.sh
bash ${WORK_DIR}/download.sh $WORK_DIR

exit
#------------------------------------------------------------------------------
# FUNCTION: log 
# DESCRIPTION:  log to LOG_FILE
#------------------------------------------------------------------------------
function log()
{
    echo `date '+%Y-%m-%d %H:%M:%S'` $*
    echo `date '+%Y-%m-%d %H:%M:%S'` $* >> ${LOG_FILE}
}


#-----------------------------------Run----------------------------------------
function str2time()
{
    res=$(eval $1)
    echo $res
}
for df in {28..4} ;
do
    run_date=`date +%Y%m%d`
    run_mon=$(str2time "date '+%Y%m' -d '-${df} hours'")
    run_day=`date +%Y%m%d`
    run_hour=$(str2time "date '+%Y%m%d%H' -d '-${df} hours'")
    database="yndx_4g.db" table="mr_table_${run_mon}"
    itime="itime=${run_hour}"
    hdfs_home="hdfs://192.168.1.131:8020"
    hdfs dfs -ls ${hdfs_home}/
    if [ $? -ne 0 ]
    then
        hdfs_home="hdfs://192.168.1.132:8020"
        hdfs dfs -ls ${hdfs_home}/
        if [ $? -ne 0 ]
        then
            log "First namenode and second namenode are useless!"
            exit 1
        fi
    fi
    impala_dir="${hdfs_home}/home/user/hive/warehouse"
    data_dir="${impala_dir}/${database}/${table}/${itime}/*"

    spark-submit ${WORK_DIR}/src/monitor.py -p $data_dir -t $run_hour
    if [ $? -ne 0 ]
    then
        log "process ${run_hour} failed"
        exit 1
    fi
    log "process ${run_hour} succeed"
done
