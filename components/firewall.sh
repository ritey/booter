#!/bin/bash
# Set up iptables.

if [ -n "$IPADDRESS" ]; then
iptables -A INPUT -p tcp -s $IPADDRESS --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
else
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
fi
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 111 -j ACCEPT
iptables -A INPUT -p udp --dport 111 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 24007:24011 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -j REJECT
iptables -A FORWARD -j REJECT

iptables-save > /etc/iptables.rules
