# Testes e demonstrações

Procedimentos para testes e demonstações.

## Binário

```
$ nasm ARQUIVO.asm -f bin -o ARQUIVO.bin
```

## Imagem

> Não é necessaŕio para os testes do boot.

```
$ cp ARQUIVO.bin ARQUIVO.img
$ truncate -s 1440k ARQUIVO.img
```

## Teste no Qemu

```
$ qemu-system-i386 -drive file=ARQUIVO.img,format=raw,index=0,if=floppy
```

