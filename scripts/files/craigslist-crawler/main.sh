#!/bin/bash

while [[ ! -z "$1" ]]; do
    ARG="$1"
    if [[ "$ARG" =~ "minprice" ]]; then
	echo ""
    fi
    shift
done
exit

curl https://denver.craigslist.org/search/cto?max_price=5000&auto_drivetrain=3
