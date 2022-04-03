#!/bin/bash


./sar.sh &

echo "Iperf3 MACsec testing..."

for j in {1..2}
do
for i in {1..10}
do
    iperf3 -s -1 -B 10.1.0.1 &
    P1=$!
    psrecord $P1 --interval 1 --log ${i}00mb-0.txt --include-children &
    P2=$!

    iperf3 -s -1 -B 10.4.0.11 &
    P3=$!
    psrecord $P3 --interval 1 --log ${i}00mb-2.txt --include-children &
    P4=$!

    iperf3 -s -1 -B 10.13.0.11 &
    P5=$!
    psrecord $P5 --interval 1 --log ${i}00mb-3.txt --include-children &
    P6=$!
    wait $P2 $P4 $P6

    curl -F "log=@${i}00mb-0.txt"  http://439d-158-174-154-62.ngrok.io/server/baseline/iperf3 &
    P7=$!
    curl -F "log=@${i}00mb-2.txt"  http://439d-158-174-154-62.ngrok.io/server/baseline/iperf3 &
    P8=$!
    curl -F "log=@${i}00mb-3.txt"  http://439d-158-174-154-62.ngrok.io/server/baseline/iperf3 &
    P9=$!
    wait $P7 $P8 $P9
done
done

echo "Finished Iperf3 MACsec test"

sockperf sr -i 10.1.0.1 &
sockperf sr -i 10.4.0.11 &
sockperf sr -i 10.13.0.11 &

sleep infinity
