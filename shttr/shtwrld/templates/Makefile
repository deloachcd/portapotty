SHELL:=bash

build:
	env $(cat shttr.conf | xargs) recipe.sh

install:
	ln -sf $PWD/${SHTTR_BUILD_EXECUTABLE} \
		$HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}

	awk '{ gsub(/\$HOME/,ENVIRON["HOME"]); print $1 }' ${SHTTR_PACKAGE_NAME}.desktop >>\
		$HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop

uninstall:
	rm $HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}
	rm $HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
