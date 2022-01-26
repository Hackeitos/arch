#!/bin/bash

source common.sh

mkdir -p /etc/systemd/network/

FILE="/etc/systemd/network/20-ethernet.network"

echo "[Match]" > "$FILE"
echo "Name=$ADAPTER" >> "$FILE"
echo >> "$FILE"
echo "[Network]" >> "$FILE"
echo "Address=$IP" >> "$FILE"
echo "Gateway=$GATEWAY" >> "$FILE"
for i in $DNS; do echo "DNS=$i" >> "$FILE"; done

sleep 5

systemctl enable systemd-networkd systemd-resolved
systemctl restart systemd-networkd systemd-resolved
