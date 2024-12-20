#!/bin/bash
#
# Compile script for NoVA Kernel.
# Copyright (C)2022 Ardany Jolón
# Credits to @ItsHaniBee


# toolchains
# Linux version 4.14.186-g7c18952d3c68 (builder@m1-xm-ota-bd086.bj.idc.xiaomi.com) (Android (6443078 based on r383902) clang version 11.0.1 (https://android.googlesource.com/toolchain/llvm-project b397f81060ce6d701042b782172ed13bee898b79), LLD 11.0.1 (/buildbot/tmp/tmp6_m7QH b397f81060ce6d701042b782172ed13bee898b79)) #1 SMP PREEMPT Thu Jun 2 19:52:17 CST 2022
# https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-14.0.0_r54/clang-r487747c.tar.gz
# https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/+archive/043dc0ad16a73e0e1973132d00fa6265ab4fa6ba.tar.gz
# https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/+archive/5ac02a0ba9f39591758bab4516dd0725747af0c3.tar.gz

# tar -zxvf arm-linux-androideabi-4.9-5ac02a0ba9f39591758bab4516dd0725747af0c3.tar.gz --one-top-level=arm-linux-androideabi
# tar -zxvf aarch64-linux-android-4.9-043dc0ad16a73e0e1973132d00fa6265ab4fa6ba.tar.gz --one-top-level=aarch64-linux-android
# tar -zxvf linux-x86-refs_tags_android-14.0.0_r54-clang-r487747c.tar.gz --one-top-level=clang-r487747c
SECONDS=0 # builtin bash timer

CLANG=~/projects/toolchain/clang-r487747c/bin
GCC32=~/projects/toolchain/arm-linux-androideabi/bin
GCC64=~/projects/toolchain/aarch64-linux-android/bin
export LD_LIBRARY_PATH=~/projects/toolchain/clang-r487747c/lib64:/usr/local/lib:$LD_LIBRARY_PATH
PATH=$CLANG:$GCC64:$GCC32:$PATH
export PATH
export ARCH=arm64

DEFCONFIG="begonia_user_defconfig"
export KBUILD_BUILD_USER=builder
export KBUILD_BUILD_HOST=m1-xm-ota-bd086.bj.idc.xiaomi.com
export KBUILD_BUILD_TIMESTAMP="Thu Jun 2 19:52:17 CST 2022"
KBUILD_BUILD_TIMESTAMP="Thu Jun 2 19:52:17 CST 2022"



export ARCH=arm64
rm -rf out/
mkdir -p out
make O=out CROSS_COMPILE=aarch64-linux-gnu- LLVM=1 $DEFCONFIG

make O=out CC=clang LLVM=1 LLVM_IAS=1 AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip LD=ld.lld CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- -j2 || exit 1

# kernel="out/arch/arm64/boot/Image
