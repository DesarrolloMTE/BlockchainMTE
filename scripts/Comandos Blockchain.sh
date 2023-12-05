

export CHANNEL_NAME=channelmte

peer channel create -o orderer.mte.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mte.com/orderers/orderer.mte.com/msp/tlscacerts/tlsca.mte.com-cert.pem

peer channel join -b channelmte.block

CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/users/Admin\@mariana.mte.com/msp/ CORE_PEER_ADDRESS=peer0.mariana.mte.com:7051 CORE_PEER_LOCALMSPID="marianaMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt peer channel join -b channelmte.block


CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdepartamental.mte.com/users/Admin\@hdepartamental.mte.com/msp/ CORE_PEER_ADDRESS=peer0.hdepartamental.mte.com:7051 CORE_PEER_LOCALMSPID="hdepartamentalMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdepartamental.mte.com/peers/peer0.hdepartamental.mte.com/tls/ca.crt peer channel join -b channelmte.block


CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/users/Admin\@cooperativa.mte.com/msp/ CORE_PEER_ADDRESS=peer0.cooperativa.mte.com:7051 CORE_PEER_LOCALMSPID="cooperativaMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/peers/peer0.cooperativa.mte.com/tls/ca.crt peer channel join -b channelmte.block


CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/users/Admin\@cesmag.mte.com/msp/ CORE_PEER_ADDRESS=peer0.cesmag.mte.com:7051 CORE_PEER_LOCALMSPID="cesmagMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/peers/peer0.cesmag.mte.com/tls/ca.crt peer channel join -b channelmte.block


CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/udenar.mte.com/users/Admin\@udenar.mte.com/msp/ CORE_PEER_ADDRESS=peer0.udenar.mte.com:7051 CORE_PEER_LOCALMSPID="udenarMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/udenar.mte.com/peers/peer0.udenar.mte.com/tls/ca.crt peer channel join -b channelmte.block



peer channel update -o orderer.mte.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/udenarMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mte.com/orderers/orderer.mte.com/msp/tlscacerts/tlsca.mte.com-cert.pem 


////// con los contratos hechos 


