#!/bin/bash

check_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Warning: $1 not installed!"
        return 1
    fi
    return 0
}

echo 
echo "Host:"
hostname
echo 
echo "OS:"
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$NAME $VERSION"
fi
echo 
echo "Kernel:"
echo "$(uname -r)"
echo 
echo "IP"
if check_command curl; then
    curl -s ifconfig.me || echo "No internet Connection"
else
    echo "N/A curl is missing"
fi
echo
echo 
echo "Network:"
if check_command ip; then
    ip link show | grep "state UP" | awk '{print $2}' | sed 's/://' | while read -r iface; do
        echo "Interface $iface: Active"
    done
else
    echo "N/A ip is missing"
fi
echo 
echo "CPU:"
if check_command lscpu; then
    echo "Model > $(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
    echo "Cores > $(lscpu | grep 'Core(s) per socket' | awk -F: '{print $2}' | xargs)"
    echo "MHz > $(lscpu | grep 'CPU max MHz' | awk -F: '{print $2}' | xargs || echo 'N/A')"
else
    cat /proc/cpuinfo | grep "model name" | head -1 | awk -F: '{print $2}' | xargs || echo "N/A"
fi
echo 
echo "Memory:"
if check_command free; then
    free -h
else
    echo "N/A free is missing"
fi
echo 
if check_command df; then
    df -h --output=source,fstype,size,used,avail,pcent,target | grep -v "tmpfs\|loop"
else
    echo "N/A df is missing"
fi
echo 

