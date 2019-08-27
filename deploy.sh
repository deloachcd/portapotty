#!/bin/bash -x

source "./pottyfunctions.sh"

# Install from apt-packages.sh file from all potties
install_packages_from_all_potties

if [[ -d "setup" ]]; then
	# 'setup' always has its hooks run before all other
	# potties
	echo "Running setup hooks..."
	cd ./setup
	chmod u+x ./hooks.sh
	./hooks.sh
	cd ..
fi

while read file; do
	if [[ -d "$file" && \
			! "$file" =~ "setup" && \
			! "$file" =~ "fake_deployments" ]]; then
		# If file is non-setup directory, assume it's a potty
		# and run its hooks
		POTTY="$file"
		echo "Running '$POTTY' hooks..."
		cd "$POTTY"
		chmod u+x ./hooks.sh
		./hooks.sh
		cd ..
	fi
done < <(ls)
