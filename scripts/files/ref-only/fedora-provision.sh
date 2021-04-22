#!/bin/bash -e

# Write kernel boot parameters for touchpad
if grep 'GRUB_DEFAULT' /etc/default/grub 1>/dev/null; then
	sed 's/GRUB_DEFAULT=.*/GRUB_DEFAULT="psmouse.synaptics_intertouch=0 quiet splash"/' /etc/default/grub > new-grub-config
else
	cat /etc/default/grub > new-grub-config
	echo 'GRUB_DEFAULT="psmouse.synaptics_intertouch=0 quiet splash"' >>\
		new-grub-config
fi

diff /etc/default/grub new-grub-config
echo "Overwrite /etc/default/grub?"
read OVERWRITE_GRUB

if [[ "$OVERWRITE_GRUB" =~ "Y" || "$OVERWRITE_GRUB" =~ "y" ]]; then
	sudo mv new-grub-config /etc/default/grub
	sudo grub2-mkconfig -o /boot/grub2/grub.cfg
fi

# Install multimedia codecs for video and audio
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plug
sudo dnf install lame\* --exclude=lame-devel
sudo dnf group upgrade --with-optional Multimedia

# Install better fonts
sudo dnf copr enable dawid/better_fonts
sudo dnf install fontconfig-enhanced-defaults fontconfig-font-replacement

cat << EOF
#########################################
$  reboot is required to apply changes  $
#########################################
EOF
