#!/bin/bash

function checkValidIP() {
  if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

function splitIP() {
  IFS='.' read -r -a ipArr <<< "$1"
}

function swapIP() {
    if [ -n $ipEnd ]; then
      ipEnd=$ipStart
    fi
    for x in $(seq $ipStart $ipEnd)
      do
        if [ $typeConvertIP -eq 1 ]; then
          /sbin/ip addr add 10.${ipArr[2]}.${ipArr[3]}.${x}/24 dev $interface
          echo -e "/sbin/ip addr add 10.${ipArr[2]}.${ipArr[3]}.${x}/24 dev $interface" >> /etc/rc.local
        else
          /sbin/ip addr add 192.168.${ipArr[3]}.${x}/24 dev $interface
          echo -e "/sbin/ip addr add 192.168.${ipArr[3]}.${x}/24 dev $interface" >> /etc/rc.local
        fi
    done
  chmod +x /etc/rc.d/rc.local
  echo "Adding IP Complete. Checking Again using command: ip a"
}

function main() {
  read -p "Enter Public IP: " ipStr
  read -p "Number of IP add (30 40): " ipStart ipEnd
  read -p "Interface want to add IP (eth0): " interface
  if checkValidIP "$ipStr"; then
    splitIP "$ipStr"
    echo "[1] - 10.x.x.x" && echo "[2] - 192.168.x.x"
    read -p "Your Choice: " typeConvertIP
    swapIP "$typeConvertIP"
  else
    echo "Abort. Try again"
  fi
}

main
