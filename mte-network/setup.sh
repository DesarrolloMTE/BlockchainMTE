#!/bin/bash

# crypto-config.yaml
cryptogen generate --config=./crypto-config.yaml

mkdir channel-artifacts
# Genesis block
configtxgen -profile ThreeOrgsOrdererGenesis -channelID system-channel -outputBlock ./channel-artifacts/genesis.block

# Create channel.tx
configtxgen -profile ThreeOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID channelmte

# Anchor peers updates
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/udenarMSPanchors.tx -channelID channelmte -asOrg udenarMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/cesmagMSPanchors.tx -channelID channelmte -asOrg cesmagMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/marianaMSPanchors.tx -channelID channelmte -asOrg marianaMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/cooperativaMSPanchors.tx -channelID channelmte -asOrg cooperativaMSP
configtxgen -profile ThreeOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/hdepartamentalMSPanchors.tx -channelID channelmte -asOrg hdepartamentalMSP

# Create Docker volume
docker volume create portainer_data

# Run Portainer container
docker run -d -p 8000:8000 -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Set environment variables
export CHANNEL_NAME=channelmte
export VERBOSE=false
export FABRIC_CFG_PATH=$PWD

# Bring up the network
CHANNEL_NAME=$CHANNEL_NAME docker-compose -f docker-compose-cli-couchdb.yaml up -d
