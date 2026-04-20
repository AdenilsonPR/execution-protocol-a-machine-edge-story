# TASK 007: MISSÕES

## Objetivo
Implementar o sistema de missões e progresso.

## Estimativa: 3-4 horas

---

## Conteúdo

### mission.gd

```gdscript
class_name Mission

var id: String
var title: String
var description: String
var objective: String
var target: int
var progress: int = 0
var recompensa: int
var unlocked: bool = false
var active: bool = false
var completed: bool = false


func _init(data: Dictionary) -> void:
    id = data.get("id", "")
    title = data.get("title", "")
    description = data.get("description", "")
    objective = data.get("objective", "")
    target = data.get("target", 1)
    recompensa = data.get("recompensa", 0)


func start() -> void:
    active = true
    progress = 0


func update_progress(amount: int = 1) -> void:
    if active:
        progress += amount


func is_complete() -> bool:
    return progress >= target


func complete() -> void:
    completed = true
    active = false


func get_progress_percent() -> float:
    return float(progress) / target


func get_restante() -> int:
    return max(0, target - progress)
```

---

### mission_database.gd

```gdscript
class_name MissionDatabase

const MISSIONS = [
    {
        "id": "m1_conexao",
        "title": "Conexão Inicial",
        "description": "Conecte-se à rede da base.",
        "objective": "Executar comando: connect",
        "target": 1,
        "recompensa": 25,
        "unlock": "boot_complete",
        "next": "m2_varredura"
    },
    {
        "id": "m2_varredura",
        "title": "Varredura Perimetral",
        "description": "Verificar o perímetro leste da base.",
        "objective": "Derrotar Electrotrions",
        "target": 3,
        "recompensa": 50,
        "unlock": "m1_conexao",
        "next": "m3_anomalia"
    },
    {
        "id": "m3_anomalia",
        "title": "Atividade Anômala",
        "description": "Investigar atividade suspeita no setor norte.",
        "objective": "Derrotar inimigos e encontrar dispositivo",
        "target": 6,
        "recompensa": 100,
        "unlock": "m2_varredura",
        "next": null,
        "reward_item": "dispositivo_criptografado"
    }
]


static func get_mission(mission_id: String) -> Mission:
    for data in MISSIONS:
        if data.id == mission_id:
            return Mission.new(data)
    return null


static func get_all_missions() -> Array[Mission]:
    return MISSIONS.map(func(d): return Mission.new(d))


static func get_available_missions(completed: Array[String]) -> Array[Mission]:
    var available: Array[Mission] = []

    for data in MISSIONS:
        var id: String = data.id
        if id in completed:
            continue

        var unlock: String = data.get("unlock", "")
        if unlock.is_empty() or unlock in completed:
            available.append(Mission.new(data))

    return available
```

---

### mission_manager.gd

```gdscript
class_name MissionManager extends Node

signal mission_updated(mission_id: String, progress: int, target: int)
signal mission_completed(mission_id: String, recompensa: int)
signal mission_started(mission_id: String)

var current_mission: Mission = null
var completed_missions: Array[String] = []
var failed_missions: Array[String] = []


func _ready() -> void:
    pass


func start_mission(mission_id: String) -> void:
    var mission: Mission = MissionDatabase.get_mission(mission_id)
    if mission:
        current_mission = mission
        mission.start()
        mission_started.emit(mission_id)


func update_progress(key: String, amount: int = 1) -> void:
    if not current_mission:
        return

    if current_mission.id == key or current_mission.objective.contains(key):
        current_mission.update_progress(amount)
        mission_updated.emit(current_mission.id, current_mission.progress, current_mission.target)

        if current_mission.is_complete():
            _complete_mission()


func update_enemy_kills(amount: int = 1) -> void:
    update_progress("derrotar", amount)


func update_items_collected(item_id: String, amount: int = 1) -> void:
    update_progress("coletar_" + item_id, amount)


func update_area_visited(area_id: String) -> void:
    update_progress("visitar_" + area_id, 1)


func _complete_mission() -> void:
    if not current_mission:
        return

    var m: Mission = current_mission
    m.complete()
    completed_missions.append(m.id)

    GameManager.add_scraps(m.recompensa)

    if m.has("reward_item"):
        InventoryManager.add_item(m.get("reward_item"))

    mission_completed.emit(m.id, m.recompensa)
    current_mission = null


func is_mission_completed(mission_id: String) -> bool:
    return mission_id in completed_missions


func get_current_mission() -> Mission:
    return current_mission


func get_completed_list() -> Array[String]:
    return completed_missions
```

---

### UI de Missão

```gdscript
# mission_ui.gd
extends Control

var current_mission_label: Label
var progress_label: Label
var recompensa_label: Label


func _ready() -> void:
    _setup_ui()


func _setup_ui() -> void:
    var container = VBoxContainer.new()
    container.set_anchors_and_offsets(ControlANCHORS_FULL_RECT)
    add_child(container)

    var title = Label.new()
    title.text = "MISSÃO ATUAL"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    container.add_child(title)

    var sep = HSeparator.new()
    container.add_child(sep)

    current_mission_label = Label.new()
    current_mission_label.text = "Nenhuma"
    container.add_child(current_mission_label)

    progress_label = Label.new()
    progress_label.text = "Progresso: 0/0"
    container.add_child(progress_label)

    recompensa_label = Label.new()
    recompensa_label.text = "Recompensa: 0 scraps"
    container.add_child(recompensa_label)


func _process(delta: float) -> void:
    _update_display()


func _update_display() -> void:
    var mission: Mission = MissionManager.get_current_mission()

    if mission:
        current_mission_label.text = mission.title
        progress_label.text = "Progresso: %d/%d" % [mission.progress, mission.target]
        recompensa_label.text = "Recompensa: %d scraps" % mission.recompensa
    else:
        current_mission_label.text = "Nenhuma missão ativa"
        progress_label.text = ""
        recompensa_label.text = ""
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Missão como resource
- [ ] MissionDatabase
- [ ] MissionManager
- [ ] UI de missão
- [ ] 3 missões da demo

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_006_combate|TASK 006: COMBATE - SISTEMA]]

---

## Dependentes

- [[task_008_inventario|TASK 008: INVENTÁRIO]]

---

## Próximo

[[task_008_inventario|AVANÇAR → Task 008]]