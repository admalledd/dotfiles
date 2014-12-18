#☼
export BL_STEPS=20
case $BLOCK_BUTTON in
    1) # left click,
        /home/admalledd/bin/chbright.sh +        
        ;;
    2) # middle click
        /home/admalledd/bin/chbright.sh 100        
        ;;  
    3) # right click, 
        /home/admalledd/bin/chbright.sh -        
        ;; 
    
esac

echo "$(/home/admalledd/bin/chbright.sh -n)" 
