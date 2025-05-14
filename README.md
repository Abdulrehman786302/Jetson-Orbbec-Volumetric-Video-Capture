# Jetson-Orbbec Volumetric Video Capture for Ithaca Project

This project demonstrates how to integrate the **NVIDIA Jetson Nano** with **Orbbec Femto Mega** cameras for synchronized, efficient volumetric video capture. Designed for scalable systems such as the *Ithaca* 9-camera setup, this solution minimizes frame drops, reduces bandwidth strain, and simplifies wiring using edge processing.

---

## 📌 Motivation

Traditional multi-camera, multi-PC systems struggle with:
- 🚫 **Frame drops due to USB or network congestion**
- 🔌 **Tangled wiring and difficult synchronization**
- 🖥️ **Expensive and power-hungry host PCs**

### ✅ Benefits of Jetson Nano + Orbbec

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

### Orbbec Femto Mega

- RGB + Depth camera with high resolution
- Supports MKV and BAG formats
- Depth sensing up to 10 meters
- Supports multi-device hardware sync
- USB 3.0 data transfer

---

## 🔧 Setup Guide

### 1. Hardware Connection

- Connect the Orbbec Femto Mega to Jetson Nano via **USB 3.0**.
- Confirm the connection:
  

