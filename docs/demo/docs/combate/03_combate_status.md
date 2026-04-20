# Combaste - Status

Esta página documenta a aba de status do combate no menu lateral.

---

## Visão Geral

A aba **Combate** exibe o status atual do combate em andamento, permitindo monitorar:
- Inimigos restantes
- HP dos inimigos
- Turno atual
- Barra de tempo ATB

---

## Interface

```
╔══════════════════════════════════════╗
║         COMBATE EM ANDAMENTO         ║
╠══════════════════════════════════════╣
║ SUA VEZ                            ║
║ ████████████░░░░░░░░░  45%        ║
╠══════════════════════════════════════╣
║ INIMIGOS:                         ║
║ [1] Perseguidor  ████████░░  40/50 ║
║ [2] Perseguidor  ████████░░  40/50 ║
║ [3] Atirador    ██████░░░░  24/40 ║
╠══════════════════════════════════════╣
║ TURNO: 3                           ║
║ DANO CAUSADO: 65                   ║
║ DANO RECEBIDO: 30                  ║
╠══════════════════════════════════════╣
║ [↑/↓] Selecionar   [ENTER] Açao    ║
╚══════════════════════════════════════╝
```

---

## Durante Combate

Quando o combate está ativo:
- Barra de tempo ATB atualiza em tempo real
- HP dos inimigos diminui quando atinge 0
- Inimigos derrotados são marcados
- Turno atual é destacado

### Barra de Tempo ATB

```
JOGADOR:  ████████████████████░░░░  85%
INIMIGO 1: ██████░░░░░░░░░░░░░░░░  25%
INIMIGO 2: ████████░░░░░░░░░░░░░░  40%
INIMIGO 3: ████████████████░░░░░░  70%
```

---

## Fora de Combate

Quando não há combate ativo:

```
╔══════════════════════════════════════╗
║           COMBATE                   ║
╠══════════════════════════════════════╣
║                                 ║
║     Nenhum combate em andamento  ║
║                                 ║
║     Derrote inimigos para earn    ║
║     scraps e experiencia!         ║
║                                 ║
╚══════════════════════════════════════╝
```

---

## Comandos de Combate

### atacar [numero]

Ataca um inimigo específico.

```
> atacar 1

╔══════════════════════════════════════╗
║ ATACANDO...                        ║
║ Alvo: Perseguidor                  ║
║ Dano: 18                          ║
║ ████████████████░░░░  32/50       ║
╚══════════════════════════════════════╝
```

### defender

Aumenta defesa e recupera HP.

```
> defender

╔══════════════════════════════════════╗
║ DEFENDENDO...                     ║
║ Escudo +20                        ║
║ HP +10                            ║
╚══════════════════════════════════════╝
```

### fugir

Tenta fugir do combate.

```
> fugir

╔══════════════════════════════════════╗
║ TENTANDO FUGIR...                 ║
║ Chance: 50%                       ║
║ [████░░░░░░] FALHOU              ║
║ Continuando combate...             ║
╚══════════════════════════════════════╝
```

### usar [item]

Usa um item do inventário.

```
> usar kit_medico

╔══════════════════════════════════════╗
║ USANDO KIT MEDICO...               ║
║ HP restaurado: 30                  ║
║ HP: 70 → 100                       ║
╚══════════════════════════════════════╝
```

---

## Integração

- [[task_006_combate|Sistema de Combate]]
- [[task_008_inventario|Inventário]]

---

## Notas

- A aba de combate é ativada automaticamente quando o combate inicia
- Retorna ao menu normal quando o combate termina
- Atalhos de teclado disponíveis durante combate
- Barra de tempo indica quem vai agir próximo

---

## Links

- [[03_combate|Combate]]
- [[04_shop|Loja]]