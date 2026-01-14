#!/bin/bash
# ============================================================================== 
# Installer for Organizer CLI (Linux/macOS)
# ============================================================================== 

set -euo pipefail

# CONFIG
REPO="Saisathvik94/organizer"
BINARY="organizer"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d -t organizer-install-XXXXXXXX)"

# COLORS
GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

# ASCII Banner
show_ascii() {
cat << "EOF"
 ██████  ██████   ██████   █████  ███    ██ ██ ███████ ███████ ██████  
██    ██ ██   ██ ██       ██   ██ ████   ██ ██    ███  ██      ██   ██ 
██    ██ ██████  ██   ███ ███████ ██ ██  ██ ██   ███   █████   ██████  
██    ██ ██   ██ ██    ██ ██   ██ ██  ██ ██ ██  ███    ██      ██   ██ 
 ██████  ██   ██  ██████  ██   ██ ██   ████ ██ ███████ ███████ ██   ██                                                                        
EOF
}

# CHECK SUDO
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}❌ Please run as root (sudo)${RESET}"
   exit 1
fi

show_ascii
echo -e "${CYAN}🚀 Installing Organizer CLI...${RESET}"

# GET LATEST RELEASE
echo -e "${YELLOW}🔍 Fetching latest release...${RESET}"
LATEST_JSON=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$LATEST_JSON" | grep -Po '"tag_name": "\K.*?(?=")')

# Determine ZIP name
if [[ "$VERSION" == "snapshot" ]]; then
    OS_NAME=$(uname | tr '[:upper:]' '[:lower:]')
    ZIP_NAME="organizer_snapshot_${OS_NAME}_amd64.zip"
else
    if [[ "$(uname)" == "Darwin" ]]; then
        ZIP_NAME="organizer_${VERSION}_darwin_amd64.zip"
    else
        ZIP_NAME="organizer_${VERSION}_linux_amd64.zip"
    fi
fi

URL="https://github.com/$REPO/releases/download/$VERSION/$ZIP_NAME"
ZIP_PATH="$TMP_DIR/$ZIP_NAME"

# DOWNLOAD
echo -e "${GREEN}📦 Downloading $ZIP_NAME...${RESET}"
curl -L -o "$ZIP_PATH" "$URL"

# EXTRACT
echo -e "${CYAN}📂 Extracting files...${RESET}"
unzip -o "$ZIP_PATH" -d "$TMP_DIR"

# REMOVE OLD INSTALL
if [[ -f "$INSTALL_DIR/$BINARY" ]]; then
    echo -e "${YELLOW}🧹 Removing existing Organizer...${RESET}"
    rm -f "$INSTALL_DIR/$BINARY"
fi

# MOVE BINARY
echo -e "${GREEN}📌 Installing Organizer to $INSTALL_DIR...${RESET}"
mv "$TMP_DIR/$BINARY" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$BINARY"

# CLEANUP
rm -rf "$TMP_DIR"

# DONE
echo -e "${GREEN}✅ Organizer installed successfully!${RESET}"
echo -e "${CYAN}📌 Version: $VERSION${RESET}"
echo -e "${CYAN}📂 Location: $INSTALL_DIR/$BINARY${RESET}"
echo -e "${YELLOW}🔁 Restart your terminal and run:${RESET}"
echo -e "   organizer --help"
