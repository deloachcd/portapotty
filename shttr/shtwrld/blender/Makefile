SHELL:=bash

build:
	env $(cat shttr.conf | xargs) recipe.sh

install:
	ln -sf $PWD/${SHTTR_BUILD_EXECUTABLE} $HOME/.local/share/bin/${SHTTR_APP_NAME}

uninstall:
	rm $HOME/.local/share/bin/${SHTTR_APP_NAME}
