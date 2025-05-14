# Jetson-Orbbec/Kinect Volumetric Video Capture for Ithaca Project

This project demonstrates how to integrate the **NVIDIA Jetson Nano** with **Orbbec Femto Mega/Bolt** and **Microsoft Kinects** cameras for synchronized, efficient volumetric video capture. Designed for scalable systems such as the *Ithaca* 9-camera setup, this solution minimizes frame drops, reduces bandwidth strain, and simplifies wiring using edge processing.

---

## 📌 Motivation

Traditional multi-camera, multi-PC systems struggle with:
- 🚫 **Frame drops due to USB or network congestion**
- 🔌 **Tangled wiring and difficult synchronization**
- 🖥️ **Expensive and power-hungry host PCs**

### ✅ Benefits of Jetson Nano + Orbbec/Kinect

- **Edge computing**: Record directly on Jetson Nano to avoid network delays.
- **Simplified wiring**: USB 3.0 from camera to Nano; no need for long Ethernet or sync chains.
- **Affordable scaling**: Each Nano is low-cost and energy-efficient.
- **Portable and compact**: Fits in tight studio setups.

---

## 🧠 Hardware Overview

### NVIDIA Jetson Nano

- Quad-core ARM Cortex-A57 CPU
- 128-core Maxwell GPU
- 4 GB RAM
- USB 3.0, HDMI, Gigabit Ethernet
- **JetPack SDK 4.6.3** (Ubuntu 18.04 / L4T 32.7.1)

> ⚠️ Note: Performance is limited compared to Jetson Xavier or Orin. Avoid heavy concurrent processes.

### Orbbec/Kinect

- RGB + Depth camera with high resolution
- Supports MKV and BAG formats
- Depth sensing up to 10 meters
- Supports multi-device hardware sync
- USB 3.0 data transfer

---

## 🔧 Setup Guide

### 1. Hardware Connection

- Connect the Orbbec to Jetson Nano via **USB 3.0**.
- Connect the Jetson with Essentials(Keyboard+Mouse+HDMI connection+DC power)
    - check here [Jetson Connections](https://developer.nvidia.com/embedded/learn/get-started-jetson-nano-devkit#setup)

## Jetson Nano Setup with Rufus + JetPack

This guide outlines the steps to set up a **Jetson Nano** (4GB/2GB) using **Rufus** to flash the SD card with a pre-built **JetPack** image. It includes instructions for both the **microSD** and **eMMC** versions of the Jetson Nano.

## ✅ What You Need

- **Jetson Nano Developer Kit** (4GB or 2GB version)
- **microSD card** (minimum 32GB, UHS-1 recommended)
- **microSD card reader** for your Windows PC
- **Rufus tool**: [Download here](https://rufus.ie/)
- **JetPack SD card image** for Jetson Nano:  
   - [JetPack SDK Downloads](https://developer.nvidia.com/jetson-nano-sd-card-image) 

## 🛠️ Step-by-Step Instructions

### Step 1: Download JetPack Image

1. Go to [JetPack SDK Downloads](https://developer.nvidia.com/jetson-nano-sd-card-image) 
2. Extract the `.img` file using the built-in unzip feature or a tool like 7-Zip.

### Step 2: Flash SD Card with Rufus

1. Insert the microSD card into your card reader.
2. Open **Rufus**.
3. In Rufus:
   - **Device**: Select your microSD card.
   - **Boot selection**: Click *SELECT* and choose the `.img` file you extracted.
   - **Partition scheme**: Set to `MBR`.
   - **File system**: Leave it as the default.
4. Click **START** to begin flashing. Confirm any prompts.

⚠️ **Warning**: This process will erase all data on the microSD card.

### Step 3: Boot the Jetson Nano

1. Insert the flashed microSD card into the Jetson Nano.
2. Connect your display (HDMI/DisplayPort), USB keyboard & mouse, and power supply.
3. Power on the Jetson Nano.
4. The first boot may take several minutes. You'll be prompted to complete the Ubuntu setup process (select language, timezone, username, etc.).

## ⚡ Optional: First Boot Tweaks

- **Network**: Connect to Wi-Fi or Ethernet.
- **Update system**: Run the following commands to ensure everything is up-to-date:
  ```bash
  sudo apt update && sudo apt upgrade
'''