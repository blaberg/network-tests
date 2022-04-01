#!/bin/bash -e

echo "Iperf3 Testing with IPsec..."
for j in {1..2}
do
for i in {1..10}
do
    echo "Sending ${i}00mb..."
    json=$(iperf3 -u -c $SERVER_IP -b ${i}00m -J) 
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" http://439d-158-174-154-62.ngrok.io/baseline &
    pid=&!
    wait $pid

    sleep 7
done
done

echo "Starting Sockperf test"

for i in {1..10}
do 
    sockperf ul -m 24938  -i $SERVER_IP -t 10 --full-log under-load.csv &
    P1=$!
    wait $P1

    curl -F "csv=@under-load.csv" http://439d-158-174-154-62.ngrok.io/server/baseline/sockperf &
    P2=$!
    wait $P2

done

for i in {1..10}
do 
    sockperf pp -m 24938  -i $SERVER_IP -t 10 --full-log ping-pong.csv &
    P3=$!
    wait $P3

    curl -F "csv=@ping-pong.csv" http://439d-158-174-154-62.ngrok.io/server/baseline/sockperf &
    P4=$!
    wait $P4

done

