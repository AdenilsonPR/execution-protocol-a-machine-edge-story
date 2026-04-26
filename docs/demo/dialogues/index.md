# Diálogos da Demo

Este arquivo serve como índice e mapa de fluxo dos diálogos.

---

## Estrutura de Arquivos

Cada diálogo é um arquivo `.md` separado, com links internos para as próximas falas.

---

## Fluxo Principal

```
01_00_boot
    ↓
03_01_reyes_boasvindas
    ├─ [1] → 03_02_reyes_tutorial
    ├─ [2] → MENU (loop)
    └─ [3] → MENU (loop)
    ↓
03_02_reyes_tutorial
    ├─ [1] → MENU (loop)
    ├─ [2] → MENU (loop)
    ├─ [3] → MENU (loop)
    └─ [4] → 03_03_missao1_reyes
    ↓
03_03_missao1_reyes (BRIEFING)
    ├─ [1] → 03_04_chen_combate (vai direto)
    └─ [2] → 03_04_chen_combate (falar com Chen)
    ↓
03_04_chen_combate
    ├─ [1] → MENU (loop)
    ├─ [2] → MENU (loop)
    └─ [3] → 03_05_missao1_inicio
    ↓
03_05_missao1_inicio (COMBATE)
    ↓
03_06_missao1_conclusao
    ├─ [1] → 03_07_missao2_reyes
    ├─ [2] → MENU (loop)
    ├─ [3] → MENU (loop)
    └─ [4] → SAIR
    ↓
03_07_missao2_reyes (BRIEFING)
    ├─ [1] → 03_09_missao2_inicio
    ├─ [2] → 03_08_missao2_vasquez
    └─ [3] → MENU (loop)
    ↓
03_08_missao2_vasquez
    ├─ [1] → MENU (loop)
    ├─ [2] → MENU (loop)
    └─ [3] → 03_09_missao2_inicio
    ↓
03_09_missao2_inicio (COMBATE + DROP)
    ↓
03_10_missao2_conclusao
    ├─ [1] → MENU (loop) - Sobre o dispositivo
    ├─ [2] → [SEM DRIVE] → loja → MENU
    │       → [COM DRIVE] → descriptografia → 03_11_fim_demo
    ├─ [3] → MENU (loop) - O que espera encontrar?
    └─ [4] → SAIR
    ↓
03_11_fim_demo
    ├─ [1] → LOOP (farming)
    └─ [2] → FIM
```

---

## NPCs

| NPC | Arquivo(s) | Tipo |
|-----|-----------|------|
| SISTEMA | `01_00_boot` | Automático |
| REYES | `03_01`, `03_02`, `03_03`, `03_06`, `03_07` | Comandante |
| CHEN | `03_04` | Veterano |
| VASQUEZ | `03_08`, `03_10` | Pesquisadora |
| NARRADOR | `03_05`, `03_09`, `03_11` | Sistema |

---

## Lista de Arquivos

| # | Arquivo | NPC | Momento |
|---|---------|-----|---------|
| 1 | [[01_00_boot]] | SISTEMA | Tutorial - Boot |
| 2 | [[03_01_reyes_boasvindas]] | REYES | Tutorial - Boas-vindas |
| 3 | [[03_02_reyes_tutorial]] | REYES | Tutorial - Comandos |
| 4 | [[03_03_missao1_reyes]] | REYES | Missão 1 - Briefing |
| 5 | [[03_04_chen_combate]] | CHEN | Missão 1 - Tutorial Combate |
| 6 | [[03_05_missao1_inicio]] | NARRADOR | Missão 1 - Combate |
| 7 | [[03_06_missao1_conclusao]] | REYES | Missão 1 - Relatório |
| 8 | [[03_07_missao2_reyes]] | REYES | Missão 2 - Briefing |
| 9 | [[03_08_missao2_vasquez]] | VASQUEZ | Missão 2 - Primeiro Encontro |
| 10 | [[03_09_missao2_inicio]] | NARRADOR | Missão 2 - Combate + Drop |
| 11 | [[03_10_missao2_conclusao]] | VASQUEZ | Missão 2 - Relatório + Chave |
| 12 | [[03_11_fim_demo]] | NARRADOR | Fim da Demo |

---

## Pontos de Decisão

| Momento | Decisão | Impacto |
|--------|---------|---------|
| Boas-vindas | Falar sobre status vs missões | Flavor apenas |
| Tutorial | Explorar comandos vs pular | Flavor apenas |
| Missão 1 | Ir direto vs falar com Chen | Dicas de combate |
| Missão 2 | Ir direto vs falar com Vasquez | Pistas + lore |
| Relatório M2 | Tem drive? | Acesso ao dispositivo |
| Fim | Continuar vs menu | Loop vs sair |

---

## Fluxo do Dispositivo

```
MISSAO 2 COMPLETA
    ↓
FALA COM VASQUEZ
    ├─ [1] Sobre o dispositivo → lore
    ├─ [2] Analisar
    │   ├─ SEM módulo → vai para LOJA (200 scraps)
    │   │   → volta para VASQUEZ
    │   │   → tenta novamente
    │   └─ COM módulo → descriptografa 87%
    ├─ [3] O que espera encontrar → flavor
    └─ [4] Sair
    ↓
FIM DA DEMO
```

---

## Links Rápidos

- [[01_00_boot|Iniciar Demo]]
- [[03_01_reyes_boasvindas|Primeiro Contato]]
- [[03_05_missao1_inicio|Combate Tutorial]]
- [[03_09_missao2_inicio|Combate Missão 2]]
- [[03_11_fim_demo|Fim da Demo]]