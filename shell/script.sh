#!/usr/bin/env bash

#TODO:
# - add a check if the script is run as root
# - backup of original file
# - method to check if website-blocker is active. => two modi: one for appending customs, one for removing

# get the full directory name, no matter from there the script is called. 
#https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPLACEMENT_IP="127.0.0.1"

# subdomains that are blocked aswell. in hosts there is only domain, i.e. google.com. 
# we also want to block www.google.com, etc
SUBDOMAINS=(www m)


while IFS= read -r line; do
    echo "processing $line"
    echo "$REPLACEMENT_IP $line" >> /etc/hosts

    # block the subdomains
    for ((i=0; i<${#SUBDOMAINS[@]}; i++)); do
        echo "accessing item: $i , elem is ${SUBDOMAINS[$i]}"
        echo "$REPLACEMENT_IP ${SUBDOMAINS[$i]}.$line" >> /etc/hosts
    done

done < "$SCRIPT_DIR/hosts.txt"

