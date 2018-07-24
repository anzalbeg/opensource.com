#!/bin/sh

# setting up the peer1 env variables inside cli environment

# setting up the peer1 env variables inside cli environment

export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export CLI_POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
#export ORDERER_POD_ID=`kubectl get pod | grep orderer | cut -f1 -d' '`
#export ORDERER_ADDR=`kubectl get --output json  pods | jq '.items[] | select(.metadata.name=="'$ORDERER_POD_ID'")' | jq .status.podIP`
export ORDERER_ADDR="35.184.113.51:30724"
export ORG_DOMAIN="org2.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp
export CORE_PEER_LOCALMSPID="Org2MSP"
#export PEER_POD_ID=`kubectl get pod --namespace org1namespace | grep peer1 | cut -f1 -d' '`
#export PEER_ADDRESS=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$PEER_POD_ID'")' | jq .status.podIP`
#export CORE_PEER_ADDRESS="$PEER_ADDRESS:7051"
export CORE_PEER_ADDRESS="104.197.198.61:31771"
export CHANNEL_NAME="mychannel"
#export CORE_PEER_EVENTS_ADDRESS="35.193.91.66:32756"
#export CORE_PEER_CHAINCODELISTENADDRESS="35.193.91.66:32757"
#export CORE_CHAINCODE_DEPLOYTIMEOUT="300s"
#export CORE_CHAINCODE_STARTUPTIMEOUT="300s"
#export CORE_VM_DOCKER_ATTACHSTDOUT="true"
#instantiating chaincode
# invoke 

kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_VM_DOCKER_ATTACHSTDOUT=$CORE_VM_DOCKER_ATTACHSTDOUT && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer chaincode query -C $CHANNEL_NAME -n mycc -c '{\"Args\":[\"query\",\"a\"]}'"


#setting up the peer2 env variables inside cli environment
# export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
# export CLI_POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
# export ORDERER_POD_ID=`kubectl get pod --namespace orderernamepsace | grep orderer | cut -f1 -d' '`
# export ORDERER_ADDR=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$ORDERER_POD_ID'")' | jq .status.podIP`
# export ORG_DOMAIN="org2.example.com"
# export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
# export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp"
# export CORE_PEER_LOCALMSPID="Org2MSP"
# export PEER_POD_ID=`kubectl get pod --namespace org2namespace | grep peer2 | cut -f1 -d' '`
# export PEER_ADDRESS=`kubectl get --all-namespaces  --output json  pods | jq '.items[] | select(.metadata.name=="'$PEER_POD_ID'")' | jq .status.podIP`
# export CORE_PEER_ADDRESS="$PEER_ADDRESS:7051"
# export CHANNEL_NAME="mychannel"

# joining mychannel with peer2

# kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer channel join -b mychannel.block -o $ORDERER_ADDR:7050"

# #installing chaincode on peer2

#kubectl exec $CLI_POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer chaincode install -n mycc -v 1.0 -p $CHAINCODE_PATH"
