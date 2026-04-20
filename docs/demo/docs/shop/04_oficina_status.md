# OFICINA + STATUS

Esta página documenta a aba de Oficina combinada com o Status do jogador.

---

## Visão Geral

A aba **OFICINA + STATUS** exibe:
- **Status** do jogador (HP, Energia, Escudo, Atributos)
- **Oficina** (melhoria de atributos)

---

## Interface

```
┌─────────────────────────────────────────┐
│        OFICINA           STATUS         │
│  SCRAPS: 350           ──────────────    │
│  ════════════════════════════════════════│
│                                         │
│  ATRIBUTOS            HP ████████░ 85  │
│  ───────────────      EN ███████░░ 80  │
│  ⚔ POT [███░] L4      ES ██████░░░ 45  │
│     +5 → +10  [UP]                     │
│  🎯 PRE [██░░] L3                      │
│     +3 → +6   [UP]                     │
│  ⚡ NUC [███░] L4                      │
│     +10 → +15 [UP]                    │
│  🏃 MAN [██░░] L3                      │
│     +2 → +4   [UP]                    │
│  🛡 DEN [███░] L4                      │
│     +10 → +15 [UP]                    │
│                                         │
│  ────────────────────────────────────   │
│  ATRIBUTOS: 15 10 18 22 12             │
└─────────────────────────────────────────┘
```

---

## Seções

### Oficina (Coluna Esquerda)

```
┌──────────────────┐
│  OFICINA        │
│  SCRAPS: 350   │
│  ═══════════════│
│  ATRIBUTOS:     │
│  ⚔ POT [███░]  │
│    L4 → L5     │
│    Custo: 300  │
│    [UPGRADE]   │
│                │
│  🎯 PRE [██░░]  │
│    L3          │
│    [UPGRADE]   │
│                │
│  ⚡ NUC [███░]  │
│    L4          │
│    [UPGRADE]   │
└──────────────────┘
```

### Status (Coluna Direita)

```
┌──────────────────┐
│  STATUS          │
│  ═══════════════│
│  HP  ████████░░ 85│
│  EN  ███████░░ 80│
│  ES  ██████░░░ 45│
│                  │
│  POT: 15  ███░░ │
│  PRE: 10  ██░░░ │
│  NUC: 18  ███░░ │
│  MAN: 22  ████░ │
│  DEN: 12  ██░░░ │
└──────────────────┘
```

---

## Atributos Detalhados

### Tabela de Melhorias

| Attr | L1→L2 | L2→L3 | L3→L4 | L4→L5 | Bonus Total |
|------|-------|-------|-------|-------|-------------|
| **Potência** | +5 | +5 | +5 | +5 | +20 |
| **Precisão** | +3 | +3 | +3 | +3 | +12 |
| **Núcleo** | +10 | +10 | +10 | +15 | +45 |
| **Manobra** | +2 | +2 | +2 | +2 | +8 |
| **Densidade** | +10 | +10 | +10 | +15 | +45 |

### Custo por Nível

| Nível | Custo |
|-------|-------|
| 1 → 2 | 100 |
| 2 → 3 | 150 |
| 3 → 4 | 200 |
| 4 → 5 | 300 |
| 5 → MAX | 500 |

---

## Comandos

### status

Mostra o status completo.

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
║   Manobra:      ████░░░  22           ║
║   Densidade:   ██░░░░░  12           ║
╠══════════════════════════════════════╣
║ SCRAPS:     ░░░░░░  350              ║
║ NÍVEL:      3                        ║
╚══════════════════════════════════════╝
```

### melhor

Abre a oficina.

```
> melhor

╔══════════════════════════════════════╗
║          OFICINA                     ║
╠══════════════════════════════════════╣
║ SCRAPS:     350                     ║
╠══════════════════════════════════════╣
║ ⚔ POT   [███░░] L4   200 scr       ║
║ 🎯 PRE  [██░░░] L3   150 scr       ║
║ ⚡ NUC  [███░░] L4   200 scr       ║
║ 🏃 MAN  [██░░░] L3   150 scr       ║
║ 🛡 DEN  [███░░] L4   200 scr       ║
╠══════════════════════════════════════╣
║ USE: melhor [atributo]              ║
║ EXIT: exit                          ║
╚══════════════════════════════════════╝
```

### melhor [atributo]

Melhora um atributo específico.

```
> melhor potencia

╔══════════════════════════════════════╗
║ MELHORANDO POTÊNCIA...              ║
║ Custo: 200 scraps                  ║
║ Potência: 15 → 20                  ║
║ ✓ Melhoria aplicada!               ║
╚══════════════════════════════════════╝
```

---

## Descrição dos Atributos

| Atributo | Ícone | Efeito |
|----------|-------|--------|
| **Potência** | ⚔ | Dano dos ataques |
| **Precisão** | 🎯 | Chance de acerto crítico |
| **Núcleo** | ⚡ | Energia máxima e regeneração |
| **Manobra** | 🏃 | Velocidade de cooldown |
| **Densidade** | 🛡 | Escudo máximo |

---

## Pixel Art (Atributos)

Cada atributo pode ter um ícone pixel art:
- Potência: Espada
- Precisão: Alvo/Mira
- Núcleo: Raio/Bateria
- Manobra: Bota/Sapato
- Densidade: Escudo

---

## Links

- [[04_oficina|Oficina]]
- [[task_008_inventario|Inventário]]