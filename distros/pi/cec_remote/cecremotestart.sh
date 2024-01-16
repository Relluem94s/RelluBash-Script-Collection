#!/bin/bash

currentUser=$(whoami)

export XAUTHORITY=/home/$currentUser/.Xauthority; export DISPLAY=:0;
cec-client | /home/$currentUser/cecremote.sh
