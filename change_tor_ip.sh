#!/bin/bash

# check tor log exist or not
if [ ! -d $HOME/.local/logs ]; then
    mkdir -p $HOME/.local/logs
fi

# Read auth cookie as hex string
COOKIE=$(xxd -ps /var/run/tor/control.authcookie | tr -d '\n')

# Send NEWNYM signal to Tor ControlPort using cookie authentication
printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$COOKIE" | nc 127.0.0.1 9051 > /dev/null

# Store IP logs
IP=$(curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r .IP)
echo "{'date':\'$(date '+%Y-%m-%d %H:%M:%S')\', - 'ip': '$IP'}" >> $HOME/.local/logs/tor_ip_log.log
