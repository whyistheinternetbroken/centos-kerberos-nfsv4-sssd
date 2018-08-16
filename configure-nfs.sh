#!/bin/sh
systemctl start dbus
systemctl start rpcgssd
systemctl start rpcidmapd
systemctl restart sssd
echo [password]| realm join -U username --computer-ou [OU=Docker] [domain]
