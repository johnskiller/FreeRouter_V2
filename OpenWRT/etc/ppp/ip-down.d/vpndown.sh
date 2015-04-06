#!/bin/sh
LOG='/tmp/vpn.log'
if [ $1 == "pptp-linode" ]; then
echo "\$Log: VPN Disconnect! @$(date +"%T@%Y-%m-%d")" >>$LOG
echo "\$Log: Remove IP rules for table 'vpn'! @$(date +"%T@%Y-%m-%d")" >>$LOG
ip rule del table vpn
ip rule del from all fwmark 1
# rules for apple tv
ip rule del from 192.168.31.25
fi
