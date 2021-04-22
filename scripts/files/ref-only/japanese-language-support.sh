#!/bin/bash -e

sudo apt install ibus ibus-mozc im-config

# Enable ibus for input method selection
cat >> .xprofile << EOF
# Settings for Japanese input
export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export XMODIFIERS=@im='ibus'
EOF
im-config -n ibus

# Install MeCab and UniDic for Japanese NLP
mkdir jp_provision_container
cd jp_provision_container

# MeCab
git clone git@github.com:taku910/mecab.git
cd mecab/mecab
./configure --enable-utf8-only && make
sudo make install
cd ../..

# UniDic
wget https://unidic.ninjal.ac.jp/unidic_archive/cwj/2.1.2/unidic-mecab-2.1.2_src.zip 
unzip unidic-mecab-2.1.2_src.zip
cd unidic-mecab-2.1.2_src
sudo apt install libmecab2
./configure && make
sudo make install
