# Run a node and (optionally) stake ETH using Prysm

## Environment preprocessing

## 1. Install Homebrew
    - .devcontainer/docker 
    - .devcontainer/devcontainer.json

## 2. Install Prysm

Create a folder called **ethereum** on your SSD, and then two subfolders within it: **consensus** and **execution**:
```
- ethereum
    - consensus
    - execution
```
### Download the Prysm client and make it executable
```
cd consensus
```
```
mkdir prysm && cd prysm
curl https://raw.githubusercontent.com/prysmaticlabs/prysm/master/prysm.sh --output prysm.sh && chmod +x prysm.sh
```


### Generate JWT Secret

The HTTP connection between your beacon node and execution node needs to be authenticated using a JWT token. 

```
openssl rand -hex 32 | tr -d "\n" > "jwt.hex"
```
Prysm will output a jwt.hex file path.


## 3. Run an execution client

install an execution-layer client that Prysm's beacon node will connect to.

### Geth installer

```
brew tap ethereum/ethereum
brew install ethereum
```

```
cd execution
geth --goerli --http --http.api eth,net,engine,admin --authrpc.jwtsecret /path/to/jwt.hex 
```


## 4. Run a beacon node using Prysm
Download the [Prater genesis state](https://github.com/eth-clients/eth2-networks/raw/master/shared/prater/genesis.ssz) from Github into your consensus/prysm directory. Then use the following command to start a beacon node that connects to your local execution node:

```
./prysm.sh beacon-chain --execution-endpoint=http://localhost:8551 --prater --jwt-secret=path/to/jwt.hex --genesis-state=genesis.ssz --suggested-fee-recipient=0x01234567722E6b0000012BFEBf6177F1D2e9758D9
```

make change on --suggested-fee-recipient and path/to/jwt.hex
