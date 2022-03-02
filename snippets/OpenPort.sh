#!/bin/bash

echo "Which Port should be opened?"
read port
sudo sudo iptables -A INPUT -p tcp --dport $port -j ACCEPT
sudo netfilter-persistent save
sudo netfilter-persistent reload
