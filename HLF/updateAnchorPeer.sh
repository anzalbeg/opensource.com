#!/bin/sh

# setting up the peer1 env variables inside cli environment

export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export ANCHOR_PEER=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/Org1MSPanchors.tx
export CLI_POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_POD_ID=`kubectl get pod | grep orderer | cut -f1 -d' '`
export ORDERER_ADDR=`kubectl get --output json  pods | jq '.items[] | select(.metadata.name=="'$ORDERER_POD_ID'")' | jq .status.podIP`
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp
export CORE_PEER_LOCALMSPID="Org1MSP"
export PEER_POD_ID=`kubectl get pod --namespace org1namespace | grep peer1 | cut -f1 -d' '`
export PEER_ADDRESS=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$PEER_POD_ID'")' | jq .status.podIP`
export CORE_PEER_ADDRESS="$PEER_ADDRESS:7051"
export CHANNEL_NAME="mychannel"
export CORE_CHAINCODE_EXECUTETIMEOUT=150000

#update Anchor peer
kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer channel update -o $ORDERER_ADDR:7050 -c $CHANNEL_NAME -f $ANCHOR_PEER"


#setting up the peer2 env variables inside cli environment
export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export ANCHOR_PEER=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/Org2MSPanchors.tx
export CLI_POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_POD_ID=`kubectl get pod | grep orderer | cut -f1 -d' '`
export ORDERER_ADDR=`kubectl get --output json  pods | jq '.items[] | select(.metadata.name=="'$ORDERER_POD_ID'")' | jq .status.podIP`
export ORG_DOMAIN="org2.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp"
export CORE_PEER_LOCALMSPID="Org2MSP"
export PEER_POD_ID=`kubectl get pod --namespace org2namespace | grep peer2 | cut -f1 -d' '`
export PEER_ADDRESS=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$PEER_POD_ID'")' | jq .status.podIP`
export CORE_PEER_ADDRESS="$PEER_ADDRESS:7051"
export CHANNEL_NAME="mychannel"

#update Anchor peer
kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer channel update -o $ORDERER_ADDR:7050 -c $CHANNEL_NAME -f $ANCHOR_PEER"