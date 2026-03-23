genkernel all --loglevel=5 --color --mountboot --bootloader=grub --firmware --microcode --virtio --lvm --postclear --oldconfig
echo ''|mailx -s 'kernel compile complete' root
