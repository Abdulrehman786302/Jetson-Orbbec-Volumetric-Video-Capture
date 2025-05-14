#!/bin/bash
set -e

# Ask user for Jetson username
read -p "Enter your Jetson device username (e.g., ftf-5): " USER_NAME
DOWNLOAD_DIR="/home/$USER_NAME/Downloads"

# Clone the Azure Kinect SDK
echo "[*] Cloning Azure Kinect Sensor SDK..."
git clone https://github.com/microsoft/Azure-Kinect-Sensor-SDK.git
cd Azure-Kinect-Sensor-SDK

# Create build directory and required subdirectories (workaround for cmake errors)
echo "[*] Creating manual build subfolders..."
mkdir -p build && cd build

mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/src/csharp/Tests/StubGenerator/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/include/k4a/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/include/k4ainternal/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/include/k4arecord/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/tests/Utilities/ConnEx/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/tests/UnitTests/utcommon/inc/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/tools/k4aviewer/platform/linux/
mkdir -p $DOWNLOAD_DIR/Azure-Kinect-Sensor-SDK/build/tools/k4aviewer/platform/windows/

# Run CMake and build the SDK
echo "[*] Running cmake and building the SDK..."
cmake ../
cmake --build .

# Install udev rules
echo "[*] Installing udev rules..."
sudo cp ../scripts/99-k4a.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger

echo "[✓] Azure Kinect SDK setup complete."
