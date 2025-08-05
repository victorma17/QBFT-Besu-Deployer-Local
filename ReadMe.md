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

Create the sub folder structure to our nodes
```bash
mkdir -p QBFT-Network
for i in {1..4}; do
  mkdir -p "QBFT-Network/Node-$i/data"
done
cd QBFT-Network
```

### ⚠️ IMPORT inside /QBFT-Network folder the qbftConfigFile.json, configBootnode.toml and configValidators.toml files that you wnat to try (take a look at URL from Besu Docu if you wan to test the sample one: https://besu.hyperledger.org/private-networks/tutorials/qbft#2-create-a-configuration-file) ⚠️ 

After that, we can generate the genesis and network folder
```bash
besu operator generate-blockchain-config --config-file=qbftConfigFile.json --to=networkFiles --private-key-file-name=key
```

We copy the genesis to a higher path
```bash
cp networkFiles/genesis.json .
```

We copy the validator keys that Besu has generated for us to our nodes
```bash
sh ../moveKeys.sh 
```

Now we need to **OPEN A NEW TERMINAL** and start the Bootloader Node ⛏️
```bash
cd QBFT-Network/Node-1 && besu --config-file=../configBootnode.toml 
```

### ⚠️  CAPTURE the enode URL from Node-1(Bootnode) and COPY IT in the others node start scripts ⚠️ 
Search for this format:
```bash
enode://7404a175960dbe4dba067f9c4fb21e35bca41583346aa2cce9bd0aa92479925d42b0540506ea0e016eeabcf48e98dbae3c8a03c6dbac57ac83e8229b4586ff36@127.0.0.1:30303
```

After add the enode in config file and later you can run them in **new and differents terminals**
Wait until 2 mins avg to let the nodes sync (or Round's are synced)
```bash
cd QBFT-Network/Node-2 && besu --config-file=../configValidators.toml --p2p-port=30304 --rpc-http-port=8546 --metrics-port=9546
```

```bash
cd QBFT-Network/Node-3 && besu --config-file=../configValidators.toml --p2p-port=30305 --rpc-http-port=8547 --metrics-port=9547
```

```bash
cd QBFT-Network/Node-4 && besu --config-file=../configValidators.toml --p2p-port=30306 --rpc-http-port=8548 --metrics-port=9548
```


## 🟢 DONE!! ENJOY OF YOUR LITTLE BLOCKCHAIN!!  🟢 


BTW, you have the folder called "sample-QBFT-Network" to see how must to be the structure as an example