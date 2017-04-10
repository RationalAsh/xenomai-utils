#!/bin/sh

XENOMAI_VER="3.0.4"
KERNEL_VER="3.18.20"
PATCH_VER="3.18.20-x86-8"

#Download xenomai, the kernel source and the ipipe patch
wget https://xenomai.org/downloads/xenomai/stable/xenomai-$XENOMAI_VER.tar.bz2
wget https://xenomai.org/downloads/ipipe/v3.x/x86/ipipe-core-$PATCH_VER.patch
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-$KERNEL_VER.tar.gz

#Untar
tar -xvf xenomai-$XENOMAI_VER.tar.bz2
tar -xvzf linux-$KERNEL_VER.tar.gz

#Prepare the kernel and copy working .config to the source tree
xenomai-$XENOMAI_VER/scripts/prepare-kernel.sh --linux=linux-$KERNEL_VER --ipipe=ipipe-core-$PATCH_VER.patch --arch=x86_64
cp configs/.config-$KERNEL_VER linux-$KERNEL_VER/.config

#Compile the kernel
cd linux-$KERNEL_VER; sudo CONCURRENCY_LEVEL=8 CLEAN_SOURCE=no fakeroot make-kpkg --initrd --append-to-version -ashwin-xenomai --revision 1.0 kernel_image kernel_headers kernel_source 
