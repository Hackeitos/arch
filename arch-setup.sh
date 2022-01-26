#!/bin/bash

source common.sh

hwclock --systohc
sed -i "s/#$LANG/$LANG/g" /etc/locale.gen
locale-gen

echo "LANG=$LANG" > /etc/locale.conf
echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
echo "$HOSTNAME" > /etc/hostname

pacman -S $EXTRA_PACKAGES

pacman -S grub efibootmgr
sleep 5
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
sleep 5

echo "Press [enter] to edit /etc/defult/grub"
read
nano /etc/default/grub
sleep 5
grub-mkconfig -o /boot/grub/grub.cfg

echo "Creating sudo group..."
groupadd sudo
echo "Creating user $USER..."
useradd -m -G $USER_ADDITIONAL_GROUPS $USER
echo "Setting password for user $USER..."
passwd $USER

echo "Press [enter] to edit /etc/sudoers"
read
nano /etc/sudoers

chown -R $USER .

echo "Installation complete! You can now reboot."