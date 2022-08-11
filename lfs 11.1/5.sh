cd /mnt/lfs/sources
tar -xvf binutils-2.38.tar.xz; rm binutils-2.38.tar.xz; cd binutils-2.38
mkdir -v build; cd build
../configure --prefix=/mnt/lfs/tools \
             --with-sysroot=/mnt/lfs \
             --target=x86_64-lfs-linux-gnu   \
             --disable-nls       \
             --disable-werror
make -j4
make install -j4

cd ../..
tar -xvf gcc-11.2.0.tar.xz; rm gcc-11.2.0.tar.xz; cd gcc-11.2.0
tar -xf ../mpfr-4.1.0.tar.xz
mv -v mpfr-4.1.0 mpfr
tar -xf ../gmp-6.2.1.tar.xz
mv -v gmp-6.2.1 gmp
tar -xf ../mpc-1.2.1.tar.gz
mv -v mpc-1.2.1 mpc
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac
mkdir -v build; cd build
../configure                  \
    --target=x86_64-lfs-linux-gnu         \
    --prefix=/mnt/lfs/tools       \
    --with-glibc-version=2.35 \
    --with-sysroot=/mnt/lfs       \
    --with-newlib             \
    --without-headers         \
    --enable-initfini-array   \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-decimal-float   \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++
make -j4
make install -j4
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $(x86_64-lfs-linux-gnu-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

cd ..
tar -xvf linux-5.16.9.tar.xz; rm linux-5.16.9.tar.xz; cd linux-5.16.9
make mrproper -j4
make headers -j4
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include /mnt/lfs/usr

cd ..
tar -xvf glibc-2.35.tar.xz; rm glibc-2.35.tar.xz; cd glibc-2.35
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 x86_64-lfs-linux-gnu/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 /mnt/lfs/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 /mnt/lfs/lib64/ld-lsb-x86-64.so.3
    ;;
esac
patch -Np1 -i ../glibc-2.35-fhs-1.patch; rm ../glibc-2.35-fhs-1.patch

mkdir -v build; cd build
echo "rootsbindir=/usr/sbin" > configparms
../configure                             \
      --prefix=/usr                      \
      --host=x86_64-lfs-linux-gnu                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/mnt/lfs/usr/include    \
      libc_cv_slibdir=/usr/lib
make -j4
make DESTDIR=/mnt/lfs install -j4
sed '/RTLDLIST=/s@/usr@@g' -i /mnt/lfs/usr/bin/ldd
echo 'int main(){}' > dummy.c
x86_64-lfs-linux-gnu-gcc dummy.c
readelf -l a.out | grep '/ld-linux'
