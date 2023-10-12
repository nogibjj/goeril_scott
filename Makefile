# Variables
CLI_DIR=~/bin
ROCKETPOOL_CLI_URL=https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-amd64
DOCKER_CONFIG_PATH=/etc/docker/daemon.json
DATA_DIR=./data/docker
CHECKPOINT_SYNC_URL=https://goerli.beaconstate.info/

# Targets
.PHONY: all_x64 all_arm64 check_bin check_path update_bashrc source_bashrc check_version configure-docker configure-node start-node init-wallet register-node

# Combined targets for each architecture
all_x64: install_x64 check_bin check_path update_bashrc source_bashrc check_version configure-docker configure-node start-node init-wallet register-node
all_arm64: install_arm64 check_bin check_path update_bashrc source_bashrc check_version configure-docker configure-node start-node init-wallet register-node

# Download and install Rocket Pool CLI for x64 systems
install_x64:
	@echo "Installing Rocket Pool for x64..."
	mkdir -p $(CLI_DIR)
	wget $(ROCKETPOOL_CLI_URL) -O $(CLI_DIR)/rocketpool
	chmod +x $(CLI_DIR)/rocketpool

# Download and install Rocket Pool CLI for arm64 systems
install_arm64:
	@echo "Installing Rocket Pool for arm64..."
	mkdir -p $(CLI_DIR)
	wget https://github.com/rocket-pool/smartnode-install/releases/latest/download/rocketpool-cli-linux-arm64 -O $(CLI_DIR)/rocketpool
	chmod +x $(CLI_DIR)/rocketpool

# Check if the ~/bin directory contains rocketpool binary
check_bin:
	@echo "Checking $(CLI_DIR) for rocketpool..."
	ls $(CLI_DIR) | grep rocketpool

# Check the PATH variable
check_path:
	@echo "Checking PATH..."
	echo $$PATH | grep -o $(CLI_DIR)

# Add '~/bin' to the PATH in ~/.bashrc if not already present
update_bashrc:
	@echo "Updating ~/.bashrc..."
	if ! grep -q 'export PATH=$(CLI_DIR):'~/.bashrc; then echo 'export PATH=$(CLI_DIR):$$PATH' >> ~/.bashrc; fi

# Source the bashrc to update PATH for the current session
source_bashrc:
	@echo "Sourcing ~/.bashrc..."
	source ~/.bashrc

# Check Rocket Pool version
check_version:
	@echo "Checking Rocket Pool version..."
	rocketpool --version

# Existing targets below

configure-docker:
	echo '{"data-root": "$(DATA_DIR)"}' | sudo tee $(DOCKER_CONFIG_PATH)
	sudo mkdir -p $(DATA_DIR)
	sudo service docker restart

configure-node:
	rocketpool service install
	rocketpool service config
	# You can input the CHECKPOINT_SYNC_URL manually or automate it here

start-node:
	rocketpool service start

init-wallet:
	rocketpool wallet init
	# This will prompt for a password and show a mnemonic. You need to handle this manually

register-node:
	rocketpool node register
	# This might require additional manual steps
