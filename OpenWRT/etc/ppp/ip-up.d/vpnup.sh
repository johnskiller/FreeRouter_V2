#!/bin/sh
# Script which handles the routing issues as necessary for pppd
# Only the link to Newman requires this handling.
#
# When the ppp link comes up, this script is called with the following
# parameters
#       $1      the interface name used by pppd (e.g. ppp3)
#       $2      the tty device name
#       $3      the tty device speed
#       $4      the local IP address for the interface
#       $5      the remote IP address
#       $6      the parameter specified by the 'ipparam' option to pppd
#
set -x
LOG='/tmp/vpn.log'
echo "ip-up $1,$2,$3,$4,$5,$6" >> $LOG
if [ $1 == "pppoe-wan" ]; then
	echo "WAN UP @$(date +"%T@%Y-%m-%d")" >>$LOG
fi

if [ $1 == "pptp-linode" ]; then
echo "\$Log: VPN Connected! @$(date +"%T@%Y-%m-%d")" >>$LOG
VPN_DEV=$(ifconfig | grep "pptp" | sed -e "s#^\([^ ]*\) .*#\1#g")
echo "\$Log: Add DNS servers to VPN route! @$(date +"%T@%Y-%m-%d")" >>$LOG
route add -host 8.8.8.8 dev $VPN_DEV
echo "\$Log: Add VPN device for table 'vpn'! @$(date +"%T@%Y-%m-%d")" >>$LOG
ip route add default dev $VPN_DEV table vpn 
echo "\$Log: Add IP marked by firewall to table 'vpn'! @$(date +"%T@%Y-%m-%d")" >>$LOG  
ip rule add fwmark 1 priority 1984 table vpn
# rule for apple tv, allways to vpn
ip rule add from 192.168.31.25 lookup vpn
/etc/init.d/dnsmasq restart
fi
