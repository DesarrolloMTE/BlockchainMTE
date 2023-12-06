#Business Blockchain Training & Consulting SpA. All Rights Reserved.
#www.blockchainempresarial.com
#email: ricardo@blockchainempresarial.com

export CHANNEL_NAME=channelmte
export CHAINCODE_NAME=energycontrol
export CHAINCODE_VERSION=1
export CC_RUNTIME_LANGUAGE=golang
export CC_SRC_PATH="../../../chaincode/$CHAINCODE_NAME/"
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mte.com/orderers/orderer.mte.com/msp/tlscacerts/tlsca.mte.com-cert.pem


#Descarga dependencias
#export FABRIC_CFG_PATH=$PWD/configtx
#pushd ../chaincode/$CHAINCODE_NAME
#GO111MODULE=on go mod vendor
#popd



#Empaqueta el chaincode
peer lifecycle chaincode package ${CHAINCODE_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CHAINCODE_NAME}_${CHAINCODE_VERSION} >&log.txt

#peer lifecycle chaincode install example
#first peer peer0.udenar.mte.com
peer lifecycle chaincode install ${CHAINCODE_NAME}.tar.gz 

#peer lifecycle chaincode uninstall -n ${CHAINCODE_NAME} -v ${CHAINCODE_VERSION} -C ${CHANNEL_NAME}

#\nPenergycontrol_1:2fa2b78d083696ac046cb462c9dfdaff57cbd88cadd49a8ce061085f142168f7\022\017energycontrol_1
# 2fa2b78d083696ac046cb462c9dfdaff57cbd88cadd49a8ce061085f142168f7



#Actualizar este  valor con el que obtengan al empaquetar el chaincode: energycontrol_1:a1c05f648dd24bd94128913d73486644ad6c351f19c429c4c661444039688299
export CC_PACKAGEID=2fa2b78d083696ac046cb462c9dfdaff57cbd88cadd49a8ce061085f142168f7

# peer0.cesmag
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/users/Admin@cesmag.mte.com/msp CORE_PEER_ADDRESS=peer0.cesmag.mte.com:7051 CORE_PEER_LOCALMSPID="cesmagMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/peers/peer0.cesmag.mte.com/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz

# peer0.mariana 
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/users/Admin@mariana.mte.com/msp CORE_PEER_ADDRESS=peer0.mariana.mte.com:7051 CORE_PEER_LOCALMSPID="marianaMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz

# peer0.cooperativa
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/users/Admin@cooperativa.mte.com/msp CORE_PEER_ADDRESS=peer0.cooperativa.mte.com:7051 CORE_PEER_LOCALMSPID="cooperativaMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/peers/peer0.cooperativa.mte.com/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz

# peer0.hdepartamental
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdepartamental.mte.com/users/Admin@hdepartamental.mte.com/msp CORE_PEER_ADDRESS=peer0.hdepartamental.mte.com:7051 CORE_PEER_LOCALMSPID="hdepartamentalMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/hdepartamental.mte.com/peers/peer0.hdepartamental.mte.com/tls/ca.crt peer lifecycle chaincode install  ${CHAINCODE_NAME}.tar.gz




#Endorsement policy for lifecycle chaincode 

peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')"  --package-id energycontrol_1:$CC_PACKAGEID


#Let mariana approve the chaincode package.
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/users/Admin@mariana.mte.com/msp  CORE_PEER_ADDRESS=peer0.mariana.mte.com:7051  CORE_PEER_LOCALMSPID="marianaMSP"  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt  peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mte.com/orderers/orderer.mte.com/msp/tlscacerts/tlsca.mte.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')"  --package-id energycontrol_1:$CC_PACKAGEID


CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/users/Admin@cooperativa.mte.com/msp  CORE_PEER_ADDRESS=peer0.cooperativa.mte.com:7051  CORE_PEER_LOCALMSPID="cooperativaMSP"  CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/peers/peer0.cooperativa.mte.com/tls/ca.crt  peer lifecycle chaincode approveformyorg --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/mte.com/orderers/orderer.mte.com/msp/tlscacerts/tlsca.mte.com-cert.pem --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --waitForEvent --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')"   --package-id energycontrol_1:$CC_PACKAGEID


#Commit  the chaincode  for udenar
 peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')"   --output json
 
 
 #commit chaincode FAILURE
peer lifecycle chaincode commit -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA  --peerAddresses peer0.udenar.mte.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/udenar.mte.com/peers/peer0.udenar.mte.com/tls/ca.crt --peerAddresses peer0.mariana.mte.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt --peerAddresses peer0.cooperativa.mte.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cooperativa.mte.com/peers/peer0.cooperativa.mte.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')" 


#check the chaincode commit 
 peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer','cooperativaMSP.peer')"  --output json
 
 #commit chaincode SUCCESS
 #Now commit chaincode. Note that we need to specify peerAddresses of both udenar and mariana (and their CA as TLS is enabled).
peer lifecycle chaincode commit -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA --peerAddresses peer0.udenar.mte.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/udenar.mte.com/peers/peer0.udenar.mte.com/tls/ca.crt --peerAddresses peer0.mariana.mte.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $CHAINCODE_VERSION --sequence 1 --signature-policy "OR ('udenarMSP.peer','marianaMSP.peer')"

#check the status of chaincode commit
peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --output json



############################################################################
#chaincode is committed and useable in the fabric network
#INIT LEDGER
#peer chaincode invoke -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA -C  $CHANNEL_NAME  -n $CHAINCODE_NAME -c '{"Args":["InitLedger"]}'
#udenar invokes set() with key “car01” and value “........”.
peer chaincode invoke -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA -C  $CHANNEL_NAME  -n $CHAINCODE_NAME -c '{"Args":["Set","did:3","ricardo","banana"]}'

 peer chaincode invoke -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA -C  $CHANNEL_NAME  -n $CHAINCODE_NAME -c '{"Args":["Set","did:3","ricardo","victor","16"]}'

#check the value of key “car01”
peer chaincode query -C $CHANNEL_NAME -n $CHAINCODE_NAME -c '{"Args":["Query","did:3"]}'



#ERROR CASE Org2 invoke CreateCar().
CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/users/Admin@cesmag.mte.com/msp  CORE_PEER_ADDRESS=peer0.cesmag.mte.com:7051 CORE_PEER_LOCALMSPID="cesmagMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/cesmag.mte.com/peers/peer0.cesmag.mte.com/tls/ca.crt  peer chaincode invoke -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA -C  $CHANNEL_NAME  -n $CHAINCODE_NAME -c '{"Args":["Set","did:5","marianela","manuel","20"]}'



CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/users/Admin@mariana.mte.com/msp  CORE_PEER_ADDRESS=peer0.mariana.mte.com:7051 CORE_PEER_LOCALMSPID="marianaMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/mariana.mte.com/peers/peer0.mariana.mte.com/tls/ca.crt  peer chaincode invoke -o orderer.mte.com:7050 --tls --cafile $ORDERER_CA -C  $CHANNEL_NAME  -n $CHAINCODE_NAME -c '{"Args":["Set","did:4","marianela","daniel","20"]}'