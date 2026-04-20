# Requisitos de Implementação

Esta página documenta o que precisa ser implementado tecnicamente para a demo.

## Visão Geral

A demo utiliza o stack de plugins **omni-system** já configurado no projeto. Esta página detalha o que está pronto versus o que precisa ser desenvolvido.

---

## Estado Atual dos Plugins

### OmniTerm ✓

**Status**: Configurado e funcionando

**Pronto**:
- Terminal básico
- Comandos help, status, clear
- Autocomplete
- History de comandos
- Typewriter effect

**Precisa implementar**:
- Comandos de jogo (attack, defend, use, shop, etc)
- Sistema de input durante combate
- Integração com BattleManager

---

### OmniChat ✓

**Status**: Parcialmente configurado

**Pronto**:
- Recursos de ChatDialogue
- Sistema de contacts
- Interface básica de chat

**Precisa implementar**:
- NPCs específicos (Reyes, Chen, Vasquez)
- Diálogos da demo
- Sistema de choices
- Lembretes/notificações

---

### OmniNarrative ✓

**Status**: Parcialmente configurado

**Pronto**:
- NarrativeDirector
- Estrutura de nós JSON

**Precisa implementar**:
- Scripts narrativos da demo
- Variáveis de jogo
- Triggers de comando
- Integração com terminal

---

### OmniSave ✓

**Status**: Configurado

**Pronto**:
- Sistema de save/load
- Estrutura de dados

**Precisa implementar**:
- Configuração de slots
- Auto-save triggers
- Validação de saves

---

## Componentes a Desenvolver

### 1. GameManager (Autoload)

Gerencia o estado global do jogo.

```gdscript
class_name GameManager extends Node

var player_data: PlayerData
var current_mission: String
var game_state: Dictionary

func _ready() -> void:
    # Inicializar estado do jogo
    pass

func start_new_game() -> void:
    # Começar novo jogo
    pass

func get_scraps() -> int:
    return player_data.scraps

func add_scraps(amount: int) -> void:
    player_data.scraps += amount
```

---

### 2. PlayerData (Resource)

Dados persistentes do jogador.

```gdscript
class_name PlayerData extends Resource

@export var unit_id: String
@export var level: int = 1
@export var hp: int = 100
@export var max_hp: int = 100
@export var energia: int = 100
@export var max_energia: int = 100
@export var escudo: int = 80
@export var max_escudo: int = 80
@export var scraps: int = 0

@export var atributos: Dictionary = {
    "potencia": 10,
    "precisao": 10,
    "nucleo": 10,
    "manobra": 10,
    "densidade": 10
}

@export var inventory: InventoryData
```

---

### 3. BattleManager (Autoload)

Gerencia o sistema de combate ATB (Active Time Battle).

```gdscript
class_name BattleManager extends Node

enum BattleState { IDLE, WAITING, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var current_state: BattleState
var enemies: Array[Enemy]
var time_bars: Dictionary  # { entity_id: float (0-100) }
var timer: float = 0.0

signal battle_started(enemies: Array)
signal turn_ready(is_player: bool)
signal action_timeout(entity_id: String)
signal turn_changed(is_player_turn: bool)
signal battle_ended(victory: bool)

func start_battle(enemy_data: Array) -> void:
    # Iniciar combate
    pass

func player_attack(target_index: int) -> void:
    # Jogador ataca
    pass

func player_defend() -> void:
    # Jogador se defende
    pass

func player_use_item(item_name: String) -> void:
    # Usar item
    pass

func enemy_turn() -> void:
    # IA do inimigo
    pass
```

---

### 4. Enemy (Classe Base)

Base para todos os tipos de inimigos.

```gdscript
class_name Enemy extends RefCounted

enum Type { PERSEGUIDOR, ATIRADOR, GRANADA, GERADOR, EXPLODIDOR }

var enemy_type: Type
var hp: int
var max_hp: int
var dano: int
var velocidade: int
var recompensa: int

func take_damage(amount: int) -> int:
    # Retorna dano real aplicado
    pass

func get_attack_description() -> String:
    pass
```

---

### 5. InventoryManager (Autoload)

Gerencia inventário e equipamentos.

```gdscript
class_name InventoryManager extends Node

@export var equipamentos: Array[Equipment]
@export var consumiveis: Dictionary
@export var especiais: Array[String]

const MAX_SLOTS_EQUIPAMENTO: int = 3
const MAX_KIT_MEDICO: int = 10
const MAX_GRANADA: int = 5

func add_item(item_name: String, amount: int = 1) -> bool:
    pass

func remove_item(item_name: String, amount: int = 1) -> bool:
    pass

func equip_item(slot: int, item: Equipment) -> void:
    pass

func use_consumable(item_name: String) -> bool:
    pass
```

---

### 6. MissionManager (Autoload)

Gerencia missões e objetivos.

```gdscript
class_name MissionManager extends Node

var current_mission: Mission
var mission_progress: Dictionary

signal mission_updated(mission_id: String, progress: int)
signal mission_completed(mission_id: String)

func start_mission(mission_id: String) -> void:
    pass

func update_progress(objective: String, amount: int = 1) -> void:
    pass

func check_completion() -> bool:
    pass
```

---

## Estrutura de Arquivos

```
res://
├── addons/
│   └── omni_*/
├── assets/
│   ├── fonts/
│   └── color_palettes/
├── src/
│   ├── autoloads/
│   │   ├── game_manager.gd
│   │   ├── battle_manager.gd
│   │   ├── inventory_manager.gd
│   │   ├── mission_manager.gd
│   │   └── chat_manager.gd
│   ├── resources/
│   │   ├── player_data.gd
│   │   ├── inventory_data.gd
│   │   ├── equipment.gd
│   │   └── items/
│   ├── characters/
│   │   ├── enemy.gd
│   │   └── enemy_types/
│   └── commands/
│       ├── attack_command.gd
│       ├── defend_command.gd
│       ├── use_command.gd
│       ├── shop_command.gd
│       ├── inventory_command.gd
│       └── chat_command.gd
├── scripts/
│   └── narrative/
│       ├── demo_missao_1.json
│       ├── demo_missao_2.json
│       └── demo_missao_3.json
├── chat/
│   └── dialogues/
│       ├── reyes.dialogue
│       ├── chen.dialogue
│       └── vasquez.dialogue
└── main.tscn
```

---

## Integração Omni-Terminal

### Registrando Comandos

```gdscript
# No terminal_config.gd
func _ready() -> void:
    var terminal = get_node("/root/Terminal")
    
    # Comandos básicos
    terminal.register_command(HelpCommand.new())
    terminal.register_command(StatusCommand.new())
    terminal.register_command(ClearCommand.new())
    
    # Comandos de jogo
    terminal.register_command(AttackCommand.new())
    terminal.register_command(DefendCommand.new())
    terminal.register_command(UseCommand.new())
    terminal.register_command(ShopCommand.new())
    terminal.register_command(InventoryCommand.new())
    terminal.register_command(ChatCommand.new())
    terminal.register_command(MissionCommand.new())
    terminal.register_command(SaveCommand.new())
    terminal.register_command(LoadCommand.new())
```

### Exemplo: AttackCommand

```gdscript
class_name AttackCommand extends CommandBase

func _init() -> void:
    super._init()
    id = "attack"
    description = "Ataca o inimigo atual"
    add_alias("atacar")

func execute(context: CommandContext) -> CommandOutput:
    if not BattleManager.current_state == BattleManager.BattleState.PLAYER_TURN:
        return CommandOutput.new(false, "Não há combate ativo.")
    
    var damage = BattleManager.calculate_player_damage()
    var result = BattleManager.player_attack(damage)
    
    return CommandOutput.new(true, "Dano causado: %d" % damage)
```

---

## Integração Omni-Narrative

### Estrutura de Script JSON

```json
{
  "nodes": [
    {
      "id": "start",
      "type": "terminal",
      "text": "Comandante Reyes: Soldado #2227, você está online.",
      "next": "m1_intro"
    },
    {
      "id": "m1_intro",
      "type": "chat",
      "contact": "reyes",
      "dialogue_id": "m1_intro",
      "choices": [
        { "text": "Entendido.", "next": "m1_objective" }
      ]
    },
    {
      "id": "m1_objective",
      "type": "terminal",
      "text": "Sua missão: Verificar o perímetro da base.",
      "set_mission": "m1_varredura"
    }
  ]
}
```

---

## Integração Omni-Chat

### Estrutura de Dialogue

```gdscript
# ChatDialogue resource
extends Resource
class_name ChatDialogue

@export var contact_id: String
@export var messages: Array[ChatMessage]

@export_group("Messages")
@export var message_001: ChatMessage
@export var message_002: ChatMessage
```

---

## Tarefas de Implementação

### Fase 1: Core (Prioridade Alta)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| GameManager | Nenhuma | Pendente |
| PlayerData | Nenhuma | Pendente |
| Estrutura de pastas | Nenhuma | Pendente |
| Comandos básicos | OmniTerm | Pendente |
| Sistema de save | OmniSave | Pendente |

### Fase 2: Missões (Prioridade Alta)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| MissionManager | GameManager | Pendente |
| Script narrativa 1 | OmniNarrative | Pendente |
| Script narrativa 2 | OmniNarrative | Pendente |
| Script narrativa 3 | OmniNarrative | Pendente |

### Fase 3: Combate (Prioridade Alta)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| BattleManager | GameManager | Pendente |
| Enemy classes | Nenhuma | Pendente |
| Comandos combate | BattleManager | Pendente |
| Sistema de rewards | BattleManager | Pendente |

### Fase 4: Shop e Inventory (Prioridade Média)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| InventoryManager | GameManager | Pendente |
| Itens consumíveis | InventoryManager | Pendente |
| Chips | InventoryManager | Pendente |
| Sistema de venda | InventoryManager | Pendente |

### Fase 5: Chat (Prioridade Média)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| ChatManager | OmniChat | Pendente |
| Dialogue Reyes | ChatManager | Pendente |
| Dialogue Chen | ChatManager | Pendente |
| Dialogue Vasquez | ChatManager | Pendente |

### Fase 6: Decryption (Prioridade Baixa)

| Tarefa | Dependência | Status |
|--------|------------|--------|
| Dispositivo | InventoryManager | Pendente |
| Puzzle 1-8 | Dispositivo | Pendente |
| Integração narrativa | Dispositivo | Pendente |

---

## Testes Recomendados

### Testes Unitários

- Cálculo de dano
- Fórmulas de recompensa
- Sistema de atributos
- Validação de inventory

### Testes de Integração

- Save/Load completo
- Transição de cenas
- Commands com BattleManager
- Narrative triggers

### Testes de UI

- Terminal responsivo
- Shop interação
- Chat scroll
- Typewriter effect

---

## Referências Técnicas

### Documentação dos Plugins

Ver [[02_terminal|documentação do OmniTerm]]:
- `/addons/omni_term/docs/`

Ver [[05_chat|documentação do OmniChat]]:
- `/addons/omni_chat/docs/`

Ver [[01_narrativa|documentação do OmniNarrative]]:
- `/addons/omni_narrative/docs/`

Ver [[07_save|documentação do OmniSave]]:
- `/addons/omni_save/docs/`

### Style Guide

Seguir o [[style guide]] do projeto para código GDScript.

---

## Próximos Passos

1. **Criar estrutura de pastas** (`res://src/`)
2. **Implementar GameManager** como autoload
3. **Configurar comandos básicos** do terminal
4. **Testar narrativa inicial** com OmniNarrative
5. **Implementar BattleManager** para combate
6. **Criar sistema de missões**
7. **Integrar shop e inventory**
8. **Adicionar diálogos** dos NPCs

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[05_chat]] — NPCs
- [[06_decryption]] — Quebra-cabeça
- [[07_save]] — Save/Load
- [[../style guide]] — Guia de estilo GDScript