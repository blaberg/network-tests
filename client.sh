#!/bin/sh

for i in {1..20}
echo '[ \n' > network-test.log
do
    iperf3 -u -c 10.0.0.2 -b ${i}00m -V -J > network-test.log
    echo ', \n' > network-test.log
done
echo '] \n' > network-test.log
