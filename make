#!/bin/bash

mkdir -p build

PS4='• '
set -x

# Bootloader

nasm src/boot/loader.asm -f bin -o build/loader.bin || exit
cp build/loader.bin build/lost.img
truncate -s 1440k build/lost.img

