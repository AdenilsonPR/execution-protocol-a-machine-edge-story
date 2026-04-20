# Tasks da Demo - Índice

## Estrutura

```
docs/demo/
├── docs/
│   ├── terminal/
│   ├── combate/
│   ├── shop/
│   ├── chat/
│   ├── narrativa/
│   ├── save/
│   └── implementacao/
├── dialogues/
└── tasks/
    ├── task_001_estrutura_base.md
    ├── task_002_autoloads.md
    ├── task_003_terminal_comandos.md
    ├── task_004_terminal_layout.md
    ├── task_005_chat_painel.md
    ├── task_006_combate.md
    ├── task_007_missoes.md
    ├── task_008_inventario.md
    ├── task_009_narrativa.md
    └── task_010_testes.md
```

---

## Ordem de Implementação

1. [[task_001_estrutura_base|Estrutura Base]] — 1-2h
2. [[task_002_autoloads|Autoloads]] — 4-6h
3. [[task_003_terminal_comandos|Terminal - Comandos]] — 4-6h
4. [[task_004_terminal_layout|Terminal - Layout]] — 3-4h
5. [[task_005_chat_painel|Chat - Painel]] — 4-5h
6. [[task_006_combate|Combate - Sistema]] — 6-8h
7. [[task_007_missoes|Missões]] — 3-4h
8. [[task_008_inventario|Inventário]] — 5-6h
9. [[task_009_narrativa|Narrativa]] — 6-8h
10. [[task_010_testes|Testes]] — 8-10h

**TOTAL: ~44-59 horas**

---

## Tarefas por Sistema

### Terminal
- [[task_003_terminal_comandos|Comandos]] → [[task_004_terminal_layout|Layout]]

### Chat
- [[task_005_chat_painel|Painel]]

### Combate
- [[task_006_combate|Sistema ATB]]

### Jogo
- [[task_007_missoes|Missões]] → [[task_008_inventario|Inventário]] → [[task_009_narrativa|Narrativa]]

### Validação
- [[task_010_testes|Testes]]

---

## Menu Lateral - Abas (5 abas)

| Aba | Conteúdo | Documentação |
|-----|----------|--------------|
| MAPA+COMBATE | Mapa + Status do combate | [[../terminal/02_mapa|Mapa]] |
| LOJA+INV | Loja + Inventário | [[../shop/04_shop|Loja]] |
| MISSÕES | Missões ativas e disponíveis | [[task_007_missoes|Missões]] |
| OFICINA+STATUS | Melhorar atributos + Stats | [[../shop/04_oficina|Oficina]] |
| CHAT | Conversas com NPCs | [[../chat/05_chat|Chat]] |

---

## Referências

- [[../index|Índice Geral]]
- [[../implementacao/plano_de_implementacao|Plano de Implementação]]
- [[../narrativa/01_narrativa|Narrativa]]
- [[../terminal/02_terminal|Comandos do Terminal]]
- [[../combate/03_combate|Combate]]
- [[../combate/03_combate_status|Combate Status]]
- [[../shop/04_shop|Loja]]
- [[../shop/04_oficina|Oficina]]
- [[../terminal/02_mapa|Mapa]]
- [[../chat/05_chat|Chat]]
- [[../narrativa/06_decryption|Decryption]]
- [[../save/07_save|Save/Load]]