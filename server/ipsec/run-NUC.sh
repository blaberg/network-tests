#!/bin/bash -e


# add iptables rules if IPTABLES=true
if [[ x${IPTABLES} == 'xtrue' ]]; then
  iptables -I INPUT ${INTERFACE} -p esp -j ACCEPT
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 500 --dport 500 -j ACCEPT
  iptables -I INPUT ${ENDPOINTS} ${INTERFACE} -p udp -m udp --sport 4500 --dport 4500 -j ACCEPT
  iptables -t nat -I POSTROUTING -m policy --dir out --pol ipsec -j ACCEPT
  iptables -t nat -I POSTROUTING -s ${RIGHTSUBNET} -j ACCEPT
fi

# enable ip forward
sysctl -w net.ipv4.ip_forward=1

# function to use when this script recieves a SIGTERM.
_term() {
  echo "Caught SIGTERM signal! Stopping ipsec..."
  kill -TERM "$child" 2>/dev/null
  ipsec stop
}

# catch the SIGTERM
trap _term SIGTERM

echo "Starting strongSwan/ipsec..."
ipsec start --nofork "$@" &

child=$!

#for j in {1..5}
#do
for i in {1..20}
do
    iperf3 -s -1 &
    P1=$!
    psrecord $(pgrep iperf3) --interval 1 --plot ${i}00mb.png --log ${i}00mb.txt --include-children &
    P2=$!
    wait $P1 $P2
    curl -F "plot=@${i}00mb.png" -F "log=@${i}00mb.txt" http://5b4b-46-239-92-149.ngrok.io/server/ipsec/iperf3 &
    P3=$!
    wait $P3
done
#done

echo "Finished Iperf3 tests!"
echo "Starting sockperf tests.."

sockperf sr -i 10.0.0.2

# wait for child process to exit
wait "$child"
