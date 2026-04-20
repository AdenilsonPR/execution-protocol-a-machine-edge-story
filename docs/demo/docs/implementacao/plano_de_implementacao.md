# Plano de Implementação - Execution Protocol Demo

Este documento detalha o plano de implementação da demo do jogo Execution Protocol: A Machine's Edge Story.

---

## Visão Geral

A demo utiliza o engine **Godot 4.x** com o stack de plugins **Omni-System** (OmniTerm, OmniChat, OmniNarrative, OmniSave).

---

## Estrutura de Pastas

```
res://
├── addons/
│   └── omni_*/              # Plugins já instalados
├── src/
│   ├── autoloads/           # GameManager, BattleManager, etc
│   ├── commands/            # Comandos do terminal
│   ├── combat/              # Sistema de combate ATB
│   ├── inventory/           # Sistema de inventário
│   ├── missions/           # Sistema de missões
│   └── narrative/          # Scripts JSON (OmniNarrative)
├── scenes/
│   ├── main.tscn           # Cena principal
│   ├── terminal.tscn       # Terminal
│   ├── chat_panel.tscn     # Painel de chat lateral
│   └── combat_menu.tscn     # Menu de combate
├── assets/
│   ├── fonts/              # VT323 (já configurado)
│   └── color_palettes/     # (já configurado)
└── dialogues/
    └── *.dialogue          # Recursos de diálogo
```

---

## Fase 1: Estrutura Base

### 1.1 Autoloads

| Arquivo | Função |
|---------|--------|
| `game_manager.gd` | Estado global,/scene transitions |
| `battle_manager.gd` | Sistema de combate ATB |
| `inventory_manager.gd` | Inventário, scraps, items |
| `mission_manager.gd` | Progresso de missões |
| `narrative_manager.gd` | Integração OmniNarrative |

### 1.2 Estrutura de Tags

```
class_name GameManager extends Node

signal game_started
signal game_saved(slot: String)
signal game_loaded(slot: String)
signal combat_started(enemies: Array)
signal combat_ended(victory: bool)
```

---

## Fase 2: Sistema de Terminal

### 2.1 Comandos

| Comando | Função |
|---------|--------|
| `help` | Lista comandos |
| `status` | Status do jogador |
| `clear` | Limpa terminal |
| `mission` | Missão atual |
| `missions` | Lista missões |
| `shop` | Abre loja |
| `chat [npc]` | Abre chat com NPC |
| `save [slot]` | Salva jogo |
| `load [slot]` | Carrega jogo |

### 2.2 Estrutura de Comando

```gdscript
class_name CommandBase extends RefCounted
```

### 2.3 Layout

```
┌─────────────────────────────────────────────┐
│ TERMINAL (70%)                              │
│ > help                                       │
│                                              │
├──────────────┬──────────────────────────────┤
│ CHAT (30%)   │                              │
│ [Reyes] ●   │   (vazio)                    │
│ [Chen]      │                              │
│ [Vasquez]   │                              │
└──────────────┴──────────────────────────────┘
```

---

## Fase 3: Sistema de Chat

### 3.1 Painel Lateral

- Sempre visível no canto inferior esquerdo
- Atualiza em tempo real
- Indicador ● para novas mensagens

### 3.2 NPCs

| NPC | ID | Função |
|-----|-----|--------|
| Comandante Reyes | `reyes` | Missões |
| Sgt. Chen | `chen` | Treinamento |
| Dr. Vasquez | `vasquez` | Pesquisa/lore |

### 3.3 Integração OmniChat

- ChatDialogue resources para cada NPC
- Sistema de escolhas via setas

---

## Fase 4: Sistema de Combate ATB

### 4.1 Menu Visual

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

### 4.2 Controles

| Tecla | Função |
|-------|--------|
| ↑ | Selecionar anterior |
| ↓ | Selecionar próxima |
| Enter | Confirmar |
| Escape | Cancelar |

### 4.3 Barras de Tempo

| Velocidade | Tempo para agir |
|------------|-----------------|
| Muito Rápida | 2s |
| Rápida | 3s |
| Normal | 4s |
| Lenta | 6s |
| Muito Lenta | 8s |

### 4.4 Inimigos

| Tipo | HP | Dano | Velocidade |
|------|-----|------|------------|
| Perseguidor | 50-60 | 10-15 | 3s |
| Atirador | 30-40 | 15-20 | 4s |
| Granada | 40-50 | 25-35 | 6s |
| Gerador | 60-70 | - | 8s |
| Explodidor | 30-40 | 40-50 | 2s |

### 4.5 Recompensas

| Inimigo | Scraps |
|---------|--------|
| Perseguidor | 15-20 |
| Atirador | 25-30 |
| Granada | 35-45 |
| Gerador | 40-50 |
| Explodidor | 0 |

---

## Fase 5: Sistema de Jogo

### 5.1 Missões

| # | Nome | Objetivo | Inimigos | Recompensa |
|---|------|----------|----------|------------|
| 1 | Conexão Inicial | Tutorial | Nenhum | 25 scraps |
| 2 | Varredura Perimetral | Verificar perímetro | 3x Perseguidor | 50 scraps |
| 3 | Atividade Anômala | Investigar setor norte | 5x Perseguidor + 1x Atirador | 100 scraps + Dispositivo |

### 5.2 Inventário

| Item | Tipo | Preço |
|------|------|-------|
| Kit Médico | Consumível | 25 |
| Granada | Consumível | 40 |
| Drive de Leitura | Especial | 200 |
| Chip (I-V) | Equipamento | 75 |

### 5.3 Scraps

Moeda do jogo. Obtida ao derrotar inimigos.

---

## Fase 6: Conteúdo Narrativo

### 6.1 Estrutura de Diálogos

```
docs/demo/dialogues/
├── 01_00_boot.md           # Boot do sistema
├── 03_01_reyes_*.md       # Reyes tutorial
├── 03_04_chen_*.md        # Chen combate
├── 03_08_vasquez_*.md     # Vasquez encontro
├── 03_10_vasquez_*.md     # Vasquez dispositivo
└── 03_11_fim_*.md         # Fim da demo
```

### 6.2 Fluxo Narrativo

```
01_00_boot
    ↓
03_01_reyes_boasvindas
    ↓
03_02_reyes_tutorial
    ↓
03_03_missao1_reyes
    ↓
03_04_chen_combate (opcional)
    ↓
03_05_missao1_inicio (COMBATE)
    ↓
03_06_missao1_conclusao
    ↓
03_07_missao2_reyes
    ↓
03_08_vasquez (opcional)
    ↓
03_09_missao2_inicio (COMBATE + DROP)
    ↓
03_10_vasquez_dispositivo
    ├─ [2] Analisar (SEM drive) → LOJA → volta
    └─ [2] Analisar (COM drive) → 87%
    ↓
03_11_fim_demo
```

### 6.3 Dispositivo

- Dropado ao completar Missão 2
- Drive de Leitura comprado na loja (200 scraps)
- Voltar à Vasquez para analisar
- Resultado: 87% descriptografado
- Fragmento 8 corrompido

---

## Fase 7: Implementação do Fluxo do Dispositivo

### 7.1 Check de Inventário

```gdscript
func _on_analisar_pressed():
    if inventory.has("drive_leitura"):
        _start_decryption_sequence()
    else:
        _show_need_drive_message()
```

### 7.2 Sequência de Descriptografia

```
Vasquez: "Voce tem um drive!"
Vasquez: "Conectando..."
[████████░░░░░░░░░░] 0%

Vasquez: "Consegui acessar!"
[████████████████░░░] 87%

Fragmento 1-7: OK
Fragmento 8: [ERRO]

Vasquez: "...87% dos dados."
Vasquez: "O ultimo fragmento esta corrompido."
```

---

## Checklist de Implementação

### Autoloads
- [ ] GameManager
- [ ] BattleManager
- [ ] InventoryManager
- [ ] MissionManager
- [ ] NarrativeManager

### Terminal
- [ ] Comandos básicos (help, status, clear)
- [ ] Comandos de sistema (shop, chat, save, load)
- [ ] Layout terminal + chat panel

### Chat
- [ ] Painel lateral
- [ ] NPCs (Reyes, Chen, Vasquez)
- [ ] Mensagens em tempo real
- [ ] Menu com setas

### Combate
- [ ] Sistema ATB
- [ ] Menu visual (↑↓ + ENTER)
- [ ] Barras de tempo
- [ ] Classes de inimigos
- [ ] Sistema de recompensa

### Jogo
- [ ] Missões (3)
- [ ] Inventário
- [ ] Loja
- [ ] Scraps

### Narrativa
- [ ] Scripts JSON (OmniNarrative)
- [ ] Diálogos
- [ ] Dispositivo
- [ ] Fluxo completo

---

## Ordem Sugerida

```
1. Autoloads + Estrutura
   ↓
2. Terminal (comandos básicos)
   ↓
3. Chat (painel + NPCs)
   ↓
4. Combate ATB
   ↓
5. Missões + Inventário + Loja
   ↓
6. Narrativa + Dispositivo
   ↓
7. Testes
```

---

## Referências

- [[00_quickstart|Quick Start da Demo]]
- [[01_narrativa|Narrativa da Demo]]
- [[02_terminal|Comandos do Terminal]]
- [[03_combate|Sistema de Combate]]
- [[05_chat|Sistema de Chat]]
- [[../style guide|Guia de Estilo GDScript]]