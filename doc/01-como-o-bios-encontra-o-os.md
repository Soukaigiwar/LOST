# Como o BIOS encontra o sistema operacional

## Modo legado

- O BIOS carrega o primeiro setor do dispositivo na memória.
- Endereço: `0x7c00`.
- O BIOS procura a assinatura de boot: `0xaa55`.
- Se encontrada, inicia a execução do código do boot.

## Modo EFI

- O BIOS procura pela partição especial EFI.
- O sistema operacional deve ser compilado com um programa de EFI.

