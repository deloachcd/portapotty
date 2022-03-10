SHELL:=bash
.PHONY: build

build:
	bash build-recipe.sh

install:
	test ! -z "${SHTTR_BUILD_EXECUTABLE}"

	bash link-binaries.sh "${SHTTR_BUILD_EXECUTABLE}" "${HOME}/.local/bin"

	if [[ -e ${SHTTR_PACKAGE_NAME}.desktop ]]; then \
		awk '{ gsub(/\$$HOME/,ENVIRON["HOME"]); print $0 }' ${SHTTR_PACKAGE_NAME}.desktop >\
			${HOME}/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop; \
	elif [[ -e default.desktop ]]; then \
		awk '{ gsub(/\$$HOME/,ENVIRON["HOME"]); print $0 }' default.desktop >\
			${HOME}/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop; \
	fi

	if [[ ! -d ${HOME}/.local/share/icons/hicolor/256x256/apps ]]; then \
		mkdir -p ${HOME}/.local/share/icons/hicolor/256x256/apps/; \
	fi
	cp pixmaps/* ${HOME}/.local/share/icons
	cp pixmaps/* ${HOME}/.local/share/icons/hicolor/256x256/apps/

uninstall:
	rm ${HOME}/.local/share/bin/${SHTTR_PACKAGE_NAME}
	rm ${HOME}/.local/share/applications/${SHTTR_PACKAGE_NAME}.desktop
