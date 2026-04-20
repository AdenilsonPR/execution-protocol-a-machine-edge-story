# TASK 004: TERMINAL - LAYOUT

## Objetivo
Configurar o layout do terminal com chat panel lateral e abas.

## Estimativa: 3-4 horas

---

## Conteúdo

### Layout da Tela

```
┌─────────────────────────────────────────────┐
│              TERMINAL (70%)                  │
│                                             │
│  > help                                     │
│                                             │
├─────────────────────────────────────────────┤
│ [MAPA+COMBATE] [LOJA+INV] [MISSOES] [OFICINA+STATUS] [CHAT]    │
├──────────────┬──────────────────────────────┤
│     CHAT   │                              │
│ [Reyes] ●  │                              │
│ [Chen]     │                              │
│ [Vasquez]  │                              │
└──────────────┴──────────────────────────────┘
```

---

### terminal.tscn

```gdscript
# Cena principal do terminal
extends Control

var input_line: LineEdit
var output_area: ScrollContainer
var output_label: Label
var tab_container: TabContainer
var chat_panel: Control


func _ready() -> void:
    _setup_ui()
    _connect_signals()


func _setup_ui() -> void:
    var main = VBoxContainer.new()
    main.set_anchors_and_offsets(ControlANCHORS_FULL_RECT)
    main.add_theme_constant_override("separation", 0)
    add_child(main)

    var terminal_container = VBoxContainer.new()
    terminal_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

    output_area = ScrollContainer.new()
    output_area.size_flags_vertical = Control.SIZE_EXPAND_FILL

    output_label = Label.new()
    output_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    output_label.text = "> Execution Protocol v0.1\n\n"

    output_area.add_child(output_label)
    terminal_container.add_child(output_area)

    input_line = LineEdit.new()
    input_line.placeholder_text = "> Digite um comando..."
    input_line.size_flags_horizontal = Control.SIZE_EXPAND_FILL

    terminal_container.add_child(input_line)

    main.add_child(terminal_container)

    tab_container = _create_tab_container()
    main.add_child(tab_container)

    var split = HSplitContainer.new()
    split.size_flags_vertical = Control.SIZE_EXPAND_FILL

    chat_panel = _create_chat_panel()
    split.add_child(chat_panel)

    main.add_child(split)


func _create_tab_container() -> TabContainer:
    var tabs = TabContainer.new()
    tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL

    var map_combat_view = _create_map_combat_tab()
    var shop_inv_view = _create_shop_inventory_tab()
    var missions_view = _create_missions_tab()
    var workshop_status_view = _create_workshop_status_tab()
    var chat_panel = _create_chat_panel()

    tabs.add_child(map_combat_view)
    tabs.add_child(shop_inv_view)
    tabs.add_child(missions_view)
    tabs.add_child(workshop_status_view)
    tabs.add_child(chat_panel)

    tabs.set_tab_title(0, "MAPA+COMBATE")
    tabs.set_tab_title(1, "LOJA+INV")
    tabs.set_tab_title(2, "MISSOES")
    tabs.set_tab_title(3, "OFICINA+STATUS")
    tabs.set_tab_title(4, "CHAT")

    return tabs


func _create_map_combat_tab() -> Control:
    var panel = PanelContainer.new()
    panel.name = "MapCombatPanel"

    var vbox = VBoxContainer.new()
    vbox.name = "MapCombatContent"

    var title = Label.new()
    title.text = "MAPA - BASE DELTA-7"
    title.name = "TitleLabel"
    vbox.add_child(title)

    var sep = HSeparator.new()
    vbox.add_child(sep)

    var map_label = Label.new()
    map_label.name = "MapLabel"
    map_label.text = "[N] ████ ████ ████\n     BLOQ TORRE ARENA\n[C] ████ ████ ████\n     BASE LAB PERI\n[S] ████ ████ ████\n     RES BLOQ BLOQ"
    vbox.add_child(map_label)

    var sep2 = HSeparator.new()
    sep2.name = "CombatSeparator"
    sep2.visible = false
    vbox.add_child(sep2)

    var combat_status = Label.new()
    combat_status.name = "CombatStatus"
    combat_status.visible = false
    combat_status.text = "COMBATE ATIVO\n...\n[1] 👾 Perseguidor ████░░ 40/50\n[2] 👾 Perseguidor █████░ 50/50"
    vbox.add_child(combat_status)

    panel.add_child(vbox)
    return panel


func _create_shop_inventory_tab() -> Control:
    var panel = PanelContainer.new()
    panel.name = "ShopInventoryPanel"

    var hbox = HBoxContainer.new()
    hbox.name = "ShopInventoryContent"

    var shop_col = VBoxContainer.new()
    shop_col.name = "ShopColumn"

    var shop_title = Label.new()
    shop_title.text = "LOJA"
    shop_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    shop_col.add_child(shop_title)

    var shop_list = VBoxContainer.new()
    shop_list.name = "ShopList"
    shop_col.add_child(shop_list)

    hbox.add_child(shop_col)

    var inv_col = VBoxContainer.new()
    inv_col.name = "InventoryColumn"

    var inv_title = Label.new()
    inv_title.text = "INVENTÁRIO"
    inv_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    inv_col.add_child(inv_title)

    var inv_list = VBoxContainer.new()
    inv_list.name = "InventoryList"
    inv_col.add_child(inv_list)

    hbox.add_child(inv_col)

    panel.add_child(hbox)
    return panel


func _create_missions_tab() -> Control:
    var panel = PanelContainer.new()
    panel.name = "MissionsPanel"

    var vbox = VBoxContainer.new()
    vbox.name = "MissionsContent"

    var title = Label.new()
    title.text = "MISSÕES"
    vbox.add_child(title)

    var missions_list = VBoxContainer.new()
    missions_list.name = "MissionsList"
    vbox.add_child(missions_list)

    panel.add_child(vbox)
    return panel


func _create_workshop_status_tab() -> Control:
    var panel = PanelContainer.new()
    panel.name = "WorkshopStatusPanel"

    var hbox = HBoxContainer.new()
    hbox.name = "WorkshopStatusContent"

    var workshop_col = VBoxContainer.new()
    workshop_col.name = "WorkshopColumn"

    var workshop_title = Label.new()
    workshop_title.text = "OFICINA"
    workshop_col.add_child(workshop_title)

    var attr_list = VBoxContainer.new()
    attr_list.name = "AttributeList"
    workshop_col.add_child(attr_list)

    hbox.add_child(workshop_col)

    var status_col = VBoxContainer.new()
    status_col.name = "StatusColumn"

    var status_title = Label.new()
    status_title.text = "STATUS"
    status_col.add_child(status_title)

    var status_bars = VBoxContainer.new()
    status_bars.name = "StatusBars"
    status_col.add_child(status_bars)

    hbox.add_child(status_col)

    panel.add_child(hbox)
    return panel


func _create_chat_panel() -> Control:
    var panel = PanelContainer.new()
    panel.custom_minimum_size.x = 300

    var vbox = VBoxContainer.new()

    var header = Label.new()
    header.text = "CHAT"
    header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(header)

    var sep = HSeparator.new()
    vbox.add_child(sep)

    var list = VBoxContainer.new()

    var btn_reyes = Button.new()
    btn_reyes.text = "[Reyes] ●"
    btn_reyes.pressed.connect(_on_reyes_pressed)
    list.add_child(btn_reyes)

    var btn_chen = Button.new()
    btn_chen.text = "[Chen]"
    btn_chen.pressed.connect(_on_chen_pressed)
    list.add_child(btn_chen)

    var btn_vasquez = Button.new()
    btn_vasquez.text = "[Vasquez]"
    btn_vasquez.pressed.connect(_on_vasquez_pressed)
    list.add_child(btn_vasquez)

    vbox.add_child(list)

    var msg_preview = Label.new()
    msg_preview.text = "\nSelecione um NPC para chat."
    msg_preview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vbox.add_child(msg_preview)

    panel.add_child(vbox)
    return panel


func _create_chat_panel() -> Control:
    var panel = PanelContainer.new()
    panel.custom_minimum_size.x = 300

    var vbox = VBoxContainer.new()

    var header = Label.new()
    header.text = "CHAT"
    header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    vbox.add_child(header)

    var sep = HSeparator.new()
    vbox.add_child(sep)

    var list = VBoxContainer.new()

    var btn_reyes = Button.new()
    btn_reyes.text = "[Reyes] ●"
    btn_reyes.pressed.connect(_on_reyes_pressed)
    list.add_child(btn_reyes)

    var btn_chen = Button.new()
    btn_chen.text = "[Chen]"
    btn_chen.pressed.connect(_on_chen_pressed)
    list.add_child(btn_chen)

    var btn_vasquez = Button.new()
    btn_vasquez.text = "[Vasquez]"
    btn_vasquez.pressed.connect(_on_vasquez_pressed)
    list.add_child(btn_vasquez)

    vbox.add_child(list)

    var msg_preview = Label.new()
    msg_preview.text = "\nSelecione um NPC para chat."
    msg_preview.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    vbox.add_child(msg_preview)

    panel.add_child(vbox)
    return panel


func _connect_signals() -> void:
    input_line.text_submitted.connect(_on_input_submitted)
    BattleManager.battle_started.connect(_on_battle_started)
    BattleManager.battle_ended.connect(_on_battle_ended)


func _on_battle_started(enemies: Array) -> void:
    var combat_tab = tab_container.get_node("CombatPanel")
    if combat_tab:
        combat_tab.visible = true
        _update_combat_display(enemies)
    tab_container.current_tab = 6


func _on_battle_ended(victory: bool) -> void:
    var combat_tab = tab_container.get_node("CombatPanel")
    if combat_tab:
        combat_tab.visible = false
    tab_container.current_tab = 0


func _update_combat_display(enemies: Array) -> void:
    var combat_tab = tab_container.get_node("CombatPanel")
    if not combat_tab:
        return

    var enemy_list = combat_tab.get_node("EnemyList")
    enemy_list.clear()

    for i in range(enemies.size()):
        var enemy = enemies[i]
        var enemy_label = Label.new()
        enemy_label.text = "[%d] %s  ████████░░  %d/%d" % [
            i + 1, enemy.id, enemy.hp, enemy.max_hp
        ]
        enemy_list.add_child(enemy_label)


func _on_input_submitted(text: String) -> void:
    input_line.clear()
    _process_command(text)


func _process_command(text: String) -> void:
    text = text.strip_edges()
    if text.is_empty():
        return

    output_label.text += "> " + text + "\n"

    var parts = text.split(" ", false, 1)
    var cmd = parts[0]
    var args: Array = []

    if parts.size() > 1:
        args = parts[1].split(" ")

    var context = CommandContext.new(cmd, args, GameManager.player_data)
    var result = CommandExecutor.execute(cmd, args)

    if result.success:
        output_label.text += result.message + "\n"

    output_area.scroll_vertical = output_label.get_line_count()


func _on_reyes_pressed() -> void:
    pass


func _on_chen_pressed() -> void:
    pass


func _on_vasquez_pressed() -> void:
    pass
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Terminal com input e output
- [ ] Abas (Mapa, Status, Loja, Missões, Inventário, Oficina)
- [ ] Chat panel sempre visível (30%)
- [ ] Botões do chat desabilitados
- [ ] Comandos registrados

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_003_terminal_comandos|TASK 003: TERMINAL - COMANDOS]]

---

## Dependentes

- [[task_005_chat_painel|TASK 005: CHAT - PAINEL]]

---

## Próximo

[[task_005_chat_painel|AVANÇAR → Task 005]]