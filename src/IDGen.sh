#!/bin/bash 

filename=$1
interface=$2 

hostname=$(hostname)


macad=$(grep -A 5 "$interface" "$filename" | grep ether | cut -d ' ' -f2) 
echo $macad

echo "Data used to generate ID: $hostname\\$macad"

echo "The generated code: $(echo -n "$hostname\\$macad" | md5sum | cut -c 1-6)"