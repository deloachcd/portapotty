#!/bin/bash

FLAGS="$@"
if [[ ! "$FLAGS" =~ "with-gui-apps" ]]; then
	exit
fi

VIVALDI_DEB="vivaldi-stable_2.7.1628.30-1_amd64.deb"

# Retrive stable version of Vivaldi browser
wget "https://downloads.vivaldi.com/stable/$VIVALDI_DEB"

# Install Vivaldi browser
sudo dpkg -i "$VIVALDI_DEB"

# Get rid of leftover DEB archive
rm "$VIVALDI_DEB"
