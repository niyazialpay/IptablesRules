#!/bin/bash
# Muhammed Niyazi ALPAY
# https://niyazialpay.com

function iptablesrules(){
	echo ""
	echo "=========================================================="
	echo ""


	read -p "Enter IP addresses between them with commas: " ipaddresses
	echo ""
	read -p "Enter port numbers between them with commas: " ports
	echo ""

	echo 0 > /proc/sys/net/ipv4/ip_forward

	iptables -A INPUT -p tcp -m multiport --dports $ports -s 127.0.0.1,$ipaddresses -j ACCEPT
	iptables -A INPUT -p udp -m multiport --dports $ports -s 127.0.0.1,$ipaddresses -j ACCEPT

	iptables -A INPUT -p tcp -m multiport --dports $ports -j DROP
	iptables -A INPUT -p udp -m multiport --dports $ports -j DROP

	echo 1 > /proc/sys/net/ipv4/ip_forward

	echo ""
	echo "=========================================================="
	echo ""

	echo "The process is successfully completed."

	echo ""
	echo "=========================================================="
	echo ""
}

read -p "Have you remove previous iptables rules? (y or n) 
" removerule

if [ ${removerule} == "y" ]; then
	echo "Flushing Iptables rules"
	iptables --flush
elif [ ${removerule} == "n" ]; then
	echo ""
else
	echo "Please enter y or n"
fi

iptablesrules

condition_to_check="False"
while [[ ${condition_to_check} == "False" ]]; do
    read -p "Continue processing? (y or n) " query
    if [ ${query} == "n" ]; then
		condition_to_check="True"
    elif [ ${query} == "y" ]; then
		iptablesrules
	else
		echo "Please enter y or n"
	fi
done
chkconfig iptables on
service iptables save
echo ""
echo "=========================================================="
echo ""
echo "Saving Iptables rules"
