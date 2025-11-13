#!/bin/bash
# Usage:
#   ./build.sh <abl-dir> <patch-dir> <target>
# Example:
#   ./build.sh abl-pineapple patch-pineapple pineapple

# SDLLVM Download:
#   https://github.com/map220v/QCOM_LLVM_10.0/
ABL_SRC=$1
PATCH_DIR=$2
TARGET=$3
SEC_VERSION=$4
set -e

if [ -z "$ABL_SRC" ] || [ -z "$PATCH_DIR" ] || [ -z "$TARGET" ] || [ -z "$SEC_VERSION" ]; then
    echo "Usage:"
    echo -e "\t$0 <abl-dir> <patch-dir> <target> <sec-version>"
    echo "Example:"
    echo -e "\t./build.sh abl-pineapple patch-pineapple pineapple 7"
    exit 1
fi

function check_tool() {
	if ! which "$1" &>/dev/null; then
		echo "$1 not found" >&2
		exit 1
	fi
}

# Check required tools
check_tool git
check_tool awk
check_tool sed
check_tool grep
check_tool patch
if ! [ -d .git ]; then
    exit 0
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
if [ ! -d $PATCH_DIR ]; then
    echo "Patch dir: $PATCH_DIR does not exist"
    exit 1
fi

# checkout before patch
git -C "$ABL_SRC" reset --hard
git -C "$ABL_SRC" clean -fd

for patch in "$PATCH_DIR"/*.patch; do
    if ! [ -f "$patch" ]; then
        continue
    fi
    if patch -d "$ABL_SRC" -sfRp1 --dry-run < "$patch" &>/dev/null; then
        continue
    fi
    echo "Apply $patch to $ABL_SRC"
    patch -d "$ABL_SRC" -tNp1 < "$patch"
done

# Build
cd $ABL_SRC
if ! make all BOOTLOADER_OUT=out/ CLANG_BIN=$SDLLVM_PATH/$SDLLVM_VERSION/bin/ "${MAKE_FLAGS[@]}"; then
    echo "Build failed!"
    exit 1
fi
cd ..

# Verify unsigned_abl.elf was created
if [ ! -f "$ROOT_DIR/unsigned_abl.elf" ]; then
    echo "Error: unsigned_abl.elf not found after build!"
    exit 1
fi

# Sign
# Use qtestsign to sign abl
if ! ./sectools/qtestsign/qtestsign.py -v$SEC_VERSION abl -o abl_"$TARGET"_testsigned.elf $ROOT_DIR/unsigned_abl.elf; then
    echo "Signing failed!"
    exit 1
fi

# Verify signed output was created
if [ ! -f "abl_${TARGET}_testsigned.elf" ]; then
    echo "Error: signed abl_${TARGET}_testsigned.elf not found!"
    exit 1
fi

echo "Build and signing completed successfully!"
