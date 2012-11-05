#!/bin/sh

ROOTFS="core-image-minimal-qemux86-64.ext3"
# ROOTFS="core-image-sato-qemux86-64-20121104193726.rootfs.ext3"

top=`pwd`

sudo umount root
sudo rm -rf core* root
sudo mkdir root
cp ../TestImages/$ROOTFS .
sudo mount -o loop  $ROOTFS root

cd linux-stable
sudo make INSTALL_MOD_PATH="$top/root" modules_install

cd $top
sudo qemu-system-x86_64 \
	-kernel linux-stable/arch/x86/boot/bzImage \
	-hda $ROOTFS \
	-serial stdio \
	-net nic,model=rtl8139 \
	-net user \
	-show-cursor -usb -usbdevice wacom-tablet \
	-vga vmware -no-reboot \
	-m 128 \
	--append "console=ttyS0 vga=0 root=/dev/sda rw mem=128M oprofile.timer=1"
	

#--append "console=ttyS0 vga=0 root=/dev/sda ip=10.1.2.222:10.1.2.0:255.255.255.0 rw mem=128M oprofile.timer=1"

#sudo qemu-system-x86_64 \
#	-kernel linux-stable/arch/x86/boot/bzImage \
#	-hda core-image-sato-qemux86-64.ext3  \
#	-net nic,vlan=0 \
#	-net tap,vlan=0,ifname=tap0,script=no,downscript=no  \
#	-serial stdio \
#	-show-cursor -usb -usbdevice wacom-tablet \
#	-vga vmware -no-reboot \
#	-m 128 \
#	--append "console=ttyS0 vga=0 root=/dev/sda rw mem=128M oprofile.timer=1"

sudo umount root

