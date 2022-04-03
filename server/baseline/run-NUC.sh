#!/bin/bash -e

timestamp() {
  date +"%T" # current time
}

echo "Iperf3 baseline testing..."

for j in {1..5}
do
for i in {1..20}
do
    iperf3 -s -1 &
    P1=$!
    psrecord $(pgrep iperf3) --interval 1 --plot ${i}00mb.png --log ${i}00mb.txt --include-children &
    P2=$!
    wait $P1 $P2
    curl -F "plot=@${i}00mb.png" -F "log=@${i}00mb.txt" 10.16.8.111:3000/server/baseline/iperf3 &
    P3=$!
    wait $P3
done
done

echo "Finished Iperf3 baseline test"

sockperf sr -i 10.0.0.2

