#!/bin/bash
set -e

# WARNING: Hardcoding passwords is insecure. Use only in trusted, local environments.
PASSWORD=""

# Function to run sudo commands with password
sudo_cmd() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Update and install dependencies
echo "[*] Installing system dependencies..."
sudo_cmd apt update
sudo_cmd apt-get install -y nano
sudo_cmd apt install -y git build-essential cmake pkg-config libopencv-dev \
    libssl-dev libxinerama-dev libvulkan-dev libxcursor-dev libjpeg-dev \
    doxygen clang-format graphviz libudev-dev libsoundio-dev

# STEP 1: Build Orbbec K4A Wrapper
echo "[*] Cloning and building Orbbec K4A Wrapper..."
git clone https://github.com/orbbec/OrbbecSDK-K4A-Wrapper.git
cd OrbbecSDK-K4A-Wrapper
sed -i 's|add_subdirectory(streaming_samples)||g' examples/CMakeLists.txt || true
mkdir -p build && cd build
cmake ..
make -j$(nproc)
cd ../..

# STEP 2: Install udev rules
echo "[*] Installing Orbbec udev rules..."
git clone https://github.com/orbbec/OrbbecSDK_v2.git
cd OrbbecSDK_v2/scripts/env_setup
chmod +x ./install_udev_rules.sh
echo "$PASSWORD" | sudo -S ./install_udev_rules.sh
sudo_cmd udevadm control --reload-rules
sudo_cmd udevadm trigger
cd ../../..

