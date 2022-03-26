#!/bin/bash

ip link del dev macsec0 2>/dev/null
ip link add link enp88s0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC
ip macsec add macsec0 tx sa 0 pn 1 on key 00 $TX_KEY
ip macsec add macsec0 rx port 1 address $MAC sa 0 pn 1 on key 01 $RX_KEY
ip link set macsec0 up
ip addr add $IP/24 dev macsec0

echo "Setup macsec0 with ip: $IP/24."

iperf3 -s

sleep infinity
