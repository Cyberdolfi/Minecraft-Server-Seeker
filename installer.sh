#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
clear
echo -e "\e[1;36m"
echo "=============================================="
echo "           MINECRAFT SERVER SEEKER"
echo "=============================================="
echo -e "\e[0m"
INSTALL_DIR="/opt/minecraft-server-seeker"
REPO_URL="https://github.com/Cyberdolfi/Minecraft-Server-Seeker.git"
REPO_NAME="minecraft-server-seeker"
LOGS_FILE="logs.txt"
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

read -e -p "Enter installation path (default: /opt/minecraft-server-seeker): " USER_PATH
INSTALL_DIR="${USER_PATH:-/opt/minecraft-server-seeker}"

if [[ "$MAIN_CHOICE" == "1" ]]; then
  echo "[Install] 🚀 Starting installation..."
  echo "[Install] Updaten all your packages..."
  sudo apt update > $LOGS_FILE
  sudo apt full-upgrade -y > $LOGS_FILE

  if ! command -v git &> $LOGS_FILE; then
    echo "[Install] 🔧 Installing Git..."
    sudo apt -y install git > $LOGS_FILE
  fi

  if ! command -v python3 &> $LOGS_FILE; then
    echo "[Install] 🐍 Installing Python 3..."
    sudo apt install -y python3 python3-pip
  fi

  if ! command -v pip3 &> $LOGS_FILE; then
    echo "📦 Installing pip3..."
    sudo apt install -y python3-pip > $LOGS_FILE
  fi

  echo "📥 Cloning repository..."
  sudo git clone "$REPO_URL" "$INSTALL_DIR" > $LOGS_FILE
  sudo chown -R $USER:$USER "$INSTALL_DIR"

  echo "📦 Installing Python requirements..."
  python3.13 -m pip install --upgrade pip > $LOGS_FILE
  python3.13 -m pip install -r "$INSTALL_DIR/requirements.txt" > $LOGS_FILE

  echo "✅ Installation complete!"
  echo "To run the tool:"
  echo "cd $INSTALL_DIR"
  echo "python3 main.py --help"
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
  python3.13 -m pip install -r requirements.txt > $LOGS_FILE
  echo "✅ Updated!"
  exit 0

elif [[ "$MAIN_CHOICE" == "4" ]]; then
  echo "🍚 Installing MySQL..."
  sudo apt update -qq > $LOGS_FILE
  sudo apt install -y mysql-server > $LOGS_FILE
  echo "✅ MySQL installed."
  exit 0

else
  echo "❌ Invalid option"
  exit 1
fi
