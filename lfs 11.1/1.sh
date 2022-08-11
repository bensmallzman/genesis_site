sudo mkfs -v -t ext4 /dev/sda
mkdir -pv /mnt/lfs
mount -v -t ext4 /dev/sda /mnt/lfs
mkdir -v /mnt/lfs/sources 
chmod -v a+wt /mnt/lfs/sources
wget --input-file=wget-list.txt --continue --directory-prefix=/mnt/lfs/sources

mkdir -pv /mnt/lfs/{etc,var} /mnt/lfs/usr/{bin,lib,sbin}
for i in bin lib sbin; do
  ln -sv usr/$i /mnt/lfs/$i
done
case $(uname -m) in
  x86_64) mkdir -pv /mnt/lfs/lib64 ;;
esac

mkdir -pv /mnt/lfs/tools

sudo groupadd lfs
sudo useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs 

chown -v lfs /mnt/lfs/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs /mnt/lfs/lib64 ;;
esac 

chown -v lfs /mnt/lfs/sources
su - lfs
