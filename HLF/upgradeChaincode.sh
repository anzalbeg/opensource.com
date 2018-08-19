#!/bin/sh

# setting up the peer1 env variables inside cli environment

export GENESIS_BLOCK=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/channel-artifacts/orderer-channel.tx
export CLI_POD_ID=`kubectl get pod -n org1namespace | grep cli | cut -f1 -d' '`
export ORDERER_ADDR=$config_clusterIpRange".249.66:7050"
export ORG_DOMAIN="org1.example.com"
export CHAINCODE_PATH=github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/chaincode/chaincode_example02/go
export CORE_PEER_MSPCONFIGPATH="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/crypto-config/opensource.com/HLF/crypto-config/peerOrganizations/$ORG_DOMAIN/users/Admin@$ORG_DOMAIN/msp"
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_ADDRESS=$config_clusterIpRange".241.223:7051"
export CHANNEL_NAME="mychannel"
#instantiating  chain code

kubectl exec $CLI_POD_ID -n org1namespace -it -- bash -c "CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID && CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH && CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS && peer chaincode upgrade -o $ORDERER_ADDR -C $CHANNEL_NAME -n mycc -v 4.0 -c '{\"Args\":[\"init\",\" \"]}' -P \"OR ('Org1MSP.peer','Org2MSP.peer')\""
