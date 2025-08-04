# QBFT-Besu-Deployer

https://besu.hyperledger.org/private-networks/tutorials/qbft

## Pre-Requisites

🟡 Install these tools
```bash
brew tap hyperledger/besu
brew install hyperledger/besu/besu
brew install openjdk@21
```

🟡 Update the export paths
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

### ⚠️  IMPORT inside QBFT-Network folder the QBFTConfigFile.json file that you wnat to try (take a look at URL from Besu Docu if you wan to test the sample one: https://besu.hyperledger.org/private-networks/tutorials/qbft#2-create-a-configuration-file) ⚠️ 

After that, we can generate the genesis and noetwork folder
```bash
besu operator generate-blockchain-config --config-file=QBFTConfigFile.json --to=networkFiles --private-key-file-name=key
```

We copy the genesis to a higher path
```bash
cp networkFiles/genesis.json .
```

We copy the validator keys that Besu has generated for us to our nodes
```bash
sh ../moveKeys.sh 
```

Now we need to **open a new terminal** and start the Bootloader Node ⛏️
```bash
cd QBFT-Network/Node-1 && besu --data-path=data --genesis-file=../genesis.json --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all"
```

### ⚠️  CAPTURE the enode URL (Format: enode://xxx) from Node-1(Bootnode) and COPY IT in the others node start scripts ⚠️ 
Search for this format:
```bash
enode://7404a175960dbe4dba067f9c4fb21e35bca41583346aa2cce9bd0aa92479925d42b0540506ea0e016eeabcf48e98dbae3c8a03c6dbac57ac83e8229b4586ff36@127.0.0.1:30303
```

After add the enode here, you can ran them in new and differents terminals
```bash
cd QBFT-Network/Node-2 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=enode://0830121f7dc0f849bdaa6bebf83525d99154eeff1219d6766898ab7bec2ab25f46828da36b717bf48c5c21b543de7a67ebae0966cc71f115c338244fd8bcf720@127.0.0.1:30303 --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546 
```

```bash
cd QBFT-Network/Node-3 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=enode://0830121f7dc0f849bdaa6bebf83525d99154eeff1219d6766898ab7bec2ab25f46828da36b717bf48c5c21b543de7a67ebae0966cc71f115c338244fd8bcf720@127.0.0.1:30303 --p2p-port=30305 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8547 
```

```bash
cd QBFT-Network/Node-4 && besu --data-path=data --genesis-file=../genesis.json --bootnodes=enode://0830121f7dc0f849bdaa6bebf83525d99154eeff1219d6766898ab7bec2ab25f46828da36b717bf48c5c21b543de7a67ebae0966cc71f115c338244fd8bcf720@127.0.0.1:30303 --p2p-port=30306 --rpc-http-enabled --rpc-http-api=ETH,NET,QBFT --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8548 
```


## 🟢 DONE!! ENJOY OF YOUR LITTLE BLOCKCHAIN!!  🟢 


BTW, you have the "sample-QBFT-Network" to see how must to be as an example