#!/bin/sh
######################
#  centos7.7 1908    #
#  Oracle12C install #
#  by dsdata.Co.Ltd  #
#  2020-02-10        #
#  Author JJ         #
######################
. /etc/profile
mkdir /home/work
echo "work directory is ready!"
sleep 2
######################
#  sysinfo writed    #
######################
cd /home/work
echo "now" `pwd`
sleep 2
/sbin/hwclock --systohc
/sbin/hwclock -r >> /home/work/work_history.txt
uname -a >> /home/work/work_history.txt
grep . /etc/*-release >> /home/work/work_history.txt
ifconfig >> /home/work/work_history.txt
df -Th >> /home/work/work_history.txt
free -m >> /home/work/work_history.txt
cat /proc/cpuinfo >> /home/work/work_history.txt
dmidecode -t 17 >> /home/work/work_history.txt
echo "sysinfo writed"
sleep 2
######################
#  selinux disabled  #
######################
#sed -i "7s/#SELINUX/SELINUX/" /etc/selinux/config
#sed -i "7s/enforcing/disabled/" /etc/selinux/config
cd /etc/selinux
echo "now" `pwd`
sleep 2
cp -p config config.bak
sed -i '/SELINUX=enforcing/ c\SELINUX=disabled' /etc/selinux/config
cd /home/work
echo "now" `pwd`
cat /etc/selinux/config >> /home/work/work_history.txt
echo "selinux disabled"
sleep 2
######################
#  PermitRootLogin   #
######################
cd /etc/ssh
echo "now" `pwd`
sleep 2
cp -p sshd_config sshd_config.bak
sed -i '/#PermitRootLogin yes/ c\PermitRootLogin yes' /etc/ssh/sshd_config
cd /home/work
cat /etc/ssh/sshd_config >> /home/work/work_history.txt
echo "ssh root login permitted"
sleep 2
######################
#  firewalld disable #
######################
cd /home/work
echo "now" `pwd`
sleep 2
systemctl stop firewalld >> /home/work/work_history.txt
systemctl disable firewalld >> /home/work/work_history.txt
echo "firewalld disabeld"
sleep 2
######################
#  bluetooth disable #
######################
cd /home/work
echo "now" `pwd`
sleep 2
systemctl stop bluetooth.service >> /home/work/work_history.txt
systemctl disable bluetooth.service >> /home/work/work_history.txt
echo "bluetooth disabeld"
sleep 2
######################
# libvirtd disable   #
######################
#cd /home/work
#echo "now" `pwd`
#sleep 2
#chkconfig libvirtd off >> /home/work/work_history.txt
#systemctl disable libvirtd.service >> /home/work/work_history.txt
#echo "libvirtd disabeld"
#sleep 2
######################
#  update yum.conf   #
######################
cd /etc
echo "now" `pwd`
sleep 2
sed -i '2 i\exclude=kernel*' yum.conf
echo "insert exlude=kernel* to yum.conf 2line"
sleep 2
######################
#  yum install       #
######################
cd /home/work
echo "now" `pwd`
echo "yum install and update started"
sleep 2
yum install -y cmake *gcc* cvs telnet ypbind compat*
sleep 1
yum install -y glibc.i686 glibc*
sleep 1
yum install -y redhat-lsb-core libcurl* libxslt*
sleep 1
yum install -y pcre*
sleep 1
yum install -y libz* bzip2-devel* readline-devel*
sleep 1
yum -y install binutils compat-libcap1 gcc gcc-c++ glibc glibc.i686
yum -y install glibc-devel glibc.i686 ksh libaio libaio.i686 libaio-devel
yum -y install libaio-devel.i686 libgcc libgcc.i686 libstdc++
yum -y install libstdc++l7.i686 libstdc++-devel libstdc++-devel.i686
yum -y install compat-libstdc++-33 compat-libstdc++-33.i686 libXi libXi.i686
yum -y install libXtst libXtst.i686 make sysstat xorg-x11-apps
######################
#  yum update        #
######################
cd /home/work
echo "now" `pwd`
echo "yum will be updated"
sleep 2
yum -y update
echo "yum updated"
sleep 2
######################
#  SET sysctl.conf   #
######################
echo "SET sysctl.conf Started..."
sleep 2
MEMTOTAL=$(free -b | sed -n '2p' | awk '{print $2}')
SHMMAX=$(expr $MEMTOTAL / 2)
SHMMNI=4096
PAGESIZE=$(getconf PAGE_SIZE)
cat >> /etc/sysctl.conf << EOF
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmmax = $SHMMAX
kernel.shmall = $(expr \( $SHMMAX / $PAGESIZE \) \* \( $SHMMNI / 16 \))
kernel.shmmni = $SHMMNI
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
EOF
echo "SET sysctl.conf end..."
cat /etc/sysctl.conf >> /home/work/work_history.txt
sysctl -p
echo "SET sysctl.conf Committed..."
sleep 2