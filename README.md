# BITZ Auto Installer

Copy and paste the below command (Must be a Linux user and not logged in as root):

```bash
wget -O ~/bitz-auto.sh https://raw.githubusercontent.com/on-blockchain/bitz/main/bitz-auto.sh && bash ~/bitz-auto.sh && source ~/.bashrc
```

Re-run again after you fund your wallet. It will automatically detect your ETH balance and whether Solana and Bitz are installed.


If you want to install it manually, follow the below commands:

# BITZ Manual Installation Guide

This guide provides manual steps to install the necessary dependencies, Solana wallet, and BITZ CLI. Follow the steps below for a manual setup. (Must be a Linux user and not logged in as root)

```bash
# === Step 1: Update System and Install Dependencies ===
# Update your system and install required dependencies
sudo apt update
sudo apt install -y build-essential pkg-config libssl-dev clang jq curl

# === Step 2: Install Rust ===
# Install Rust programming language
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Source the Rust environment variables
source $HOME/.cargo/env

# === Step 3: Install Solana CLI ===
# Install Solana CLI
sh -c "$(curl -sSfL https://release.solana.com/v1.18.2/install)"

# Ensure Solana path is loaded
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
# Add Solana path to bashrc to persist across sessions
echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
# Source bashrc to apply the changes
source ~/.bashrc

# === Step 4: Create Solana Wallet ===
# Create a new Solana wallet (without a passphrase)
solana-keygen new --no-passphrase --force

# === Step 5: Set Solana Config for Eclipse ===
# Set Solana config to connect to the Eclipse RPC
solana config set --url https://bitz-000.eclipserpc.xyz/

# === Step 6: Install BITZ CLI ===
# Install BITZ CLI using Cargo (Rust package manager)
cargo install bitz

# === Step 7: Verify the Installation ===
# Check if Solana is installed
solana --version
# Check if BITZ is installed
bitz --version

# === Step 8: Fund Your Wallet ===
# To fund your wallet, first get your Solana wallet address by running:
solana address
# The output will be your wallet address. Send at least 0.005 ETH to this address using an Ethereum wallet or exchange.

# === Step 9: Run the Mining Script ===
# To start mining, run the following command:
bitz collect
