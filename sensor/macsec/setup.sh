#!/bin/bash -e

ip link del dev macsec0 2>/dev/null
ip link add link enp88s0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC
ip macsec add macsec0 tx sa 0 pn 1 on key 01 5ab1e25dc2c8ba299d87205e674f7a50
ip macsec add macsec0 rx port 1 address $MAC sa 0 pn 1 on key 00 5ab1e25dc2c8ba299d87205e674f7a50
ip link set macsec0 up
ip addr add $MAC_IP/24 dev macsec0

echo "Setup macsec0 with ip: $MAC_IP/24."

sleep infinity
