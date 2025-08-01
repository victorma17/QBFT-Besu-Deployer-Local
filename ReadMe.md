# QBFT-Besu-Deployer

https://besu.hyperledger.org/private-networks/tutorials/qbft#3-generate-node-keys-and-a-genesis-file

## Pre-Requisites

Install these tools
```bash
brew tap hyperledger/besu
brew install hyperledger/besu/besu
brew install openjdk@21
```

Update the export paths
```bash
export JAVA_HOME="/opt/homebrew/opt/openjdk@21"
export PATH="$JAVA_HOME/bin:$PATH"
sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Install Instructions

Create the sub folder
```bash
mkdir -p QBFT-Network
```
Create the sub folder structure to our nodes
```bash
for i in {1..4}; do
  mkdir -p "QBFT-Network/Node-$i/data"
done
```
Move to the folder
```bash
cd QBFT-Network
```

### ⚠️  IMPORT HERE the QBFTConfigFile.json that you WANT (take a look at URL from Besu Docu) ⚠️ 

Generate the genesis and noetwork folder
```bash
besu operator generate-blockchain-config --config-file=QBFTConfigFile.json --to=networkFiles --private-key-file-name=key
```

Copiamos el genesis en una ruta superior
```bash
cp networkFiles/genesis.json .
```

Copiamos las claves de los validadores que nos ha generado Besu a nuestros nodos
```bash
sh ../moveKeys.sh 
```

Iniciamos el primero nodo bootloader
```bash
cd QBFT-Network/Node-1 && besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --profile=ENTERPRISE
```

### ⚠️  CAPTURE the enode://xxx from Node-1(Bootnode) and COPY it in the next node start scripts ⚠️ 
Like this format:
```bash
enode://7404a175960dbe4dba067f9c4fb21e35bca41583346aa2cce9bd0aa92479925d42b0540506ea0e016eeabcf48e98dbae3c8a03c6dbac57ac83e8229b4586ff36@127.0.0.1:30303
```

Luego los demas cada uno en su terminal - Esperamos 5 mins a que se encuentren
```bash
cd QBFT-Network/Node-2 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=<ENODE NODE 1> --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546 --profile=ENTERPRISE
```

```bash
cd QBFT-Network/Node-3 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=<ENODE NODE 1> --p2p-port=30305 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8547 --profile=ENTERPRISE
```

```bash
cd QBFT-Network/Node-4 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=<ENODE NODE 1> --p2p-port=30306 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8548 --profile=ENTERPRISE
```

Done, you have the "sample-QBFT-Network" to see how must to be

## 🟢 ENJOY OF YOUR LITTLE BLOCKCHAIN!!  🟢 

