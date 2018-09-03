#☼
export BL_STEPS=20
case $BLOCK_BUTTON in
    1) # left click,
        xbacklight -inc 5 -time 0
        ;;
    2) # middle click
        xbacklight -set 100 -time 250
        ;;  
    3) # right click, 
        xbacklight -dec 5 -time 0
        ;; 
    
esac

echo "$(xbacklight -get | python -c "import sys;print sys.stdin.read().split('.')[0]")" 
