# LOJA + INVENTÁRIO

Esta página documenta a aba de Loja combinada com o Inventário.

---

## Visão Geral

A aba **LOJA + INV** exibe:
- **Loja** (itens para comprar)
- **Inventário** (itens que possui)

Layout em duas colunas para otimizar espaço.

---

## Interface

```
┌─────────────────────────────────────────┐
│        LOJA              INVENTÁRIO      │
│  SCRAPS: 350           ──────────────    │
│  ════════════════════════════════════════│
│                                         │
│  [1] Kit Médico      │  ITENS:           │
│      25 scraps       │  - Kit x3        │
│  [2] Granada         │  - Granada x2     │
│      40 scraps       │                  │
│  [3] Chip Potência   │  EQUIP:           │
│      75 scraps       │  - Chip Pot. [1] │
│  [4] Chip Precisão   │  - [2] VAZIO      │
│      75 scraps       │  - [3] VAZIO      │
│  [5] Drive Leitura   │                  │
│     200 scraps       │  ESPECIAIS:       │
│                       │  - Drive Leitura  │
│  ─────────────────   │                  │
│  [COMPRAR] [VENDER]  │  [USAR] [EQUIP]  │
└─────────────────────────────────────────┘
```

---

## Seções

### Loja (Coluna Esquerda)

```
┌──────────────────┐
│  LOJA            │
│  SCRAPS: 350    │
│  ═══════════════│
│  [1] Kit Médico  │
│      25 scraps   │
│  [2] Granada      │
│      40 scraps   │
│  [3] Chip Pot.    │
│      75 scraps   │
│  [4] Drive        │
│     200 scraps   │
│  ────────────────│
│  [COMPRAR]       │
└──────────────────┘
```

### Inventário (Coluna Direita)

```
┌──────────────────┐
│  INVENTÁRIO      │
│  ═══════════════│
│  ITENS:          │
│  - Kit x3        │
│  - Granada x2     │
│                  │
│  EQUIP:          │
│  - [1] Chip Pot. │
│  - [2] VAZIO     │
│  - [3] VAZIO     │
│                  │
│  [USAR] [EQUIP]  │
└──────────────────┘
```

---

## Comandos

### shop

Abre a aba LOJA + INV.

```
> shop

╔══════════════════════════════════════════╗
║        LOJA              INVENTÁRIO       ║
║  SCRAPS: 350           ────────────────   ║
╠══════════════════════════════════════════╣
║ [1] Kit 25scr   │  Kit x3, Gran x2       ║
║ [2] Gran 40scr  │  ────────────────      ║
║ [3] Chip 75scr  │  Equip: [1]Chip [2]-    ║
║ [4] Drive200scr │  ────────────────      ║
╠══════════════════════════════════════════╣
║ USE: buy [num]    │  USE: use [item]     ║
╚══════════════════════════════════════════╝
```

### buy [numero]

Compra um item.

```
> buy 1

╔══════════════════════════════════════╗
║ COMPRANDO...                      ║
║ Item: Kit Médico                   ║
║ Custo: 25 scraps                  ║
║ ✓ Comprado!                       ║
║ Kit x3 → Kit x4                    ║
╚══════════════════════════════════════╝
```

### sell [item]

Vende um item.

```
> sell kit_medico

╔══════════════════════════════════════╗
║ VENDENDO...                       ║
║ Item: Kit Médico                   ║
║ Preço: 12 scraps                  ║
║ ✓ Vendido!                       ║
╚══════════════════════════════════════╝
```

### use [item]

Usa um item consumível.

```
> use kit_medico

╔══════════════════════════════════════╗
║ USANDO...                         ║
║ Kit Médico                         ║
║ HP: 70 → 100                       ║
║ ✓ Restaurado!                     ║
╚══════════════════════════════════════╝
```

### equip [slot] [item]

Equipa um item.

```
> equip 1 chip_potencia

╔══════════════════════════════════════╗
║ EQUIPANDO...                      ║
║ Slot: 1                            ║
║ Item: Chip de Potência I          ║
║ Potência +5                        ║
║ ✓ Equipado!                       ║
╚══════════════════════════════════════╝
```

---

## Layout Adaptativo

Se o espaço ficar apertado:

### Opção 1: Tabs Internas

```
┌─────────────────────────┐
│  [LOJA] [INVENTÁRIO]    │  ← Sub-tabs
│  ════════════════════  │
│                         │
│  LOJA SELECIONADA       │
│  ...                    │
└─────────────────────────┘
```

### Opção 2: Scroll Vertical

```
┌─────────────────────────┐
│  LOJA                   │
│  SCRAPS: 350           │
│  ════════════════════  │
│  [1] Kit 25scr         │
│  [2] Gran 40scr        │
│  [3] Chip 75scr         │
│  ...scroll...           │
│  ────────────────────   │
│  ▼ INVENTÁRIO           │  ← Collapsible
│    Kit x3, Gran x2     │
└─────────────────────────┘
```

---

## Pixel Art (Inventário)

Os itens terão pixel artsミニaturas:
- Kit Médico: Seringa
- Granada: Granada
- Chip: Circuito
- Drive: Disquete/CD

---

## Links

- [[04_shop|Loja]]
- [[task_008_inventario|Inventário]]