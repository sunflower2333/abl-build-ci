#!/bin/bash
source env.sh

wget $SDLLVM_URL -O sdllvm/sdllvm.zip &> /dev/null
unzip sdllvm/sdllvm.zip -d sdllvm/ &> /dev/null
rm sdllvm/sdllvm.zip
