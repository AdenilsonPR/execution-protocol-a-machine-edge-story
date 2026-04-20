## 🎮 Controle Externo e Modo Headless

O OmniChat pode ser configurado para funcionar como um sistema "Display-Only", onde a interface visual serve apenas para exibir as mensagens, enquanto a interação (escolhas de diálogo e navegação) é feita por um sistema externo, como o **OmniTerm**.

### Ativando o Modo Não-Interativo

Você pode desativar a interação direta via Editor ou Código:

1.  **No Inspector**: Selecione o nó `OmniChat` e desmarque a propriedade `Interactive`.
2.  **Via Script**:
```gdscript
chat_node.interactive = false
```

**O que acontece no modo não-interativo:**
*   A barra inferior de opções e inputs fica oculta.
*   Cliques na lista de contatos são ignorados.
*   O sistema para de capturar eventos de mouse nos botões de escolha.

---

### Fluxo de Controle via API

Para controlar o chat externamente, utilize o seguinte fluxo de sinais e métodos:

#### 1. Escutando e Exibindo Opções (Exemplo com Terminal)
Sempre que o diálogo chegar em um ponto de decisão, o sinal `choices_offered` será emitido. Você pode usar esse sinal para injetar dinamicamente um input customizado (ex: um menu de setinhas) dentro da árvore do Terminal.

```gdscript
func _ready():
    omni_chat.choices_offered.connect(_on_choices_received)

func _on_choices_received(choices: Dictionary) -> void:
    # 1. Avisa o terminal para travar/congelar a história (esconde o input padrão)
    terminal.call("_freeze_history")
    
    # 2. Transforma o dicionário em um array de strings
    var keys = choices.keys()
    var options: Array[String] = []
    for key in keys:
        options.append(choices[key])
        
    # 3. Instancia e injeta a cena customizada no Log do Terminal
    var choice_scene = load("res://caminho/para/choice_input.tscn")
    var input_node = choice_scene.instantiate()
    var log_node = terminal.get_node("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer")
    
    log_node.add_child(input_node)
    terminal.set("_current_input", input_node)
    
    # 4. Configura as opções e o foco (FOCUS_ALL é vital para capturar o teclado)
    input_node.setup(options)
    input_node.grab_focus()
    
    # 5. Espera 2 frames para o Godot recalcular a UI e rola a tela
    var scroll = terminal.get_node("MarginContainer/PanelContainer/ScrollContainer")
    await get_tree().process_frame
    await get_tree().process_frame
    scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
    
    # 6. Aguarda a seleção do usuário e envia de volta ao Chat
    var selected_index: int = await input_node.submitted
    input_node.disable()
    
    omni_chat.select_choice(keys[selected_index])
    terminal.unlock()
```

---

### Exemplo: Integração com Terminal

Se você estiver usando o **OmniTerm**, pode criar um comando que interage com o chat:

```gdscript
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
    var choice_id = args[0]
    omni_chat.select_choice(choice_id)
    return CommandOutput.create("Você selecionou a opção " + choice_id)
```

---

### Sincronia de Interfaces e Dicas Práticas (Gotchas do Godot 4)

Ao integrar múltiplos addons e inputs customizados, preste atenção aos seguintes comportamentos da Engine:

1. **Evitando Prompts Duplos ao Iniciar Diálogos (Locking UI):**
   Ao disparar a narrativa através de um comando do terminal (ex: `contact_command.gd`), o terminal naturalmente tentará criar uma nova linha de input (`user@local: >`) ao finalizar o comando. Se você quiser que o terminal **fique travado** durante a execução do chat, mude o modo do terminal para `IDLE` imediatamente antes de retornar a resposta do comando:
   ```gdscript
   context.terminal.set("_mode", 0) # InputMode.IDLE
   ```

2. **Dicionários e Sinais (Pass-by-Reference):**
   No Godot 4, dicionários e arrays são passados por referência. Se você emitir um sinal com um dicionário (como `choices_offered.emit(choices)`) e logo em seguida chamar `choices.clear()` internamente para limpar a UI, o dicionário será apagado **antes** do receptor conseguir ler os dados! Utilize sempre `.duplicate()` ao armazenar ou emitir dados temporários caso precise limpar a referência em seguida.

3. **Injeção de Inputs Customizados (`ChoiceInput`):**
   * **Foco:** Se o seu input usar `_unhandled_input(event)` para navegar com as setas, certifique-se de configurar `focus_mode = Control.FOCUS_ALL` no `_ready()` (ou via Inspector) do seu input customizado. `VBoxContainer` e afins vêm com `FOCUS_NONE` por padrão, o que faz o `grab_focus()` falhar silenciosamente.
   * **Atraso de Scroll (2 Frames):** Quando você injeta blocos dinâmicos (`RichTextLabel` com `fit_content = true`), o `VBoxContainer` pode precisar de **2 frames completos** para recalcular sua altura final. Para forçar o scroll até o final sem cortar o conteúdo:
     ```gdscript
     await get_tree().process_frame
     await get_tree().process_frame
     scroll.scroll_vertical = int(scroll.get_v_scroll_bar().max_value)
     ```

⬅️ Voltar para a [[Home]]
