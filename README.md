# portapotty
![portapotty-logo](https://github.com/deloachcd/img/blob/master/portapotty-logo.png?raw=true)

*"portapotty is the Gentoo of version controlling your Linux command line tools" - me*

## how it works
1. create directories for storing dotfiles, pulling remote objects, etc.
2. specify dependencies for deploying your software in `packages.yml`
3. write logic for deploying your software in `hooks.sh` scripts
4. run `deploy.sh` to deploy your software, and push-up to update the repo

## ...what?
Just skim over `pottyfunctions.sh` and `deploy.sh` and you'll be able to
get it. Portapotty is designed on the principle of Aggressively Simple
Software, or ASS. It will never be some multiple hundred line behemoth
that calls python, perl, and imports half of the node ecosystem unless
someone forks this thing and turns it into the cornerstone of their
startup company's value proposition.
