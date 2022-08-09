sudo vgdisplay rootvg
sudo yum install cloud-utils-growpart gdisk -y
sudo pvscan
lsblk /dev/sda2
sudo growpart /dev/sda 2
lsblk /dev/sda2
sudo pvresize /dev/sda2
sudo pvscan
sudo lvresize -r -L +135G /dev/mapper/rootvg-rootlv
