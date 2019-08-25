#!/bin/bash

source ./pottyfunctions.sh

# Install from apt-packages.sh file from all potties
install_packages_from_all_potties

while read file; do
	if [[ -d "$file" ]]; then
		# If file is directory, assume it's a potty
		POTTY="$file"
		cd "$POTTY"
		chmod u+x ./hooks.sh
		./hooks.sh
		cd ..
	fi
done < <(ls)
