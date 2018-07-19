#!/bin/sh
export GENESIS_BLOCK=/etc/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export POD_ID=`kubectl get pod --namespace org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_ADDR="10.60.0.61"
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH="/etc/crypto-config/opensource.com/HLF/chaincode/chaincode_example02"

#creating channel name mychannel
kubectl exec $POD_ID --namespace org1namespace -it --  bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=peer1.org1.example.com:7051 peer channel create -o $ORDERER_ADDR:7050 -c mychannel -f $GENESIS_BLOCK"

#joining mychannel with peer1
kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=peer1.org1.example.com:7051 && peer channel join -b mychannel.block -o $ORDERER_ADDR:7050"

#installing chaincode on peer1
kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=peer1.org1.example.com:7051 && peer chaincode install -n mycc -v 1.0 -p $CHAINCODE_PATH"

#setting up the peer2 env variables
export GENESIS_BLOCK=/etc/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export POD_ID=`kubectl get pod --namespace org2namespace | grep cli | cut -f1 -d' '`
export ORDERER_ADDR="10.60.0.61"
export ORG_DOMAIN="org2.example.com"
export CHAINCODE_PATH="/etc/crypto-config/opensource.com/HLF/chaincode/chaincode_example02"

#joining mychannel with peer2
kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=peer2.org2.example.com:7051 && peer channel join -b mychannel.block -o $ORDERER_ADDR:7050"

#installing chaincode on peer2
kubectl exec $POD_ID --namespace org1namespace -it -- bash -c "CORE_PEER_MSPCONFIGPATH=/etc/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp && CORE_PEER_ADDRESS=peer2.org2.example.com:7051 && peer chaincode install -n mycc -v 1.0 -p $CHAINCODE_PATH"
