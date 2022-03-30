#!/bin/bash -e

echo "Iperf3 Testing with IPsec..."
for i in {1..20}
do
    json=$(iperf3 -u -c 10.0.0.2 -b ${i}00m -J) 
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" 10.1.20.233:3000/baseline &
    pid=&!
    wait $pid

    sleep 4
done

for i in {1..20}
do 
    sockperf ul -m 24938  -i 10.0.0.2 -t 10 --full-log log.csv
    P1=$!
    wait $P1

    curl -F "csv=@log.csv" 10.1.20.233:3000/server/baseline/sockperf &
    P2=$!
    wait $P2

done

sleep infinity
