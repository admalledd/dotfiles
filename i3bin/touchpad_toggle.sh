#!/bin/bash
TOUCHPAD_ID=$(xinput |grep "TouchPad"|python -c "import sys;sys.stdout.write('%s'%sys.stdin.read().split('\t')[1].split('=')[1])")
TOUCH_STATE=$(xinput list-props $TOUCHPAD_ID|grep "Device Enabled"|python -c "import sys;print sys.stdin.read().split()[-1]")

#if we got a command line, force that state rather than toggling (eg force disable on i3 start)

echo "$1"

if [[ "$1" == "disable" || "$1" == "off"  || "$1" == "0" ]]; then
    echo "disabling touchpad (via cmdline opt)"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 0
    exit
elif [[ "$1" == "enable"  || "$1" == "on"  || "$1" == "1" ]]; then
    echo "enabling touchpad (via cmdline opt)"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 1
    exit
fi

if [[ "$TOUCH_STATE" -eq "0" ]]; then
    echo "enabling touchpad"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 1
elif [[ "$TOUCH_STATE" -eq "1" ]]; then
    echo "disabling touchpad"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 0
fi

