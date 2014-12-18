#!/bin/bash
TOUCHPAD_ID=$(xinput |grep "ETPS/2 Elantech Touchpad"|python -c "import sys;sys.stdout.write('%s'%sys.stdin.read().split('\t')[1].split('=')[1])")
xinput set-prop $TOUCHPAD_ID "Device Enabled" 0
