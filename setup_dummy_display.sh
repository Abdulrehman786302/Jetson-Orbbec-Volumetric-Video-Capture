#!/bin/bash
set -e

# WARNING: Hardcoding passwords is insecure. Use only in trusted, local environments.
PASSWORD=""

# Function to run sudo commands with password
sudo_cmd() {
    echo "$PASSWORD" | sudo -S "$@"
}

# Confirm action
read -p "Enable dummy display (for headless mode)? [y/n]: " dummy
if [[ "$dummy" != "y" ]]; then
    echo "[*] Skipping dummy display setup."
    exit 0
fi

echo "[*] Installing dummy display driver if not present..."
if ! dpkg -l | grep -q xserver-xorg-video-dummy; then
    sudo_cmd apt update
    sudo_cmd apt install -y xserver-xorg-video-dummy
else
    echo "[*] Dummy driver already installed."
fi

echo "[*] Setting up dummy X11 config..."
# Clear and write config
echo "$PASSWORD" | sudo -S bash -c 'truncate -s 0 /etc/X11/xorg.conf'
echo "$PASSWORD" | sudo -S bash -c 'cat > /etc/X11/xorg.conf' <<EOF
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

echo "[✓] Dummy display configuration completed."
