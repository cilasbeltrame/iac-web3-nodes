#!/usr/bin/env bash

sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update -y && sudo apt-get install ethereum -y
geth --http.api eth,web3,net,txpool --ws --ws.api eth,web3,net,txpool