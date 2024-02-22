# Testes e demonstrações

## Montagem

```
$ nasm ARQUIVO.asm -f bin -o ARQUIVO.bin
$ cp ARQUIVO.bin ARQUIVO.img
$ truncate -s 1440k ARQUIVO.img
```

## Teste no Qemu

```
$ qemu-system-i386 -drive file=ARQUIVO.img,format=raw,index=0,if=floppy
```

