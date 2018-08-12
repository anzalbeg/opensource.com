
 Hyperledger Fabric on Kubernetes on Google Cloud 
1. Pre-requisites: Below given is pre-requisites that need to be followed before deploying hyperledger fabric on Kubernetes. 

a. Download the latest Helm, add it to your $PATH. Follow the below commands 
? curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash 
? PATH=$PATH:$PWD/linux-amd64 
? helm version 

b. Now since we are using an RBAC-based Kubernetes (Engine) cluster, we need to install Helm’s Tiller to the cluster following the below commands: 
? kubectl create serviceaccount tiller --namespace=kube-system 
? kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller 
? helm init --service-account=tiller 

Above commands should return the below results. 
? $HELM_HOME has been configured at /usr/local/google/home/dazwilkin/.helm. 
? Tiller (the Helm server-side component) has been installed into your Kubernetes Cluster. 
? Please note: by default, Tiller is deployed with an insecure 'allow unauthenticated users' policy. For more information on securing your installation see: https://docs.helm.sh/using_helm/#securing-your-helm-installation Happy Helming! 

c. The Helm Chart requires a Kubernetes PersistentVolume that’s ReadWriteMany. So, we’re going to use NFS to provide the read-many capability. Ironically, the NFS solution we’re going to use is itself 


backed by Google Persistent Disk. Let’s create the NFS server because the Helm Chart depends upon it. Create the underlying Persistent Disk with the following commands. 

ZONE=${REGION}-c 
gcloud compute disks create nfs-disk \ --project=${PROJECT} \ --zone=${ZONE} \ --type=pd-standard \ --size=10GB 
d. Apply the following deployment file to your cluster to register SSD as a storage class: 

ssd.yaml: 
apiVersion: storage.k8s.io/v1 
kind: StorageClass 
metadata: 
name: ssd 
provisioner: kubernetes.io/gce-pd 
parameters: 
type: pd-ssd 
kubectl apply --filename=ssd.yaml 
e. Then apply the following Deployment and Service your Kubernetes cluster. The Deployment creates the NFS service using Google’s hosted volume-nfsimage and binds the service to the Persistent Disk: 

nfs-deployment.yaml: 
--- 
apiVersion: v1 
kind: PersistentVolumeClaim 
metadata: 
name: nfs 
spec: 
storageClassName: ssd 
accessModes: 
- ReadWriteOnce 
resources: 
requests: 
storage: 100Gi 
... 
--- 
apiVersion: extensions/v1beta1 
kind: Deployment 
metadata: 
name: nfs 
spec: 
replicas: 1 
selector: 
matchLabels: 
role: nfs 
template: 
metadata: 
labels: 
role: nfs 
spec: 
containers: 
- name: nfs 
image: gcr.io/google_containers/volume-nfs:0.8 
ports: 
- name: nfs 
containerPort: 2049 
- name: mountd 
containerPort: 20048 
- name: rpcbind 
containerPort: 111 
securityContext: 
privileged: true 
volumeMounts: 
- mountPath: /exports 
name: nfs 
volumes: 
- name: nfs 
persistentVolumeClaim: 
claimName: nfs 
readOnly: false 
... 
kubectl apply --filename=nfs-deployment.yaml 
nfs-servicre.yaml: 
apiVersion: v1 
kind: Service 
metadata: 
name: nfs 
spec: 
ports: 
- name: nfs 
port: 2049 
- name: mountd 
port: 20048 
- name: rpcbind 
port: 111 
selector: 
role: nfs 
kubectl apply --filename=nfs-service.yaml 
2. Generate the crypto material for the two organizations network using the command ‘./network-artifacts-gen.sh’. This will generate the crypto certificates for the hyperledger network having two organizations org1 and org2 with a single peer in each org and a solo orderer 

Note: This is already done and present in our repository at HLF ->crypto-config folder. 
3. Channel artifacts are also generated in the above steps after running network-artifacts-gen.sh scripts. This generates mychannel.tx file, orderer.genesis.block, Org1MSPAnchor.tx and Org2MSPAnchor.tx files which are required in the further steps to start the orderer with genesis block and creating the channel on the orderer and updating the anchor peers after joining the channels. 

Note: This is already done and present in our repository at HLF ->channel-artifacts folder. 
4. Creating the deployment scripts for every component in the network. This includes peers deployment files for each org, orderer deployment file and fabric-CA deployment files for each org and Cli deployment file 

Note: This is already done and present in our repository at HLF ->fabric-artifacts - >templates folder. 
5. Create the helm charts for packaging the deployment scripts. 

Note: This is already done and present in our repository at HLF ->fabric-artifacts - >chart.yaml folder. 

6. Create the helm values for packaging the deployment scripts. 

Note: This is already done and present in our repository at HLF ->fabric-artifacts - >values.yaml folder. 
7. Clone the repository using git clone https://github.com/anzalbeg/opensource.com.git 

8. Change the directory using below command. 

Command: “cd opensource/HFL 
Note: Before running the 9th step command, delete the existing fabric deployment using Command: “helm del --purge test” 
9. Deploy fabric components on Kubernetes using helm charts using the command 

Command: “helm install --name test ./fabric-artifacts -f org1.example.com.yaml” 
10. Verify in kubernetes dashboard that all of the peers, CA and orderer pods are up and running in kubernetes cluster. 

11. Navigate to HLF folder and then run the channel creation script ‘./channel.sh’. This scripts run ‘peer channel create --logging-level=DEBUG -o $ORDERER_ADDR -c $CHANNEL_NAME -f $GENESIS_BLOCK’ command from within the cli environment. This utilizes channel-


artifacts/mychannel.tx file and will create the channel with name “mychannel” on the orderer. 

Command: ‘./channel.sh’ 
12. Run the Join peers scripts ‘./joinChannel.sh’. This scripts run ‘peer channel join -b mychannel.block -o $ORDERER_ADDR’ command from within the cli environment. This utilizes mychannel.block file inside the cli pod and will make the peers of both the orgs to join the channel. 

Command: ‘./joinChannel.sh’ 
13. Run the update anchor peers scripts ‘./updateAnchorPeer.sh’. This scripts run ‘peer channel update -o $ORDERER_ADDR -c $CHANNEL_NAME -f $ANCHOR_PEER’ command from within the cli environment. This utilizes channel-artifacts/Org1MspAnchorpeer.tx file and 


channel-artifacts/Org2MspAnchorpeer.tx file and will update the anchor peers information on the channel. 

Command: ‘./updateAnchorPeer.sh’ 
14. Writing the smart contract as per the business requirements and put this smart contract at the repository location ./HLF/chaincode/chaincode_example02/go/ 

15. Run the chaincode installation scripts ‘./InstallChaincode.sh’. This scripts run ‘peer chaincode install -n supplychain -v 2.0 -p $CHAINCODE_PATH’ command from within the cli environment. This utilizes HLF/chaincode/chaincode_example02/go/chaincode_example02.go file and will install chaincode on each peer in each org with chaincode name as ‘supplychain’. 

Command: ‘./InstallChaincode.sh’ 

16. Run the chaincode instantiation scripts ‘./instantaiteChaoincode.sh’. This scripts run ‘peer chaincode instantiate -o $ORDERER_ADDR -C $CHANNEL_NAME -n supplychain -v 1.0 -c '{\"Args\":[\"init\",\" \"]}' -P \"OR ('Org1MSP.peer','Org2MSP.peer')\"’ command from within the cli environment. This will instantiate the chaincode aka smart contract on the channel. 

Command: ‘./instantiateChaincode.sh’ 
17. Run the chaincode invocation scripts ‘./invoke.sh’. This scripts run ‘peer chaincode invoke -o $ORDERER_ADDR -C $CHANNEL_NAME -n supplychain -c '{\"Args\":[\"createShipment\",\"shipment01\",\"{\\\"objectType\\\": \\\"shipment\\\",\\\"shipmentID\\\": \\\"shipment01\\\",\\\"purchaseOrder\\\": {\\\"purchaseOrderID\\\": \\\"purchase01\\\", \\\"ref\\\": \\\"987667eye56728yx87q80j\\\", \\\"shipmentOrderedState\\\": \\\"deliverywaiting\\\", \\\"orderDate\\\": \\\"2018-06-05T17:00:00Z\\\" }, \\\"customer\\\": { \\\"customerID\\\": \\\"customerID01\\\" }, \\\"carrier\\\": { \\\"carrierID\\\": 


\\\"3rdPartyLogistic\\\" }, \\\"location\\\": { \\\"latitude\\\": \\\"48.8566\\\", \\\"longitude\\\": \\\"2.3522\\\", \\\"address\\\": \\\"paris\\\", \\\"dock\\\": \\\"ns\\\" }, \\\"expectedDepartureDate\\\": \\\"2018-06-05T17:00:00Z\\\", \\\"expectedArrivedDate\\\": \\\"2018-06-05T17:00:00Z\\\", \\\"realDepartureDate\\\": \\\"2018-06-05T17:00:00Z\\\", \\\"realArrivedDate\\\": \\\"2018-06-05T17:00:00Z\\\", \\\"shipmentOrderedState\\\": \\\"loaded\\\", \\\"dispute\\\": false, \\\"reasonDispute\\\": \\\"na\\\" }\"]}'’ command from within the cli environment. This will invoke the chaincode on the channel and store the sample data. 

Command: ‘./invoke.sh’ 
18. Run the chaincode query scripts ‘./query.sh’. This scripts run ‘peer chaincode query -C $CHANNEL_NAME -n supplychain -c '{\"Args\":[\"readShipmentData\",\"shipment01\"]}'’ command from within the cli environment. This will query the chaincode on the channel and get the results. 

Command: ‘./query.sh’ 

19. Optional – Incase of any update in smart contract we need to run chaincode installation scripts again and then we need to run the upgrade chaincode scripts using the command ‘./upgradeChaincode.sh’. 

