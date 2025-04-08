TOR_GROUP="debian-tor"
sudo apt update && sudo apt install -y curl tor jq xxd
sudo mkdir /opt/tor
sudo mv -v change_tor_ip.sh /opt/tor
chmod +x /opt/tor/change_tor_ip.sh
sudo cp change-tor-ip.service /etc/systemd/system/
sudo usermod -aG "$TOR_GROUP" "$USER"
sudo systemctl daemon-reload
sudo systemctl enable --now change-tor-ip.service
sudo systemctl enable --now tor.service