SHELL:=bash

build:
	env $(cat shttr.conf | xargs) recipe.sh

install:
	ln -sf $PWD/${SHTTR_BUILD_EXECUTABLE} \
		$HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}

	if [[ -e ${SHTTR_PACKAGE_NAME}.desktop ]]; then
		awk '{ gsub(/\$HOME/,ENVIRON["HOME"]); print $1 }' ${SHTTR_PACKAGE_NAME}.desktop >>\
			$HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
	fi

	if [[ -e icon.png ]]; then
		cp icon.png $HOME/.local/share/icons/hicolor/256x256/apps/${SHTTR_PACKAGE_NAME}.png
	elif [[ -e ${SHTTR_PACKAGE_NAME}.png ]]; then
		cp ${SHTTR_PACKAGE_NAME}.png $HOME/.local/share/icons/hicolor/256x256/apps/${SHTTR_PACKAGE_NAME}.png
	fi

uninstall:
	rm $HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}
	rm $HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
