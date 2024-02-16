ASM=nasm

SRC_DIR=src
BUILD_DIR=build

$(BUILD_DIR)/disk.img: $(BUILD_DIR)/main.bin
	cp $(BUILD_DIR)/main.bin $(BUILD_DIR)/disk.img
	truncate -s 1440k $(BUILD_DIR)/disk.img

$(BUILD_DIR)/main.bin: $(SRC_DIR)/main.asm
	$(ASM) $(SRC_DIR)/main.asm -f bin -o $(BUILD_DIR)/main.bin

run:
	@qemu-system-i386 -drive file=build/disk.img,format=raw,index=0,if=floppy
