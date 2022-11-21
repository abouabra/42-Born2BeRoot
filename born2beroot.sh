sudo su -
apt -y install sudo openssh-server ufw libpam-pwquality curl lighttpd mariadb-server php-cgi php-mysql wget vsftpd ftp bc
#<-----configure sudo ------>
#add user to sudo
addgroup user42
adduser abouabra sudo
adduser abouabra user42
#sudo config
touch /etc/sudoers.d/sudo
mkdir /var/log/sudo/
echo 'Defaults	passwd_tries=3
Defaults	badpass_message="Bad Msg Enter Valid Passwd"
Defaults	logfile="/var/log/sudo/log"
Defaults	log_input,log_output
Defaults	iolog_dir="/var/log/sudo/"
Defaults	requiretty
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"' > /etc/sudoers.d/sudo
#<---------------------------->

#<-----configure ssh ------>
#ssh config
sed -i 's/#Port 22/Port 4242/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
#<---------------------------->

#<-----configure ufw ------>
#ufw config
ufw enable
ufw allow 4242
ufw allow 80
ufw allow 21
ufw status
#<---------------------------->

#<-----configure User Management ------>
#<-----configure login defs ------>

sed -i 's/PASS_MAX_DAYS	99999/PASS_MAX_DAYS	30/' /etc/login.defs
sed -i 's/PASS_MIN_DAYS	0/PASS_MIN_DAYS	2/' /etc/login.defs
sed -i 's/PASS_WARN_AGE	7/PASS_WARN_AGE	7/' /etc/login.defs
#<-----configure Password Strength ------>
sed -i 's/# difok = 1/difok = 7/' /etc/security/pwquality.conf
sed -i 's/# minlen = 8/minlen = 10/' /etc/security/pwquality.conf
sed -i 's/# dcredit = 0/dcredit = -1/' /etc/security/pwquality.conf
sed -i 's/# ucredit = 0/ucredit = -1/' /etc/security/pwquality.conf
sed -i 's/# lcredit = 0/lcredit = -1/' /etc/security/pwquality.conf
sed -i 's/# maxrepeat = 0/maxrepeat = 3/' /etc/security/pwquality.conf
sed -i 's/# usercheck = 1/usercheck = 1/' /etc/security/pwquality.conf
sed -i 's/# enforce_for_root/enforce_for_root/' /etc/security/pwquality.conf
#<---------------------------->

#<-----configure Cron ------>

crontab -l | { cat; echo "*/10 * * * * bash /home/abouabra/monitoring.sh"; } | crontab -
#<---------------------------->

#<-----configure Monitoring.sh ------>
curl https://raw.githubusercontent.com/abouabra/Born2BeRoot/master/monitoring.sh > /home/abouabra/monitoring.sh
chmod +x monitoring.sh
#<---------------------------->

#<-----configure mariadb ------>
mysql_secure_installation <<EOF

y
1598753246
1598753246
y
y
y
y
EOF

mariadb -e "CREATE DATABASE wordpress;"
mariadb -e "GRANT ALL ON wordpress.* TO 'abouabra'@'localhost' IDENTIFIED BY '1598753246' WITH GRANT OPTION;"
mariadb -e "FLUSH PRIVILEGES"
mariadb -e "SHOW DATABASES;"

#<---------------------------->
#<-----configure WordPress ------>

cd /var/www/html/
rm -rf *
wget http://wordpress.org/latest.tar.gz
tar -xzvf /var/www/html/latest.tar.gz
mv wordpress/* .
rm -rf latest.tar.gz wordpress
cp wp-config-sample.php wp-config.php

sed -i 's/database_name_here/wordpress/' wp-config.php
sed -i 's/username_here/abouabra/' wp-config.php
sed -i 's/password_here/1598753246/' wp-config.php

#<---------------------------->
#<-----configure Lighttpd ------>

lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php
service lighttpd force-reload
#<---------------------------->
#<-----configure FTP ------>
sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
chmod -R 777 *
#<---------------------------->

#<-----configure App Armor ------>
apt install apparmor-easyprof apparmor-notify apparmor-utils certspotter
sudo mkdir -p /etc/default/grub.d
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=1 security=apparmor"' > /etc/default/grub.d/apparmor.cfg
update-grub
reboot
#<---------------------------->
