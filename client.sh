#!/bin/sh
echo '[ \n' > network-test.log
for i in {1..20}
do
    iperf3 -u -c 10.0.0.2 -b ${i}00m -V -J > network-test.log
    echo ', \n' >> network-test.log
done
echo '] \n' >> network-test.log
