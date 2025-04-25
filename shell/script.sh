#!/usr/bin/env bash

# get the full directory name, no matter from there the script is called. 
#https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPLACEMENT_IP="127.0.0.1"


while IFS= read -r line; do
    echo "processing $line"
    sudo echo "$REPLACEMENT_IP $line" >> /etc/hosts
done < "$SCRIPT_DIR/hosts.txt"

