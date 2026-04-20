# Sistema de Chat - Especificação de Implementação

## Visão Geral

O sistema de chat da demo funciona da seguinte forma:
- **Chat Panel**: Apenas visualização em tempo real
- **Escolhas**: Aperecem no Terminal, não no Chat
- **Controle**: Todo via terminal (setas + Enter)

---

## Arquitetura

```
┌─────────────────────────────────────────────────────┐
│                     TERMINAL                        │
│  > chat reyes                                     │
│                                                     │
│  ╔═══════════════════════════════════════════════╗  │
│  ║ CONECTADO: COMANDANTE REYES               ║  │
│  ║   > [1] Missoes                          ║  │
│  ║     [2] Como estou?                       ║  │
│  ║     [3] Sair                             ║  │
│  ╚═══════════════════════════════════════════════╝  │
│                                                     │
│  [↑/↓] navegar   [ENTER] selecionar              │
├──────────────────────┬──────────────────────────────┤
│      CHAT PANEL     │                              │
│  ┌──────────────┐  │                              │
│  │ [Reyes] ●   │  │  (mensagens aparecem       │
│  │ [Chen]      │  │   em tempo real aqui)      │
│  │ [Vasquez]    │  │                              │
│  ├──────────────┤  │                              │
│  │ Reyes:      │  │                              │
│  │ "Ola..."    │  │                              │
│  └──────────────┘  │                              │
└──────────────────────┴──────────────────────────────┘
```

---

## Fluxo: Comando chat [npc]

### 1. Jogador digita no terminal

```
> chat reyes
```

### 2. Terminal processa comando

```gdscript
# terminal_command.gd
func _on_chat_command(npc_id: String):
    var chat = get_node("/root/OmniChat")
    
    # Abre conversa no chat (apenas visual)
    chat.open_conversation(npc_id)
    
    # Busca diálogo associated
    var dialogue = load_dialogue(npc_id)
    
    # Exibe primeira fala no TERMINAL
    display_dialogue_in_terminal(dialogue)
    
    # Se há escolhas, exibe no TERMINAL
    if dialogue.has_choices():
        display_choices_in_terminal(dialogue.choices)
```

### 3. Chat Panel atualiza (visual only)

```gdscript
# chat panel - apenas visual
func _on_new_message(contact: String, message: String):
    update_panel_preview(contact, message)
    # NÃO abre chat interaction
    # Apenas mostra que há nova mensagem
```

### 4. Escolhas aparecem no Terminal

```
╔══════════════════════════════════════╗
║ CONECTADO: COMANDANTE REYES         ║
╠══════════════════════════════════════╣
║   > [1] Missoes                   ║
║     [2] Como estou?               ║
║     [3] Sair                      ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

### 5. Jogador seleciona (setas + Enter)

```
# Usuario aperta ENTER na opção 1
→ choice_selected.emit("missoes")

# Terminal escuta
choice_selected.connect(_on_choice_made)

# Processa próxima fala
process_next_dialogue_node("missoes")
```

---

## API: OmniChat

O OmniChat já tem os métodos necessários:

### Métodos Utilizados

```gdscript
# Abre conversa (apenas visual, não interage)
chat.open_conversation(npc_id: String) -> void

# Renderiza mensagem no chat panel
chat.render_text(text: String, speed: float, contact: String) -> void

# Limpa escolhas (não usamos)
chat.clear_choices() -> void
```

### Sinais Utilizados

```gdscript
# Emitido quando nova mensagem chega
signal new_message_received(contact_name: String)

# Emitido quando escolha é feita (no chat original)
# NOVO: Vamos usar para notificar terminal
signal choice_selected(choice_id: String)

# Emitido quando conversa abre
signal chat_opened(contact_name: String)
```

### Métodos a Adicionar/Customizar

```gdscript
# NOVO: Get última mensagem para preview
func get_last_message(npc_id: String) -> String:
    return _conversations[npc_id].last_msg

# NOVO: Lista NPCs disponíveis
func get_contact_list() -> Array:
    return _conversations.keys()

# NOVO: Verifica se tem mensagens não lidas
func has_unread(npc_id: String) -> bool:
    return _conversations[npc_id].unread > 0

# MODIFICADO: Não criar botões clicáveis
# Em vez disso, apenas exibir no terminal
func display_choices(choices: Dictionary) -> void:
    # NÃO criar botões
    # Apenas emitir sinal para terminal exibir
    terminal_display_choices.emit(choices)
```

---

## Integração: Terminal ↔ Chat

### Quando terminal envia comando

```gdscript
# 1. Terminal recebe comando
> chatreyes

# 2. Terminal chama chat
chat.open_conversation("reyes")

# 3. Chat atualiza painel visual
# (mostra que Reyes está online)

# 4. Terminal exibe diálogo
terminal.display_text(dialogue.messages[0])

# 5. Se há escolhas, terminal exibe menu
if dialogue.choices.size() > 0:
    terminal.show_choice_menu(dialogue.choices)
```

### Quando chat recebe mensagem (tempo real)

```gdscript
# Chat recebe nova mensagem
chat.render_text("Olá!", 0.03, "reyes")

# Chat emite sinal
new_message_received.emit("reyes")

# Terminal escuta e atualiza painel lateral
# (apenas visual, não abre interação)
```

---

## Especificação: Chat Panel (Visual Only)

### Layout

```
┌──────────────────┐
│ CHAT             │
├──────────────────┤
│ [Reyes] ●      │ ← Indicador de novas msg
│ [Chen]          │
│ [Vasquez]       │
├──────────────────┤
│ Reyes:          │
│ "Ola, soldado" │
│                  │
└──────────────────┘
```

### Comportamento

| Ação | Comportamento |
|------|---------------|
| Clique no NPC | **NADA** (desabilitado) |
| Nova mensagem | Atualiza preview |
| Hover | **NADA** |
| Qualquer clique | **NADA** |

### Como desabilitar clique

```gdscript
# Em OmniChat customization
func _setup_list_ui():
    # ... código original ...
    
    # Adicionar:
    btn.mouse_filter = Control.MOUSE_FILTER_IGNORE
    # Isso ignora todos os cliques
```

---

## Especificação: Menu de Escolhas (Terminal)

### Appearance

```
╔══════════════════════════════════════╗
║ CONECTADO: COMANDANTE REYES         ║
╠══════════════════════════════════════╣
║ REYES: "Sua primeira missao..."   ║
║                                     ║
║   > [1] Missoes                   ║
║     [2] Como estou?               ║
║     [3] Sair                      ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

### Navegação

| Tecla | Ação |
|-------|-------|
| ↑ | Selecionar opção anterior |
| ↓ | Selecionar próxima opção |
| Enter | Confirmar seleção |
| Escape | Cancelar/Sair |

### Processamento

```gdscript
# 1. Jogador seleciona opção
func _on_enter_pressed():
    var selected_id = current_choices[selected_index]
    choice_selected.emit(selected_id)

# 2. Terminal processa
func _on_choice_made(choice_id: String):
    # Buscar próxima fala baseada na escolha
    var next_node = dialogue.get_next_node(choice_id)
    process_node(next_node)
```

---

## Lista de NPCs

```gdscript
const NPC_LIST := {
    "reyes": {
        "name": "Comandante Reyes",
        "position": "Torre de Comando",
        "dialogue_file": "res://dialogues/reyes_intro.dialogue"
    },
    "chen": {
        "name": "Sgt. Chen",
        "position": "Arena de Treinamento", 
        "dialogue_file": "res://dialogues/chen_intro.dialogue"
    },
    "vasquez": {
        "name": "Dr. Vasquez",
        "position": "Laboratório",
        "dialogue_file": "res://dialogues/vasquez_intro.dialogue"
    }
}
```

---

## Checklist de Implementação

### Terminal
- [ ] Comando `chat [npc]` funcional
- [ ] Menu de escolhas com ↑↓
- [ ] Enter confirma seleção
- [ ] Escape cancela

### Chat Panel
- [ ] Painel sempre visível
- [ ] Lista de NPCs atualizada
- [ ] Preview de mensagens em tempo real
- [ ] Clique desabilitado em tudo

### Integração
- [ ] Terminal → Chat: `open_conversation()`
- [ ] Chat → Terminal: sinais para tempo real
- [ ] Escolhas: processadas no terminal

---

## Referências

- [[plano_de_implementacao|Plano de Implementação]]
- [[02_terminal|Comandos do Terminal]]
- [[05_chat|Sistema de Chat]]