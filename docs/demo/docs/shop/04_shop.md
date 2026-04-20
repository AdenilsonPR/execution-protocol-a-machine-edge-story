# Loja e Inventory

Esta página documenta o sistema de compras e inventario.

## Acessando a Loja

```
> shop
```

Ou dentro do terminal principal:
- Digite `shop` para abrir o menu
- Digite `exit` para sair

---

## Interface da Loja

```
╔══════════════════════════════════════╗
║         LOJA - BASE DELTA-7          ║
╠══════════════════════════════════════╣
║ SCRAPS:     350                      ║
╠══════════════════════════════════════╣
║ CONSUMÍVEIS:                        ║
║   [1] Kit Médico         25 scraps ║
║   [2] Granada Fragment.  40 scraps║
║   [3] Granada Fumaça     35 scraps║
║   [4] Granada Gás        45 scraps║
╠══════════════════════════════════════╣
║ EQUIPAMENTOS:                       ║
║   [5] Chip de Potência I  75 scraps║
║   [6] Chip de Precisão I  75 scraps║
║   [7] Chip de Núcleo I   75 scraps║
║   [8] Chip de Manobra I   75 scraps║
║   [9] Chip de Densidade I 75 scraps║
╠══════════════════════════════════════╣
║ ESPECIAIS:                          ║
║   [D] Drive de Criptografia       ║
║       200 scraps                   ║
╠══════════════════════════════════════╣
║ UPGRADES:                           ║
║   [U] Upgrade de Atributo         150 scraps║
╠══════════════════════════════════════╣
║ USE: buy [numero]                   ║
║      sell [numero]                  ║
║ EXIT: exit                          ║

╚══════════════════════════════════════╝
```

---

## Itens Consumíveis

### Kit Médico

| Atributo | Valor |
|---------|-------|
| Preço | 25 scraps |
| Efeito | +50 HP |
| Uso | Combate / Fora |
| Stack | Sim (máx 10) |

```
> buy 1

[+] Kit Médico adicionado ao inventário
[-] 25 scraps
```

---

### Granada Fragmentação

| Atributo | Valor |
|---------|-------|
| Preço | 40 scraps |
| Efeito | 30-40 dano área |
| Uso | Apenas combate |
| Stack | Sim (máx 5) |

**Uso no combate**:
```
> use granada_fragmentacao

> USAR GRANADA FRAGMENTAÇÃO:
[+] Granada lançada!
[+] Dano: 35
[+] Granada Fragmentação x1 usado
```

---

### Granada de Fumaça

| Atributo | Valor |
|---------|-------|
| Preço | 35 scraps |
| Efeito | Inimigos perdem alvo por 2 turnos |
| Uso | Apenas combate |
| Stack | Sim (máx 3) |

---

### Granada de Gás

| Atributo | Valor |
|---------|-------|
| Preço | 45 scraps |
| Efeito | 15 dano + 50% chance de silêncio |
| Uso | Apenas combate |
| Stack | Sim (máx 3) |

---

## Chips de Atributos

### Tipos de Chips

| Chip | Atributo | Bônus | Preço |
|------|----------|-------|-------|
| Chip de Potência I | Potência | +5 | 75 |
| Chip de Precisão I | Precisão | +5 | 75 |
| Chip de Núcleo I | Núcleo | +5 | 75 |
| Chip de Manobra I | Manobra | +5 | 75 |
| Chip de Densidade I | Densidade | +5 | 75 |

### Sistema de Fusão

Dois chips do mesmo tipo e nível podem ser fusionados:

```
FUSÃO:
  [Chip Potência I] + [Chip Potência I]
  =
  [Chip Potência II]

Nível Máximo: V
```

### Efeitos por Nível

| Nível | Bônus | Chance Upgrade |
|-------|-------|----------------|
| I | +5 | 100% |
| II | +12 | 80% |
| III | +20 | 60% |
| IV | +30 | 40% |
| V | +45 | — |

---

## Drive de Criptografia

**Item especial** necessário para abrir o [[06_decryption|Dispositivo Criptografado]].

| Atributo | Valor |
|---------|-------|
| Preço | 200 scraps |
| Uso | Uma vez |
| Requer | Dispositivo Criptografado no inventário |

```
> buy d

[+] Drive de Criptografia adquirido
[+] Use 'use drive_criptografia' no inventário
```

---

## Upgrade de Atributos

Aprimora diretamente um atributo base.

| Atributo | Custo Base | Multiplicador |
|----------|-------------|---------------|
| Potência | 150 | x1.5 por nível |
| Precisão | 150 | x1.5 por nível |
| Núcleo | 150 | x1.5 por nível |
| Manobra | 150 | x1.5 por nível |
| Densidade | 150 | x1.5 por nível |

**Tabela de Preços**:

| Nível | Preço |
|-------|-------|
| 1→2 | 150 |
| 2→3 | 225 |
| 3→4 | 337 |
| 4→5 | 506 |
| 5→6 | 759 |

---

## Vendendo Itens

```
> sell 1

VENDER: Kit Médico
  Preço: 12 scraps
  Confirmar? (s/n): s

[-] Kit Médico removido
[+] 12 scraps
```

**Preço de venda**: 50% do valor de compra

---

## Inventário

### Visualizando

```
> inventory

╔══════════════════════════════════════╗
║         INVENTÁRIO                    ║
╠══════════════════════════════════════╣
║ EQUIPAMENTOS:                        ║
║   [1] Chip de Potência I            ║
║   [2] Chip de Escudo I              ║
║   [3] --- VAZIO ---                  ║
╠══════════════════════════════════════╣
║ CONSUMÍVEIS:                         ║
║   Kit Médico x2                     ║
║   Granada Fragmentação x3           ║
║   Granada de Fumaça x1             ║
╠══════════════════════════════════════╣
║ ITENS ESPECIAIS:                     ║
║   Dispositivo Criptografado         ║
╚══════════════════════════════════════╝
```

### Usando Itens

```
> use kit_medico

[+] +50 HP restaurado (85 -> 100)
[-] Kit Médico x1
```

### Equipando Chips

```
> equip 1

[+] Chip de Potência I equipped
    Slot 1: Chip de Potência I (+5 Potência)
```

### Desequipando

```
> unequip 1

[-] Chip de Potência I moved to inventory
```

---

## Slots de Equipamento

| Slot | Desbloqueio |
|------|-------------|
| 1 | Início |
| 2 | Nível 10 |
| 3 | Nível 20 |

---

## Moeda: Scraps

Scraps são obtidos através de:
- Derrotar [[03_combate|inimigos]]
- Completar missões
- Vender itens
- Bônus de vitória

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[05_chat]] — NPCs
- [[06_decryption]] — Quebra-cabeça
- [[07_save]] — Save/Load
- [[08_implementacao]] — Implementação