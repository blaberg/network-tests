#!/bin/bash

ip link del dev macsec0 2>/dev/null
ip link add link $DEVICE_0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC_0
ip macsec add macsec0 tx sa 0 pn 1 on key 00 5ab1e25dc2c8ba299d87205e674f7a50
ip macsec add macsec0 rx port 1 address $MAC_0 sa 0 pn 1 on key 01 5ab1e25dc2c8ba299d87205e674f7a50
ip link set macsec0 up
ip addr add $IP_0/24 dev macsec0

echo "Setup macsec0 with ip: $IP_0/24."

ip link del dev macsec9 2>/dev/null
ip link add link $DEVICE_2 macsec9 type macsec encrypt off
ip macsec add macsec9 rx port 1 address $MAC_2
ip macsec add macsec9 tx sa 0 pn 1 on key 00 5ab1e25dc2c8ba299d87205e674f7a50
ip macsec add macsec9 rx port 1 address $MAC_2 sa 0 pn 1 on key 01 5ab1e25dc2c8ba299d87205e674f7a50
ip link set macsec9 up
ip addr add $IP_2/24 dev macsec9

echo "Setup macsec9 with ip: $IP_2/24."

ip link del dev macsec10 2>/dev/null
ip link add link $DEVICE_3 macsec10 type macsec encrypt off
ip macsec add macsec10 rx port 1 address $MAC_3
ip macsec add macsec10 tx sa 0 pn 1 on key 00 5ab1e25dc2c8ba299d87205e674f7a50
ip macsec add macsec10 rx port 1 address $MAC_3 sa 0 pn 1 on key 01 5ab1e25dc2c8ba299d87205e674f7a50
ip link set macsec10 up
ip addr add $IP_3/24 dev macsec10

echo "Setup macsec10 with ip: $IP_3/24."


