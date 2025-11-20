#!/bin/bash
source env.sh

wget $SDLLVM_URL -O sdllvm/sdllvm.zip
unzip sdllvm.zip -d sdllvm/$SDLLVM_VER/

