#!/bin/bash
# Usage:
#   ./build.sh <dir> <codename>
# Example:
#   ./build.sh abl-pineapple pineapple

# SDLLVM Download:
#   https://github.com/SuleMareVientu/Qualcomm_Snapdragon_LLVM_ARM_Toolchain_OEM/releases/download/16.1.3.0/16.1.3.0.zip
ABL_SRC=$1
PATCH_DIR=$2
TARGET=$3

if [ -z "$TARGET" || -z "PATCH_DIR" || -z "TARGET" ]; then
    echo "Usage:"
    echo -e "\t$0  <dir> <codename>"
    echo "Example:"
    echo -e "\t$0 abl-pineapple pineapple"
    exit 1
fi

# Setting up env
ROOT_DIR=$PWD/
source $ROOT_DIR/$ABL_SRC/QcomModulePkg/build.config.msm.$TARGET
SDLLVM_PATH=$ROOT_DIR/sdllvm/
SDLLVM_VERSION="10.0"

if [ ! -d "$SDLLVM_PATH" ]; then
    echo "SDLLVM directory not found!"
    echo "Please update git submodules"
    exit 1
fi

# Apply Patch
if [ ! -d $PATCH_DIR ]
    echo "Patch dir: $PATCH_DIR does not exist"
    exit 1
fi
git am $PATCH_DIR/*

# Build
cd $ABL_SRC
make all BOOTLOADER_OUT=out/ CLANG_BIN=$SDLLVM_PATH/$SDLLVM_VERSION/bin/ "${MAKE_FLAGS[@]}"
cd ..

# Sign
# --
