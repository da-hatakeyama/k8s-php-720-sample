#!/bin/bash

cp /etc/resolv.conf ~/
DNS_IP=""
while :
do
	sleep 5
	DNS_IP=`ping -c1 dns-sv | sed -nE 's/^PING[^(]+\(([^)]+)\).*/\1/p'`
	if [ -n "$DNS_IP" ]; then
		break
	fi
done

sed -i "s/\(^nameserver.*\)/nameserver ${DNS_IP}\n;\1/" ~/resolv.conf
cat ~/resolv.conf > /etc/resolv.conf
rm -rf ~/resolv.conf

