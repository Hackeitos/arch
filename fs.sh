#!/bin/bash

source common.sh

shopt -s dotglob

sudo cp -rf ./fs/* /
cp -rf ./usr-fs/* /home/$USER

shopt -u dotglob

chmod +x ~/.xinitrc

ln -s ~/.config/fish/config.fish ~/.fishrc
ln -s ~/.config/fish/functions ~/.fish

sudo ln -s ~/.gtkrc-2.0 /etc/gtk-2.0/gtkrc
sudo ln -s ~/.config/gtk-3.0/settings.ini /etc/gtk-3.0/settings.ini

sudo chmod a+rx /usr/sbin/fishlogin
echo /usr/sbin/fishlogin | sudo tee -a /etc/shells
chsh -s /usr/sbin/fishlogin

sudo localectl set-x11-keymap "$KEYMAP"
