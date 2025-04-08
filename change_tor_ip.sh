#!/bin/bash
# Read auth cookie as hex string
COOKIE=$(xxd -ps /var/run/tor/control.authcookie | tr -d '\n')
formate='+%Y-%m-%d %H:%M:%S'
# Send NEWNYM signal to Tor ControlPort using cookie authentication
printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$COOKIE" | nc 127.0.0.1 9051 > /dev/null

# Store IP logs
IP=$(curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r .IP)
echo "{'date':'$(date $formate )', - 'ip': '$IP'}" >> /var/log/tor-changer/tor_ip_log.log
