#!/bin/bash
# Cloud-init user-data script for Geth node setup
set -e
set -x
# Create dedicated user for geth
GETH_USER="geth"
GETH_HOME="/home/geth"
SECRET_FILE="/opt/secrets/jwt.hex"

# Create secrets directory
sudo mkdir -p /opt/secrets
openssl rand -hex 32 | tr -d "\n" | sudo tee $SECRET_FILE

# Get consensus client

curl -LO https://github.com/sigp/lighthouse/releases/download/v8.0.1/lighthouse-v8.0.1-x86_64-unknown-linux-gnu.tar.gz
sudo tar -xvf lighthouse-v8.0.1-x86_64-unknown-linux-gnu.tar.gz
sudo mv lighthouse /usr/bin/lighthouse
# Update system
sudo apt-get update -y

# Install Ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update -y
sudo apt-get install -y ethereum


# Create user with home directory and no login shell
sudo useradd -r -m -d "$GETH_HOME" -s /bin/bash "$GETH_USER"

# Create data directory structure
sudo mkdir -p /opt/data/geth
sudo mkdir -p /opt/data/lighthouse
sudo chown -R "$GETH_USER:$GETH_USER" /opt/data
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
ExecStart=/usr/bin/geth --sepolia --authrpc.addr localhost --authrpc.port 8551 --authrpc.vhosts localhost --authrpc.jwtsecret $SECRET_FILE --datadir /opt/data/geth
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service for lighthouse beacon node
sudo tee /etc/systemd/system/lighthouse-bn.service << EOF
[Unit]
Description=Lighthouse Beacon Node
After=network.target geth.service
Requires=geth.service

[Service]
Type=simple
User=$GETH_USER
Group=$GETH_USER
WorkingDirectory=$GETH_HOME
ExecStart=/usr/bin/lighthouse bn \
  --network sepolia \
  --execution-endpoint http://localhost:8551 \
  --execution-jwt $SECRET_FILE \
  --checkpoint-sync-url https://checkpoint-sync.sepolia.ethpandaops.io
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable and start services
sudo systemctl daemon-reload
sudo systemctl enable geth
sudo systemctl enable lighthouse-bn
sudo systemctl start geth
sudo systemctl start lighthouse-bn
