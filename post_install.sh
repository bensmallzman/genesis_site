cd /home/debian/

wget https://wireless.wiki.kernel.org/_media/en/users/drivers/iwlwifi-8265-ucode-22.361476.0.tgz

tar -xvf iwlwifi-8265-ucode-22.361476.0.tgz

cd iwlwifi-8265-ucode-22.361476.0/

cp iwlwifi-8265-22.ucode /lib/firmware

cd /etc/apt/

rm sources.list

echo -e 'deb http://deb.debian.org/debian bullseye main\n
deb http://security.debian.org/debian-security bullseye-security main\n
deb http://deb.debian.org/debian bullseye-updates main' >> sources.list

sudo reboot
