#!/bin/bash

###########################################################################################
#                                          OpenPort                                       #
#                                     by Relluem94 2022                                   #
###########################################################################################
#                                                                                         #
#                                                                                         #
# This Program will open a port via iptables                                              #
#                                                                                         #
###########################################################################################
#                                     DO NOT TOUCH THE CODE                               #
###########################################################################################
#
#
#
echo "Which Port should be opened?"
read port
sudo sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
sudo netfilter-persistent save
sudo netfilter-persistent reload
#
#
#
###########################################################################################
#                                           END OF CODE                                   #
###########################################################################################
