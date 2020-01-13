# portapotty

## what is this?
bash scripting project for deploying dotfiles and installing apt
packages on a new linux workstation.

## "shit out" all deployments
```
git clone https://github.com/deloachcd/portapotty &&\
	cd portapotty &&\
	./deploy.sh &&\
	cd ..
```

## create a "potty" to add deployment logic for a piece of software
```
	source ./pottyfunctions.sh && mkpotty [name_of_software]
```

## create a fake deployment to test deployment logic

```
	source ./pottyfunctions.sh && fake_deploy
```
