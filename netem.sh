
RATE=300kbps
CEIL=300kbps

tc-clean() {
  sudo tc qdisc del dev eth0 root
  sudo tc qdisc del dev eth1 root
}

tc-show() {
  # tc -s -d qdisc show dev eth0
  # tc -s -d qdisc show dev eth1
  tc -s -d qdisc show
}

iptables-clean() {
  sudo iptables -F
  sudo iptables -X
  sudo iptables -t nat -F
  sudo iptables -t nat -X
  sudo iptables -t mangle -F
  sudo iptables -t mangle -X
}

iptables-show() {
  sudo iptables-save
}

tc-rate() {
  echo "Your Rate Setting:"
  echo "Rate: $RATE"
  echo "Ceil: $CEIL"
}

tc-set-h2() {
  RATE=800kbps
  CEIL=800kbps
  tc-set
}

tc-set-h4() {
  RATE=800kbps
  CEIL=800kbps
  tc-set
}


tc-set() {
  tc-clean
  iptables-clean

  #sudo tc tc qdisc add dev eth0 root netem delay 100ms 10ms 10%
  #sudo tc tc qdisc add dev eth1 root netem delay 100ms 10ms 10%
  
  # iptables -t mangle -A POSTROUTING -d 192.168.0.135 -i eth0 -j MARK –set-mark 10


  # eth0

  sudo tc qdisc add dev eth0 root handle 10:0 htb default 0
  
  sudo tc class add dev eth0 parent 10:0 classid 10:1 htb rate $RATE ceil $CEIL
    sudo tc qdisc add dev eth0 parent 10:1 handle 101: pfifo
  
  sudo tc filter add dev eth0 parent 10:0 protocol ip prio 1 handle 100 fw classid 10:1

  
  sudo iptables -t mangle -A POSTROUTING -o eth0 -j MARK --set-mark 100
  sudo iptables -t mangle -A PREROUTING -i eth0 -j MARK --set-mark 100


  # eth1

  sudo tc qdisc add dev eth1 root handle 20:0 htb default 0
  
  sudo tc class add dev eth1 parent 20:0 classid 20:1 htb rate $RATE ceil $CEIL
    sudo tc qdisc add dev eth1 parent 20:1 handle 201: pfifo
  
  sudo tc filter add dev eth1 parent 20:0 protocol ip prio 1 handle 200 fw classid 20:1

  
  sudo iptables -t mangle -A POSTROUTING -o eth1 -j MARK --set-mark 200
  sudo iptables -t mangle -A PREROUTING -i eth1 -j MARK --set-mark 200

  #tc qdisc add dev eth0 root handle 10: htb rate $RATE ceil $CEIL
  #tc qdisc add dev eth1 root handle 20: htb rate $RATE ceil $CEIL

  tc-rate
}

temp () {
  echo "temp"

}
