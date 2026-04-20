# Oficina

Esta página documenta o sistema de melhoria de atributos da Oficina.

---

## Visão Geral

A **Oficina** é uma aba no menu lateral onde o jogador pode melhorar seus atributos permanente.

Cada melhoria custa **scraps** e requer **nível** mínimo.

---

## Atributos

| Atributo | Descrição |
|----------|----------|
| **Potência** | Dano causado em ataques |
| **Precisão** | Chance de acerto crítico |
| **Núcleo** | Energia máxima e regeneração |
| **Manobra** | Velocidade no combate |
| **Densidade** | Escudo e resistência |

---

## Tabela de Melhorias

### Potência

| Nível | Custo | Bonus |
|-------|-------|-------|
| 1 → 2 | 100 scraps | +5 |
| 2 → 3 | 150 scraps | +5 |
| 3 → 4 | 200 scraps | +5 |
| 4 → 5 | 300 scraps | +5 |
| 5 → MÁX | 500 scraps | +5 |

### Precisão

| Nível | Custo | Bonus |
|-------|-------|-------|
| 1 → 2 | 100 scraps | +3 |
| 2 → 3 | 150 scraps | +3 |
| 3 → 4 | 200 scraps | +3 |
| 4 → 5 | 300 scraps | +3 |
| 5 → MÁX | 500 scraps | +3 |

### Núcleo

| Nível | Custo | Bonus |
|-------|-------|-------|
| 1 → 2 | 100 scraps | +10 energia máx |
| 2 → 3 | 150 scraps | +10 energia máx |
| 3 → 4 | 200 scraps | +10 energia máx |
| 4 → 5 | 300 scraps | +10 energia máx |
| 5 → MÁX | 500 scraps | +15 energia máx |

### Manobra

| Nível | Custo | Bonus |
|-------|-------|-------|
| 1 → 2 | 100 scraps | -0.5s cooldown |
| 2 → 3 | 150 scraps | -0.5s cooldown |
| 3 → 4 | 200 scraps | -0.5s cooldown |
| 4 → 5 | 300 scraps | -0.5s cooldown |
| 5 → MÁX | 500 scraps | -0.5s cooldown |

### Densidade

| Nível | Custo | Bonus |
|-------|-------|-------|
| 1 → 2 | 100 scraps | +10 escudo máx |
| 2 → 3 | 150 scraps | +10 escudo máx |
| 3 → 4 | 200 scraps | +10 escudo máx |
| 4 → 5 | 300 scraps | +10 escudo máx |
| 5 → MÁX | 500 scraps | +15 escudo máx |

---

## Interface

```
╔══════════════════════════════════════╗
║          OFICINA                 ║
╠══════════════════════════════════════╣
║ SCRAPS:     350                  ║
╠══════════════════════════════════════╣
║ ATRIBUTOS:                      ║
║                               ║
║ Potência   [████████░░] LVL 4  ║
║ [MELHORAR] 200 scr             ║
║                               ║
║ Precisão  [███████░░░] LVL 3  ║
║ [MELHORAR] 150 scr             ║
║                               ║
║ Núcleo   [████████░░] LVL 4  ║
║ [MELHORAR] 200 scr             ║
║                               ║
║ Manobra  [███████░░░] LVL 3  ║
║ [MELHORAR] 150 scr             ║
║                               ║
║ Densidade[████████░░] LVL 4  ║
║ [MELHORAR] 200 scr             ║
╠══════════════════════════════════════╣
║ USE: melhor [atributo]            ║
║ EXIT: exit                    ║
╚══════════════════════════════════════╝
```

---

## Comandos

### melhor [atributo]

Melhora um atributo específico.

```
> melhor potencia

╔══════════════════════════════════════╗
║ MELHORANDO POTÊNCIA...              ║
╠���═════════════════════════════════════╣
║ Custo: 200 scraps                ║
║ Potência: 15 → 20                ║
║ ✓ Melhoria aplicada!              ║
╚══════════════════════════════════════╝
```

### Status dos atributos

```
> atributos

╔══════════════════════════════════════╗
║          ATRIBUTOS                ║
╠══════════════════════════════════════╣
║ Potência:   ████████░░ LVL 4   ║
║ Precisão:  ███████░░░ LVL 3   ║
║ Núcleo:   ████████░░ LVL 4   ║
║ Manobra:   ███████░░░ LVL 3   ║
║ Densidade: ████████░░ LVL 4   ║
╚══════════════════════════════════════╝
```

---

## Integração

A Oficina requer:
- Sistema de inventory (scraps)
- Atributos do jogador
- Registro de melhorias por save

---

## Notas

- Atributos são **permanentes** (salvos com o jogo)
- Custo aumenta a cada nível
- Máximo: Nível 5 (+25 base)
- Alguns equipamentos podem adicionar bônus temporários

---

## Links

- [[04_shop|Loja]]
- [[03_combate|Combate]]