#!/bin/bash -e

cat << EOF > /etc/ipsec.conf
config setup
    charondebug="all"
    uniqueids=yes
    strictcrlpolicy=no
 
conn zero-trust
    type=transport
    authby=secret
    left=$IP
    right=$SERVER_IP
    auto=start
    esp=null-sha256
EOF

cat << EOF > /etc/ipsec.secrets
#source     #destination
$IP/24 $SERVEER_IP/24 : PSK "einride"
EOF


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

# wait for child process to exit
wait "$child"
