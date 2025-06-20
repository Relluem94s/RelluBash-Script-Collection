#!/bin/bash
function keychar {
    parin1=$1 #first param; abc1
    parin2=$2 #second param; 0=a, 1=b, 2=c, 3=1, 4=a, ...
    parin2=$((parin2)) #convert to numeric
    parin1len=${#parin1} #length of parin1
    parin2pos=$((parin2 % parin1len)) #position mod
    char=${parin1:parin2pos:1} #char key to simulate
    if [ "$parin2" -gt 0 ]; then #if same key pressed multiple times, delete previous char; write a, delete a write b, delete b write c, ...
        ydotool key "BackSpace"
    fi
    #special cases for xdotool ( X Keysyms )
    if [ "$char" = " " ]; then char="space"; fi
    if [ "$char" = "." ]; then char="period"; fi
    if [ "$char" = "-" ]; then char="minus"; fi
    ydotool key $char
}
datlastkey=$(date +%s%N)
strlastkey=""
strlastid=""
intkeychar=0
intmsbetweenkeys=2000 #two presses of a key sooner that this makes it delete previous key and write the next one (a->b->c->1->a->...)
intmousestartspeed=10 #mouse starts moving at this speed (pixels per key press)
intmouseacc=10 #added to the mouse speed for each key press (while holding down key, more key presses are sent from the remote)
intmousespeed=30

while read oneline
do
    keyline=$(echo $oneline | grep " key ")
    #echo $keyline --- debugAllLines
    if [ -n "$keyline" ]; then
        datnow=$(date +%s%N)
        datdiff=$((($datnow - $datlastkey) / 1000000)) #bla bla key pressed: previous channel (123)
        strkey=$(grep -oP '(?<=sed: ).*?(?= \()' <<< "$keyline") #bla bla key pres-->sed: >>previous channel<< (<--123)
        strstat=$(grep -oP '(?<=key ).*?(?=:)' <<< "$keyline") #bla bla -->key >>pressed<<:<-- previous channel (123)
        strpressed=$(echo $strstat | grep "pressed")
        strreleased=$(echo $strstat | grep "released")
        if [ -n "$strpressed" ]; then
            strid=$(grep -oP '(\[ ).*?(\])' <<< "$keyline") # get the id from the debug line to ingnore dupe detection.
            #echo $keyline --- debug
            if [ "$strkey" = "$strlastkey" ] && [ "$datdiff" -lt "$intmsbetweenkeys" ]; then
                intkeychar=$((intkeychar + 1)) #same key pressed for a different char
            else
                intkeychar=0 #different key / too far apart
            fi
            datlastkey=$datnow
            strlastkey=$strkey
            if [ "$strid" != "$strlastid" ]; then
                case "$strkey" in
                    "1")
                        ydotool key "BackSpace"
                        ;;
                    "2")
                        keychar "abc2" intkeychar
                        ;;
                    "3")
                        keychar "def3" intkeychar
                        ;;
                    "4")
                        keychar "ghi4" intkeychar
                        ;;
                    "5")
                        keychar "jkl5" intkeychar
                        ;;
                    "6")
                        keychar "mno6" intkeychar
                        ;;
                    "7")
                        keychar "pqrs7" intkeychar
                        ;;
                    "8")
                        keychar "tuv8" intkeychar
                        ;;
                    "9")
                        keychar "wxyz9" intkeychar
                        ;;
                    "0")
                        keychar " 0.-" intkeychar
                        ;;
                    "previous channel")
                        ydotool key "Return" #Enter
                        ;;
                    "channel up")
                        ydotool click 4 #mouse scroll up
                        ;;
                    "channel down")
                        ydotool click 5 #mouse scroll down
                        ;;
                    "channels list")
                        ydotool click 3 #right mouse button click
                        ;;
		            "up")
                        ydotool mousemove -x 0 -y$(( 0 - intmousespeed ))
                        intmousespeed=$((intmousespeed + intmouseacc))
                        ;;
                    "down")
                        ydotool mousemove -x 0 -y$intmousespeed
                        intmousespeed=$((intmousespeed + intmouseacc))
                        ;;
                    "left")
                        ydotool mousemove -x$(( 0 - intmousespeed )) -y 0
                        intmousespeed=$((intmousespeed + intmouseacc))
                        ;;
                    "right")
                        ydotool mousemove -x$intmousespeed -y 0
                       intmousespeed=$((intmousespeed + intmouseacc))
                        ;;
                    "select")
                        ydotool click 0x40 #left mouse button click
			ydotool click 0x80
                        ;;
                    "return")
                        ydotool key "Alt_L+Left" #WWW-Back
                        ;;
                    "exit")
                        echo Key Pressed: EXIT
                        ;;
                    "F2")
                        echo Key Pressed: F4
                        ;;
                    "F3")
                        echo Key Pressed: F3
                        ;;
                    "F4")
                        echo Key Pressed: YELLOW C
                        sync;sync;shutdown -h now
                        ;;
                    "F1")
                        echo Key Pressed: F1
                        ;;
                    "rewind")
                        echo Key Pressed: REWIND
			            ydotool key "Left"
                        ;;
                    "pause")
                        echo Key Pressed: PAUSE
        		        ydotool key "k"
                        ;;
                    "Fast forward")
                        echo Key Pressed: FAST FORWARD
		            	ydotool key "right"
                        ;;
		    "forward")
                        echo Key Pressed: forward
                        
                        ;;
		    "backward")
                        echo Key Pressed: backward
		                ydotool key "f"
                        ;;
                    "play")
                        echo Key Pressed: PLAY
        		        ydotool key "k"
                        ;;
                    "stop")
                        ## with my remote I only got "STOP" as key released (auto-released), not as key pressed; see below
                        echo Key Pressed: STOP
                        ;;
                    *)
                        echo Unrecognized Key Pressed: $strkey ; CEC Line: $keyline
                        ;;

                esac
            else
                echo Ignoring key $strkey with duplicate id $strid
            fi
            # store the id of the keypress to check for duplicate press count.
            strlastid=$strid
        fi
        if [ -n "$strreleased" ]; then
            #echo $keyline --- debug
            case "$strkey" in
                "stop")
                    echo Key Released: STOP
                    ;;
		 "up"|"down"|"left"|"right")
                    intmousespeed=$intmousestartspeed #reset mouse speed
                    ;;
            esac
        fi
    fi
done

