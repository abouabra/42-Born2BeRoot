sudo su -
apt -y install sudo openssh-server ufw libpam-pwquality curl lighttpd mariadb-server php-cgi php-mysql wget vsftpd ftp
#<-----configure sudo ------>
#add user to sudo
addgroup user42
adduser abouabra sudo
adduser abouabra user42
#sudo config
touch /etc/sudoers.d/sudo.log

echo 'Defaults	passwd_tries=3
Defaults	badpass_message="Bad Msg Enter Valid Passwd"
Defaults	logfile="/var/log/sudo/log"
Defaults	log_input,log_output
Defaults	iolog_dir="/var/log/sudo"
Defaults	requiretty
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"' > /etc/sudoers.d/sudo.log
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
curl https://raw.githubusercontent.com/abouabra/Born2BeRoot/master/monitoring.sh > monitoring.sh
chmod +x monitoring.sh