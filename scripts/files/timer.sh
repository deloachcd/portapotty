#!/bin/bash

T_STR="$1"
T_HOURS=$(echo $T_STR | awk -F ':' '{ print $1 }')
T_MINUTES=$(echo $T_STR | awk -F ':' '{ print $2 }')
T_SECONDS=$(echo $T_STR | awk -F ':' '{ print $3 }')

# Sum time into seconds to make counting easier
T_SECONDS=$((T_SECONDS+(T_HOURS*3600)+(T_MINUTES*60)))

pad_numeric() {
    if [[ "${#1}" -lt 2 ]]; then
        printf "0$1"
    else
        printf "$1"
    fi
}

clear
printf "00:00:00\r"
total_seconds=0; n_seconds=0; n_minutes=0; n_hours=0;
while [[ $total_seconds -lt $T_SECONDS ]]; do
    sleep 1
    # internal program count
    total_seconds=$((total_seconds+1))
    # count displayed to user
    n_seconds=$((n_seconds+1))
    if [[ $n_seconds -eq 60 ]]; then
        n_seconds=0
        n_minutes=$((n_minutes+1))
        if [[ $n_minutes -eq 60 ]]; then
            n_minutes=0
            n_hours=$((n_hours+1))
        fi
    fi
    printf "$(pad_numeric $n_hours):"
    printf "$(pad_numeric $n_minutes):"
    printf "$(pad_numeric $n_seconds)\r"
done
echo
