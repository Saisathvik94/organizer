#!/bin/bash
# ============================================================================== 
# Installer for Organizer CLI (Linux/macOS) 
# ==============================================================================

set -euo pipefail

REPO="Saisathvik94/organizer"
BINARY="organizer"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="$(mktemp -d -t organizer-install-XXXXXXXX)"

GREEN="\033[0;32m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

show_ascii() {
cat << "EOF"
 ██████  ██████   ██████   █████  ███    ██ ██ ███████ ███████ ██████  
██    ██ ██   ██ ██       ██   ██ ████   ██ ██    ███  ██      ██   ██ 
██    ██ ██████  ██   ███ ███████ ██ ██  ██ ██   ███   █████   ██████  
██    ██ ██   ██ ██    ██ ██   ██ ██  ██ ██ ██  ███    ██      ██   ██ 
 ██████  ██   ██  ██████  ██   ██ ██   ████ ██ ███████ ███████ ██   ██
EOF
}

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}❌ Please run as root (sudo)${RESET}"
  exit 1
fi

show_ascii
echo -e "${CYAN}🚀 Installing Organizer CLI...${RESET}"

echo -e "${YELLOW}🔍 Fetching latest release...${RESET}"
LATEST_JSON=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$LATEST_JSON" | sed -n 's/.*"tag_name": "\(.*\)".*/\1/p')

if [[ "$(uname)" == "Darwin" ]]; then
  ZIP_NAME="organizer_${VERSION}_darwin_amd64.zip"
else
  ZIP_NAME="organizer_${VERSION}_linux_amd64.zip"
fi

URL="https://github.com/$REPO/releases/download/$VERSION/$ZIP_NAME"
ZIP_PATH="$TMP_DIR/$ZIP_NAME"

echo -e "${GREEN}📦 Downloading $ZIP_NAME...${RESET}"
curl -fL -o "$ZIP_PATH" "$URL" || {
  echo -e "${RED}❌ Download failed${RESET}"
  exit 1
}

echo -e "${CYAN}📂 Extracting files...${RESET}"
unzip -o "$ZIP_PATH" -d "$TMP_DIR"

if [[ ! -f "$TMP_DIR/$BINARY" ]]; then
  echo -e "${RED}❌ Organizer binary not found${RESET}"
  exit 1
fi

rm -f "$INSTALL_DIR/$BINARY"
mv "$TMP_DIR/$BINARY" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/$BINARY"

rm -rf "$TMP_DIR"

echo -e "${GREEN}✅ Organizer installed successfully!${RESET}"
echo -e "${CYAN}📌 Version: $VERSION${RESET}"
echo -e "${CYAN}📂 Location: $INSTALL_DIR/$BINARY${RESET}"
echo -e "${YELLOW}🔁 Run:${RESET} organizer --help"