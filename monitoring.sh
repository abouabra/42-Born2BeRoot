LVM_COUNT=$(cat /etc/fstab | grep "LVMGROUP" | wc -l)
LVM_ANSWER=$(if [ $LVM_COUNT -eq 0 ]; then echo "no";else echo "yes";fi)
wall "
	#Architecture	: $(uname -a)
	#CPU physical	: $(lscpu | awk '$1 == "CPU(s):" {print $2}')
	#vCPU		: $(grep -c "^processor" /proc/cpuinfo)
	#Memory Usage: $(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')
	#Disk Usage: $(df --total -h | awk '$1 == "total" {printf("%d/%dGb (%.2f%%)", $3 * 1024, $2, $3*100/$2)}')
	#CPU load: $(top -bn1 | grep "%Cpu" | awk '{printf ("%.2f%%", $2+$4)}')
	#Last boot: $(who -b | awk '{print $3 " " $4}')
	#LVM use: $LVM_ANSWER
	#Connexions TCP: $(cat /proc/net/sockstat | awk ' $1 == "TCP:" {print $3}') ESTABLISHED
	#User log: $(users | wc -w)
	#Network: IP $(hostname -I) ($(ip link | awk '$1 == "link/ether" {print $2}'))
	#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd
"
