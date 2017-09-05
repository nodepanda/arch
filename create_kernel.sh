#!/bin/bash

cat /proc/cmdline > /boot/cmdline

objcopy \
    --add-section .osrel=/etc/os-release --change-section-vma .osrel=0x20000 \
    --add-section .cmdline=/boot/cmdline --change-section-vma .cmdline=0x30000 \
    --add-section .linux=/boot/vmlinuz-linux --change-section-vma .linux=0x40000 \
    --add-section .initrd=/boot/initramfs-linux.img --change-section-vma .initrd=0x3000000 \
    /usr/lib/systemd/boot/efi/linuxx64.efi.stub /boot/efi/kernel.efi

echo kernel.efi $(cat /proc/cmdline | cut -d " " -f 2-) > /boot/efi/startup.nsh
