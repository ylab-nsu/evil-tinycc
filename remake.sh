#!/bin/bash

make clean
make -j"$(nproc)" 
sudo make install
