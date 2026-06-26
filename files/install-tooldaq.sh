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
git clone https://github.com/gtortone/ToolDAQFramework.git

cd /opt/armhf/ToolDAQFramework
cmake -B build-arm -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-arm-linux-gnueabihf.cmake
make -j -C build-arm
cp build-arm/include/*.h /usr/include
cp build-arm/lib/*.so /usr/lib/arm-linux-gnueabihf
cp build-arm/lib/*.a /usr/lib/arm-linux-gnueabihf

