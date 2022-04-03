#!/bin/bash -e


./sar.sh &

echo "Iperf3 baseline testing..."


for j in {1..2}
do
for i in {1..10}
do
    iperf3 -s -1 -B 10.0.0.11 &
    P1=$!
    psrecord $P1 --interval 1 --log ${i}00mb-0.txt --include-children &
    P2=$!

    iperf3 -s -1 -B 10.2.0.11 &
    P3=$!
    psrecord $P3 --interval 1 --log ${i}00mb-2.txt --include-children &
    P4=$!

    iperf3 -s -1 -B 10.3.0.11 &
    P5=$!
    psrecord $P5 --interval 1 --log ${i}00mb-3.txt --include-children &
    P6=$!
    wait $P2 $P4 $P6

    curl -F "log=@${i}00mb-0.txt"  http://439d-158-174-154-62.ngrok.io/server/ipsec/iperf3 &
    P7=$!
    curl -F "log=@${i}00mb-2.txt"  http://439d-158-174-154-62.ngrok.io/server/ipsec/iperf3 &
    P8=$!
    curl -F "log=@${i}00mb-3.txt"  http://439d-158-174-154-62.ngrok.io/server/ipsec/iperf3 &
    P9=$!
    wait $P7 $P8 $P9
done
done

echo "Finished Iperf3 baseline test"

sockperf sr -i 10.0.0.11 &
sockperf sr -i 10.2.0.11 &
sockperf sr -i 10.3.0.11 &

sleep infinity

