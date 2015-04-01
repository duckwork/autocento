#!/bin/bash

# Variables
OPTIND=1
header=""
blacklist=""

while getopts "h:b:" opt; do
    case "$opt" in
        h)
            header=$OPTARG
            ;;
        b)
            blacklist=$OPTARG
            ;;
    esac
done

shift $((OPTIND - 1))

echo "header = $header"
echo "blacklist = $blacklist"
