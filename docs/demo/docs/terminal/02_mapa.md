# Mapa

Esta página documenta o sistema de mapa da base e setores.

---

## Visão Geral

O **Mapa** mostra a localização do jogador e os setores disponíveis da Base Delta-7.

---

## Setores

| Setor | Status | Descrição |
|-------|--------|----------|
| **Base Central** | Livre | Área segura, ponto de partida |
| **Torre de Comando** | Livre | Onde fica o Comandante Reyes |
| **Arena de Treino** | Livre | Treinamento com Sgt. Chen |
| **Laboratório** | Livre | Dr. Vasquez e pesquisas |
| **Perímetro Leste** | Disponível | eletrotrions aparecen |
| **Setor Norte** | Bloqueado | Requer missão 2+ |
| **Setor Sul** | Disponível | Recursos |

---

## Interface do Mapa

```
╔══════════════════════════════════════╗
║            MAPA - BASE DELTA-7      ║
╠══════════════════════════════════════╣
║                                     ║
║   [NORTE] ████ BLOQUEADO ███     ║
║                                     ║
║ ████  ████  ████              ║
║ █BASE█ █TORRE█ █ARENA█           ║
║ █(1)█  █(2)█  █(3)█              ║
║ ████  ████  ████              ║
║                                     ║
║        [LAB]                       ║
║        (V)                        ║
║                                     ║
║ ████  ████  ████              ║
║ █PER█ █SUL┃ ██RES█              ║
║ █(4)█  █(5)█  █(6)█              ║
║                                     ║
╠══════════════════════════════════════╣
║ LEGENDA:                          ║
║ █ (1) Livre                        ║
║ ▓ (2) Disponível                 ║
║ ░ (3) Bloqueado                   ║
║ ████setor                       ║
╠══════════════════════════════════════╣
║ VOCÊ ESTÁ EM: Base Central        ║
╚══════════════════════════════════════╝
```

---

## Comandos

### mapa

Abre o mapa visual.

```
> mapa

[MAPA - BASE DELTA-7]

Você está em: Base Central
Setores desbloqueados: Base Central, Torre de Comando
Setores disponíveis: Arena, Laboratório, Perímetro Leste
```

### ir [setor]

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

---

## setores Disponíveis

| Comando | Setor |
|---------|-------|
| `ir base` | Base Central |
| `ir torre` | Torre de Comando |
| `ir arena` | Arena de Treino |
| `ir lab` | Laboratório |
| `ir perimetro` | Perímetro Leste |
| `ir norte` | Setor Norte (bloqueado) |
| `ir sul` | Setor Sul |

---

## Integração

- **Combate**: Inimigos aparecem em setores específicos
- **Missões**: Objetivos em diferentes áreas
- **Chat**: NPCs emlocalizações fixas

---

## Notas

- Setores bloqueados requerem missões específicas
- Alguns setores só funcionam com veículos
- O mapa atualiza com progresso da história

---

## Links

- [[02_terminal|Terminal]]
- [[03_combate|Combate]]