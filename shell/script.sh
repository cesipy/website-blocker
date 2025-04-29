#!/usr/bin/env bash

#TODO:
# - add a check if the script is run as root
# - cron job to continously reapply blocks

# get the full directory name, no matter from there the script is called. 
#https://stackoverflow.com/a/246128
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPLACEMENT_IP="127.0.0.1"

if [ "$1" == "block" ]; then
    backup="/etc/hosts.backup"
    # check if there is already a backup file. If yes => blocks are already added, cannot be added again
    if [ -f $backup ]; then
        echo "Backup file already exists. Please run 'sudo $0 unblock' first"
        exit 1
    fi

    # creating backup of current /etc/hosts file
    cp /etc/hosts $backup

    # subdomains that are blocked aswell. in hosts there is only domain, i.e. google.com. 
    # we also want to block www.google.com, etc
    SUBDOMAINS=(www m de at)

    echo "# custom entries (for blocking, see \$CODING/github/website-blocker">> /etc/hosts
    echo "# or 'https://github.com/cesipy/website-blocker')">> /etc/hosts

    while IFS= read -r line; do
        # echo "processing $line"
        echo "$REPLACEMENT_IP $line" >> /etc/hosts

        # block the subdomains
        for ((i=0; i<${#SUBDOMAINS[@]}; i++)); do
            echo "$REPLACEMENT_IP ${SUBDOMAINS[$i]}.$line" >> /etc/hosts
        done

    done < "$SCRIPT_DIR/hosts.txt"
    echo "finished"

elif [ "$1" == "unblock" ]; then 
    if [ ! -f /etc/hosts.backup ]; then
        echo "No backup file found. Please run 'sudo $0 block' first"
        exit 1
    fi

    cp /etc/hosts.backup /etc/hosts
    rm /etc/hosts.backup

    echo "finished"

else 
    echo "Please provide a valid argument: block or unblock"
    exit 1
fi
