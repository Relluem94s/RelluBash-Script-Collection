#!/bin/bash

###########################################################################################
#                                    Commandline Goodies                                  #
#                                      by Relluem94 2022                                  #
###########################################################################################
#                                                                                         #
# Requires nmcli to run!                                                                  #  
# Sudo required for some operations!
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
options=("Add OVPN File via Network Manager" "Open Port in IP Tables" "Exit")
select opt in "${options[@]}"

do
    case $opt in
        "Add OVPN File via Network Manager")
            ./snippets/AddVPN.sh            
            break
            ;;
            "Open Port in IP Tables")
            ./snippets/OpenPort.sh
            break
            ;;
        "Exit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
