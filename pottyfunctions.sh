#!/bin/bash
# This function should only be sourced, not executed!

mkpotty() {
	POTTYNAME="$1"
	mkdir "$POTTYNAME"
	cd "$POTTYNAME"
	touch apt-packages.sh
	cat > hooks.sh << EOF
#!/bin/bash

if [[ -e "$HOME/.local/share/portapotty/$POTTYNAME" ]]; then
	echo "Skipping deployment for '$POTTYNAME'... (already present)"
	exit
fi

## deploy {

## }

touch "$HOME/.local/share/portapotty/$POTTYNAME"
EOF
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
