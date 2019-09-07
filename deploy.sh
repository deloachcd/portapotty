#!/bin/bash -x

GLOBAL_FLAGS="$@"

source "./pottyfunctions.sh"

if [[ -d "setup" ]]; then
	# 'setup' always has its hooks run before all other
	# potties
	echo "Running setup hooks..."
	cd ./setup
	chmod u+x ./hooks.sh
	./hooks.sh
	cd ..
fi

# Install from apt-packages.sh file from all potties
install_packages_from_all_potties

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
		if [[ -e "flags" ]]; then
			get_local_flags "flags" # assigns LOCAL_FLAGS
		else
			LOCAL_FLAGS=""
		fi
		./hooks.sh "$GLOBAL_FLAGS" "$LOCAL_FLAGS"
		cd ..
	fi
done < <(ls)
