#!/bin/bash
set -e

# WARNING: Hardcoding passwords is insecure. Use only in trusted, local environments.
PASSWORD="962931"

# Function to run sudo commands with password
sudo_cmd() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Get absolute path to script directory before doing any cd
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURRENT_USER=$(whoami)

# STEP 0: Install dependencies
echo "[*] Installing system dependencies..."
sudo_cmd apt-get install -y nano
sudo_cmd apt-get install -y libssl-dev libxinerama-dev libvulkan-dev libxcursor-dev \
    libjpeg-dev doxygen clang-format graphviz libudev-dev libsoundio-dev

# STEP 1: Clone and build Orbbec K4A Wrapper
echo "[*] Cloning and building Orbbec K4A Wrapper..."
cd "$SCRIPT_DIR"
git clone https://github.com/orbbec/OrbbecSDK-K4A-Wrapper.git
cd OrbbecSDK-K4A-Wrapper

# Comment out the full install() block in examples/CMakeLists.txt
echo "[*] Commenting out install(TARGETS ...) block"
sed -i '/install(TARGETS streaming_samples/,/)/ s/^/#/' examples/CMakeLists.txt

mkdir -p build && cd build
cmake ..
make -j$(nproc)
cd "$SCRIPT_DIR"

# STEP 2: Install Orbbec udev rules
echo "[*] Installing Orbbec udev rules..."
git clone https://github.com/orbbec/OrbbecSDK_v2.git
cd OrbbecSDK_v2/scripts/env_setup
chmod +x ./install_udev_rules.sh
echo "$PASSWORD" | sudo -S ./install_udev_rules.sh
sudo_cmd udevadm control --reload-rules
sudo_cmd udevadm trigger
cd "$SCRIPT_DIR"


echo "[✓] Setup completed successfully."
