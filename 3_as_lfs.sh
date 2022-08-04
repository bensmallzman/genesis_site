rm -v dummy.c a.out
$LFS/tools/libexec/gcc/$LFS_TGT/11.2.0/install-tools/mkheaders

cd ../../gcc-11.2.0/build
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/11.2.0
make -j4
make DESTDIR=$LFS install

cd ../..
tar -xvf m4-1.4.19.tar.xz && rm m4-1.4.19.tar.xz && cd m4-1.4.19
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=$LFS install

cd ..
tar -xvf ncurses-6.3.tar.gz && rm ncurses-6.3.tar.gz && cd ncurses-6.3
sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --disable-stripping          \
            --enable-widec
make -j4
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install -j4
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

cd ..
tar -xvf bash-5.1.16.tar.gz && rm bash-5.1.16.tar.gz && cd bash-5.1.16
./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc
make -j4
make DESTDIR=$LFS install -j4
ln -sv bash $LFS/bin/sh

cd ..
tar -xvf coreutils-9.0.tar.xz && rm coreutils-9.0.tar.xz && cd coreutils-9.0
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make -j4
make DESTDIR=$LFS install -j4
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

cd ..
tar -xvf diffutils-3.8.tar.xz && rm diffutils-3.8.tar.xz && cd diffutils-3.8
./configure --prefix=/usr --host=$LFS_TGT
make -j4
make DESTDIR=$LFS install -j4

cd ..
tar -xvf file-5.41.tar.gz && rm file-5.41.tar.gz && cd file-5.41
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file -j4
make DESTDIR=$LFS install -j4

cd ..
tar -xvf findutils-4.9.0.tar.xz && rm findutils-4.9.0.tar.xz && cd findutils-4.9.0
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/$LFS install -j4

cd ..
tar -xvf gawk-5.1.1.tar.xz && rm gawk-5.1.1.tar.xz && cd gawk-5.1.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=$LFS install -j4

cd ..
tar -xvf grep-3.7.tar.xz && rm grep-3.7.tar.xz && cd grep-3.7
./configure --prefix=/usr   \
            --host=$LFS_TGT
make -j4
make DESTDIR=$LFS install -j4

cd ..
tar -xvf gzip-1.11.tar.xz && rm gzip-1.11.tar.xz && cd gzip-1.11
./configure --prefix=/usr --host=$LFS_TGT
make -j4
make DESTDIR=$LFS install -j4

cd ..
tar -xvf make-4.3.tar.gz && rm make-4.3.tar.gz && cd make-4.3
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=$LFS install

cd ..
tar -xvf patch-2.7.6.tar.xz && rm patch-2.7.6.tar.xz && cd patch-2.7.6
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=$LFS install

cd ..
tar -xvf sed-4.8.tar.xz && rm sed-4.8.tar.xz && cd sed-4.8
./configure --prefix=/usr   \
            --host=$LFS_TGT
make -j4
make DESTDIR=$LFS install

cd ..
tar -xvf tar-1.34.tar.xz && rm tar-1.34.tar.xz && cd tar-1.34
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=$LFS install

cd ..
tar -xvf xz-5.2.5.tar.xz && rm xz-5.2.5.tar.xz && cd xz-5.2.5
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5
make -j4
make DESTDIR=$LFS install

cd ../binutils-2.38
sed '6009s/$add_dir//' -i ltmain.sh
cd build
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd
make -j4
make DESTDIR=$LFS install

cd ../gcc-11.2.0
tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
  ;;
esac
cd build
mkdir -pv $LFS_TGT/libgcc
ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --prefix=/usr                                  \
    CC_FOR_TARGET=$LFS_TGT-gcc                     \
    --with-build-sysroot=$LFS                      \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
make -j4
make DESTDIR=$LFS install
ln -sv gcc $LFS/usr/bin/cc

cd ..
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root $LFS/lib64 ;;
esac

mkdir -pv $LFS/{dev,proc,sys,run}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mount -v --bind /dev $LFS/dev
mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts
mount -vt tmpfs shm $LFS/dev/shm
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys

sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login

