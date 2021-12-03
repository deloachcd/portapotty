# portapotty
![portapotty-logo](https://github.com/deloachcd/img/blob/master/portapotty-logo.png?raw=true)

*"portapotty is the Gentoo of version controlling your Linux configs" - me*

## what this is
This repo hosts my dotfiles, plus a script `portapotty.sh` which allows me
to string together smaller scripts to version control them and install
the packages they pertain to on my workstations. Symlinks created with
`link_config` within directories created with `ensure_directory_exists` are
the preferred method of tracking these files, as local changes can be
committed to remote as soon as they are made, with no need to replicate
their contents anywhere.

## initial set-up
```
git clone git@github.com:deloachcd/portapotty.git ~/.potty
cd ~/.potty
git submodule init
git submodule update
./portapotty.sh
```
