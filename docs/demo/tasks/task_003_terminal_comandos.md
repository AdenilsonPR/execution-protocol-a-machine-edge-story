# TASK 003: TERMINAL - COMANDOS

## Objetivo
Implementar todos os comandos do terminal.

## Estimativa: 4-6 horas

---

## Conteúdo

### command_base.gd (Base)

```gdscript
class_name CommandBase extends RefCounted

var id: String = ""
var description: String = ""
var aliases: Array[String] = []
var requires_args: bool = false
var min_args: int = 0
var max_args: int = 0


func _init() -> void:
    pass


func execute(context: CommandContext) -> CommandOutput:
    return CommandOutput.new(false, "Comando não implementado")


func get_usage() -> String:
    return id


func validate_args(args: Array[String]) -> bool:
    if requires_args and args.is_empty():
        return false
    if args.size() < min_args or args.size() > max_args:
        return false
    return true
```

### command_context.gd

```gdscript
class_name CommandContext extends RefCounted

var command: String
var args: Array[String]
var player: PlayerData


func _init(cmd: String, a: Array[String], p: PlayerData) -> void:
    command = cmd
    args = a
    player = p
```

### command_output.gd

```gdscript
class_name CommandOutput extends RefCounted

var success: bool
var message: String
var additional: Dictionary = {}


func _init(s: bool, m: String, a: Dictionary = {}) -> void:
    success = s
    message = m
    additional = a
```

---

### help_command.gd

```gdscript
class_name HelpCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "help"
    description = "Mostra lista de comandos"
    add_alias("h")
    add_alias("?")


func execute(context: CommandContext) -> CommandOutput:
    var output: String = "Comandos disponiveis:\n"
    output += "  help     - Mostra esta lista\n"
    output += "  status   - Mostra seu status\n"
    output += "  clear    - Limpa o terminal\n"
    output += "  mission  - Mostra missao atual\n"
    output += "  missions - Lista todas as missoes\n"
    output += "  shop    - Abre a loja\n"
    output += "  chat    - Abre chat com NPC\n"
    output += "  inventory - Mostra inventario\n"
    output += "  save    - Salva o jogo\n"
    output += "  load    - Carrega um save\n"
    return CommandOutput.new(true, output)
```

---

### status_command.gd

```gdscript
class_name StatusCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "status"
    description = "Mostra status do jogador"
    add_alias("s")


func execute(context: CommandContext) -> CommandOutput:
    var p: PlayerData = GameManager.player_data

    var hp_bar: String = _create_bar(p.hp, p.max_hp, 10)
    var energia_bar: String = _create_bar(p.energia, p.max_energia, 10)
    var escudo_bar: String = _create_bar(p.escudo, p.max_escudo, 10)

    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║       UNIDADE DE GUERRA #%s          ║\n" % p.unit_id
    output += "╠══════════════════════════════════════╣\n"
    output += "║ HP:      %s %d/%d    ║\n" % [hp_bar, p.hp, p.max_hp]
    output += "║ ENERGIA: %s %d/%d   ║\n" % [energia_bar, p.energia, p.max_energia]
    output += "║ ESCUDO:  %s %d/%d    ║\n" % [escudo_bar, p.escudo, p.max_escudo]
    output += "╠══════════════════════════════════════╣\n"
    output += "║ ATRIBUTOS:                          ║\n"

    for attr in p.atributos.keys():
        var val: int = p.atributos[attr]
        var bar: String = _create_bar(val, 30, 5)
        output += "║   %s:   %s %d           ║\n" % [attr.capitalize(), bar, val]

    output += "╠══════════════════════════════════════╣\n"
    output += "║ SCRAPS:     %s              ║\n" % _pad_number(p.scraps)
    output += "║ NIVEL:      %s               ║\n" % _pad_number(p.level)
    output += "╚══════════════════════════════════════╝"

    return CommandOutput.new(true, output)


func _create_bar(current: int, max_val: int, size: int) -> String:
    var filled: int = int(float(current) / max_val * size)
    return "█".repeat(filled) + "░".repeat(size - filled)


func _pad_number(n: int) -> String:
    return str(n).pad_zeros(5)
```

---

### clear_command.gd

```gdscript
class_name ClearCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "clear"
    description = "Limpa o terminal"
    add_alias("cls")
    add_alias("cl")


func execute(context: CommandContext) -> CommandOutput:
    var terminal = get_node("/root/Terminal")
    terminal.clear()
    return CommandOutput.new(true, "")
```

---

### mission_command.gd

```gdscript
class_name MissionCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "mission"
    description = "Mostra missao atual"
    add_alias("m")


func execute(context: CommandContext) -> CommandOutput:
    if not MissionManager.current_mission:
        return CommandOutput.new(true, "Nenhuma missao ativa.")

    var m: Mission = MissionManager.current_mission
    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║ MISSAO ATUAL: %s       ║\n" % m.title.left(24)
    output += "╠══════════════════════════════════════╣\n"
    output += "║ OBJETIVO: %s              ║\n" % m.objective.left(26)
    output += "║ PROGRESSO: %s             ║\n" % _get_progress_bar(m)
    output += "║ RECOMPENSA: %d scraps           ║\n" % m.recompensa
    output += "╚══════════════════════════════════════╝"
    return CommandOutput.new(true, output)


func _get_progress_bar(m: Mission) -> String:
    return "███░░░░░ " + str(m.progress) + "/" + str(m.target)
```

---

### missions_command.gd

```gdscript
class_name MissionsCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "missions"
    description = "Lista todas as missoes"


func execute(context: CommandContext) -> CommandOutput:
    var all: Array = MissionDatabase.get_all_missions()
    var output: String = ""

    for i in range(all.size()):
        var m: Mission = all[i]
        var status: String = "?"
        if MissionManager.is_mission_completed(m.id):
            status = "✓"
        elif MissionManager.has_mission(m.id):
            status = ">"

        output += "[%d] %s %s\n" % [i + 1, status, m.title]

    return CommandOutput.new(true, output)
```

---

### shop_command.gd

```gdscript
class_name ShopCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "shop"
    description = "Abre a loja"
    add_alias("store")


func execute(context: CommandContext) -> CommandOutput:
    var scraps: int = GameManager.get_scraps()
    var items: Array = ShopDatabase.get_items()

    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║         LOJA - BASE DELTA-7          ║\n"
    output += "╠══════════════════════════════════════╣\n"
    output += "║ SCRAPS:  %s                         ║\n" % str(scraps).pad_zeros(5)
    output += "╠══════════════════════════════════════╣\n"

    for i in range(items.size()):
        var item = items[i]
        output += "║ [%d] %s - %d scr     ║\n" % [i + 1, item.name.left(18), item.preco]

    output += "╠══════════════════════════════════════╣\n"
    output += "║ USE: buy [numero]                   ║\n"
    output += "║ EXIT: exit                         ║\n"
    output += "╚══════════════════════════════════════╝"

    GameManager.set_state(GameManager.GameState.SHOP)
    return CommandOutput.new(true, output, { "mode": "shop" })


func _handle_shop_input(input: String) -> CommandOutput:
    var parts: Array = input.split(" ")
    var action: String = parts[0]

    match action:
        "buy":
            return _buy_item(parts[1])
        "exit":
            GameManager.set_state(GameManager.GameState.PLAYING)
            return CommandOutput.new(true, "Loja fechada.")

    return CommandOutput.new(false, "Comando invalido.")


func _buy_item(item_index: String) -> CommandOutput:
    var index: int = int(item_index) - 1
    var items: Array = ShopDatabase.get_items()

    if index < 0 or index >= items.size():
        return CommandOutput.new(false, "Item invalido.")

    var item = items[index]
    if GameManager.spend_scraps(item.preco):
        InventoryManager.add_item(item.id)
        return CommandOutput.new(true, "Comprado: %s" % item.name)

    return CommandOutput.new(false, "Scraps insuficientes.")
```

---

### chat_command.gd

```gdscript
class_name ChatCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "chat"
    description = "Abre chat com NPC"
    add_alias("msg")


func execute(context: CommandContext) -> CommandOutput:
    if context.args.is_empty():
        return CommandOutput.new(true, _get_npc_list())

    var npc_id: String = context.args[0]
    var valid_npcs: Array = ["reyes", "chen", "vasquez"]

    if npc_id not in valid_npcs:
        return CommandOutput.new(false, "NPC invalido. Usage: chat [reyes|chen|vasquez]")

    return _open_chat(npc_id)


func _get_npc_list() -> String:
    var output: String = "NPCs disponiveis:\n"
    output += "  reyes    - Comandante Reyes\n"
    output += "  chen    - Sgt. Chen\n"
    output += "  vasquez  - Dr. Vasquez\n"
    output += "\nUsage: chat [npc]"
    return output


func _open_chat(npc_id: String) -> CommandOutput:
    var chat = get_node("/root/OmniChat")
    chat.open_conversation(npc_id)

    var dialogue: Resource = load("res://dialogues/%s.dialogue" % npc_id)
    if dialogue:
        dialogue.start()

    return CommandOutput.new(true, "Conectando com %s..." % npc_id, { "npc": npc_id })
```

---

### inventory_command.gd

```gdscript
class_name InventoryCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "inventory"
    description = "Mostra inventario"
    add_alias("inv")
    add_alias("i")


func execute(context: CommandContext) -> CommandOutput:
    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║         INVENTÁRIO                 ║\n"
    output += "╠══════════════════════════════════════╣\n"
    output += "║ EQUIPAMENTOS:                        ║\n"

    for i in range(InventoryManager.MAX_EQUIPMENT_SLOTS):
        var item: Equipment = InventoryManager.get_equipped(i)
        if item:
            output += "║   [%d] %s              ║\n" % [i + 1, item.name]
        else:
            output += "║   [%d] --- VAZIO ---             ║\n" % [i + 1]

    output += "╠══════════════════════════════════════╣\n"
    output += "║ ITENS:                           ║\n"

    for item_name in InventoryManager.consumibles.keys():
        var count: int = InventoryManager.get_item_count(item_name)
        output += "║   %s x%d                      ║\n" % [item_name, count]

    if InventoryManager.special_items.size() > 0:
        output += "╠══════════════════════════════════════╣\n"
        output += "║ ITENS ESPECIAIS:                   ║\n"
        for item in InventoryManager.special_items:
            output += "║   %s                        ║\n" % item

    output += "╚══════════════════════════════════════╝"
    return CommandOutput.new(true, output)
```

---

### save_command.gd

```gdscript
class_name SaveCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "save"
    description = "Salva o jogo"


func execute(context: CommandContext) -> CommandOutput:
    if context.args.is_empty():
        return _show_save_slots()

    var slot: String = context.args[0]

    if slot == "quick":
        return _save_game("quick")

    return _save_game(slot)


func _show_save_slots() -> CommandOutput:
    var saves: Array = SaveSystem.get_slots()

    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║            SAVE GAME               ║\n"
    output += "╠══════════════════════════════════════╣\n"

    for i in range(saves.size()):
        var slot = saves[i]
        output += "║ Slot %d: %s  %s    ║\n" % [i + 1, slot.type, slot.date]

    output += "╠══════════════════════════════════════╣\n"
    output += "║ USE: save [slot]                     ║\n"
    output += "║ QUICK: save quick                    ║\n"
    output += "╚══════════════════════════════════════╝"
    return CommandOutput.new(true, output)


func _save_game(slot: String) -> CommandOutput:
    var success: bool = SaveSystem.save(slot, GameManager.player_data, MissionManager.current_mission)

    if success:
        return CommandOutput.new(true, "Jogo salvo no Slot %s" % slot)

    return CommandOutput.new(false, "Erro ao salvar.")
```

---

### load_command.gd

```gdscript
class_name LoadCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "load"
    description = "Carrega um save"


func execute(context: CommandContext) -> CommandOutput:
    if context.args.is_empty():
        return _show_load_slots()

    var slot: String = context.args[0]
    return _load_game(slot)


func _show_load_slots() -> CommandOutput:
    var saves: Array = SaveSystem.get_slots()

    var output: String = "╔══════════════════════════════════════╗\n"
    output += "║           LOAD GAME                 ║\n"
    output += "╠══════════════════════════════════════╣\n"

    for i in range(saves.size()):
        var slot = saves[i]
        if slot.is_empty():
            output += "║ Slot %d: [---VAZIO---]           ║\n" % [i + 1]
        else:
            output += "║ Slot %d: %s  %s    ║\n" % [i + 1, slot.type, slot.date]

    output += "╠══════════════════════════════════════╣\n"
    output += "║ USE: load [slot]                    ║\n"
    output += "╚══════════════════════════════════════╝"
    return CommandOutput.new(true, output)


func _load_game(slot: String) -> CommandOutput:
    var data = SaveSystem.load(slot)

    if data:
        GameManager.player_data = data.player
        MissionManager.start_mission(data.mission)
        return CommandOutput.new(true, "Jogo carregado do Slot %s" % slot)

    return CommandOutput.new(false, "Slot vazio ou invalido.")
```

---

## Registro de Comandos

```gdscript
func _ready() -> void:
    var terminal = get_node("/root/OmniTerminal")

    terminal.register_command(HelpCommand.new())
    terminal.register_command(StatusCommand.new())
    terminal.register_command(ClearCommand.new())
    terminal.register_command(MissionCommand.new())
    terminal.register_command(MissionsCommand.new())
    terminal.register_command(ShopCommand.new())
    terminal.register_command(ChatCommand.new())
    terminal.register_command(InventoryCommand.new())
    terminal.register_command(SaveCommand.new())
    terminal.register_command(LoadCommand.new())
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] HelpCommand
- [ ] StatusCommand
- [ ] ClearCommand
- [ ] MissionCommand
- [ ] MissionsCommand
- [ ] ShopCommand
- [ ] ChatCommand
- [ ] InventoryCommand
- [ ] SaveCommand
- [ ] LoadCommand

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]

---

## Dependentes

- [[task_004_terminal_layout|TASK 004: TERMINAL - LAYOUT]]

---

## Próximo

[[task_004_terminal_layout|AVANÇAR → Task 004]]