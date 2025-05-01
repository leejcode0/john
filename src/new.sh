#!/bin/bash 

greetings() { 
    local func_name="${FUNCNAME[0]}"

    if (($# == 1)); then
        echo "hello, $1"
    else
        echo "usage :  name"
    fi 
}

#!/bin/bash 

greetings() { 
    local func_name="${FUNCNAME[0]}"

    if (($# == 1)); then
        echo "hello, $1"
    else
        echo "usage : ${FUNCNAME[0]} name"
    fi 
}

greetings "$@"

multiplyints() { 
local result=1 
for num in "$@" 
do result=$((result*num))
done 
echo $result 
}

calcsum() { 
local result=0
for num in "$@"; do
do result=$((result+num))
}