#!/bin/sh -e
echo "Testing..."
for i in 5 10 15 20
do
    iperf3 -u -c 10.0.0.2 -b ${i}00m -V
done
sleep infinity
