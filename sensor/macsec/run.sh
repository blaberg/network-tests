#!/bin/bash

ip link del dev macsec0 2>/dev/null
ip link add link enp88s0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC
ip macsec add macsec0 tx sa 0 pn 1 on key 01 $TX_KEY
ip macsec add macsec0 rx port 1 address $MAC sa 0 pn 1 on key 00 $RX_KEY
ip link set macsec0 up
ip addr add $IP/24 dev macsec0

echo "Setup macsec0 with ip: $IP/24."

echo "Iperf3 Testing with IPsec..."
for i in {1..20}
do
    json=$(iperf3 -u -c 10.1.0.2 -b ${i}00m -J)
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" 10.1.20.233:3000/macsec
done

sleep infinity