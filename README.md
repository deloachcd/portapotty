# portapotty

## what is this?
"ultra low-overhead" deployment solution for stuff I use.
basically just a set of convenience functions and a directory
layout for scripting automated deployment of software packages
and configurations.

## "shit out" all deployments
```
git clone --depth=1 git@github.com:deloachcd/portapotty.git &&\
	cd portapotty &&\
	chmod u+x ./deploy.sh &&\
	./deploy.sh &&\
	cd ..
```

## create a "potty" to add deployment logic for a piece of software
```
	source ./potty/activate && mkpotty [name_of_software]
```

## create a fake deployment to test your deployment logic

```
	source ./potty/activate && fake_deploy
```
