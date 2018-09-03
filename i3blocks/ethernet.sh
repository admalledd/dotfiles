#!/bin/bash

if [[ $(ip -o -4 addr show dev enp59s0) == "" ]]; then
    echo "enp59s0 down" 
else
    ip -o -4 addr show dev enp59s0|python -c "import sys;print sys.stdin.read().split()[3].split('/')[0]"
fi
