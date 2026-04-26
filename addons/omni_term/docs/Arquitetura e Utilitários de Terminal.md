## 💎 Arquitetura e Utilitários de Terminal

### 1. Anatomia de um Comando (`args` e `Context`)

Ao criar um comando injetando `CommandBase`, você recebe dois parâmetros vitais no método `execute`:

#### O Array `args` (Argumentos)
O motor divide automaticamente o que o usuário digita nos espaços.
- **Input**: `hackear sistema 09`
- **`args[0]`**: `"sistema"`
- **`args[1]`**: `"09"`

#### O `CommandContext`
O context expõe o objeto `terminal`. Isso permite que o comando manipule o estado direto do motor:
```gdscript
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var terminal: OmniTerm = context.terminal
	return CommandOutput.create("Ação executada.")
```

---

### 2. Extensibilidade com `inject_custom_input`

Esta é uma das funções mais poderosas do OmniTerm. Ela permite que você interrompa o fluxo normal de comandos para injetar um nó de interface customizado (como menus de escolha, minijogos de hack, etc).

```gdscript
func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
    var my_custom_ui: Control = preload("res://my_ui.tscn").instantiate()
    context.terminal.inject_custom_input(my_custom_ui)
    return CommandOutput.create("Iniciando interface customizada...")
```

---

### 3. Personalização Externa com `label_added`

O terminal é estático por padrão, mas emite o sinal `label_added(label: RichTextLabel)` sempre que uma nova linha é criada. Você pode usar este sinal no script do seu jogo para aplicar animações ou sons customizados.

**Exemplo de Implementação de Som/Animação:**
```gdscript
func _on_terminal_label_added(label: RichTextLabel) -> void:
    # Exemplo: Efeito simples de fade-in
    label.modulate.a = 0
    var tween = create_tween()
    tween.tween_property(label, "modulate:a", 1.0, 0.5)
    
    # Exemplo: Tocar um som de 'bip' para cada nova linha
    $AudioPlayer.play()
```

Isso permite que você crie o visual e a sonoplastia que desejar sem precisar modificar o código do plugin.

---

### 4. Limpando a Tela (`clear_terminal`)

Você pode limpar todo o histórico visual do terminal a qualquer momento.

**De dentro de um Comando:**
```gdscript
func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.clear_terminal()
	return CommandOutput.create("")
```

---

### 5. Autocomplete e Ghost Text (Sugestões)

O OmniTerm oferece sugestões em tempo real.
- **Visual**: Um texto cinza sugere o comando correspondente.
- **Interação**: Pressione **Tab** para aceitar a sugestão.

---

### 6. Histórico de Comandos (UX)

O terminal armazena automaticamente os comandos digitados.
- **Seta para Cima**: Comando anterior.
- **Seta para Baixo**: Comando posterior.

⬅️ Voltar para a [[Home]]
