# TASK 001: ESTRUTURA BASE

## Objetivo
Criar a estrutura de pastas e arquivos inicial do projeto.

## Estimativa: 1-2 horas

---

## Ações

### 1.1 Criar Pastas

```bash
res://
├── addons/
│   └── omni_*/
├── src/
│   ├── autoloads/
│   │   ├── game_manager.gd
│   │   ├── battle_manager.gd
│   │   ├── inventory_manager.gd
│   │   ├── mission_manager.gd
│   │   └── narrative_manager.gd
│   ├── commands/
│   │   ├── help_command.gd
│   │   ├── status_command.gd
│   │   ├── clear_command.gd
│   │   ├── mission_command.gd
│   │   ├── missions_command.gd
│   │   ├── shop_command.gd
│   │   ├── chat_command.gd
│   │   ├── save_command.gd
│   │   ├── load_command.gd
│   │   └── inventory_command.gd
│   ├── combat/
│   │   ├── enemy.gd
│   │   ├── enemy_perseguidor.gd
│   │   ├── enemy_atirador.gd
│   │   ├── enemy_granada.gd
│   │   ├── enemy_gerador.gd
│   │   ├── enemy_explodidor.gd
│   │   └── combat_menu.gd
│   ├── inventory/
│   │   ├── item.gd
│   │   ├── equipment.gd
│   │   ├── consumible.gd
│   │   └── special_item.gd
│   ├── missions/
│   │   ├── mission.gd
│   │   ├── mission_objective.gd
│   │   └── mission_reward.gd
│   └── narrative/
│       ├── missao_1.json
│       ├── missao_2.json
│       └── demo_intro.json
├── scenes/
│   ├── main.tscn
│   ├── terminal.tscn
│   ├── chat_panel.tscn
│   └── combat_scene.tscn
├── assets/
│   ├── fonts/
│   └── sprites/
│       ├── enemies/
│       ├── npcs/
│       └── ui/
├── dialogues/
│   ├── reyes.dialogue
│   ├── chen.dialogue
│   └── vasquez.dialogue
└── data/
    ├── player_initial_data.tres
    └── game_settings.tres
```

---

## Recursos

### game_settings.tres

```gdscript
extends Resource
class_name GameSettings

@export var version: String = "0.1"
@export var debug_mode: bool = false

@export_group("Terminal")
@export var terminal_font: Font
@export var terminal_bg_color: Color = Color(0.05, 0.05, 0.1)
@export var terminal_text_color: Color = Color(0.2, 0.9, 0.2)

@export_group("Combat")
@export var atb_tick_rate: float = 0.1
@export var combat_music: AudioStream

@export_group("UI")
@export var chat_panel_width: float = 0.3
@export var enable_typewriter: bool = true
@export var typewriter_speed: float = 0.03
```

### player_initial_data.tres

```gdscript
extends Resource
class_name PlayerData

@export var unit_id: String = "2227"
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

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Todas as pastas criadas
- [ ] Recursos (`.tres`) configurados
- [ ] Pronto para autoloads

---

## Dependências

- **Nenhuma**

---

## Dependentes

- [[task_002_autoloads|TASK 002: AUTOLOADS]]

---

## Próximo

[[task_002_autoloads|AVANÇAR → Task 002]]