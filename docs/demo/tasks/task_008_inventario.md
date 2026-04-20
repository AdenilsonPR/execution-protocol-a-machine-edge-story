# TASK 008: INVENTÁRIO

## Objetivo
Implementar o sistema de inventário, equipamentos, loja e oficina.

## Estimativa: 5-6 horas

---

## Conteúdo

### item.gd

```gdscript
class_name Item

var id: String
var name: String
var description: String
var type: ItemType
var price: int
var stackable: bool = false
var max_stack: int = 1

enum ItemType { CONSUMIVEL, EQUIPAMENTO, ESPECIAL, MATERIAL }


func _init(data: Dictionary) -> void:
    id = data.get("id", "")
    name = data.get("name", "")
    description = data.get("description", "")
    type = data.get("type", ItemType.CONSUMIVEL)
    price = data.get("price", 0)
    stackable = data.get("stackable", false)
    max_stack = data.get("max_stack", 99)
```

### equipment.gd

```gdscript
class_name Equipment extends Item

var slot: EquipmentSlot
var stats: Dictionary = {}
var level_required: int = 1
var rarity: Rarity = Rarity.COMUM

enum EquipmentSlot { ARMA, DEFESA, ACESSORIO }
enum Rarity { COMUM, INCOMUM, RARO, EPICO, LENDARIO }


func _init(data: Dictionary) -> void:
    super._init(data)
    slot = data.get("slot", EquipmentSlot.ARMA)
    stats = data.get("stats", {})
    level_required = data.get("level_required", 1)
    rarity = data.get("rarity", Rarity.COMUM)
```

### item_database.gd

```gdscript
class_name ItemDatabase

const ITEMS = {
    "kit_medico": {
        "id": "kit_medico",
        "name": "Kit Médico",
        "description": "Restaura 30 HP.",
        "type": Item.ItemType.CONSUMIVEL,
        "price": 25,
        "stackable": true,
        "effect": { "hp": 30 }
    },
    "granada": {
        "id": "granada",
        "name": "Granada",
        "description": "Causa 25 dano em área.",
        "type": Item.ItemType.CONSUMIVEL,
        "price": 40,
        "stackable": true,
        "effect": { "dano": 25, "area": true }
    },
    "drive_leitura": {
        "id": "drive_leitura",
        "name": "Drive de Leitura",
        "description": "Permite ler dispositivos criptografados.",
        "type": Item.ItemType.ESPECIAL,
        "price": 200,
        "stackable": false
    },
    "chip_potencia": {
        "id": "chip_potencia",
        "name": "Chip de Potência I",
        "description": "+5 Potência.",
        "type": Item.ItemType.EQUIPAMENTO,
        "price": 75,
        "slot": Equipment.EquipmentSlot.ACESSORIO,
        "stats": { "potencia": 5 },
        "level_required": 1
    },
    "chip_precisao": {
        "id": "chip_precisao",
        "name": "Chip de Precisão I",
        "description": "+5 Precisão.",
        "type": Item.ItemType.EQUIPAMENTO,
        "price": 75,
        "slot": Equipment.EquipmentSlot.ACESSORIO,
        "stats": { "precisao": 5 },
        "level_required": 1
    },
    "chip_nucleo": {
        "id": "chip_nucleo",
        "name": "Chip de Núcleo I",
        "description": "+5 Núcleo.",
        "type": Item.ItemType.EQUIPAMENTO,
        "price": 75,
        "slot": Equipment.EquipmentSlot.ACESSORIO,
        "stats": { "nucleo": 5 },
        "level_required": 1
    },
    "dispositivo_criptografado": {
        "id": "dispositivo_criptografado",
        "name": "Dispositivo Criptografado",
        "description": "Contém dados misteriosos. Requer drive para abrir.",
        "type": Item.ItemType.ESPECIAL,
        "price": 0,
        "stackable": false
    }
}


static func get_item(item_id: String) -> Item:
    var data = ITEMS.get(item_id)
    if data:
        return Item.new(data)
    return null


static func get_all_items() -> Array[Item]:
    return ITEMS.values().map(func(d): return Item.new(d))


static func is_special(item_id: String) -> bool:
    var data = ITEMS.get(item_id)
    return data and data.type == Item.ItemType.ESPECIAL
```

---

### inventory_manager.gd

```gdscript
class_name InventoryManager extends Node

signal item_added(item_id: String, amount: int)
signal item_removed(item_id: String, amount: int)
signal equipment_changed(slot: int, item: Equipment)

const MAX_EQUIPMENT_SLOTS: int = 3

var consumibles: Dictionary = {}
var equipment: Array[Equipment] = []
var special_items: Array[String] = []


func _ready() -> void:
    equipment.resize(MAX_EQUIPMENT_SLOTS)
    equipment.fill(null)


func has_item(item_id: String) -> bool:
    if consumibles.has(item_id):
        return consumibles[item_id] > 0
    return item_id in special_items


func get_count(item_id: String) -> int:
    return consumibles.get(item_id, 0)


func add_item(item_id: String, amount: int = 1) -> void:
    if ItemDatabase.is_special(item_id):
        if item_id not in special_items:
            special_items.append(item_id)
            item_added.emit(item_id, 1)
        return

    var current: int = consumibles.get(item_id, 0)
    consumibles[item_id] = current + amount
    item_added.emit(item_id, amount)


func remove_item(item_id: String, amount: int = 1) -> bool:
    if item_id in special_items:
        special_items.erase(item_id)
        item_removed.emit(item_id, 1)
        return true

    var current: int = consumibles.get(item_id, 0)
    if current >= amount:
        consumibles[item_id] = current - amount
        item_removed.emit(item_id, amount)
        return true
    return false


func equip(slot: int, item: Equipment) -> void:
    if slot < 0 or slot >= MAX_EQUIPMENT_SLOTS:
        return

    var old: Equipment = equipment[slot]
    if old:
        unequip(slot)

    equipment[slot] = item
    equipment_changed.emit(slot)


func unequip(slot: int) -> void:
    if slot < 0 or slot >= MAX_EQUIPMENT_SLOTS:
        return

    var item: Equipment = equipment[slot]
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


func use_consumable(item_id: String) -> bool:
    if not has_item(item_id):
        return false

    var item: Item = ItemDatabase.get_item(item_id)
    if item.type != Item.ItemType.CONSUMIVEL:
        return false

    if not remove_item(item_id, 1):
        return false

    _apply_effect(item.effect)
    return true


func _apply_effect(effect: Dictionary) -> void:
    if effect.has("hp"):
        GameManager.heal(effect.hp)
    if effect.has("energia"):
        GameManager.restore_energia(effect.energia)
    if effect.has("escudo"):
        GameManager.restore_escudo(effect.escudo)
```

---

### workshop_manager.gd (Oficina)

```gdscript
class_name WorkshopManager extends Node

const IMPROVE_COSTS = {
    1: 100,
    2: 150,
    3: 200,
    4: 300,
    5: 500
}

var attribute_levels: Dictionary = {
    "potencia": 1,
    "precisao": 1,
    "nucleo": 1,
    "manobra": 1,
    "densidade": 1
}

var attribute_bonuses: Dictionary = {
    "potencia": 5,
    "precisao": 3,
    "nucleo": 10,
    "manobra": 2,
    "densidade": 10
}


func get_improve_cost(attr: String, current_level: int) -> int:
    return IMPROVE_COSTS.get(current_level, 500)


func can_improve(attr: String) -> bool:
    var level: int = attribute_levels.get(attr, 1)
    var cost: int = get_improve_cost(attr, level)
    return level < 5 and GameManager.spend_scraps(cost)


func improve(attr: String) -> bool:
    var level: int = attribute_levels.get(attr, 1)

    if level >= 5:
        return false

    var cost: int = get_improve_cost(attr, level)

    if not GameManager.spend_scraps(cost):
        return false

    attribute_levels[attr] = level + 1
    _apply_bonus(attr)
    return true


func _apply_bonus(attr: String) -> void:
    var bonus: int = attribute_bonuses.get(attr, 5)
    var current_level: int = attribute_levels.get(attr, 1)
    var attr_key: String = attr.to_lower()

    match attr:
        "potencia":
            GameManager.player_data.atributos["potencia"] += bonus
        "precisao":
            GameManager.player_data.atributos["precisao"] += bonus
        "nucleo":
            GameManager.player_data.max_energia += bonus
        "manobra":
            GameManager.player_data.atributos["manobra"] += 2
        "densidade":
            GameManager.player_data.max_escudo += bonus


func get_attribute_level(attr: String) -> int:
    return attribute_levels.get(attr, 1)
```

---

### shop.gd

```gdscript
class_name Shop

var items: Array[Item] = []
var is_open: bool = false


func _ready() -> void:
    _load_shop_items()


func _load_shop_items() -> void:
    items = [
        ItemDatabase.get_item("kit_medico"),
        ItemDatabase.get_item("granada"),
        ItemDatabase.get_item("chip_potencia"),
        ItemDatabase.get_item("chip_precisao"),
        ItemDatabase.get_item("chip_nucleo"),
        ItemDatabase.get_item("drive_leitura")
    ]


func buy(item_id: String) -> bool:
    var scraps: int = GameManager.get_scraps()
    var item: Item = ItemDatabase.get_item(item_id)

    if not item:
        return false

    if scraps < item.price:
        return false

    if GameManager.spend_scraps(item.price):
        InventoryManager.add_item(item_id)
        return true

    return false


func sell(item_id: String) -> bool:
    if not InventoryManager.has_item(item_id):
        return false

    var item: Item = ItemDatabase.get_item(item_id)
    var sell_price: int = item.price / 2

    if InventoryManager.remove_item(item_id):
        GameManager.add_scraps(sell_price)
        return true

    return false
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Item como resource
- [ ] ItemDatabase com todos os itens
- [ ] InventoryManager
- [ ] WorkshopManager (Oficina)
- [ ] Shop com buy/sell
- [ ] UI de inventário

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_007_missoes|TASK 007: MISSÕES]]

---

## Dependentes

- [[task_009_narrativa|TASK 009: NARRATIVA]]

---

## Próximo

[[task_009_narrativa|AVANÇAR → Task 009]]