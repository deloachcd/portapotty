#!/bin/bash
# This script is designed to install GLFW3 for C++ projects development
# to run on Ubuntu 20.04.
#
# Ensure that /etc/apt/sources.list has "deb-src" lines commented
# out before running this, so that build dependencies for GLFW3
# can be installed by the package manager (it's either universe or
# multiverse)
export GLFW_HOME=$HOME/.local/include/glfw
sudo apt build-dep -y glfw3
sudo apt install -y xorg-dev
if [[ ! -d $GLFW_HOME ]]; then
    git clone https://github.com/glfw/glfw.git $GLFW_HOME
fi
cd $GLFW_HOME
cmake -G "Unix Makefiles" .
make
