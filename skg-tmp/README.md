## Um simples makefile para abreviar uns comandos.

#### Para usá-la, basta digitar:
`make` Para fazer o processo de criar e preparar o arquivo da imagem de boot com seus 1440k de tamanho.

`make run` Para fazer o mesmo acima e executar o QEMU. 

`make xxd` Para fazer o mesmo acima e executar o XXD.

Um comando não depende do outro, se digitar `make run` automaticamente vai executar o primeiro antes.

Basta criar um arquivo chamado `makefile`, inserir o código abaixo e usar.

Como exemplo, eu tenho criado uma pasta e dentro dela crio o makefile para usar. Assim não afeta outros testes.

```
.
|-- teste01
|   `-- boot.asm
|   `-- makefile
```

```
SRC_NAME = boot
OUT_DIR = ./build
EXE_NAME = $(OUT_DIR)/$(SRC_NAME)
IMG_NAME = $(OUT_DIR)/$(SRC_NAME).img

all: $(IMG)
	ls -la ./build

run: $(IMG_NAME)
	ls -la ./build
	qemu-system-i386 -drive file=$(IMG_NAME),format=raw,index=0,if=floppy

xxd: $(IMG_NAME)
	xxd $(EXE_NAME).bin

$(IMG_NAME): $(EXE_NAME)
	cp $(OUT_DIR)/$(SRC_NAME).bin $(IMG_NAME)
	truncate -s 1440k $(IMG_NAME)

$(EXE_NAME): $(SRC_NAME).asm
	mkdir -p $(OUT_DIR)
	nasm $(SRC_NAME).asm -f bin -o $(OUT_DIR)/$(SRC_NAME).bin

clean:
	rm -rf $(OUT_DIR)

```
