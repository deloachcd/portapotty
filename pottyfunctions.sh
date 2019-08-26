#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
	POTTYDIR="$1"
	mkdir "$POTTYDIR"
	cd "$POTTYDIR"
	mkdir binaries
	mkdir dotfiles
	touch apt-packages.sh
	printf "#!/bin/bash\n\n" > hooks.sh
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
	# Always run this from project root
	REALHOME="$HOME"
	FAKEHOME="$(pwd)/fake_deployments/deployment_$(date +%s)"
	mkdir -p "$FAKEHOME"
	env HOME="$FAKEHOME" ./deploy.sh
	HOME="$REALHOME"
}

clean_fakes() {
	rm -r ./fake_deployments/*
}
