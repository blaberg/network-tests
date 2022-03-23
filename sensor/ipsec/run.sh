#!/bin/bash -e

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
