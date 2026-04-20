# TASK 005: CHAT - PAINEL

## Objetivo
Implementar o sistema de chat com OmniChat e diálogos dos NPCs.

## Estimativa: 4-5 horas

---

## Conteúdo

### Configuração do OmniChat

```gdscript
# chat_manager.gd
extends Node

var chat: OmniChat
var contacts: Dictionary = {}


func _ready() -> void:
    _setup_chat()
    _setup_contacts()


func _setup_chat() -> void:
    chat = get_node("/root/OmniChat")

    chat.set_contacts([
        { "id": "reyes", "name": "Comandante Reyes", "position": "Torre de Comando" },
        { "id": "chen", "name": "Sgt. Chen", "position": "Arena" },
        { "id": "vasquez", "name": "Dr. Vasquez", "position": "Laboratório" }
    ])

    chat.set_ui_config({
        "width": 300,
        "show_typing": false,
        "show_timestamps": true,
        "typewriter_speed": 0.03
    })


func _setup_contacts() -> void:
    contacts["reyes"] = {
        "greeting": "Olá, soldado!",
        "status": "away"
    }
    contacts["chen"] = {
        "greeting": "Precisa de treino?",
        "status": "online"
    }
    contacts["vasquez"] = {
        "greeting": "Interessante...",
        "status": "away"
    }
```

---

### Estrutura de Diálogo

```gdscript
# chat_dialogue.gd
extends Resource
class_name ChatDialogue

@export var contact_id: String
@export var contact_name: String
@export var messages: Array[ChatMessage]
@export var choices: Dictionary = {}


func _init() -> void:
    pass


func get_message(index: int) -> ChatMessage:
    if index >= 0 and index < messages.size():
        return messages[index]
    return null


func get_next_message(current: int) -> int:
    return current + 1


func has_choices() -> bool:
    return choices.size() > 0


func get_choices() -> Array:
    return choices.values()
```

### ChatMessage

```gdscript
# chat_message.gd
class_name ChatMessage
extends RefCounted

var id: String
var text: String
var sender: String
var type: MessageType = MessageType.TEXT
var choices: Array[Dictionary] = []
var next: String = ""

enum MessageType { TEXT, CHOICE, SYSTEM }


func _init(t: String, s: String, type_: MessageType = MessageType.TEXT) -> void:
    text = t
    sender = s
    type = type_
```

---

### Diálogos dos NPCs

#### reyes.dialogue

```gdscript
# res://dialogues/reyes.dialogue
extends ChatDialogue


func _init() -> void:
    contact_id = "reyes"
    contact_name = "Comandante Reyes"

    messages = [
        ChatMessage.new("Você está operacional, #2227. É isso que importa.", "Reyes"),
        ChatMessage.new("Esse erro no driver óptico... é só ruído de dados.", "Reyes"),
        ChatMessage.new("Você não precisa 'enxergar' para processar comandos, precisa?", "Reyes"),
        ChatMessage.new("Foque no que você consegue fazer, soldado.", "Reyes")
    ]

    choices = {
        "missoes": { "text": "Missões", "next": "node_missoes" },
        "status": { "text": "Como estou?", "next": "node_status" },
        "sair": { "text": "Sair", "next": "exit" }
    }
```

#### chen.dialogue

```gdscript
# res://dialogues/chen.dialogue
extends ChatDialogue


func _init() -> void:
    contact_id = "chen"
    contact_name = "Sgt. Chen"

    messages = [
        ChatMessage.new("E aí, #2227. Dormiu bem?", "Chen"),
        ChatMessage.new("Ótimo. Precisamos conversar.", "Chen"),
        ChatMessage.new("Quer treinar? Algo sobre combate.", "Chen")
    ]

    choices = {
        "treino": { "text": "Quero treinar", "next": "node_treino" },
        "status": { "text": "Como estou?", "next": "node_status" },
        "sair": { "text": "Sair", "next": "exit" }
    }
```

#### vasquez.dialogue

```gdscript
# res://dialogues/vasquez.dialogue
extends ChatDialogue


func _init() -> void:
    contact_id = "vasquez"
    contact_name = "Dr. Vasquez"

    messages = [
        ChatMessage.new("Você é um bug ambulante, seu código fonte é muito antigo, sabia?", "Vasquez"),
        ChatMessage.new("Driver diz 'incompatível' talvez você não devesse estar aqui.", "Vasquez"),
        ChatMessage.new("Mas aqui está você. Funcionando ou quase.", "Vasquez"),
        ChatMessage.new("Não pergunte como. É milagre da engenharia.", "Vasquez")
    ]

    choices = {
        "anomalia": { "text": "Sobre a anomalia", "next": "node_anomalia" },
        "pesquisa": { "text": "O que pesquisa?", "next": "node_pesquisa" },
        "sair": { "text": "Sair", "next": "exit" }
    }
```

---

### Sistema de Tempo Real

```gdscript
# chat_realtime.gd
extends Node

var chat: OmniChat
var terminal: Control


func _ready() -> void:
    chat = get_node("/root/OmniChat")
    terminal = get_node("/root/Terminal")

    _connect_signals()


func _connect_signals() -> void:
    chat.message_received.connect(_on_message_received)
    terminal.conversation_opened.connect(_on_conversation_opened)


func _on_message_received(contact: String, message: String) -> void:
    var panel = get_tree().root.get_node("ChatPanel")
    if panel:
        panel.update_message(contact, message)


func _on_conversation_opened(contact: String) -> void:
    var panel = get_tree().root.get_node("ChatPanel")
    if panel:
        panel.set_online(contact, true)
```

---

### Menu de Escolhas (Terminal)

```gdscript
# choice_menu.gd
extends Control

var choices: Array[Dictionary] = []
var selected_index: int = 0
var on_select: Callable


func _ready() -> void:
    _setup_ui()


func _setup_ui() -> void:
    var container = VBoxContainer.new()
    container.set_anchors_and_offsets(ControlANCHORS_FULL_RECT)
    add_child(container)


func _process_input() -> void:
    if Input.is_action_just_pressed("ui_up"):
        selected_index = max(0, selected_index - 1)
        _update_selection()

    if Input.is_action_just_pressed("ui_down"):
        selected_index = min(choices.size() - 1, selected_index + 1)
        _update_selection()

    if Input.is_action_just_pressed("ui_accept"):
        _confirm_selection()


func show(choices: Array, callback: Callable) -> void:
    self.choices = choices
    self.on_select = callback
    selected_index = 0
    _update_options()


func _update_options() -> void:
    for child in get_children():
        child.queue_free()

    for i in range(choices.size()):
        var option = choices[i]
        var label = Label.new()
        label.text = "[%d] %s" % [i + 1, option.text]

        if i == selected_index:
            label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.2))
        else:
            label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))

        add_child(label)


func _update_selection() -> void:
    _update_options()


func _confirm_selection() -> void:
    if selected_index < choices.size():
        var choice = choices[selected_index]
        on_select.call(choice.id)


func hide() -> void:
    queue_free()
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] OmniChat configurado
- [ ] Contatos (Reyes, Chen, Vasquez)
- [ ] Diálogos carregar
- [ ] Mensagens em tempo real
- [ ] Menu de escolhas no terminal

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_004_terminal_layout|TASK 004: TERMINAL - LAYOUT]]

---

## Dependentes

- [[task_006_combate|TASK 006: COMBATE - SISTEMA]]

---

## Próximo

[[task_006_combate|AVANÇAR → Task 006]]