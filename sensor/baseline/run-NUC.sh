#!/bin/bash -e

echo "Iperf3 Testing with IPsec..."
for j in {1..5}
do
for i in {1..20}
do
    json=$(iperf3 -u -c 10.0.0.2 -b ${i}00m -J) 
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" 10.16.8.111:3000/baseline &
    pid=&!
    wait $pid

    sleep 4
done
done

echo "Starting Sockperf test"

for i in {1..20}
do 
    sockperf ul -m 24938  -i 10.0.0.2 -t 10 --full-log under-load.csv &
    P1=$!
    wait $P1

    curl -F "csv=@under-load.csv" 10.16.8.111:3000/server/baseline/sockperf &
    P2=$!
    wait $P2

done

for i in {1..20}
do 
    sockperf pp -m 24938  -i 10.0.0.2 -t 10 --full-log ping-pong.csv &
    P3=$!
    wait $P3

    curl -F "csv=@ping-pong.csv" 10.16.8.111:3000/server/baseline/sockperf &
    P4=$!
    wait $P4

done

sleep infinity
