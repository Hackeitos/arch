#!/bin/bash

sudo ln -fs /usr/lib/systemd/system/ly.service /etc/systemd/system/display-manager.service
sudo nano /etc/systemd/system/display-manager.service
sudo systemctl daemon-reload
sudo systemctl enable getty@tty1 display-manager

echo "ly installed!"
