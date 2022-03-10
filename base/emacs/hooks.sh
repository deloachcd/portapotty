cd config
git submodule init
git submodule update
cd ..

link_config chemacs2 ~/.emacs.d
link_config config/emacs-profiles.el ~/.emacs-profiles.el
link_config config/doom ~/.config/doom
link_config config/evilmacs ~/.config/emacs
