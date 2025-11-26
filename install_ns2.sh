#!/bin/bash

# ------------------------------------------
# Install NS2 (ns-allinone-2.35) on Ubuntu 24.04
# ------------------------------------------

echo "[1/7] Updating system..."
sudo apt update

echo "[2/7] Installing dependencies..."
sudo apt install -y build-essential autoconf automake libxmu-dev gcc g++ perl \
    libtool libxt-dev libx11-dev libxaw7-dev libxmu-headers libssl-dev \
    make git xorg-dev wget

echo "[3/7] Downloading ns-allinone-2.35..."
wget https://sourceforge.net/projects/nsnam/files/ns-2/2.35/ns-allinone-2.35.tar.gz

echo "[4/7] Extracting package..."
tar -xvzf ns-allinone-2.35.tar.gz
cd ns-allinone-2.35

echo "[5/7] Applying patches for Ubuntu 20+/24+ compatibility..."
# Fix for ls.cc warning error
sed -i 's/DSDV_AODV/DSDV\/AODV/g' ns-2.35/linkstate/ls.cc

# Remove -Werror flag to avoid GCC strict errors
sed -i 's/-Werror//' ns-2.35/Makefile

echo "[6/7] Compiling NS2... this may take several minutes"
./install

echo "[7/7] Adding NS2 environment variables..."
echo "export PATH=\$PATH:$HOME/ns-allinone-2.35/bin:$HOME/ns-allinone-2.35/tcl8.5.10/unix:$HOME/ns-allinone-2.35/tk8.5.10/unix" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:$HOME/ns-allinone-2.35/otcl-1.14:$HOME/ns-allinone-2.35/lib" >> ~/.bashrc

source ~/.bashrc

echo "------------------------------------------"
echo " NS2 Installation Completed Successfully!"
echo " Run 'ns' to test the simulator."
echo " Run 'nam' to test the Network Animator."
echo "------------------------------------------"
