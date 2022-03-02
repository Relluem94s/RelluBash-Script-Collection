#!/bin/bash

read client
sudo nmcli connection import type openvpn file $client.ovpn
