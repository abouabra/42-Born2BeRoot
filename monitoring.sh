LVM_COUNT=$(cat /etc/fstab | grep "LVMGroup" | wc -l)
LVM_ANSWER=$(if [ $LVM_COUNT -eq 0 ]; then echo "no";else echo "yes";fi)
NUMBER_OF_SOCKETS=$(lscpu | awk 'NR == 9 {printf $NF}')
CORE_PER_SOCKET=$(lscpu | awk 'NR == 8 {printf $NF}')
THREADS_PER_CORE=$(lscpu | awk 'NR == 7 {printf $NF}')
wall "
	#Architecture	: $(uname -a)
	#CPU physical	: $(echo $NUMBER_OF_SOCKETS \* $CORE_PER_SOCKET | bc)
	#vCPU		: $(echo $NUMBER_OF_SOCKETS \* $CORE_PER_SOCKET \* $THREADS_PER_CORE | bc)
	#Memory Usage: $(free -m | awk 'NR == 2 {printf("%s/%sMB (%.2f%%)",$3,$2,$3*100/$2)}')
	#Disk Usage: $(df --total -h | awk 'NR == 9 {printf("%d/%dGb (%.2f%%)", $3 * 1024, $2, $3*100/$2)}')
	#CPU load: $(top -bn1 | tr ',' ' ' | awk 'NR==3 {printf("%d%%", 100-$8)}')
	#Last boot: $(who -b | awk '{print $3 " " $4}')
	#LVM use: $LVM_ANSWER
	#Connexions TCP: $(cat /proc/net/sockstat | awk 'NR==2 {print $3}') ESTABLISHED
	#User log: $(users | wc -w)
	#Network: IP $(hostname -I) $(ip link | awk '$1 == "link/ether" {print $2}')
	#Sudo : $(journalctl _COMM=sudo | grep COMMAND | wc -l) cmd
"
