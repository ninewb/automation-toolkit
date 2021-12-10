
export disks=$(lsblk -r --output NAME,MOUNTPOINT | awk -F \/ '/sd/ { dsk=substr($1,1,3);dsks[dsk]+=1 } END { for ( i in dsks ) { if (dsks[i]==1) print i } }')

for disk in ${disks}; do
  sudo parted /dev/${disk} --script mklabel gpt mkpart xfspart xfs 0% 100%
  sudo mkfs.xfs /dev/${disk}1
  sudo partprobe /dev/${disk}1
done


