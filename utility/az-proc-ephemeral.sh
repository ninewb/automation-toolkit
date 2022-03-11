export disk=/dev/sdb1

sudo parted ${disk} --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs ${disk}
sudo mkfs.xfs ${disk} -f

export UUID=$(blkid ${disk} | awk -F'"' '{print $2}')
# Add option to replace UUID in fstab
sudo sed "s/^UUID=$VALUETOREPLACE$/UUID=${UUID}" </etc/fstab

sudo systemctl daemon-reload

sudo mount -a
sudo mdkir /sastemp/sascache
sudo mkdir /sastemp/saswork
sudo chown -R sas:sas /sastemp
sudo chmod -R 777 /sastemp/*
