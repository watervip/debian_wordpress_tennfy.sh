#!/bin/bash
# Check if user is root
if [ $(id -u) != "0" ]; then
    printf "Error: You must be root to run this script!\n"
    exit 1
fi

echo "=========================================================================\n"
printf "Auto install wordpress with lnmp install on your vps,written by tennfy \n"
printf "Version 0.1 \n"
 
read -p "Please input your hostname ,For example tennfy.com :" hostname
read -p "please MySql root password:" dbrootpass
read -p "please input database name:" dbname
read -p "please input database password:" dbpass
cd /var/www
wget http://cn.wordpress.org/wordpress-4.2-zh_CN.zip
unzip wordpress-3.9-zh_CN.zip
cp -r ./wordpress/* /var/www/$hostname
cd /var/www/$hostname
cp wp-config-sample.php wp-config.php
sed -i 's/database_name_here/'$dbname'/g' /var/www/$hostname/wp-config.php
sed -i 's/username_here/'$dbname'/g' /var/www/$hostname/wp-config.php
sed -i 's/password_here/'$dbpass'/g' /var/www/$hostname/wp-config.php
 mysql -u root -p$dbrootpass -s <<EOT
 create database if not exists $dbname default charset utf8 collate utf8_general_ci;
create user '$dbname'@'localhost' identified by '$dbpass';
grant all on $dbname.* to $dbname@localhost;
flush privileges;
QUIT
EOT
chown -R www-data /var/www/$hostname
echo "=========================================================================\n"
echo "Auto install WordPress Complete!Good Bye!"
