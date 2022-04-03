#!/bin/bash -e

echo "Setting up sar listener for network"
sar -n EDEV --iface=enp8s0,enp9s0,enp10s0 -o netlog 1 300 &
net=$!
echo "Setting up sar listener for cpu"
sar -u ALL -o cpulog 1 300 &
cpu=$!

wait $cpu $net
sadf -d netlog > netlog.csv
sadf -d cpulog > cpulog.csv

curl -F "cpu=@cpulog.csv" -F "net=@netlog.csv"   http://439d-158-174-154-62.ngrok.io/server/ipsec/cpu 


