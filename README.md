#!/bin/bash
set -e

echo "=== STEP 0: Ensure sources.list is set up for Jetson ==="
sudo tee /etc/apt/sources.list <<EOF
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy-updates main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy-security main restricted universe multiverse
deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports/ jammy-backports main restricted universe multiverse
EOF

sudo apt update
sudo apt install -y git build-essential cmake pkg-config libopencv-dev libssl-dev libxinerama-dev libvulkan-dev libxcursor-dev libjpeg-dev doxygen clang-format graphviz libudev-dev libsoundio-dev

echo "=== STEP 1: Clone and build Orbbec SDK ==="
git clone https://github.com/orbbec/OrbbecSDK.git
cd OrbbecSDK
mkdir -p build && cd build
cmake .. && make -j$(nproc)
cd ../..

echo "=== STEP 2: Clone and build Orbbec SDK K4A Wrapper ==="
git clone https://github.com/orbbec/OrbbecSDK-K4A-Wrapper.git
cd OrbbecSDK-K4A-Wrapper
sed -i 's|add_subdirectory(streaming_samples)||g' examples/CMakeLists.txt || true
mkdir -p build && cd build
cmake .. && make -j$(nproc)
cd ../..

echo "=== STEP 3: Install UDEV rules for Orbbec Femato ==="
git clone https://github.com/orbbec/OrbbecSDK_v2.git
cd OrbbecSDK_v2/scripts/env_setup
chmod +x ./install_udev_rules.sh
sudo ./install_udev_rules.sh
sudo udevadm control --reload-rules && sudo udevadm trigger
cd ../../..

echo "=== STEP 4: Build MKV Recorder using K4A Wrapper ==="
cd OrbbecSDK-K4A-Wrapper
g++ tools/k4arecorder/main.cpp -Iinclude -Itools/k4arecorder -Llib -lk4arecorder -lk4a -o recorder
cd ..

echo "=== STEP 5: Export library path for runtime ==="
echo "export LD_LIBRARY_PATH=$(pwd)/OrbbecSDK-K4A-Wrapper/lib:\$LD_LIBRARY_PATH" >> ~/.bashrc
export LD_LIBRARY_PATH=$(pwd)/OrbbecSDK-K4A-Wrapper/lib:$LD_LIBRARY_PATH

echo "=== STEP 6: Jetson Display (Optional) ==="
read -p "Do you want to enable dummy display for headless mode? (y/n): " headless
if [[ $headless == "y" ]]; then
    sudo tee /etc/X11/xorg.conf <<EOF
Section "Device"
    Identifier  "DummyDevice"
    Driver      "dummy"
    Option      "AllowEmptyInitialConfiguration" "true"
EndSection
Section "Monitor"
    Identifier "DummyMonitor"
    HorizSync   28.0-80.0
    VertRefresh 48.0-75.0
    Modeline "1920x1080" 148.5 1920 2008 2052 2200 1080 1084 1089 1125 +hsync +vsync
EndSection
Section "Screen"
    Identifier "DummyScreen"
    Monitor    "DummyMonitor"
    Device     "DummyDevice"
    DefaultDepth 24
    SubSection "Display"
        Depth 24
        Modes "1920x1080"
    EndSubSection
EndSection
EOF
    echo "Dummy display configured. Reboot to activate."
fi

echo "=== STEP 7: (Optional) Time Sync with Windows Host ==="
read -p "Do you want to enable Jetson NTP service for clock sync? (y/n): " ntp
if [[ $ntp == "y" ]]; then
    sudo apt install -y ntp
    sudo systemctl enable ntp
    sudo systemctl start ntp
    ntpq -p
    sudo systemctl status ntp
    echo "Jetson time sync service enabled. Configure Windows to sync with Jetson IP manually."
fi

echo ""
echo "🎉 Setup complete! To record MKV files using the Orbbec Femato Mega, run:"
echo ""
echo "cd OrbbecSDK-K4A-Wrapper"
echo "./recorder -c 2160p -r 5 -l 1 color.mkv"
echo "./recorder -d NFOV_UNBINNED -c OFF -r 5 -l 1 depth.mkv"
