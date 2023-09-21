# Run a node and (optionally) stake ETH using Rocket pool, Geth, and lighthouse in codespace

## 1. Creating a Standard Rocket Pool Node with Docker
Process Overview
At a high level, here's what is involved in installing Rocket Pool:

* Download the Rocket Pool command-line interface (CLI)
* Use the CLI to install the Smartnode stack
* Configure the Smartnode stack with an easy-to-use UI in the terminal


### Step 1. Downloading the Rocket Pool CLI
Start by creating a new folder that will hold the CLI application:

```
mkdir -p ~/bin
```

Next, download the CLI. This depends on what architecture your system uses, in codespace, it's usually x86_64. 

* TIP
  * If you do not know your CPU architecture, you can run the following command to find it:
    ```
    uname -m
    ```
    The output of this command will print your architecture. Note that x86_64 is the same as x64 and amd64.Note that aarch64 is the same as arm64.

For x64 systems (most normal computers):
```
wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64 -O ~/bin/rocketpool
```

For arm64 systems:
```
wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-arm64 -O ~/bin/rocketpool
```

Mark it as executable, so it has permissions to run:

```
chmod +x ~/bin/rocketpool
```
in here the directory where the placed the rocketpool binary is not in codespace system's PATH. so we need to set up the PATH as following step:

1. Check the Location of Your ~/bin Directory: Verify that you created the ~/bin directory in your home directory. You can do this by running the following command:
  * 
    ```
    ls ~/bin

    # this should return "rocketpool", which is list the rocketpool binary.
    ```
 
 2. Check Your PATH: Make sure that ~/bin is included in your system's PATH. You can check your current PATH by running:
  * 
      ```
      echo $PATH
      ```
    If ~/bin is not included in the PATH, you'll need to add it. You can do this by editing your shell configuration file (e.g., ~/.bashrc, ~/.bash_profile, ~/.zshrc, etc.).

  3. In codespace, we using Bash, you can edit ~/.bashrc:
  * 
    ```
    nano ~/.bashrc
    ```
  4. Add the following line to the end of the file:
* 
  ```
  export PATH=~/bin:$PATH
  ```
5. Press Ctrl+O, Enter to save the file, and Ctrl+X, Enter to exit the editor.

6. Apply Changes to Your Current Session: To apply the changes immediately to your current session, you can either restart your terminal or run the following command:
* 
  ```
  source ~/.bashrc
  ```
  This will reload your shell configuration.

7. Test the rocketpool Command: After adding ~/bin to your PATH, you should be able to run the rocketpool command without any issues. Try running:
* 
  ```
  rocketpool --version
  ```
  You should now see the version information for Rocket Pool displayed.

  > rocketpool version 1.10.2



### Step 2. Installing the Smartnode Stack

Now that you have the CLI installed, you can deploy the Smartnode stack. This will prepare your system with Docker, docker-compose, and load the Smartnode files so they're ready to go. It won't actually run anything yet; that comes later.

To deploy the Smartnode stack, you will need to run the following command on your node machine (either by logging in locally, or connecting remotely such as through SSH):

```
rocketpool service install
```
This will grab the latest version of the Smartnode stack and set it up. You should see output like this (above some release notes for the latest version which will be printed at the end):

![rocketpool](./pic/rocketpool.png)

If there aren't any error messages, then the installation was successful. By default, it will be put into the ~/.rocketpool directory inside of your user account's home folder. After this, start a new terminal for the settings to take effect.

Once this is finished, the Smartnode stack will be ready to run.


### Step 3. Configuring Docker's Storage Location

1. By default, Docker will store all of its container data on your operating system's drive. In some cases, this is not what you want. 
    > If you are fine with this default behavior, skip down to the next section.
    To do this, create a new file called /etc/docker/daemon.json as the root user:
    ```
    sudo nano /etc/docker/daemon.json
    ```
    This will be empty at first, which is fine. Add this as the contents:
    ```
    {
        "data-root": "<your external mount point>/docker"
    }
    ```
    where <your external mount point> is the directory that your other drive is mounted to. For here we use ./data folder as the place we store the data.

    Press Ctrl+O, Enter to save the file, and Ctrl+X, Enter to exit the editor.


2. Next, make the folder:
      ```
      sudo mkdir -p ./data/docker
      ```

3. Now, restart the docker daemon so it picks up on the changes:
      ```
      sudo service docker restart
      ```





## 2. Configuring the Smartnode Stack













## 1. Install Lighthouse using Homebrew

```
brew install lighthouse
```

## 2. Run the Node 

### Step 1. Create a JWT secret file
A JWT secret file is used to secure the communication between the execution client and the consensus client. In this step, we will create a JWT secret file which will be used in later steps.

```
sudo mkdir -p /secrets
openssl rand -hex 32 | tr -d "\n" | sudo tee /secrets/jwt.hex
```


### Step 2: Set up an execution node
The Lighthouse beacon node must connect to an execution engine in order to validate the transactions present in blocks. The execution engine connection must be exclusive, i.e. you must have one execution node per beacon node. The reason for this is that the beacon node controls the execution node. In here we select Geth as out execution client. 

#### install the Geth node
```
brew tap ethereum/ethereum && brew install ethereum
```

then start Geth so that it can connect to a consensus client looks as follows:
```
geth \
--authrpc.addr localhost \
--authrpc.port 8551 \
--authrpc.vhosts localhost \
--authrpc.jwtsecret /tmp/jwtsecret
```

### Setp 3: Set up a beacon node using Lighthouse

```
lighthouse bn \
  --network goerli \
  --execution-endpoint http://localhost:8551 \
  --execution-jwt /secrets/jwt.hex \
  --checkpoint-sync-url https://mainnet.checkpoint.sigp.io \
  --http
```
> Note: If you download the binary file, you need to navigate to the directory of the binary file to run the above command.

Notable flags:

```
Notable flags:

--network flag, which selects a network:
    lighthouse (no flag): Mainnet.

    lighthouse --network mainnet: Mainnet.

    lighthouse --network goerli: Goerli (testnet).

    lighthouse --network sepolia: Sepolia (testnet).

    lighthouse --network chiado: Chiado (testnet).

    lighthouse --network gnosis: Gnosis chain.
```








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
