#!/bin/bash

dpkg --add-architecture armhf 
apt-get update

apt-get install -y zlib1g:armhf zlib1g-dev:armhf 

apt-get install -y libboost-date-time-dev:armhf \
   libboost-serialization-dev:armhf \
   libboost-iostreams-dev:armhf \
   libzmq5:armhf \
   libczmq-dev:armhf \
   libzmq3-dev:armhf \
   libzstd1:armhf \
   libzstd-dev:armhf

mkdir /opt/armhf /opt/noarch

# NOARCH

cd /opt/noarch
git clone https://github.com/zeromq/cppzmq.git
cd cppzmq
cp zmq.hpp /usr/include
cp zmq_addon.hpp /usr/include

# ARMHF

cd /opt/armhf
git clone https://github.com/ToolFramework/ToolFrameworkCore.git
git clone https://github.com/ToolDAQ/ToolDAQFramework.git
git clone https://github.com/ToolDAQ/libDAQInterface.git

cd /opt/armhf/ToolFrameworkCore
cp /opt/scripts/Makefile.static.tfc /opt/armhf/ToolFrameworkCore/Makefile.static
sed -i 's/g++/arm-linux-gnueabihf-g++/g' Makefile
make clean && make -j 
make -f Makefile.static
cp include/*.h /usr/include
cp lib/*.so /usr/lib/arm-linux-gnueabihf
cp lib/*.a /usr/lib/arm-linux-gnueabihf

cd /opt/armhf/ToolDAQFramework
cp /opt/scripts/Makefile.static.tdf /opt/armhf/ToolDAQFramework/Makefile.static
# 30.05.2026: change required for gcc 12
sed -i 's/500L/500LL/g' src/ServiceDiscovery/ServicesBackend.cpp
#
sed -i 's/g++/arm-linux-gnueabihf-g++/g' Makefile
sed -i '0,/^CXXFLAGS/{/^CXXFLAGS/{/-Wno-deprecated-declarations/! s/\([[:space:]]*#.*\)\?$/ -Wno-deprecated-declarations\1/}}' Makefile
make clean && make -j
make -f Makefile.static
cp include/*.h /usr/include
cp lib/*.so /usr/lib/arm-linux-gnueabihf
cp lib/*.a /usr/lib/arm-linux-gnueabihf

cd /opt/armhf/libDAQInterface
cp /opt/scripts/Makefile.static.ldi /opt/armhf/libDAQInterface/Makefile.static
mkdir Dependencies
ln -s /opt/armhf/ToolDAQFramework Dependencies/
ln -s /opt/armhf/ToolFrameworkCore Dependencies/
sed -i 's/g++/arm-linux-gnueabihf-g++/g' Makefile
sed -i '0,/^CXXFLAGS/{/^CXXFLAGS/{/-Wno-deprecated-declarations/! s/$/ -Wno-deprecated-declarations/}}' Makefile
make clean && make -j
make -f Makefile.static
cp include/*.h /usr/include
cp lib/*.so /usr/lib/arm-linux-gnueabihf
cp lib/*.a /usr/lib/arm-linux-gnueabihf
