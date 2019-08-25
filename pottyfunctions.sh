#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
	POTTYDIR="$1"
	mkdir "$POTTYDIR"
	cd "$POTTYDIR"
	mkdir binaries
	mkdir dotfiles
	touch apt-packages.sh
	touch hooks.sh
	cd ..
}

install_packages_from_all_potties() {
	APT_PACKAGES=""
	while read package_list; do
		while read package; do
			APT_PACKAGES="$(eval printf "$package") $APT_PACKAGES"
		done < <(cat "$package_list")
	done < <(find . | grep 'apt-packages')
	sudo apt install $APT_PACKAGES
}

fake_deploy() {
	REALHOME="$HOME"
	FAKEHOME="fake_deployments/deployment_$(date +%s)"
	mkdir -p "$FAKEHOME"
	env HOME="$FAKEHOME" ./deploy.sh
	HOME="$REALHOME"
}

# install_packages() {
# 	PACKAGE_INSTALL_LIST="$1"
# 	APT_PACKAGES=""
# 	while read line; do
# 		if [[ ! "$line" =~ "#" ]]; then  # Ignore comments
# 			APT_PACKAGES="$(eval printf "$line") $APT_PACKAGES"
# 		fi
# 	done < "$PACKAGE_INSTALL_LIST"
# 	sudo apt install -y "$APT_PACKAGES"
# }

