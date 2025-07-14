#!/bin/bash

# Check if both arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: ./script.sh <vnc_username> <port_number>"
    exit 1
fi

vncuser=$1
portnum=$2
vncport=$((5900 + portnum))
service_file="/etc/systemd/system/vnc-${vncuser}.service"

echo "Disabling VNC service for user: $vncuser"
systemctl disable vnc-${vncuser}.service

echo "Removing service file: $service_file"
rm -f "$service_file"

echo "Reloading systemd daemon"
systemctl daemon-reload

echo "Deleting UFW rule for port $vncport"
ufw delete allow ${vncport}/tcp

echo "Reloading UFW"
ufw reload

echo "VNC service cleanup for user '$vncuser' on port $vncport completed."
