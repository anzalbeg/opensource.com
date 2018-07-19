#!/bin/sh
export GENESIS_BLOCK=/etc/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export POD_ID=`kubectl get pod --namespace org1namespace | grep peer1 | cut -f1 -d' '`
export ORDERER_ADDR="orderer"
export ORG_DOMAIN="org1.example.com"

#kubectl exec $POD_ID --namespace org1namespace -it --  bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=0.0.0.0:7051 peer channel create -o $ORDERER_ADDR:7050 -c mychannel -f $GENESIS_BLOCK"

#kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=0.0.0.0:7051 && peer channel join -b mychannel.block -o $ORDERER_ADDR:7050"

kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=0.0.0.0:7051 && peer chaincode install -n mycc -v 1.0 -p github.com/hyperledger/SmartProperty/chaincode/smartProperty"


#export GENESIS_BLOCK=/etc/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
#export POD_ID=`kubectl get pod --namespace org2namespace | grep peer2 | cut -f1 -d' '`
#export ORDERER_ADDR="orderer"
#export ORG_DOMAIN="org2.example.com"


#kubectl exec $POD_ID --namespace org2namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=0.0.0.0:7051 && peer channel join -b mychannel.block -o $ORDERER_ADDR:7050"
