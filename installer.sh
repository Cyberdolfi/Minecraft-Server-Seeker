#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# 🧹 Clear terminal
clear

# 🎨 ASCII Logo
echo -e "\e[1;36m"
echo "=============================================="
echo "           MINECRAFT SERVER SEEKER"
echo "=============================================="
echo -e "\e[0m"

# 📍 Check if installed
INSTALL_DIR="/opt/minecraft-server-seeker"
REPO_URL="https://github.com/<user>/<repo>.git"
REPO_NAME="minecraft-server-seeker"

if [ -d "$INSTALL_DIR" ]; then
  echo -e "\e[33mServer Seeker already seems to be installed at: $INSTALL_DIR\e[0m"
  echo "Choose an option:"
  echo "  1) Cancel"
  echo "  2) Continue anyway"
  echo "  3) Reinstall"

  read -p "Your choice [1-3]: " EXISTING_CHOICE
  case $EXISTING_CHOICE in
    1) echo "Cancelled."; exit 0 ;;
    2) echo "Continuing..." ;;
    3) echo "Reinstalling..."
       sudo rm -rf "$INSTALL_DIR"
       ;;
    *) echo "Invalid choice"; exit 1 ;;
  esac
fi

# 📦 Menu
echo ""
echo "Choose an action:"
echo "  1) Install"
echo "  2) Uninstall"
echo "  3) Update"
echo "  4) Install MySQL"
echo "  5) Exit"

read -p "Your choice [1-5]: " MAIN_CHOICE

if [[ "$MAIN_CHOICE" == "5" ]]; then
  echo "Bye 👋"
  exit 0
fi

# 🧠 Check OS
OS_ID=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VER=$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')

if [[ "$OS_ID" == "ubuntu" && "${OS_VER%%.*}" -lt 21 ]]; then
  echo "⚠️ Ubuntu version too old. Ubuntu 21+ required."
  exit 1
elif [[ "$OS_ID" == "debian" && "${OS_VER%%.*}" -lt 12 ]]; then
  echo "⚠️ Debian version too old. Debian 12+ required."
  exit 1
elif [[ "$OS_ID" != "ubuntu" && "$OS_ID" != "debian" ]]; then
  echo "❌ Unsupported OS: $OS_ID"
  echo "This installer only supports Ubuntu 21+ or Debian 12+"
  exit 1
fi

# 📂 Ask install path
read -e -p "Enter installation path (default: /opt/minecraft-server-seeker): " USER_PATH
INSTALL_DIR="${USER_PATH:-/opt/minecraft-server-seeker}"

# ✅ Begin install
if [[ "$MAIN_CHOICE" == "1" ]]; then
  echo "🚀 Starting installation..."

  # Update system
  sudo apt update -qq > /dev/null
  sudo apt full-upgrade -y -qq > /dev/null

  # Install git
  if ! command -v git &> /dev/null; then
    echo "🔧 Installing Git..."
    sudo apt -y install git > /dev/null
  fi

  # Install Python 3.13
  if ! command -v python3.13 &> /dev/null; then
    echo "🐍 Installing Python 3.13..."
    sudo add-apt-repository ppa:deadsnakes/ppa -y > /dev/null 2>&1 || true
    sudo apt update -qq > /dev/null
    sudo apt install -y python3.13 python3.13-venv python3-pip > /dev/null
  fi

  # Check pip3
  if ! command -v pip3 &> /dev/null; then
    echo "📦 Installing pip3..."
    sudo apt install -y python3-pip > /dev/null
  fi

  # Clone repo
  echo "📥 Cloning repository..."
  sudo git clone "$REPO_URL" "$INSTALL_DIR" > /dev/null
  sudo chown -R $USER:$USER "$INSTALL_DIR"

  # Install Python dependencies
  echo "📦 Installing Python requirements..."
  python3.13 -m pip install --upgrade pip > /dev/null
  python3.13 -m pip install -r "$INSTALL_DIR/requirements.txt" > /dev/null

  echo "✅ Installation complete!"
  echo "To run the tool:"
  echo "cd $INSTALL_DIR"
  echo "python3.13 main.py --help"
  exit 0

elif [[ "$MAIN_CHOICE" == "2" ]]; then
  echo "🗑️ Uninstalling..."
  sudo rm -rf "$INSTALL_DIR"
  echo "✅ Uninstalled."
  exit 0

elif [[ "$MAIN_CHOICE" == "3" ]]; then
  echo "🔄 Updating..."
  cd "$INSTALL_DIR"
  git pull origin main
  python3.13 -m pip install -r requirements.txt > /dev/null
  echo "✅ Updated!"
  exit 0

elif [[ "$MAIN_CHOICE" == "4" ]]; then
  echo "🍚 Installing MySQL..."
  sudo apt update -qq > /dev/null
  sudo apt install -y mysql-server > /dev/null
  echo "✅ MySQL installed."
  exit 0

else
  echo "❌ Invalid option"
  exit 1
fi
