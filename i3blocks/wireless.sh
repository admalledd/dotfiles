#!/bin/bash

if [[ $(iwgetid -r) == "" ]]; then
    echo "WifiDown" 
else
    echo \"$(iwgetid -r)\"  $(ip -o -4 addr show dev wlan0 |python -c "import sys;print sys.stdin.read().split()[3].split('/')[0]")
fi
