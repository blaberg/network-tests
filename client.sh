#!/bin/sh
echo '[ \n' > network-test.log
for i in 2 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    echo "Test $i"
    iperf3 -u -c 10.0.0.2 -b ${i}00m -J >> network-test.log
    echo ', \n' >> network-test.log
done
echo '] \n' >> network-test.log
