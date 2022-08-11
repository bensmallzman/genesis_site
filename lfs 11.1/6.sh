cd /mnt/lfs/sources/glibc-2.35/build

rm -v dummy.c a.out
/mnt/lfs/tools/libexec/gcc/x86_64-lfs-linux-gnu/11.2.0/install-tools/mkheaders

cd ../../gcc-11.2.0/build
../libstdc++-v3/configure           \
    --host=x86_64-lfs-linux-gnu                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/x86_64-lfs-linux-gnu/include/c++/11.2.0
make -j4
make DESTDIR=/mnt/lfs install

cd ../..
tar -xvf m4-1.4.19.tar.xz && rm m4-1.4.19.tar.xz && cd m4-1.4.19
./configure --prefix=/usr   \
            --host=x86_64-lfs-linux-gnu \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install

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
            --host=x86_64-lfs-linux-gnu              \
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
make DESTDIR=/mnt/lfs TIC_PATH=$(pwd)/build/progs/tic install -j4
echo "INPUT(-lncursesw)" > /mnt/lfs/usr/lib/libncurses.so

cd ..
tar -xvf bash-5.1.16.tar.gz && rm bash-5.1.16.tar.gz && cd bash-5.1.16
./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=x86_64-lfs-linux-gnu                 \
            --without-bash-malloc
make -j4
make DESTDIR=/mnt/lfs install -j4
ln -sv bash /mnt/lfs/bin/sh

cd ..
tar -xvf coreutils-9.0.tar.xz && rm coreutils-9.0.tar.xz && cd coreutils-9.0
./configure --prefix=/usr                     \
            --host=x86_64-lfs-linux-gnu                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make -j4
make DESTDIR=/mnt/lfs install -j4
mv -v /mnt/lfs/usr/bin/chroot              /mnt/lfs/usr/sbin
mkdir -pv /mnt/lfs/usr/share/man/man8
mv -v /mnt/lfs/usr/share/man/man1/chroot.1 /mnt/lfs/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    /mnt/lfs/usr/share/man/man8/chroot.8

cd ..
tar -xvf diffutils-3.8.tar.xz && rm diffutils-3.8.tar.xz && cd diffutils-3.8
./configure --prefix=/usr --host=x86_64-lfs-linux-gnu
make -j4
make DESTDIR=/mnt/lfs install -j4

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
./configure --prefix=/usr --host=x86_64-lfs-linux-gnu --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file -j4
make DESTDIR=/mnt/lfs install -j4

cd ..
tar -xvf findutils-4.9.0.tar.xz && rm findutils-4.9.0.tar.xz && cd findutils-4.9.0
./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=x86_64-lfs-linux-gnu                 \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install -j4

cd ..
tar -xvf gawk-5.1.1.tar.xz && rm gawk-5.1.1.tar.xz && cd gawk-5.1.1
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr   \
            --host=x86_64-lfs-linux-gnu \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install -j4

cd ..
tar -xvf grep-3.7.tar.xz && rm grep-3.7.tar.xz && cd grep-3.7
./configure --prefix=/usr   \
            --host=x86_64-lfs-linux-gnu
make -j4
make DESTDIR=/mnt/lfs install -j4

cd ..
tar -xvf gzip-1.11.tar.xz && rm gzip-1.11.tar.xz && cd gzip-1.11
./configure --prefix=/usr --host=x86_64-lfs-linux-gnu
make -j4
make DESTDIR=/mnt/lfs install -j4

cd ..
tar -xvf make-4.3.tar.gz && rm make-4.3.tar.gz && cd make-4.3
./configure --prefix=/usr   \
            --without-guile \
            --host=x86_64-lfs-linux-gnu \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install

cd ..
tar -xvf patch-2.7.6.tar.xz && rm patch-2.7.6.tar.xz && cd patch-2.7.6
./configure --prefix=/usr   \
            --host=x86_64-lfs-linux-gnu \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install

cd ..
tar -xvf sed-4.8.tar.xz && rm sed-4.8.tar.xz && cd sed-4.8
./configure --prefix=/usr   \
            --host=x86_64-lfs-linux-gnu
make -j4
make DESTDIR=/mnt/lfs install

cd ..
tar -xvf tar-1.34.tar.xz && rm tar-1.34.tar.xz && cd tar-1.34
./configure --prefix=/usr                     \
            --host=x86_64-lfs-linux-gnu                   \
            --build=$(build-aux/config.guess)
make -j4
make DESTDIR=/mnt/lfs install

cd ..
tar -xvf xz-5.2.5.tar.xz && rm xz-5.2.5.tar.xz && cd xz-5.2.5
./configure --prefix=/usr                     \
            --host=x86_64-lfs-linux-gnu                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5
make -j4
make DESTDIR=/mnt/lfs install

cd ../binutils-2.38
sed '6009s/$add_dir//' -i ltmain.sh
mkdir -v build2 && cd build2
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=x86_64-lfs-linux-gnu            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd
make -j4
make DESTDIR=/mnt/lfs install

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
mkdir -v build2 && cd build2
mkdir -pv x86_64-lfs-linux-gnu/libgcc
ln -s ../../../libgcc/gthr-posix.h x86_64-lfs-linux-gnu/libgcc/gthr-default.h
../configure                                       \
    --build=$(../config.guess)                     \
    --host=x86_64-lfs-linux-gnu                                \
    --prefix=/usr                                  \
    CC_FOR_TARGET=x86_64-lfs-linux-gnu-gcc                     \
    --with-build-sysroot=/mnt/lfs                      \
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
make DESTDIR=/mnt/lfs install
ln -sv gcc /mnt/lfs/usr/bin/cc

cd ..
chown -R root:root /mnt/lfs/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -R root:root /mnt/lfs/lib64 ;;
esac

mkdir -pv /mnt/lfs/{dev,proc,sys,run}
mknod -m 600 /mnt/lfs/dev/console c 5 1
mknod -m 666 /mnt/lfs/dev/null c 1 3
mount -v --bind /dev /mnt/lfs/dev
mount -v --bind /dev/pts /mnt/lfs/dev/pts
mount -vt proc proc /mnt/lfs/proc
mount -vt sysfs sysfs /mnt/lfs/sys
mount -vt tmpfs tmpfs /mnt/lfs/run
if [ -h /mnt/lfs/dev/shm ]; then
  mkdir -pv /mnt/lfs/$(readlink /mnt/lfs/dev/shm)
fi

mount -v --bind /dev /mnt/lfs/dev
mount -vt devpts devpts /mnt/lfs/dev/pts
mount -vt tmpfs shm /mnt/lfs/dev/shm
mount -vt proc proc /mnt/lfs/proc
mount -vt sysfs sysfs /mnt/lfs/sys

sudo chroot "/mnt/lfs" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login

