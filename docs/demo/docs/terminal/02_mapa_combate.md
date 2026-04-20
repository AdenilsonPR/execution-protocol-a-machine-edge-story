# MAPA + COMBATE

Esta página documenta a aba de Mapa combinada com o Status do Combate.

---

## Visão Geral

A aba **MAPA + COMBATE** exibe:
- **Mapa** da Base Delta-7 com setores interligados
- **Combate** em andamento (quando ativo)

---

## Mapa (Quadradinhos Interligados)

```
┌─────────────────────────────────────────┐
│            MAPA - BASE DELTA-7          │
│  ════════════════════════════════════════│
│                                         │
│        [N] ████  ████  ████             │
│            BLOQ  TORRE ARENA           │
│             (4)   (2)   (3)             │
│                                         │
│        [C] ��███  ████  ████             │
│            BASE LAB  PERI               │
│             (1)   (V)   (5)             │
│                                         │
│        [S] ████  ████  ████             │
│            RES  BLOQ  BLOQ              │
│             (6)   (7)   (8)             │
│                                         │
│  ───────────────────────────────────────│
│  LEGENDA:                               │
│  █ Setor livre                          │
│  ▒ Setor disponível                     │
│  ░ Setor bloqueado                      │
│                                         │
│  VOCÊ: Base Central [1]                │
└─────────────────────────────────────────┘
```

---

## Combate (quando ativo)

```
┌─────────────────────────────────────────┐
│            COMBATE ATIVO                 │
│  ════════════════════════════════════════│
│                                         │
│  TURNO: VOCÊ                            │
│  ████████░░░░░░░░░░░░░░░░  35%         │
│                                         │
│  ───────────────────────────────────────│
│                                         │
│  INIMIGOS:                              │
│  [1] 👾 Perseguidor  ████░░  40/50     │
│  [2] 👾 Perseguidor  █████░  50/50     │
│  [3] 🎯 Atirador     ███░░░  30/40     │
│                                         │
│  ───────────────────────────────────────│
│  DANO: 65  │  RECEBIDO: 30             │
│                                         │
│  [↑/↓] Selecionar   [ENTER] Atacar     │
└─────────────────────────────────────────┘
```

---

## Estados

### Fora de Combate

```
┌─────────────────────────────────────────┐
│            MAPA - BASE DELTA-7          │
│  ════════════════════════════════════════│
│                                         │
│        [N] ████  ████  ████             │
│            BLOQ  TORRE ARENA           │
│             (4)   (2)   (3)             │
│                                         │
│        [C] ████  ████  ████             │
│            BASE LAB  PERI               │
│             (1)   (V)   (5)             │
│                                         │
│  ───────────────────────────────────────│
│  Setor atual: Base Central             │
│  Use 'ir [local]' para se mover         │
└─────────────────────────────────────────┘
```

### Durante Combate

```
┌─────────────────────────────────────────┐
│            COMBATE ATIVO                 │
│  ════════════════════════════════════════│
│                                         │
│  TURNO: VOCÊ  ████████████░░░░  75%    │
│                                         │
│  INIMIGOS:                              │
│  [1] 👾 Perseguidor  ████░░  40/50     │
│  [2] 👾 Perseguidor  █████░  50/50     │
│  [3] 🎯 Atirador     ███░░░  30/40     │
│                                         │
│  ───────────────────────────────────────│
│  [↑/↓] Selecionar   [ENTER] Atacar     │
└─────────────────────────────────────────┘
```

---

## Comandos

### mapa

Mostra o mapa sem combate.

### ir [local]

Move para um setor (se não estiver em combate).

```
> ir perimetro

╔══════════════════════════════════════╗
║ DESLOCANDO...                    ║
║ DESTINO: Perímetro Leste          ║
║ TEMPO: 0.5s                  ║
║ ✓ Chegou!                   ║
╚══════════════════════════════════════╝
```

Locais: `base`, `torre`, `arena`, `lab`, `perimetro`, `norte`, `sul`

---

## Transição Automática

- Ao **iniciar combate** → muda para aba COMBATE automaticamente
- Ao **terminar combate** → volta para MAPA
- Durante combate → `mapa` mostra COMBATE

---

## Pixel Art (Futuro)

Os setores podem ter pixel artsミニaturas no futuro:
- Base: Ícone de casa/base
- Torre: Ícone de torre
- Arena: Ícone de escudo (treino)
- Lab: Ícone de tubo de ensaio
- Setores de combate: Ícone de inimigo

---

## Links

- [[03_combate|Combate]]
- [[02_mapa|Mapa]]