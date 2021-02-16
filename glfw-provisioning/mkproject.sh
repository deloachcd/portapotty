#!/bin/bash
# This script is designed to provision GLFW3 C++ projects on Linux, once
# the library has been installed.
PROJECT_ROOT=$1
if [[ -z $PROJECT_ROOT ]]; then
    echo "USAGE: mkproject.sh <project_root>"
    exit -1
elif [[ ! -d $PROJECT_ROOT ]]; then
    mkdir $PROJECT_ROOT
fi
cp ./CMakeLists.txt $PROJECT_ROOT
touch $PROJECT_ROOT/main.cpp
mkdir $PROJECT_ROOT/include
