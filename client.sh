#!/bin/sh
echo -e '[ \n' > network-test.log
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    echo "Test $i"
    iperf3 -u -c 10.0.0.2 -b ${i}00m -V -J >> network-test.log
    echo ', \n' >> network-test.log
done
echo -e '] \n' >> network-test.log
