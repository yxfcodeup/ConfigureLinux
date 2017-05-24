#!/bin/bash - 
#===============================================================================
#
#          FILE: basic_packages.sh
# 
#         USAGE: ./basic_packages.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 05/12/2017 15:27
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

WORK_DIR=$1

# GCC 系列
yum install gcc                         # C 编译器
yum install gcc-c++                     # C++ 编译器
yum install gcc-gfortran                # Fortran 编译器
yum install compat-gcc-44               # 兼容 gcc 4.4
yum install compat-gcc-44-c++           # 兼容 gcc-c++ 4.4
yum install compat-gcc-44-gfortran      # 兼容 gcc-fortran 4.4
yum install compat-libf2c-34            # g77 3.4.x 兼容库

# 软件开发辅助工具
yum install make
yum install gdb                         # 代码调试器
yum install cmake                       # Cmake
yum install git                         # 版本控制

# NTFS 驱动
yum install ntfs-3g

# Java 环境

# Clang 系列
yum install clang                         # clang 编译器
yum install clang-analyzer                # clang 静态分析器

# NVIDIA驱动
