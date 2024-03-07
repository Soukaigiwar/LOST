# Pilha

- Região da memória acessada segundo o esqueme LIFO (*last in, first out*).
- Analogia clássica: uma pilha de pratos...

```
3   \_____/ <-- Prato no topo da pilha
2   \_____/
1   \_____/
0   \_____/ <-- Prato na base da pilha
```

- Para acessar um prato no meio da pilha, é preciso remover, um a um, os pratos
  que estão no topo.
- Para remover o prato no topo da pilha: `pop`.
- Para incluir um prato no topo da pilha: `push`
- Na memória, os "pratos" são empilhados na direção dos endereços mais baixos.

## Ponteiros da pilha

Registram endereços de dados na pilha:

- `SP`: Registra o endereço do topo da pilha.
- `BP`: Registra o endereço da base da pilha.

```
            SP              BP
            |               |
            V               v
Endereços --+---+---+---+---+-- Endereços
mais        | 3 | 2 | 1 | 0 |   mais
baixos    --+---+---+---+---+-- altos
```


---

[Voltar](../README.md#conceitos)

