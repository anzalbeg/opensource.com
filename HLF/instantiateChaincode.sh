#!/bin/sh

# setting up the peer1 env variables inside cli environment

export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export CLI_POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
#export ORDERER_POD_ID=`kubectl get pod | grep orderer | cut -f1 -d' '`
#export ORDERER_ADDR=`kubectl get --output json  pods | jq '.items[] | select(.metadata.name=="'$ORDERER_POD_ID'")' | jq .status.podIP`
export ORDERER_ADDR="35.184.113.51:30724"
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp
export CORE_PEER_LOCALMSPID="Org1MSP"
#export PEER_POD_ID=`kubectl get pod --namespace org1namespace | grep peer1 | cut -f1 -d' '`
#export PEER_ADDRESS=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$PEER_POD_ID'")' | jq .status.podIP`
#export CORE_PEER_ADDRESS="$PEER_ADDRESS:7051"
export CORE_PEER_ADDRESS="35.193.91.66:32009"
export CHANNEL_NAME="mychannel"
export CORE_CHAINCODE_EXECUTETIMEOUT="2400s"
export CORE_CHAINCODE_STARTUPTIMEOUT="2400s"
export CORE_PEER_EVENTS_ADDRESS="35.193.91.66:32756"
export CORE_PEER_CHAINCODELISTENADDRESS="35.193.91.66:"

#instantiating chaincode

kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && CORE_CHAINCODE_EXECUTETIMEOUT=$CORE_CHAINCODE_EXECUTETIMEOUT && CORE_CHAINCODE_STARTUPTIMEOUT=$CORE_CHAINCODE_STARTUPTIMEOUT && CORE_PEER_EVENTS_ADDRESS=$CORE_PEER_EVENTS_ADDRESS && peer chaincode instantiate -o $ORDERER_ADDR -C $CHANNEL_NAME -n mycc -v 1.0 -c '{\"Args\":[\"init\",\"a\", \"100\", \"b\",\"200\"]}' -P \"OR ('Org1MSP.member','Org2MSP.member')\""
