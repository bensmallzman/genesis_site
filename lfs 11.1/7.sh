cd /mnt/lfs/sources
tar -xvf man-pages-5.13.tar.xz; rm man-pages-5.13.tar.xz; cd man-pages-5.13
make prefix=/usr install

cd ..
tar -xvf iana-etc-20220207.tar.gz; rm iana-etc-20220207.tar.gz; cd iana-etc-20220207
cp services protocols /etc

cd ..
cd glibc-2.35; patch -Np1 -i ../glibc-2.35-fhs-1.patch; rm ../glibc-2.35-fhs-1.patch;
mkdir -v build2 && cd build2
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=3.2                      \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/usr/lib
make -j4
make check -j4
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install -j4
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
mkdir -pv /usr/lib/locale
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2021e.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
tzselect
ln -sfv /usr/share/zoneinfo/America/Eastern /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

cd /mnt/lfs/sources
tar -xvf zlib-1.2.12.tar.gz; rm zlib-1.2.12.tar.gz; cd zlib-1.2.12
./configure --prefix=/usr
make -j4
make check -j4
make install
rm -fv /usr/lib/libz.a

cd ..
tar -xvf bzip2-1.0.8.tar.gz; rm bzip2-1.0.8.tar.gz; cd bzip2-1.0.8
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch;  rm ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f -j4 Makefile-libbz2_so
make clean -j4
make -j4
make PREFIX=/usr install -j4
cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a

cd ..
cd xz-5.2.5
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5
make -j4
make check -j4
make install -j4

cd ..
tar -xvf zstd-1.5.2.tar.gz; rm zstd-1.5.2.tar.gz; cd zstd-1.5.2
make -j4
make check -j4
make prefix=/usr install -j4
rm -v /usr/lib/libzstd.a

cd ..
cd file-5.41
./configure --prefix=/usr
make -j4
make check -j4
make install -j4

cd ..
tar -xvf readline-8.1.2.tar.gz; rm readline-8.1.2.tar.gz; cd readline-8.1.2
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1.2
make -j4 SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="lncursesw" install -j4
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2

cd ..
cd m4-1.4.19
./configure --prefix=/usr
make -j4
make check -j4
make install -j4

cd ..
tar -xvf bc-5.2.2.tar.xz; rm bc-5.2.2.tar.xz; cd bc-5.2.2
CC=gcc ./configure --prefix=/usr -G -03
make -j4
make test -j4
make install -j4

cd ..
tar -xvf flex-2.6.4.tar.gz; rm flex-2.6.4.tar.gz; cd flex-2.6.4
./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make -j4
make check -j4
make install -j4
ln -sv flex /usr/bin/lex

cd ..
tar -xvf tcl8.6.12-src.tar.gz; rm tcl8.6.12-src.tar.gz; cd tcl8.6.12
tar -xvf ../tcl8.6.12-html.tar.gz --strip-components=1 && rm ../tcl8.6.12-html.tar.gz
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit)
make -j4
sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.3|/usr/lib/tdbc1.1.3|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.3|/usr/include|"            \
    -i pkgs/tdbc1.1.3/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.2|/usr/lib/itcl4.2.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.2|/usr/include|"            \
    -i pkgs/itcl4.2.2/itclConfig.sh

unset SRCDIR

make test -j4
make install -j4
chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers -j4
ln -sfv tclsh8.6 /usr/bin/tclsh
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3
mkdir -v -p /usr/share/doc/tcl-8.6.12
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.12

cd ../..
tar -xvf expect5.45.4.tar.gz; rm expect5.45.4.tar.gz; cd expect5.45.4
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make -j4
make test -j4
make install -j4
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd ..
tar -xvf dejagnu-1.6.3.tar.gz; rm dejagnu-1.6.3.tar.gz; cd dejagnu-1.6.3
mkdir -v build; cd build
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
make install -j4
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3
make check -j4

cd ../..
cd binutils-2.38
expect -c "spawn ls"
