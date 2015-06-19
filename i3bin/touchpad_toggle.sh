#!/bin/bash
TOUCHPAD_ID=$(xinput |grep "ETPS/2 Elantech Touchpad"|python -c "import sys;sys.stdout.write('%s'%sys.stdin.read().split('\t')[1].split('=')[1])")
TOUCH_STATE=$(xinput list-props $TOUCHPAD_ID|grep "Device Enabled"|python -c "import sys;print sys.stdin.read().split()[-1]")

if [[ "$TOUCH_STATE" -eq "0" ]]; then
    echo "enabling touchpad"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 1
elif [[ "$TOUCH_STATE" -eq "1" ]]; then
    echo "disabling touchpad"
    xinput set-prop $TOUCHPAD_ID "Device Enabled" 0
fi

