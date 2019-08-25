# portapotty

## "shit out" your deployments
```
git clone --depth=1 git@github.com:deloachcd/portapotty.git &&\
	cd portapotty &&\
	chmod u+x ./deploy.sh &&\
	./deploy.sh &&\
	cd ..
```

## create a "potty" to add deployment logic for a piece of software
```
	source pottyfunctions.sh && mkpotty [name_of_software]
```

## create a fake deployment to test your deployment logic

```
	source pottyfunctions.sh && fake_deploy
```
