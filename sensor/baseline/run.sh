#!/bin/bash -e

echo "Iperf3 Testing with IPsec..."s
for i in {1..20}
do
    json=$(iperf3 -u -c 10.0.0.2 -b ${i}00m -J) 
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" 10.1.20.233:3000/baseline &
    pid=&!
    wait $pid

    sleep 4
done



sleep infinity
