#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
	HOME_VAR='$HOME'
	POTTYNAME="$1"
	mkdir "$POTTYNAME"
	cd "$POTTYNAME"
	touch apt-packages.sh
	printf "#!/bin/bash\n\n" > hooks.sh
	cd ..
}

get_local_flags() {
	LOCAL_FLAGS=""
	while read flag; do
		if [[ ! "$flag" =~ "#" ]]; then
			LOCAL_FLAGS="$flag $LOCAL_FLAGS"
		fi
	done < <(cat "$1")
}

install_packages_from_all_potties() {
	APT_PACKAGES=""
	while read package_list; do
		while read package; do
			APT_PACKAGES="$(eval printf "$package") $APT_PACKAGES"
		done < <(cat "$package_list")
	done < <(find . | grep 'apt-packages')
	sudo apt update
	sudo apt install $APT_PACKAGES
}

fake_deploy() {
	# Always run this from project root
	FLAGS="$@"
	REALHOME="$HOME"
	FAKEHOME="$(pwd)/fake_deployments/deployment_$(date +%s)"
	mkdir -p "$FAKEHOME"
	env HOME="$FAKEHOME" ./deploy.sh "$FLAGS"
	HOME="$REALHOME"
}

clean_fakes() {
	rm -r ./fake_deployments/*
}

deploy_dotfile() {
    SRC="$1"
    DST="$2"
    cp "$SRC" "$DST"
    cat >> "$HOME/.local/bin/push-up" << EOF
if [[ -e "$DST" ]]; then
    cp "$DST" "$SRC"
fi
EOF
}
