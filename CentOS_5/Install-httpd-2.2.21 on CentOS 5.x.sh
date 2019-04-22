#!/bin/bash
#

service httpd stop
yum -y remove gnome-user-share
yum -y remove httpd

FileName=httpd-2.2.21.tar.gz

# 下載並安裝 httpd-2.2.21
if [ -f $FileName ]; then
  color blue
  echo $FileName+' is exists...'
  color black
else
  wget http://download.nextag.com/apache//httpd/$FileName
fi

rm -rf /usr/local/src/httpd-2.2.21

# 將 tar 解壓縮到 /usr/local/src 是為了方便管理
tar zxvf $FileName -C /usr/local/src

cd /usr/local/src/httpd-2.2.21
./configure --with-included-apr --enable-so --enable-ssl --enable-rewrite=shared
make
make install

groupdel apache
userdel apache
groupadd apache
groupadd --gid=48 apache
useradd -s /sbin/nologin -d /usr/local/apache2 -g apache --uid=48 apache

ln -s /usr/local/apache2/bin/apachectl /etc/rc.d/init.d/apache2
chown -R apache:apache /usr/local/apache2
service apache2 restart

#-----------------------------------------------------------------------
echo 
echo 'Configure apache2 as a service and run as boot.'
eccho 'Write to /etc/rc.d/rc.local'
echo 
echo 'service apache2 start' >> /etc/rc.d/rc.local

