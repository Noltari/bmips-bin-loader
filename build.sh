#!/bin/bash

# Binary loader for BMIPS CFE based boards
# Copyright (C) 2017 Álvaro Fernández Rojas <noltari@gmail.com>

# If you want to use LEDE toolchain uncomment the following two lines:
#export STAGING_DIR="/home/noltari/lede/lede-staging/staging_dir/"
#export PATH="$PATH:/home/noltari/lede/lede-staging/staging_dir/toolchain-mips_mips32_gcc-5.4.0_musl/bin"

make clean
cp ../u-boot/u-boot.bin ./
make LOADADDR=0x80010000 BIN_TEXT_START=0x80a00000 CACHELINE_SIZE=16 LOADER_DATA=u-boot.bin CROSS_COMPILE=mips-openwrt-linux- all
