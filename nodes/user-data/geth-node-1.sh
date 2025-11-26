#!/bin/bash
# Cloud-init user-data script for Geth node setup
set -e
set -x

# Update system
sudo apt-get update -y

# Install Ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update -y
sudo apt-get install -y ethereum

# Create dedicated user for geth
GETH_USER="geth"
GETH_HOME="/home/geth"

# Create user with home directory and no login shell
sudo useradd -r -m -d "$GETH_HOME" -s /bin/bash "$GETH_USER"

# Create data directory
sudo mkdir -p /opt/geth
sudo chown -R "$GETH_USER:$GETH_USER" /opt/geth
# Create systemd service for geth
sudo tee /etc/systemd/system/geth.service << EOF
[Unit]
Description=Ethereum Geth Node
After=network.target

[Service]
Type=simple
User=$GETH_USER
Group=$GETH_USER
WorkingDirectory=$GETH_HOME
ExecStart=/usr/bin/geth --http --http.api eth,web3,net,txpool --ws --ws.api eth,web3,net,txpool --datadir /opt/geth
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable and start geth service
sudo systemctl daemon-reload
sudo systemctl enable geth
sudo systemctl start geth

echo "User-data script completed at $(date)"