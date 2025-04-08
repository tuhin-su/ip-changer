#!/bin/bash

# Read auth cookie as hex string
COOKIE=$(xxd -ps /var/run/tor/control.authcookie | tr -d '\n')

# Send NEWNYM signal to Tor ControlPort using cookie authentication
printf 'AUTHENTICATE %s\r\nSIGNAL NEWNYM\r\nQUIT\r\n' "$COOKIE" | nc 127.0.0.1 9051 > /dev/null

# Get current IP via Tor
IP=$(curl -s --socks5-hostname 127.0.0.1:9050 https://check.torproject.org/api/ip | jq -r .IP)

# Prepare log directory
LOG_DIR="/var/log/tor-changer"
LOG_FILE="$LOG_DIR/tor_ip_log.log"
sudo mkdir -p "$LOG_DIR"

# Log IP with timestamp in proper JSON format
echo "{\"date\": \"$(date '+%Y-%m-%d %H:%M:%S')\", \"ip\": \"$IP\"}" >> "$LOG_FILE"
