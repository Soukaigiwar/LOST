SRC_NAME = boot
OUT_DIR = ./build
EXE_NAME = $(OUT_DIR)/$(SRC_NAME)
IMG_NAME = $(OUT_DIR)/$(SRC_NAME).img

all: $(EXE_NAME)
	ls -la ./build

run: $(EXE_NAME)
	qemu-system-i386 -drive file=$(IMG_NAME),format=raw,index=0,if=floppy

$(BOOT_NAME): $(EXE_NAME)
	cp $(OUT_DIR)/$(SRC_NAME).bin $(IMG_NAME)
	truncate -s 1440k $(IMG_NAME)

$(EXE_NAME): $(SRC_NAME).asm
	mkdir -p $(OUT_DIR)
	nasm $(SRC_NAME).asm -f bin -o $(OUT_DIR)/$(SRC_NAME).bin

clean:
	rm -rf $(OUT_DIR)
