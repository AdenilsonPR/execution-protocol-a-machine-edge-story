# TASK 006: COMBATE - SISTEMA

## Objetivo
Implementar o sistema de combate ATB com menu visual.

## Estimativa: 6-8 horas

---

## Conteúdo

### battle_scene.tscn

```gdscript
# battle_scene.gd
extends Control

var enemies: Array[Enemy] = []
var combat_menu: Control
var time_bars: Dictionary = {}
var is_player_turn: bool = true


func _ready() -> void:
    _setup_ui()
    _connect_signals()


func _setup_ui() -> void:
    var main = HBoxContainer.new()
    main.set_anchors_and_offsets(ControlANCHORS_FULL_RECT)
    add_child(main)

    var player_area = VBoxContainer.new()
    player_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL

    var status_panel = _create_status_panel()
    player_area.add_child(status_panel)

    combat_menu = _create_combat_menu()
    player_area.add_child(combat_menu)

    main.add_child(player_area)

    var enemy_area = VBoxContainer.new()
    enemy_area.size_flags_horizontal = Control.SIZE_EXPAND_FILL

    enemy_area.add_child(_create_enemy_display())
    main.add_child(enemy_area)


func _create_status_panel() -> Control:
    var panel = PanelContainer.new()
    panel.custom_minimum_size.y = 150

    var vbox = VBoxContainer.new()

    var hp_label = Label.new()
    hp_label.name = "HP_Label"
    hp_label.text = "HP: 100/100"
    vbox.add_child(hp_label)

    var hp_bar = ProgressBar.new()
    hp_bar.name = "HP_Bar"
    hp_bar.max_value = 100
    hp_bar.value = 100
    vbox.add_child(hp_bar)

    var energia_label = Label.new()
    energia_label.name = "Energia_Label"
    energia_label.text = "ENERGIA: 100/100"
    vbox.add_child(energia_label)

    var escudo_label = Label.new()
    escudo_label.name = "Escudo_Label"
    escudo_label.text = "ESCUDO: 80/80"
    vbox.add_child(escudo_label)

    panel.add_child(vbox)
    return panel


func _create_combat_menu() -> Control:
    var menu = VBoxContainer.new()
    menu.name = "CombatMenu"
    menu.size_flags_vertical = Control.SIZE_EXPAND_FILL

    var title = Label.new()
    title.text = "SUA VEZ! Escolha uma ação:"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    menu.add_child(title)

    var sep = HSeparator.new()
    menu.add_child(sep)

    var options = [
        { "id": "atacar", "text": "ATACAR" },
        { "id": "defender", "text": "DEFENDER" },
        { "id": "usar_item", "text": "USAR ITEM" },
        { "id": "fugir", "text": "FUGIR" }
    ]

    for opt in options:
        var btn = Label.new()
        btn.name = opt.id
        btn.text = opt.text
        menu.add_child(btn)

    var instructions = Label.new()
    instructions.text = "\n[↑/↓] navegar   [ENTER] selecionar"
    instructions.add_theme_font_size_override("font_size", 14)
    menu.add_child(instructions)

    return menu


func _create_enemy_display() -> Control:
    var container = VBoxContainer.new()
    container.name = "EnemyContainer"

    var title = Label.new()
    title.text = "INIMIGOS"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    container.add_child(title)

    return container


func _connect_signals() -> void:
    BattleManager.turn_ready.connect(_on_turn_ready)
    BattleManager.battle_ended.connect(_on_battle_ended)


func _process(delta: float) -> void:
    if is_player_turn:
        _handle_input()


func _handle_input() -> void:
    if Input.is_action_just_pressed("ui_up"):
        _select_previous()

    if Input.is_action_just_pressed("ui_down"):
        _select_next()

    if Input.is_action_just_pressed("ui_accept"):
        _execute_selected()


func _on_turn_ready(is_player: bool) -> void:
    is_player_turn = is_player


func _on_battle_ended(victory: bool) -> void:
    if victory:
        _show_victory_screen()
    else:
        _show_defeat_screen()
```

---

### enemy.gd

```gdscript
# enemy.gd
class_name Enemy
extends RefCounted

var id: String
var type: EnemyType
var hp: int
var max_hp: int
var dano: int
var velocidade: int
var recompensa: int
var time_bar: float = 0.0
var is_dead: bool = false

enum EnemyType { PERSEGUIDOR, ATIRADOR, GRANADA, GERADOR, EXPLODIDOR }


func _init() -> void:
    pass


func setup(data: Dictionary) -> void:
    id = data.get("id", "")
    type = data.get("type", EnemyType.PERSEGUIDOR)
    hp = data.get("hp", 50)
    max_hp = hp
    dano = data.get("dano", 10)
    velocidade = data.get("velocidade", 3)
    recompensa = data.get("recompensa", 15)


func take_damage(amount: int) -> int:
    var actual: int = min(hp, amount)
    hp -= actual

    if hp <= 0:
        is_dead = true

    return actual


func attack() -> int:
    return dano + randi() % 5


func update_time(delta: float) -> void:
    if not is_dead:
        time_bar += delta * (10.0 / velocidade)


func is_ready() -> bool:
    return time_bar >= 100.0


func reset_time() -> void:
    time_bar = 0.0


func is_defeated() -> bool:
    return is_dead


func get_hp_percent() -> float:
    return float(hp) / max_hp
```

---

### enemy_factory.gd

```gdscript
# enemy_factory.gd
class_name EnemyFactory

const ENEMY_DATA = {
    Enemy.EnemyType.PERSEGUIDOR: {
        "nome": "Perseguidor",
        "hp": 50,
        "dano": 12,
        "velocidade": 3,
        "recompensa": 15,
        "descricao": "Inimigo rápido que persegue o jogador."
    },
    Enemy.EnemyType.ATIRADOR: {
        "nome": "Atirador",
        "hp": 35,
        "dano": 18,
        "velocidade": 4,
        "recompensa": 25,
        "descricao": "Atira à distância. Cuidado."
    },
    Enemy.EnemyType.GRANADA: {
        "nome": "Granadeiro",
        "hp": 45,
        "dano": 30,
        "velocidade": 6,
        "recompensa": 40,
        "descricao": "Lança granadas. Mantenha distância."
    },
    Enemy.EnemyType.GERADOR: {
        "nome": "Gerador",
        "hp": 65,
        "dano": 0,
        "velocidade": 8,
        "recompensa": 45,
        "descricao": "Gera energia para outros inimigos. Derrote primeiro."
    },
    Enemy.EnemyType.EXPLODIDOR: {
        "nome": "Explodidor",
        "hp": 30,
        "dano": 45,
        "velocidade": 2,
        "recompensa": 0,
        "descricao": "Explode quando derrotado. Cuidado!"
    }
}


static func create_enemy(type: Enemy.EnemyType, variant: int = 0) -> Enemy:
    var data: Dictionary = ENEMY_DATA[type].duplicate()
    data["type"] = type

    var hp_variation: int = randi() % 11 - 5
    data["hp"] += hp_variation

    var dano_variation: int = randi() % 3 - 1
    data["dano"] += dano_variation

    return Enemy.new().setup(data)


static func create_wave(wave_data: Array) -> Array[Enemy]:
    var enemies: Array[Enemy] = []

    for data in wave_data:
        var type: Enemy.EnemyType = data.get("type", Enemy.EnemyType.PERSEGUIDOR)
        var count: int = data.get("count", 1)

        for i in range(count):
            enemies.append(create_enemy(type, i))

    return enemies
```

---

### Sistema de Turnos

```gdscript
# turn_system.gd
extends Node

const TICK_RATE: float = 0.1
const MAX_TIME: float = 100.0

var battle_state: BattleState = BattleState.IDLE
var all_entities: Dictionary = {}

signal turn_started(entity_id: String)
signal turn_ended(entity_id: String)

enum BattleState { IDLE, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }


func _ready() -> void:
    set_process(true)


func _process(delta: float) -> void:
    if battle_state == BattleState.PLAYER_TURN:
        _update_player_time(delta)
    elif battle_state == BattleState.ENEMY_TURN:
        _update_enemy_times(delta)


func start_battle(enemies: Array[Enemy], player_speed: int) -> void:
    all_entities.clear()
    all_entities["player"] = 0.0

    for enemy in enemies:
        all_entities[enemy.id] = 0.0

    battle_state = BattleState.PLAYER_TURN
    turn_started.emit("player")


func _update_player_time(delta: float) -> void:
    var player_time: float = all_entities["player"]
    player_time += delta * (10.0 / player_speed)
    all_entities["player"] = player_time

    if player_time >= MAX_TIME:
        BattleManager.turn_ready.emit(true)


func _update_enemy_times(delta: float) -> void:
    for id in all_entities.keys():
        if id == "player":
            continue

        var time: float = all_entities[id]
        time += delta * 10.0
        all_entities[id] = time

        if time >= MAX_TIME:
            _execute_enemy_turn(id)
            break


func _execute_enemy_turn(enemy_id: String) -> void:
    BattleManager.execute_enemy_turn(enemy_id)
    all_entities[enemy_id] = 0.0
    turn_ended.emit(enemy_id)
```

---

### Recompensas

```gdscript
# reward_system.gd
extends Node

var total_scraps: int = 0
var total_xp: int = 0


func calculate_reward(enemy: Enemy) -> Dictionary:
    var scraps: int = enemy.recompensa + randi() % 6
    var xp: int = enemy.max_hp + (enemy.dano * 2)

    return {
        "scraps": scraps,
        "xp": xp,
        "drops": _calculate_drops(enemy)
    }


func _calculate_drops(enemy: Enemy) -> Array:
    var drops: Array = []
    var drop_chance: float = randf()

    if drop_chance > 0.7:
        var item: String = _get_random_drop()
        if item:
            drops.append(item)

    if drop_chance > 0.95:
        drops.append("fragmento_tecnologia")

    return drops


func _get_random_drop() -> String:
    var drops: Array = ["kit_medico", "granada", "chip_aleatorio"]
    return drops[randi() % drops.size()]


func grant_rewards(enemies: Array[Enemy]) -> void:
    for enemy in enemies:
        var reward: Dictionary = calculate_reward(enemy)

        GameManager.add_scraps(reward.scraps)
        total_scraps += reward.scraps
        total_xp += reward.xp

        if reward.drops.size() > 0:
            for drop in reward.drops:
                InventoryManager.add_item(drop)


func get_total_rewards() -> Dictionary:
    return {
        "scraps": total_scraps,
        "xp": total_xp
    }
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Battle scene com UI
- [ ] Menu visual com ↑↓
- [ ] Sistema ATB funcionando
- [ ] Classes de inimigos
- [ ] Sistema de recompensas

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]

---

## Dependentes

- [[task_007_missoes|TASK 007: MISSÕES]]
- [[task_008_inventario|TASK 008: INVENTÁRIO]]

---

## Próximo

[[task_007_missoes|AVANÇAR → Task 007]]