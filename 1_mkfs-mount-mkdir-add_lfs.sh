mkfs -v -t ext4 $1
export LFS=/mnt/lfs
echo $LFS
mkdir -pv $LFS
mount -v -t ext4 $1 $LFS
mkdir -v $LFS/sources 
chmod -v a+wt $LFS/sources
wget --input-file=wget-list.txt --continue --directory-prefix=$LFS/sources

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs 

chown -v lfs /mnt/lfs/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v lfs /mnt/lfs/lib64 ;;
esac 

chown -v lfs /mnt/lfs/sources
su - lfs
