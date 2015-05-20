#!/bin/bash

#Script to help with setting up extended multimonitors automatically

#when using nvidia GPU to drive displays
LAPTOP="eDP-1-0"
HDMI="HDMI-1-1"
DISPLAYPORT="HDMI-1-0"

#when using intel GPU to drive displays
#LAPTOP="eDP1"
#HDMI="HDMI2"
#DISPLAYPORT="HDMI1"



if [ "$1" = "" ]; then
    echo "I=Internal, H=HDMI, D=DisplayPort"
    echo "please select what settings to do"
    echo "I,IH,ID,IHD,IDH"
elif [ "$1" = "I" ]; then
    echo "Intermal monitor"
    xrandr --output $LAPTOP --auto --output $HDMI --off --output $DISPLAYPORT --off
elif [ "$1" = "IH" ]; then
    echo "Internal, HDMI"
    xrandr --output $LAPTOP --auto --output $HDMI --auto --right-of $LAPTOP --output $DISPLAYPORT --off
elif [ "$1" = "ID" ]; then
    echo "Internal, DisplayPort"
    xrandr --output $LAPTOP --auto --output $DISPLAYPORT --auto --right-of $LAPTOP --output $HDMI --off
elif [ "$1" = "IHD" ]; then
    echo "Internal, HDMI, DisplayPort"
    xrandr --output $LAPTOP --auto --output $HDMI --auto --right-of $LAPTOP --output $DISPLAYPORT --auto --right-of $HDMI
elif [ "$1" = "IDH" ]; then
    echo "Internal, HDMI, DisplayPort"
    xrandr --output $LAPTOP --auto --output $DISPLAYPORT --auto --right-of $LAPTOP --output $HDMI --auto --right-of $DISPLAYPORT

fi
