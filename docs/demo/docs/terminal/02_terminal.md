# Comandos do Terminal

Esta página documenta todos os comandos disponíveis no jogo.

## Layout do Jogo

O jogo possui dois painéis com 5 abas:

```
┌─────────────────────────────────────────────┐
│ TERMINAL (comandos)                         │
│ > help                                      │
│                                             │
├─────────────────────────────────────────────┤
│ [MAPA+COMBATE] [LOJA+INV] [MISSOES] [OFICINA+STATUS] [CHAT]    │
├──────────────┬──────────────────────────────┤
│ MAPA       │                              │
│ - Base Delta-7                        │
│ - Setor Norte (bloqueado)              │
│ - Perimetro Leste                   │
│ - Setor Sul                        │
├──────────────┼──────────────────────────────┤
│ CHAT       │                              │
│ [Reyes] ●  │   (mensagens em tempo real)  │
│ [Chen]     │                              │
│ [Vasquez]  │                              │
└──────────────┴──────────────────────────┘
```

---

## Abas do Menu Lateral

| Aba | Conteúdo |
|-----|----------|
| **MAPA + COMBATE** | Mapa da base + Status do combate |
| **LOJA + INV** | Loja + Inventário |
| **MISSÕES** | Missões ativas e disponíveis |
| **OFICINA + STATUS** | Melhorar atributos + Stats do jogador |
| **CHAT** | Conversas com NPCs |

---

## Comandos Básicos

### help

Lista todos os comandos disponíveis.

```
> help

Comandos:
  help      - Mostra esta lista
  status    - Mostra seu status
  clear     - Limpa o terminal
  mission   - Mostra missao atual
  missions  - Lista todas as missoes
  shop      - Abre a loja
  chat NPC  - Abre chat com NPC (reyes, chen, vasquez)
  save      - Salva o jogo
  load      - Carrega um save

Combate (menu visual):
  Use ↑↓+ENTER para selecionar acao
```

**Uso**: `help [comando]`

Parâmetros opcionais — mostra help específico de um comando.

---

### status

Mostra informações sobre seu personagem.

```
> status

╔══════════════════════════════════════╗
║       UNIDADE DE GUERRA #2227          ║
╠══════════════════════════════════════╣
║ HP:      ████████████░░░░  85/100    ║
║ ENERGIA: ████████████░░░░  80/100   ║
║ ESCUDO:  ████████░░░░░░░░░  45/80    ║
╠══════════════════════════════════════╣
║ ATRIBUTOS:                          ║
║   Potência:     ███░░░  15           ║
║   Precisão:     ██░░░░  10           ║
║   Núcleo:      ███░░░░  18          ║
║   Manobra:      ████░░░  22          ║
║   Densidade:   ██░░░░░  12           ║
╠══════════════════════════════════════╣
║ SCRAPS:     ░░░░░░  350              ║
║ NÍVEL:      3                        ║
║ LOCAL:     Base Delta-7             ║
╚══════════════════════════════════════╝
```

---

### clear

Limpa o histórico do terminal.

```
> clear
```

---

### mapa

Mostra o mapa da base.

```
> mapa

[MAPA - BASE DELTA-7]
Setores:
  [1] Base Central (atual)
  [2] Torre de Comando
  [3] Arena de Treino
  [4] Laboratório
  [5] Perímetro Leste
  [6] Setor Norte (bloqueado)
  [7] Setor Sul
```

Ver [[02_mapa|Mapa]] para detalhes completos.

---

### ir [local]

Move para um setor específico.

```
> ir torre

╔══════════════════════════════════════╗
║ DESLOCANDO...                    ║
║ DESTINO: Torre de Comando         ║
║ TEMPO: 0.5s                  ║
║ ✓ Chegou!                   ║
╚══════════════════════════════════════╝
```

Locais disponíveis: `base`, `torre`, `arena`, `lab`, `perimetro`, `norte`, `sul`

---

### melhor

Abre a oficina para melhorar atributos.

```
> melhor

╔══════════════════════════════════════╗
║          OFICINA                 ║
╠══════════════════════════════════════╣
║ SCRAPS:     350                  ║
╠══════════════════════════════════════╣
║ Potência   [Lv4]  200 scr        ║
║ Precisão  [Lv3]  150 scr        ║
║ Núcleo    [Lv4]  200 scr        ║
║ Manobra   [Lv3]  150 scr        ║
║ Densidade [Lv4]  200 scr        ║
╠══════════════════════════════════════╣
║ USE: melhor [atributo]            ║
║ EXIT: exit                    ║
╚══════════════════════════════════════╝
```

```
> melhor potencia

╔══════════════════════════════════════╗
║ MELHORANDO POTÊNCIA...              ║
║ Custo: 200 scraps                ║
║ Potência: 15 → 20                ║
║ ✓ Melhoria aplicada!              ║
╚══════════════════════════════════════╝
```

Ver [[04_oficina|Oficina]] para detalhes completos.

---

### mission

Mostra a missão atual.

```
> mission

╔══════════════════════════════════════╗
║ MISSAO ATUAL: Varredura Perimetral       ║
╠══════════════════════════════════════╣
║ OBJETIVO: Derrotar 3 Electrotrions    ║
║ PROGRESSO: ████░░░░░░░░  2/3         ║
║ RECOMPENSA: 50 scraps                ║
╚══════════════════════════════════════╝
```

---

### missions

Lista todas as missões disponíveis, incluindo as completadas.

```
> missions

[1] ✓ Conexão Inicial (COMPLETA)
[2] > Varredura Perimetral (ATIVA)
[3] ? Atividade Anômala (DISPONÍVEL)
[4] ? Investigação Profunda ( BLOQUEADA)
```

Legenda:
- `✓` Completada
- `>` Ativa
- `?` Disponível
- `X` Bloqueada

---

### inventory

Mostra seu inventário.

```
> inventory

╔══════════════════════════════════════╗
║         INVENTÁRIO                    ║
╠════════════��═════════════════════════╣
║ EQUIPAMENTOS:                        ║
║   [1] Chip de Potência I            ║
║   [2] Chip de Escudo I              ║
║   [3] --- VAZIO ---                 ║
╠══════════════════════════════════════╣
║ ITENS DE COMBATE:                   ║
║   Kit Médico x2                     ║
║   Granada Fragmentação x3           ║
║   Granada de Fumaça x1              ║
╠══════════════════════════════════════╣
║ ITENS ESPECIAIS:                    ║
║   Dispositivo Criptografado         ║
╚══════════════════════════════════════╝
```

Comandos de inventário:
- `use [item]` — Usa um item
- `equip [slot] [item]` — Equipa um item
- `unequip [slot]` — Desequipa um item

---

### shop

Abre a loja da base.

```
> shop

╔══════════════════════════════════════╗
║         LOJA - BASE DELTA-7          ║
╠══════════════════════════════════════╣
║ SCRAPS:  350                         ║
╠══════════════════════════════════════╣
║ [1] Kit Médico          - 25 scr     ║
║ [2] Granada Fragment. - 40 scr      ║
║ [3] Chip de Potência I  - 75 scr     ║
║ [4] Chip de Precisão I - 75 scr     ║
║ [5] Chip de Núcleo I  - 75 scr     ║
║ [6] Drive de Criptogr. - 200 scr    ║
║ [7] Upgrade de Atributo - 150 scr   ║
╠══════════════════════════════════════╣
║ USE: buy [numero]                    ║
║ EXIT: exit                          ║
╚══════════════════════════════════════╝
```

Ver [[04_shop]] para detalhes completos.

---

### chat [npc]

Abre conversa detalhada com NPC. Também abre o painel lateral na aba de chat.

```
> chat reyes

Conectando com Comandante Reyes...
[19:42] COMANDANTE REYES: Olá, soldado!
[19:42]         Tem um momento?
[19:42]         Precisamos verificar o perímetro.
>
```

**Painel Lateral**: Quando não está em uma conversa, o painel mostra:
- Lista de NPCs
- Indicador de novas mensagens (●)
- Últimas mensagens recebidas

Ver [[05_chat]] para detalhes completos.

---

### save

Salva o jogo.

```
> save

╔══════════════════════════════════════╗
║            SAVE GAME               ║
╠══════════════════════════════════════╣
║ Slot 1: [AUTO]    2026-04-20    ║
║ Slot 2: [BATTLE]  2026-04-19    ║
║ Slot 3: [---VAZIO---]            ║
╠══════════════════════════════════════╣
║ USE: save [slot]                  ║
║ QUICK: save quick                ║
╚══════════════════════════════════════╝
```

Ver [[07_save]] para detalhes completos.

---

### load

Carrega um save existente.

```
> load

╔══════════════════════════════════════╗
║           LOAD GAME                 ║
╠══════════════════════════════════════╣
║ Slot 1: [AUTO]    2026-04-20    ║
║ Slot 2: [BATTLE]  2026-04-19    ║
╠══════════════════════════════════════╣
║ USE: load [slot]                   ║
╚══════════════════════════════════════╝
```

---

## Combate

Durante o combate, você não usa comandos de terminal.
O jogo abre um **menu visual** usando setas + Enter.

```
╔═══════════════════════════════════════╗
║  SUA VEZ! Escolha uma ação:          ║
╠═══════════════════════════════════════╣
║  > ATACAR                            ║
║    DEFENDER                          ║
║    USAR ITEM                         ║
║    FUGIR                             ║
╚═══════════════════════════════════════╝

[↑/↓] navegar   [ENTER] selecionar
```

Ver [[03_combate]] para detalhes completos.

---

## Atalhos

| Atalho | Comando |
|-------|---------|
| `h` | `help` |
| `s` | `status` |
| `m` | `mission` |
| `i` | `inventory` |
| `q` | `save quick` |

---

## Atalhos de Navegação

| Tecla | Ação |
|------|------|
| `↑` | Commands anteriores |
| `↓` | Próxima command |
| `Tab` | Autocomplete |
| `Ctrl+L` | Limpar terminal |

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[05_chat]] — Sistema de chat
- [[06_decryption]] — Quebra-cabeça
- [[07_save]] — Save/Load
- [[08_implementacao]] — Implementação