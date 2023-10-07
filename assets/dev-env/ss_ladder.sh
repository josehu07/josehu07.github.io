#/usr/bin/bash

sudo apt update
sudo apt -y upgrade

sudo apt -y install shadowsocks-libev
cat > /etc/shadowsocks-libev/config.json <<EOL
{
    "server": ["::0", "0.0.0.0"],
    "mode": "tcp_and_udp",
    "server_port": 42857,
    "password": "Hgz142857!?$",
    "timeout": 300,
    "method": "chacha20-ietf-poly1305",
    "fast_open": true,
}
EOL
sudo systemctl restart shadowsocks-libev

sudo apt -y install ufw
sudo ufw allow ssh
sudo ufw allow 42857
sudo ufw enable

