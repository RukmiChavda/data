sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev \
	make m4 tcsh csh libx11-dev gperf  tcl8.6-dev tk8.6 tk8.6-dev \
	libxmp4 libxpm-dev  libxcb1 libcairo2  \
      libxrender-dev libx11-xcb-dev libxaw7-dev freeglut3-dev automake yosys
sudo apt-get update
sudo apt-get -y install libtool


#!/bin/bash
set -e

echo "Starting installation of open-source VLSI tools with Sky130 PDK..."
echo "Ensure you have sudo privileges and an internet connection."

# Install prerequisites
echo "Installing essential packages..."
sudo apt-get update
sudo apt-get install -y build-essential cmake git python3 python3-pip libx11-dev libxpm-dev libxaw7-dev \
    libreadline-dev gawk tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev \
    libncurses-dev bison flex libffi-dev libboost-all-dev libeigen3-dev klayout yosys

# 1. Xschem
echo "Installing Xschem..."
git clone https://github.com/StefanSchippers/xschem.git
cd xschem
./configure
make
sudo make install
cd ..

# 2. Ngspice
echo "Installing Ngspice..."
git clone https://git.code.sf.net/p/ngspice/ngspice ngspice_git
cd ngspice_git
mkdir release
sudo apt-get install -y adms
./autogen.sh --adms
cd release
../configure --with-x --enable-xspice --disable-debug --enable-cider --with-readline=yes --enable-openmp --enable-adms
make
sudo make install
cd ../..

# 3. Netgen
echo "Installing Netgen..."
git clone https://github.com/RTimothyEdwards/netgen.git
cd netgen
./configure
make
sudo make install
cd ..

# 4. Magic
echo "Installing Magic..."
git clone https://github.com/RTimothyEdwards/magic.git
cd magic
./configure
make
sudo make install
cd ..

# 5. KLayout (already installed above via apt)

# 6. OpenROAD
echo "Installing OpenROAD..."
git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD.git
cd OpenROAD
sudo ./etc/DependencyInstaller.sh
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..

# 7. OpenSTA
echo "Installing OpenSTA..."
git clone https://github.com/The-OpenROAD-Project/OpenSTA.git
cd OpenSTA
mkdir build
cd build
cmake ..
make
sudo make install
cd ../..

# 8. OpenRAM
echo "Installing OpenRAM..."
git clone https://github.com/VLSIDA/OpenRAM.git
cd OpenRAM
make sky130-pdk
./install_conda.sh
source miniconda/bin/activate
make sky130-install
cd ..

# 9. Sky130 PDK
echo "Installing Sky130 PDK..."
git clone git://opencircuitdesign.com/open_pdks
cd open_pdks
./configure --enable-sky130-pdk
sudo make
sudo make install
cd ..

echo "✅ All tools and PDK installed successfully!"
