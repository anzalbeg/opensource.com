#!/bin/sh

set -ev

export VERSION=1.1.0
export ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')

MARCH=`uname -m`

FABRIC="$MARCH-$VERSION"
BIN="$ARCH-$VERSION"
SLEEP_TIMEOUT=10

ORG1_DOMAIN="org1.example.com"
ORG2_DOMAIN="org2.example.com"

if [ ! "$(docker images | grep hyperledger/fabric )" ]; then
 docker pull hyperledger/fabric-peer:$FABRIC
 docker pull hyperledger/fabric-ca:$FABRIC
 docker pull hyperledger/fabric-ccenv:$FABRIC
 docker pull hyperledger/fabric-orderer:$FABRIC
 docker pull hyperledger/fabric-couchdb:latest
fi

if [ ! -d "bin"]; then
    curl https://nexus.hyperledger.org/content/repositories/releases/org/hyperledger/fabric/hyperledger-fabric/${BIN}/hyperledger-fabric-${BIN}.tar.gz | tar xz
fi

sleep $SLEEP_TIMEOUT

./bin/cryptogen generate --config=./crypto-config.yaml

sleep $SLEEP_TIMEOUT

KEYSTORE1=`ls ./crypto-config/peerOrganizations/$ORG1_DOMAIN/users/Admin@$ORG1_DOMAIN/msp/keystore`
composer identity import \
-p hlfv1 \
-u Admin@$ORG1_DOMAIN \
-c ./crypto-config/peerOrganizations/$ORG1_DOMAIN/users/Admin@$ORG1_DOMAIN/msp/signcerts/Admin@$ORG1_DOMAIN-cert.pem \
-k ./crypto-config/peerOrganizations/$ORG1_DOMAIN/users/Admin@$ORG1_DOMAIN/msp/keystore/$KEYSTORE1

sleep $SLEEP_TIMEOUT

KEYSTORE2=`ls ./crypto-config/peerOrganizations/$ORG2_DOMAIN/users/Admin@$ORG2_DOMAIN/msp/keystore`
composer identity import \
-p hlfv1 \
-u Admin@$ORG2_DOMAIN \
-c ./crypto-config/peerOrganizations/$ORG2_DOMAIN/users/Admin@$ORG2_DOMAIN/msp/signcerts/Admin@$ORG2_DOMAIN-cert.pem \
-k ./crypto-config/peerOrganizations/$ORG2_DOMAIN/users/Admin@$ORG2_DOMAIN/msp/keystore/$KEYSTORE2

sleep $SLEEP_TIMEOUT

export FABRIC_CFG_PATH=$PWD

OUTPUT_DIR=$PWD/channel-artifacts

mkdir -p $OUTPUT_DIR

./bin/configtxgen -profile TwoOrgsOrdererGenesis -outputBlock $OUTPUT_DIR/orderer-genesis.block
./bin/configtxgen -profile TwoOrgsChannel -outputCreateChannelTx $OUTPUT_DIR/orderer-channel.tx -channelID mychannel

echo "... 🙌🏿"
  