# Sistema de Combate

Esta página documenta o sistema de combate ATB da demo.

## Visão Geral

O combate usa **ATB (Active Time Battle)**. Todas as barras de tempo enchem simultaneamente. Quando a sua barra encher, você escolhe uma ação usando **setas + Enter**.

### Estrutura de Combate

```
┌─────────────────────────────────────────────┐
│ COMBATE - Tempo: 00:45                      │
├─────────────────────────────────────────────┤
│                                             │
│  INIMIGOS:                                  │
│  [1] Perseguidor  [████████░░░] 80%        │
│  [2] Atirador     [███████░░░░] 60%        │
│                                             │
│  ╔═══════════════════════════════════════╗  │
│  ║  SUA VEZ! Escolha uma ação:          ║  │
│  ╠═══════════════════════════════════════╣  │
│  ║  > ATACAR                            ║  │ ← Seleção atual
│  ║    DEFENDER                          ║  │
│  ║    USAR ITEM                         ║  │
│  ║    FUGIR                             ║  │
│  ╚═══════════════════════════════════════╝  │
│                                             │
│  [↑/↓] navegar   [ENTER] selecionar        │
├─────────────────────────────────────────────┤
│ SEU STATUS: HP 85/100 | ENERGIA 80/100     │
└─────────────────────────────────────────────┘
```

### Menu de Combate

| Opção | Função |
|-------|--------|
| ATACAR | Ataca o inimigo selecionado |
| DEFENDER | Reduz dano recebido em 50% |
| USAR ITEM | Abre submenu de itens |
| FUGIR | Tenta escapar do combate |

### Controles

| Tecla | Função |
|-------|--------|
| ↑ | Selecionar opção anterior |
| ↓ | Selecionar próxima opção |
| Enter | Confirmar seleção |
| Escape | Cancelar / Voltar |

### Sistema de Tempo

| Velocidade | Tempo para agir |
|------------|-----------------|
| Muito Rápida | 2 segundos |
| Rápida | 3 segundos |
| Normal | 4 segundos |
| Lenta | 6 segundos |
| Muito Lenta | 8 segundos |

**Velocidade base**: 4 segundos

**Modificadores**:
- Atributo Manobra aumenta velocidade
- Defender não afeta velocidade
┌──────────────────────────────────────────┐
║ COMBATE - Turno #N                        ║
├──────────────────────────────────────────┤
║ INIMIGOS ATIVOS:                      ║
║   [1] Perseguidor     ████████░░  45/60║
║   [2] Perseguidor     ██████████  55/55║
║   [3] Atirador        ████░░░░░░░  30/80║
├──────────────────────────────────────────┤
║ SEU STATUS:                          ║
║   HP:  85/100  ENERGIA: 80/100      ║
║   ESCUDO: 45/80                     ║
├──────────────────────────────────────────┤
║ AÇÕES:                              ║
║   > attack                          ║
║   > defend                         ║
║   > use [item]                    ║
║   > escape                         ║
╚──────────────────────────────────────────┘
```

---

## Tipos de Inimigos

### Perseguidor

Inimigo básico que persegue e causa dano por contato.

| Atributo | Valor |
|---------|-------|
| HP | 50-60 |
| Dano | 10-15 |
| Velocidade ATB | 3s (Rápida) |
| Comportamento | Move-se até alcance e ataca |

**Recompensa**: 15-20 scraps

---

### Atirador

Inimigo que para à distância e atira projéteis.

| Atributo | Valor |
|---------|-------|
| HP | 30-40 |
| Dano | 15-20 |
| Velocidade ATB | 4s (Normal) |
| Alcance | Longo |
| Comportamento | Mantém distância, atira |

**Recompensa**: 25-30 scraps

---

### Atirador de Granada

Inimigo que causa dano em área.

| Atributo | Valor |
|---------|-------|
| HP | 40-50 |
| Dano | 25-35 |
| Velocidade ATB | 6s (Lenta) |
| Comportamento | Granada área |
| Aviso | Mostra área de impacto |

**Recompensa**: 35-45 scraps

---

### Gerador

Inimigo que spawna pequenos seguidores.

| Atributo | Valor |
|---------|-------|
| HP | 60-70 |
| Velocidade ATB | 8s (Muito Lenta) |
| Spawna | Perseguidor (a cada 3 ATBs) |
| Comportamento | Foge enquanto Spawna |

**Recompensa**: 40-50 scraps

---

### Explodidor

Inimigo suicida que explode ao atingir proximidade.

| Atributo | Valor |
|---------|-------|
| HP | 30-40 |
| Dano | 40-50 |
| Velocidade ATB | 2s (Muito Rápida) |
| Auto-destroy | Sim (morre após explosão) |
| Comportamento | Corre em direção ao player |

**Recompensa**: 0 scraps (não dar por segurança)

---

## Fórmulas de Dano

### Dano de Ataque

```
dano = (potencia * multiplicador_arma) + variacao
variacao = randf_range(0.85, 1.15)  // ±15%
```

### Dano Crítico

```
if (roll() < precisao / 100):
    dano *= 1.5
    msg += "CRÍTICO!"
```

### Redução por Defesa

```
if (defendendo):
    dano_recebido = dano * 0.5
```

### Dano Contra Escudo

```
if (escudo > 0):
    dano_escudo = min(dano, escudo)
    escudo -= dano_escudo
    dano -= dano_escudo
```

---

## Resistências e Fraquezas

| Arma | Perseguidor | Atirador | Granada | Gerador |
|------|-------------|----------|---------|--------|
| Pistola | 100% | 100% | 75% | 100% |
| Shotgun | 125% | 75% | 100% | 125% |
| Rifle | 75% | 150% | 75% | 75% |
| SMG | 125% | 100% | 75% | 100% |
| Granada | 100% | 75% | 150% | 125% |

---

## Sistema de Energia

Cada ação consome energia:

| Ação | Custo |
|------|-------|
| attack | 10-20 |
| defend | 5 |
| usar Granada | 15 |
| usar Kit | 10 |

**Recuperação**: 5 por ação

---

## Recompensas

### Tabela de Scraps

| Inimigo | Mínimo | Máximo |
|--------|--------|--------|
| Perseguidor | 15 | 20 |
| Atirador | 25 | 30 |
| Granada | 35 | 45 |
| Gerador | 40 | 50 |
| Elite | 100 | 150 |

### Bônus de Vitória

|tempo|Vitória|Bônus|
|-----|-------|-----|
| <30s | Vitória relampago | +100% |
| 30-60s | Vitória normal | +50% |
| 60-90s | Vitória normal | +25% |
| >90s | Vitória normal | +0% |
| 0 hits recebidos | Vitória perfeita | +100% |

---

## Fluxo de Combate (ATB)

```
INICIAR COMBATE
    ├─ Spawn de inimigos
    ├─ Inicializar barras de tempo (100%)
    └─ Barras começam aencher

LOOP (parallel)
    ├─ Todas as barras enchendo simultaneamente
    │
    ├─ SE barra jogador cheia
    │   └─ Pausa! Jogador escolhe ação
    │
    ├─ SE barra inimigo cheia
    │   └─ Inimigo executa ação IMEDIATAMENTE
    │
    └─ Se jogador demorar, inimigo ataca!

FIM COMBATE
    ├─ Mostra rewards
    ├─ Atualiza missões
    └─ Retorna ao terminal
```

---

## Sistema de Turno Automático

### O que acontece se o jogador não fizer nada?

```
[1] Perseguidor está pronto!
>
[2] Perseguidor ataca!
> PERSEGUIDOR: Investida!
> -15 HP

[3] Sua vez em 3...
> 
[4] Atirador está pronto!
> ATIRADOR: Fogo!
> -20 HP
```

**Você tem 4 segundos por turno!**

### Indicadores de Urgência

| Indicador | Significado |
|-----------|-------------|
| Barra piscando | Próximo a agir |
| Nome em vermelho | Atacando agora |
| "SUA VEZ" | Tempo disponível |

---

### O que acontece se o jogador não fizer nada?

```
[1] Perseguidor esta pronto!
>
[2] Perseguidor ataca!
> PERSEGUIDOR: Investida!
> -15 HP

[3] Sua vez em 3...
> 
[4] Atirador esta pronto!
> ATIRADOR: Fogo!
> -20 HP
```

**Voce tem 4 segundos por turno!**

---

## Velocidade por Inimigo

---

## Condições Especiais

### Chance de Fuga

```
fuga_sucesso = 50% + (manobra * 0.5)%
```

- Falha: turno perdido
- Sucesso: combate terminado

### Encontras Especial

5% de chance de drop especial ao derrotar qualquer inimigo.

Itens dropáveis:
- Kit Médico (15%)
- Chip Aleatório (5%)
- scrap Bônus (30%)
- Nada (50%)

---

## Integração com Sistema de Missões

Ver [[01_narrativa]] para misses específicas da demo.

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[04_shop]] — Loja e inventory
- [[05_chat]] — NPCs
- [[06_decryption]] — Quebra-cabeça
- [[07_save]] — Save/Load
- [[08_implementacao]] — Implementação