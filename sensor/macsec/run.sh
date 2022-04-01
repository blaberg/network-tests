#!/bin/bash

ip link del dev macsec0 2>/dev/null
ip link add link enp88s0 macsec0 type macsec encrypt off
ip macsec add macsec0 rx port 1 address $MAC
ip macsec add macsec0 tx sa 0 pn 1 on key 01 $TX_KEY
ip macsec add macsec0 rx port 1 address $MAC sa 0 pn 1 on key 00 $RX_KEY
ip link set macsec0 up
ip addr add $IP/24 dev macsec0

echo "Setup macsec0 with ip: $IP/24."

echo "Iperf3 Testing with MACsec..."
for j in {1..5}
do
for i in {1..20}
do
    json=$(iperf3 -u -c 10.1.0.2 -b ${i}00m -J)
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" http://911f-46-239-92-149.ngrok.io/macsec &
    pid=&!
    wait $pid

    sleep 4
done
done

echo "Iperf3 test done!"
echo "Starting Sockperf test"

for i in {1..20}
do 
    sockperf ul -m 24938  -i 10.1.0.2 -t 10 --full-log under-load.csv &
    P1=$!
    wait $P1

    curl -F "csv=@under-load.csv" http://911f-46-239-92-149.ngrok.io/server/macsec/sockperf &
    P2=$!
    wait $P2

done

for i in {1..20}
do 
    sockperf pp -m 24938  -i 10.1.0.2 -t 10 --full-log ping-pong.csv &
    P3=$!
    wait $P3

    curl -F "csv=@ping-pong.csv" http://911f-46-239-92-149.ngrok.io/server/macsec/sockperf &
    P4=$!
    wait $P4

done

sleep infinity
