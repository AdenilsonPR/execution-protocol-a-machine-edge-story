# TASK 002: AUTOLOADS

## Objetivo
Criar os sistemas globais do jogo (autoloads).

## Estimativa: 4-6 horas

---

## Conteúdo

### game_manager.gd

```gdscript
class_name GameManager extends Node

signal game_started
signal game_saved(slot: String)
signal game_loaded(slot: String)
signal scene_changed(scene_name: String)
signal state_changed(state: GameState)

enum GameState { BOOT, TITLE, PLAYING, COMBAT, DIALOGUE, SHOP, PAUSED, GAME_OVER }

var current_state: GameState = GameState.BOOT
var player_data: PlayerData
var current_scene: String = ""
var is_paused: bool = false


func _ready() -> void:
    _load_initial_data()


func _load_initial_data() -> void:
    var data: Resource = load("res://data/player_initial_data.tres")
    if data:
        player_data = data.duplicate()
    else:
        player_data = PlayerData.new()


func start_new_game() -> void:
    _load_initial_data()
    current_state = GameState.PLAYING
    game_started.emit()


func get_scraps() -> int:
    return player_data.scraps


func add_scraps(amount: int) -> void:
    player_data.scraps = max(0, player_data.scraps + amount)


func spend_scraps(amount: int) -> bool:
    if player_data.scraps >= amount:
        player_data.scraps -= amount
        return true
    return false


func get_hp_percent() -> float:
    return float(player_data.hp) / player_data.max_hp


func get_energia_percent() -> float:
    return float(player_data.energia) / player_data.max_energia


func take_damage(amount: int) -> void:
    var escudo_damage: int = min(player_data.escudo, amount)
    player_data.escudo -= escudo_damage

    var remaining: int = amount - escudo_damage
    player_data.hp = max(0, player_data.hp - remaining)

    if player_data.hp <= 0:
        _game_over()


func heal(amount: int) -> void:
    player_data.hp = min(player_data.max_hp, player_data.hp + amount)


func restore_energia(amount: int) -> void:
    player_data.energia = min(player_data.max_energia, player_data.energia + amount)


func restore_escudo(amount: int) -> void:
    player_data.escudo = min(player_data.max_escudo, player_data.escudo + amount)


func _game_over() -> void:
    current_state = GameState.GAME_OVER
    state_changed.emit(current_state)


func set_state(new_state: GameState) -> void:
    current_state = new_state
    state_changed.emit(current_state)
```

---

### battle_manager.gd

```gdscript
class_name BattleManager extends Node

signal battle_started(enemies: Array)
signal battle_ended(victory: bool)
signal turn_ready(is_player: bool)
signal turn_changed(is_player_turn: bool)
signal action_timeout(entity_id: String)

enum BattleState { IDLE, WAITING, PLAYER_TURN, ENEMY_TURN, VICTORY, DEFEAT }

var current_state: BattleState = BattleState.IDLE
var current_enemies: Array[Enemy] = []
var time_bars: Dictionary = {}
var player_time: float = 0.0

const TICK_RATE: float = 0.1
const MAX_TIME: float = 100.0


func _ready() -> void:
    set_process(true)


func _process(delta: float) -> void:
    if current_state == BattleState.PLAYER_TURN:
        _update_time_bars(delta)
    elif current_state == BattleState.ENEMY_TURN:
        _update_enemy_ai(delta)


func start_battle(enemy_data: Array) -> void:
    current_enemies.clear()
    for data in enemy_data:
        var enemy: Enemy = Enemy.new()
        enemy.setup(data)
        current_enemies.append(enemy)

    player_time = 0.0
    current_state = BattleState.PLAYER_TURN
    battle_started.emit(current_enemies)


func _update_time_bars(delta: float) -> void:
    player_time += delta * 10.0

    if player_time >= MAX_TIME:
        turn_ready.emit(true)


func _update_enemy_ai(delta: float) -> void:
    for enemy in current_enemies:
        enemy.update_time(delta)
        if enemy.is_ready():
            _execute_enemy_turn(enemy)


func _execute_enemy_turn(enemy: Enemy) -> void:
    var damage: int = enemy.attack()
    GameManager.take_damage(damage)
    enemy.reset_time()


func player_attack(target_index: int) -> void:
    if target_index < 0 or target_index >= current_enemies.size():
        return

    var damage: int = _calculate_player_damage()
    var enemy: Enemy = current_enemies[target_index]
    enemy.take_damage(damage)

    if enemy.is_defeated():
        _on_enemy_defeated(enemy)

    _end_player_turn()


func player_defend() -> void:
    GameManager.heal(GameManager.player_data.max_hp * 0.1)
    GameManager.restore_escudo(20)
    _end_player_turn()


func player_flee() -> bool:
    if randf() > 0.5:
        end_battle(false)
        return true
    return false


func _calculate_player_damage() -> int:
    var base: int = GameManager.player_data.atributos["potencia"]
    var precisao: int = GameManager.player_data.atributos["precisao"]
    return base + (precisao / 2) + randi() % 10


func _on_enemy_defeated(enemy: Enemy) -> void:
    var reward: int = enemy.recompensa
    GameManager.add_scraps(reward)
    current_enemies.erase(enemy)

    if current_enemies.is_empty():
        end_battle(true)


func end_battle(victory: bool) -> void:
    current_state = BattleState.VICTORY if victory else BattleState.DEFEAT
    battle_ended.emit(victory)


func _end_player_turn() -> void:
    player_time = 0.0
    current_state = BattleState.ENEMY_TURN
    turn_changed.emit(false)


func get_active_enemies() -> Array[Enemy]:
    return current_enemies
```

---

### inventory_manager.gd

```gdscript
class_name InventoryManager extends Node

signal item_added(item_name: String, amount: int)
signal item_removed(item_name: String, amount: int)
signal equipment_changed(slot: int)

const MAX_EQUIPMENT_SLOTS: int = 3

var equipment: Array[Equipment] = []
var consumibles: Dictionary = {}
var special_items: Array[String] = []


func _ready() -> void:
    equipment.resize(MAX_EQUIPMENT_SLOTS)
    equipment.fill(null)


func has_item(item_name: String) -> bool:
    if consumibles.has(item_name):
        return consumibles[item_name] > 0
    return item_name in special_items


func get_item_count(item_name: String) -> int:
    return consumibles.get(item_name, 0)


func add_item(item_name: String, amount: int = 1) -> bool:
    if ItemDatabase.is_special(item_name):
        if item_name not in special_items:
            special_items.append(item_name)
            item_added.emit(item_name, 1)
            return true
        return false

    var current: int = consumibles.get(item_name, 0)
    consumibles[item_name] = current + amount
    item_added.emit(item_name, amount)
    return true


func remove_item(item_name: String, amount: int = 1) -> bool:
    if special_items.has(item_name):
        special_items.erase(item_name)
        item_removed.emit(item_name, 1)
        return true

    var current: int = consumibles.get(item_name, 0)
    if current >= amount:
        consumibles[item_name] = current - amount
        item_removed.emit(item_name, amount)
        return true
    return false


func equip_item(slot: int, item: Equipment) -> void:
    if slot < 0 or slot >= MAX_EQUIPMENT_SLOTS:
        return

    var old_item: Equipment = equipment[slot]
    if old_item:
        unequip_item(slot)

    equipment[slot] = item
    equipment_changed.emit(slot)


func unequip_item(slot: int) -> void:
    if slot < 0 or slot >= MAX_EQUIPMENT_SLOTS:
        return

    var item: Equipment = equipment[slot]
    if item:
        equipment[slot] = null
        equipment_changed.emit(slot)


func get_equipped(slot: int) -> Equipment:
    if slot >= 0 and slot < equipment.size():
        return equipment[slot]
    return null


func calculate_bonus(stat: String) -> int:
    var bonus: int = 0
    for item in equipment:
        if item and item.stats.has(stat):
            bonus += item.stats[stat]
    return bonus
```

---

### mission_manager.gd

```gdscript
class_name MissionManager extends Node

signal mission_updated(mission_id: String, progress: int)
signal mission_completed(mission_id: String)
signal mission_started(mission_id: String)

var current_mission: Mission = null
var completed_missions: Array[String] = []
var mission_progress: Dictionary = {}


func has_mission(mission_id: String) -> bool:
    return current_mission != null and current_mission.id == mission_id


func start_mission(mission: Mission) -> void:
    current_mission = mission
    current_mission.start()
    mission_started.emit(mission.id)


func complete_mission() -> void:
    if current_mission:
        var mission_id: String = current_mission.id
        current_mission.complete()
        completed_missions.append(mission_id)
        current_mission = null
        mission_completed.emit(mission_id)


func update_progress(objective_key: String, amount: int = 1) -> void:
    if current_mission:
        current_mission.update_progress(objective_key, amount)
        mission_updated.emit(current_mission.id, current_mission.get_progress())


func is_mission_completed(mission_id: String) -> bool:
    return mission_id in completed_missions


func get_available_missions() -> Array[Mission]:
    return MissionDatabase.get_available_missions(completed_missions)


func get_current_objectives() -> Array[String]:
    if current_mission:
        return current_mission.objectives
    return []
```

---

### narrative_manager.gd

```gdscript
class_name NarrativeManager extends Node

signal node_started(node_id: String)
signal node_completed(node_id: String)
signal dialogue_started(contact: String)
signal dialogue_ended(contact: String)
signal choice_made(choice_id: String)

var current_script: String = ""
var current_node: String = ""
var variables: Dictionary = {}


func load_script(script_path: String) -> void:
    current_script = script_path
    _start_node("start")


func _start_node(node_id: String) -> void:
    current_node = node_id
    node_started.emit(node_id)

    var node: Dictionary = _get_node_data(node_id)
    if node:
        _process_node(node)


func _process_node(node: Dictionary) -> void:
    match node.type:
        "terminal":
            _show_terminal_text(node.text)
        "chat":
            _show_chat_message(node.contact, node.text)
        "choice":
            _show_choices(node.choices)
        "set_var":
            _set_variable(node.var, node.value)
        "jump":
            _start_node(node.next)
        "condition":
            if _check_condition(node.condition):
                _start_node(node.then)
            elif node.has("else"):
                _start_node(node.else)

    node_completed.emit(node_id)


func _show_terminal_text(text: String) -> void:
    var terminal = get_node("/root/Terminal")
    terminal.print(text + "\n")


func _show_chat_message(contact: String, text: String) -> void:
    var chat = get_node("/root/OmniChat")
    chat.render_text(text, 0.03, contact)
    dialogue_started.emit(contact)


func _show_choices(choices: Array) -> void:
    var terminal = get_node("/root/Terminal")
    terminal.show_choice_menu(choices)


func _on_choice_selected(choice_id: String) -> void:
    choice_made.emit(choice_id)
    var node: Dictionary = _get_node_data(current_node)
    if node and node.has("choices"):
        for choice in node.choices:
            if choice.id == choice_id:
                _start_node(choice.next)
                break


func set_variable(key: String, value: Variant) -> void:
    variables[key] = value


func get_variable(key: String, default: Variant = null) -> Variant:
    return variables.get(key, default)


func _get_node_data(node_id: String) -> Dictionary:
    return {}
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] GameManager funcional
- [ ] BattleManager com ATB
- [ ] InventoryManager com items
- [ ] MissionManager com progresso
- [ ] NarrativeManager integrado

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]

---

## Dependentes

- [[task_003_terminal_comandos|TASK 003: TERMINAL - COMANDOS]]
- [[task_004_terminal_layout|TASK 004: TERMINAL - LAYOUT]]
- [[task_005_chat_painel|TASK 005: CHAT - PAINEL]]
- [[task_006_combate|TASK 006: COMBATE - SISTEMA]]

---

## Próximo

[[task_003_terminal_comandos|AVANÇAR → Task 003]]