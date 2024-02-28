# LOS/T - Learning Operating Systems Together

Criação coletiva de um sistema operacional do zero para fins de aprendizado.

> **Este material está em constante construção!**

## Objetivos

- Este não é um curso.
- Este é um projeto de construção coletiva de conhecimento.
- A ideia é a gente se divertir enquanto aprende!

### Fase 1

- Dar boot numa máquina virtual e imprimir uma mensagem.
- Carregar um kernel mínimo em outra região da imagem do disco.

### Fase 2

- Sistema de arquivos
- Criação de alguns progranas (mini-games?)

### Fase 3

- Criação de um shell mínimo

## Fontes de pesquisa

### Documentos

- [BIOS Interrupt Call - Wikipedia](https://en.wikipedia.org/wiki/BIOS_interrupt_call)
- [Interrupt Vector Table (IVT) - Wikipedia](https://en.wikipedia.org/wiki/Interrupt_vector_table)
- [Interrupt Services DOS/BIOS/EMS/Mouse - HelpPC](https://stanislavs.org/helppc/idx_interrupt.html)
- [DOS, BIOS & Extensions Service Index (bem melhor!)](http://www.techhelpmanual.com/27-dos__bios___extensions_service_index.html)
- [Real Mode - OS Dev](https://wiki.osdev.org/Real_Mode)
- [Segmentação - OS Dev](https://wiki.osdev.org/Segmentation)
- [FAT - OS Dev](https://wiki.osdev.org/FAT)
- [Disk access using the BIOS (INT 13h) - OS Dev](https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h))

### Artigos

- [How to write a simple operating system - Mike Saunders (MikeOS)](https://mikeos.sourceforge.net/write-your-own-os.html)
- [Building an OS (transcrições dos vídeos) - Nanobyte](https://nanobyte.dev/transcripts/building-an-os-1-hello-world)

### Vídeos

- [Building an OS (playlist) - Nanobyte](https://www.youtube.com/watch?v=9t-SPC7Tczc&list=PLFjM7v6KGMpiH2G-kT781ByCNC_0pKpPN)
- [x86 Assembly with NASM (a partir do vídeo 28) -  OliveStem](https://youtube.com/playlist?list=PL2EF13wm-hWCoj6tUBGUmrkJmH1972dBB&si=F5GnAdNp4rEr_8vD)

### Códigos para referência

- [BootMine ("Campo Minado" para o setor de boot) - GitHub](https://github.com/io12/BootMine/blob/master/mine.asm)
- [ghaiklor-os-gcc (OS educacional) - GitHub](https://github.com/ghaiklor/ghaiklor-os-gcc)
- [Nanobyte OS (fontes da série em vídeo) - GitHub](https://github.com/nanobyte-dev/nanobyte_os)

## Requisitos e ferramentas

- Montador: [nasm](https://manpages.debian.org/unstable/nasm/nasm.1.en.html)
- Máquina virtual: [qemu-system-i386](https://manpages.debian.org/unstable/qemu-system-x86/qemu-system-i386.1.en.html)
- Hex dump: [xxd](https://manpages.debian.org/unstable/xxd/xxd.1.en.html)

```
sudo apt install build-essential qemu nasm
```

## Conceitos

1. [Como o BIOS encontra o sistema operacional](doc/01-como-o-bios-encontra-o-os.md)
1. [Diretivas e instruções](doc/02-diretivas-e-instrucoes.md)
1. [Endereçamento de memória](doc/03-enderecamento-de-memoria.md)
1. [Boot mínimo](doc/04-boot-minimo.md)
1. [Inicialização dos segmentos de dados](doc/05-inicializacao-dos-segmentos-de-dados.md) 
1. [Pilha](doc/06-pilha.md)
1. [Iniciando a pilha](doc/07-iniciando-a-pilha.md)

## Scripts de montagem

- [make (bash)](make)
- [run (bash)](run)

## Estrutura do projeto na fase 1

```
.
|-- doc
|   `-- ...
|-- src
|   |-- boot
|   |   |-- kernel.asm
|   |   `-- loader.asm
|   `-- lib
|       |-- dev
|       |   `-- fat12header.asm
|       `-- stdio
|           `-- puts.asm
|-- tmp
|   `-- ...
|-- LICENSE
|-- make
|-- README.md
`-- run
```

### Fontes

- Bootloader: [loader.asm](src/boot/loader.asm)
- Kernel: [kernel.asm](src/boot/kernel.asm)
- Impressão de strings: [puts.asm](src/lib/stdio/puts.asm)
- Cabeçalho FAT12: [fat12header.asm](src/lib/dev/fat12header.asm)


