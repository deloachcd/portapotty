# portapotty
![portapotty-logo](https://github.com/deloachcd/img/blob/master/portapotty-logo.png?raw=true)

*"what the hell is all this shit" - anyone stumbling onto this repo*

## what this is
This started out as a script/repo for managing dotfiles for various
programs I use on Linux, and gradually grew into automatically
installing relevant packages, supporting macOS and containing it's own system
for automating builds for stuff I use like emacs and blender
(currently known as `dsht`, short for Dandified SHiTter). It supports
multiple distros of Linux, but they've have to really fuck up
Debian at this point for me to have any desire to migrate now that it
ships with a reasonably stable version of KDE in `testing`. I might
keep Fedora support just so it supports one .DEB and one .RPM distro,
but why in god's name I ever thought using Arch was a good enough idea
to support it is beyond me.

### TL;DR
This repo will probably be most useful to you if you want to
set up your Debian/macOS exactly like I do, since everything I do has its origin
in the mind of greatness and is the absolute best way to do things ever.

## initial set-up on a new machine
```
git clone git@github.com:deloachcd/portapotty.git ~/.potty
cd ~/.potty
./portapotty.sh -i
```
