#!/bin/bash
# Usage:
#   ./build.sh <codename>
# Example:
#   ./build.sh pineapple

# SDLLVM Download:
#   https://github.com/SuleMareVientu/Qualcomm_Snapdragon_LLVM_ARM_Toolchain_OEM/releases/download/16.1.3.0/16.1.3.0.zip
TARGET=$1
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <codename>"
    echo "Example: $0 pineapple"
    exit 1
fi

# Setting up env
ROOT_DIR=$PWD/
ABL_SRC=abl/
source $ROOT_DIR/$ABL_SRC/QcomModulePkg/build.config.msm.$TARGET
SDLLVM_PATH=$ROOT_DIR/sdllvm/
SDLLVM_VERSION="16.1.3.0"

if [ ! -d "$SDLLVM_PATH" ]; then
    echo "SDLLVM directory not found!"
    echo "Please download sdllvm from:"
    echo -e "\thttps://github.com/SuleMareVientu/Qualcomm_Snapdragon_LLVM_ARM_Toolchain_OEM/releases/download/16.1.3.0/16.1.3.0.zip"
    echo "and extract SDLLVM to $SDLLVM_PATH/$SDLLVM_VERSION"
    exit 1
fi

# Build
cd $ABL_SRC
make all BOOTLOADER_OUT=out/ CLANG_BIN=/usr/bin/ "${MAKE_FLAGS[@]}"
cd ..

# Sign
# --
