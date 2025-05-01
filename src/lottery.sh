#!/bin/bash

#generate number 1-49 
generate_random_number() {
    while :; do
        num=$(dd if=/dev/random bs=1 count=1 status=none | od -A n -t u1 | tr -d ' ')
        if [[ $num -ge 1 && $num -le 49 ]]; then
            echo $num
            return
        fi
    done
}

#generate 7 random number 
declare -a numbers
while [[ ${#numbers[@]} -lt 7 ]]; do
    rand=$(generate_random_number)
    if [[ ! " ${numbers[@]} " =~ " $rand " ]]; then
        numbers+=($rand)
    fi
done
#sort it to lowest to highest
IFS=$'\n' sorted=($(sort -n <<<"${numbers[*]}"))
unset IFS
echo "${sorted[*]}"
