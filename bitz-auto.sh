#!/bin/bash

set -e

# Paths
WALLET_PATH="$HOME/.config/solana/id.json"
BITZ_INSTALLED=$(command -v bitz || echo "no")
SOLANA_INSTALLED=$(command -v solana || echo "no")
SOLANA_PATH="$HOME/.local/share/solana/install/active_release/bin/solana"

function install_everything() {
  echo "=== 🛠 Updating system and installing dependencies ==="
  sudo apt update
  sudo apt install -y build-essential pkg-config libssl-dev clang jq curl

  echo "=== Installing Rust ==="
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env

  echo "=== Installing Solana CLI ==="
  sh -c "$(curl -sSfL https://release.solana.com/v1.18.2/install)"

  # Ensure Solana path is loaded
  export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
  echo 'export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc

  echo "=== Creating Solana wallet ==="
  solana-keygen new --no-passphrase --force

  echo "=== Setting Solana config for Eclipse ==="
  solana config set --url https://bitz-000.eclipserpc.xyz/

  echo "=== Installing BITZ CLI ==="
  cargo install bitz
}

function show_wallet_info() {
  ADDRESS=$($SOLANA_PATH address)
  PRIVATE_KEY=$(cat "$WALLET_PATH")
  echo ""
  echo "=== 🚀 Wallet Info ==="
  echo "Wallet Address: $ADDRESS"
  echo "Private Key: $PRIVATE_KEY"
  echo ""
}

function check_balance_and_mine() {
  ADDRESS=$($SOLANA_PATH address)
  BALANCE_SOL=$($SOLANA_PATH balance | awk '{print $1}')
  BALANCE_ETH=$(printf "%.6f" "$BALANCE_SOL")

  MIN_BALANCE=0.005

  echo "Checking wallet balance..."
  sleep 1
  echo "Balance: $BALANCE_ETH ETH"

  COMPARE=$(echo "$BALANCE_ETH >= $MIN_BALANCE" | bc -l)
  if [ "$COMPARE" -eq 1 ]; then
    echo "✅ Sufficient balance."
    echo "Starting mining..."
    bitz collect
  else
    echo "❌ Wallet doesn't have enough ETH on Eclipse (need at least 0.005)."
    echo "➡️  Fund your wallet and run this script again."
    echo "Wallet Address: $ADDRESS"
  fi
}

# === MAIN ===

echo "=== BITZ Mining Bootstrap ==="

# Check if Solana, BITZ, or wallet doesn't exist
if [[ "$BITZ_INSTALLED" == "no" || "$SOLANA_INSTALLED" == "no" || ! -f "$WALLET_PATH" ]]; then
  echo "⚙️  Required tools or wallet not found. Starting installation..."
  install_everything
  show_wallet_info
  echo "➡️  Please fund your wallet with at least 0.005 ETH on Eclipse and re-run the script."
else
  echo "✅ Environment looks good."
  check_balance_and_mine
fi

