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
        
            ###########################################################################
            read client
            sudo nmcli connection import type openvpn file $client.ovpn
            ###########################################################################
            
            break
            ;;
            "Open Port in IP Tables")
        
            ###########################################################################
            read port
            sudo sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
            sudo netfilter-persistent save
            sudo netfilter-persistent reload
            ###########################################################################
            
            break
            ;;
        "Exit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done





