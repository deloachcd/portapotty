#!/bin/bash

source ./pottyfunctions.sh

# Install from apt-packages.sh file from all potties
install_packages_from_all_potties

if [[ -d "setup" ]]; then
	# 'setup' always has its hooks run before all other
	# potties
	cd ./setup
	chmod u+x ./hooks.sh
	./hooks.sh
	cd ..
fi

while read file; do
	if [[ -d "$file" && ! "$file" =~ "setup" ]]; then
		# If file is non-setup directory, assume it's a potty
		# and run its hooks
		POTTY="$file"
		cd "$POTTY"
		chmod u+x ./hooks.sh
		./hooks.sh
		cd ..
	fi
done < <(ls)
