#!/bin/bash
#
# 0xskar nmap scanner (c) 2023

# Check if user is root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit
fi

# Check if target IP address was provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <target_ip>"
    exit 1
fi

# Define target IP address
target_ip="$1"
echo "Target IP address: $target_ip"

# Perform initial port scan to discover open ports
nmap -T4 -p- $target_ip -vvv -oN /tmp/scan_results.txt
open_ports=$(grep '[^0-9]' /tmp/scan_results.txt | cut -d '/' -f 1 | grep '^[0-9]' | tr '\n' ',' | sed s/,$//)
rm /tmp/scan_results.txt
echo "Open ports: $open_ports"

# Run additional scans on open ports
if [ -n "$open_ports" ]; then
    nmap -v -sC -sV -O -p$open_ports $target_ip -vvv
else
    echo "No open ports found on target"
fi
