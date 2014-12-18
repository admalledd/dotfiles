#!/bin/bash

if [[ $(ip -o -4 addr show dev eth0) == "" ]]; then
    echo "eth0 down" 
else
    ip -o -4 addr show dev eth0|python -c "import sys;print sys.stdin.read().split()[3].split('/')[0]"
fi
