#!/bin/bash

source common.sh

ls /sys/firmware/efi/efivars &> /dev/null || { echo "Not UEFI booted. Aborting..." ; exit; }
ls $DISK &> /dev/null || { echo "$DISK does not exist. Aborting..." ; exit; }

echo "Please confirm with [enter] that $DISK is the disk where you wanna install Arch. ALL DATA IN $DISK WILL BE LOST"
read

echo "Setting keybaoard layout..."
loadkeys $KEYMAP

echo "Partitioning $DISK..."

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk $DISK
  g  # New GPT partition table
  n  # New partition for /boot
  1  # ID 1
     # Default first sector
  y  # Confirm if asked
  +${PART_BOOT_SIZE}
  t  # Change partition type
  1  # EFI System
  n  # Partition for swap
  2  # ID 2
     # Default first sector
  +${PART_SWAP_SIZE}
  y  # Confirm if asked
  t  # Change partition type
  2  # ID 2
  19 # Linux swap
  n  # Partition for /
  3  # ID 3
     # Default first sector
     # Use remaining space
  y  # Confirm if asked
  t  # Change partition type
  3  # ID 3
  23 # Linux root (x86-64)
  w  # Save and exit
EOF

echo "Formatting partitions..."
mkfs.ext4 ${DISK}3
sleep 1
mkswap ${DISK}2
sleep 1
mkfs.fat -F 32 ${DISK}1

sleep 5

echo "Mounting system partition..."
mount ${DISK}3 /mnt
sleep 5
echo "Mounting boot partition..."
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot
sleep 5
echo "Swapping on ${DISK}2..."
swapon ${DISK}2
sleep 5

echo "Installing arch..."
pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab
echo "Press [enter] to edit fstab and make the needed changes, if any"
read
nano /mnt/etc/fstab

ln -sf /mnt/usr/share/zoneinfo/$TIMEZONE /mnt/etc/localtime

mkdir /mnt/stuff
cp -rp ./* /mnt/stuff

echo "Set-up complete! Press [enter] to arch-chroot into /mnt"
read
arch-chroot /mnt
