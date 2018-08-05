#!/bin/sh

# setting up the peer0org1 env variables inside cli environment

export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export ANCHOR_PEER=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/Org1MSPanchors.tx
export CLI_POD_ID=`kubectl get pod -n org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_ADDR="10.63.249.66:7050"
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp"
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_ADDRESS="10.63.241.223:7051"
export CHANNEL_NAME="mychannel"

#update Anchor peer0org1
kubectl exec $CLI_POD_ID -n org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer channel update -o $ORDERER_ADDR -c $CHANNEL_NAME -f $ANCHOR_PEER"


#setting up the peer0org2 env variables inside cli environment
export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export ANCHOR_PEER=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/Org2MSPanchors.tx
export CLI_POD_ID=`kubectl get pod -n org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_ADDR="10.63.249.66:7050"
export ORG_DOMAIN="org2.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp"
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_ADDRESS="10.63.245.74:7051"
export CHANNEL_NAME="mychannel"

#update Anchor peer
kubectl exec $CLI_POD_ID -n org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer channel update -o $ORDERER_ADDR -c $CHANNEL_NAME -f $ANCHOR_PEER"
