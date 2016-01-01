#!/bin/bash
clear
echo "==================================================================="
echo "install wordpress with lnmp install on your vps,written by tennfy  "
echo "                           Version 1.1                             "
echo "==================================================================="
# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi
echo
read -p "Please input your hostname ,For example tennfy.com :" hostname
read -p "please MySql root password:" dbrootpass
read -p "please input database name:" dbname
read -p "please input database password:" dbpass
cd /var/www
wget https://cn.wordpress.org/latest-zh_CN.zip
unzip latest-zh_CN.zip
cp -r ./wordpress/* /var/www/$hostname
cd /var/www/$hostname
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/'$dbname'/g' /var/www/$hostname/wp-config.php
sed -i 's/username_here/'$dbname'/g' /var/www/$hostname/wp-config.php
sed -i 's/password_here/'$dbpass'/g' /var/www/$hostname/wp-config.php
 mysql -uroot -p$dbrootpass -s <<EOT
 create database if not exists $dbname default charset utf8 collate utf8_general_ci;
create user '$dbname'@'localhost' identified by '$dbpass';
grant all on $dbname.* to $dbname@localhost;
flush privileges;
QUIT
EOT
chown -R www-data /var/www/$hostname
rm -f /var/www/latest-zh_CN.zip
rm -rf /var/www/wordpress
echo "========================================================================"
echo "             wordpress install finished, please enjoy it!               "
echo "========================================================================"
