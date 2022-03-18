#!/bin/sh
echo "Testing IPsec..."
echo '[ \n' > ipsec.json
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    echo "> Testing ${i}00 mbit"
    iperf3 -u -c 10.0.0.2 -b ${i}00m -J >> ipsec.json
    echo ', \n' >> ipsec.json
done
echo '] \n' >> ipsec.json

echo "Testing MACsec..."
echo '[ \n' > macsec.json
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
    echo "> Testing ${i}00 mbit"
    iperf3 -u -c 10.1.0.2 -b ${i}00m -J >> macsec.json
    echo ', \n' >> macsec.json
done
echo '] \n' >> macsec.json
