# Funções do bootloader

As principais funções de um bootloader são:

- Carregar os componentes básicos na memória
- Colocar o computador no estado que o kernel espera
- Coletar informações básicas do sistema

Isso varia de acordo com o sistema operacional. O DOS, por exemplo, opera em
16-bits *real-mode*: basta um salto para a região do disco contento o sistema.
Sistemas mais modernos, por outro lado, esperam que o bootloader altere o modo
de operação para 32-bit *protected-mode* e colete algumas informações sobre o
sistema, especialmente porque, no modo protegido, não há mais acesso aos
serviços e às funções do BIOS que poderiam forncer iformações críticas (como o
*layout* da memória, por exemplo).

> **Nota:** o acesso às informações necessárias não é exatamente "impossível"
> no modo protegido, mas requereria soluções complexas demais.



---

[Voltar](../README.md#conceitos)

