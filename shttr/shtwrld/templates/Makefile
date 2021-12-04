SHELL:=bash

build:
	env $(cat shttr.conf | xargs) recipe.sh

install:
	ln -sf $PWD/${SHTTR_BUILD_EXECUTABLE} \
		$HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}

	env SED_FRIENDLY_HOME=$(echo $HOME | awk '{ gsub(/\//,"\\/"); print $1 }') \
		sed "s/\$HOME/$SED_FRIENDLY_HOME/g" emacs.desktop >> \
		$HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop

uninstall:
	rm $HOME/.local/share/bin/${SHTTR_PACKAGE_NAME}
	rm $HOME/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
