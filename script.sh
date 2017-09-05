pacstrap /mnt base base-devel vim grub networkmanager openssh firewalld zsh zsh-completions grml-zsh-config
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt curl -o /etc/vconsole.conf -L https://raw.github.com/nodepanda/arch/master/vconsole.conf
arch-chroot /mnt curl -o /etc/locale.conf -L https://raw.github.com/nodepanda/arch/master/locale.conf
arch-chroot /mnt mkinitcpio -p linux

arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt sed -i 's/#sk_SK.UTF-8 UTF-8/sk_SK.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt locale-gen

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Bratislava /etc/localtime
arch-chroot /mnt hwclock --systohc

arch-chroot /mnt sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
arch-chroot /mnt sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet logvelev=3 rd.systemd.show_status=auto rd.udev.log-priority=3 vt.global_cursor_default=0"/g' /etc/default/grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt grub-install /dev/sda

setterm -cursor on >> /mnt/etc/issue
echo "archvm" > /mnt/etc/hostname

arch-chroot /mnt systemctl enable NetworkManager
arch-chroot /mnt systemctl enable firewalld
arch-chroot /mnt systemctl enable openssh

arch-chroot /mnt chsh root -s /usr/bin/zsh

arch-chroot /mnt pacman --noconfirm -Rs vi

umount /mnt
reboot
