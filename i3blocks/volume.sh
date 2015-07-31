#!/bin/bash

#GTK2_RC_FILES=/home/admalledd/.i3/gtk2_darktheme_override.gtkrc-2.0 GTK_THEME=Darklooks
# yad --text="Volume" --scale --value 25 --button gtk-ok:0 --geometry=32x220+55+500 --class "YADWIN" --vertical --text-align center

pulsectl=/home/admalledd/bin/pulseaudio-ctl

if [[ $1 = "head" ]]; then

    case $BLOCK_BUTTON in
        1)
            $pulsectl up
            ;;
        2)
            $pulsectl mute
            ;;
        3)
            $pulsectl down
            ;;  
            #amixer -q -D $MIXER sset $SCONTROL $(capability) toggle ;; # right click, mute/unmute
    esac

    if [ $($pulsectl cm) = "yes" ];then
        echo "🎧 M $($pulsectl c)"
    else
        echo "🎧 $($pulsectl c)"
    fi

elif [[ $1 = "mic" ]]; then

    case $BLOCK_BUTTON in
        1) 
            #SETVOL=$(yad --text="Volume" --scale --value 25 --button gtk-ok:0 --geometry=55x200+${BLOCK_X}-25 --class "YADWIN" --vertical --text-align center)
            #$pulsectl 
            ;;
        2)
            $pulsectl mi
            ;;
        3)
            ;;
    esac
    if [ $($pulsectl cim) = "yes" ];then
        echo "🎤 M $($pulsectl ci)"
    else
        echo "🎤 $($pulsectl ci)"
    fi
fi
#sleep .25