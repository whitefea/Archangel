#!/bin/bash
read -p "按回车进行配置"
nmcli connection modify "System eth0" ipv4.method manual ipv4.addresses "172.25.0.11/24 172.25.0.254" ipv4.dns "172.25.254.254"  connection.autoconnect yes &> /dev/null
nmcli connection up "System eth0" &> /dev/null
hostnamectl set-hostname server0.example.com 
yum -y install sssd autofs &> /dev/null
systemctl restart chronyd 
systemctl restart sssd autofs 
yum-config-manager --add "http://content.example.com/rhel7.0/x86_64/dvd" &> /dev/null
sed -i s/gpgcheck=1/gpgcheck=0/g /etc/yum.conf &> /dev/null
fdisk /dev/vdb <<EOF
n
p


+300M
n
p


+2G
n
p


+1G
n
e


n

+300M
n

+2G
n

+512M
w
EOF
vgcreate systemvg /dev/vdb1 &> /dev/null
lvcreate -L 200M -n vo systemvg &> /dev/null
vgextend systemvg /dev/vdb5 &> /dev/null
lvextend -L 300M /dev/systemvg/vo &> /dev/null
mkfs.ext3 /dev/systemvg/vo &> /dev/null
mkdir /vo 
echo "/dev/systemvg/vo    /vo    ext3    defaults    0 0" >> /etc/fstab
groupadd adminuser &> /dev/null
useradd -G adminuser natasha ; echo flectrag | passwd --stdin natasha &> /dev/null
useradd -G adminuser harry ;echo flectrag | passwd --stdin harry &> /dev/null
useradd -s /sbin/nologin sarah ; echo flectrag | passwd --stdin sarah &> /dev/null
useradd -u 3456 alex ; echo flectrag | passwd --stdin alex &> /dev/null
cp /etc/fstab /var/tmp/
setfacl -m u:natasha:rw /var/tmp/fstab &> /dev/null
setfacl -m u:harry:--- /var/tmp/fstab &> /dev/null
mkdir /home/admins
chown :adminuser /home/admins &> /dev/null
chmod 2770 /home/admins &> /dev/null
wget -O /kernel.rpm http://classroom.example.com/content/rhel7.0/x86_64/errata/Packages/kernel-3.10.0-123.1.2.el7.x86_64.rpm &> /dev/null
rpm -ivh /kernel.rpm 
authconfig --enableldap --enableldapauth --ldapserver="classroom.example.com" --ldapbasedn="dc=example,dc=com" --enableldaptls --update
wget -O /etc/openldap/cacerts/example-ca.crt http://classroom.example.com/pub/example-ca.crt &> /dev/null
mkdir /home/guests
echo "ldapuser0    -rw    classroom.example.com:/home/guests/ldapuser0" >> /etc/guests.rule 
echo "/home/guests /etc/guests.rule" >> /etc/auto.master 
echo "server classroom.example.com iburst" >> /etc/chrony.conf
timedatectl set-ntp true &> /dev/null
mkswap /dev/vdb7 &> /dev/null
echo "/dev/vdb7    swap    swap    defaults    0 0" >> /etc/fstab 
swapon -s &> /dev/null
swapon -a &> /dev/null
mkdir /root/findfiles ; find / -user student -type f -exec cp -p {} /root/findfiles \; &> /dev/null
grep -v "^$" /usr/share/dict/words | grep "seismic" > /root/wordlist &> /dev/null
vgcreate -s 16M datastore /dev/vdb6 &> /dev/null
lvcreate -l 50 -n database datastore  &> /dev/null
mkfs.ext3 /dev/datastore/database &> /dev/null
mkdir /mnt/database
echo "/dev/datastore/database    /mnt/database    ext3    defaults    0 0" >> /etc/fstab 
tar -jPcf /root/backup.tar.bz2 /usr/local &> /dev/null
authconfig --updateall
systemctl enable sssd chronyd autofs &> /dev/null
read -p "Will reboot type yes or no ：" n
if [ $n == "yes" ];then
reboot
fi
