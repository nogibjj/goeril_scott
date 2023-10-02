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

```
rocketpool service config
```
You can follow the setup step from [here](https://docs.rocketpool.net/guides/node/config/overview.html)

note, it's better to have the checkpoints setting in the Consensus Client (ETH2). You need to input the Checkpoint Sync URL, you can google it, or you can use mine as well, this setting will make the sync faster: 

```
https://goerli.beaconstate.info/  
```

## 3. Start the Rocket pool 
```
$ rocketpool service start

Your Smartnode is currently using the Prater Test Network.

Your eth2 client is on the correct network.

Your primary execution client is fully synced.
You do not have a fallback execution client enabled.
Your consensus client is still syncing (99.69%).
```


## 4. Create a new wallet 

```
rocketpool wallet init
```
You will first be prompted for a password to protect your wallet's private key. Next, you will be presented the unique 24-word mnemonic for your new wallet. This is the recovery phrase for your wallet.


## 5. Preparing your Node for Operation

Now you've successfully started the Smartnode services, created a wallet, and finished syncing both the Execution (ETH1) and Consensus (ETH2) chains on your respective clients. If so, then you are ready to register your node on the Rocket Pool network and create a minipool with an ETH2 validator

```
rocketpool node register
```
