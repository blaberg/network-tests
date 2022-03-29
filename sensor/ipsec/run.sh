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

echo "Iperf3 Testing with IPsec..."
for i in {1..20}
do
    json=$(iperf3 -u -c 10.0.0.2 -b ${i}00m -J)
    
    curl -H "Content-Type: application/json" -X POST --data-binary "{ \"bitrate\" : \"${i}00m\", \"output\" : $json }" 10.1.20.233:3000/ipsec

    sleep 5
done

child=$!
# wait for child process to exit
wait "$child"
