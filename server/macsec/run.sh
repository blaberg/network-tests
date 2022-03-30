#!/bin/bash

ip link del dev macsec0 2>/dev/null
ip link add link enp88s0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC
ip macsec add macsec0 tx sa 0 pn 1 on key 00 $TX_KEY
ip macsec add macsec0 rx port 1 address $MAC sa 0 pn 1 on key 01 $RX_KEY
ip link set macsec0 up
ip addr add $IP/24 dev macsec0

echo "Setup macsec0 with ip: $IP/24."

for i in {1..20}
do
    iperf3 -s -1 &
    P1=$!
    psrecord $(pgrep iperf3) --interval 1 --plot ${i}00mb.png --log ${i}00mb.txt --include-children &
    P2=$!
    wait $P1 $P2
    curl -F "plot=@${i}00mb.png" -F "log=@${i}00mb.txt" 10.1.20.233:3000/server/macsec/iperf3 &
    P3=$!
    wait $P3
done

echo "Finished Iperf3 MACsec test"

sockperf sr -i 10.1.0.2
