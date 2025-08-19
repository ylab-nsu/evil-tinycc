#!/bin/bash

make clean
make -j"$(nproc)" CC=tcc 
sudo make install
