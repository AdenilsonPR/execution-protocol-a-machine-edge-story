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

O nó injetado ficará no topo do log e receberá o foco automaticamente. Quando sua UI terminar, ela deve se encarregar de chamar `terminal.create_new_line()` para devolver o controle ao jogador.

---

### 3. Limpando a Tela (`clear_terminal`)

Você pode limpar todo o histórico visual do terminal a qualquer momento.

**De dentro de um Comando:**
```gdscript
func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.clear_terminal()
	return CommandOutput.create("")
```

---

### 4. Autocomplete e Ghost Text (Sugestões)

Inspirado no *Fish Shell*, o OmniTerm oferece sugestões em tempo real.
- **Visual**: Um texto cinza semitransparente sugere o comando.
- **Interação**: Pressione **Tab** para aceitar a sugestão.

---

### 5. Histórico de Comandos (UX)

O terminal armazena automaticamente os comandos digitados.
- **Seta para Cima**: Comando anterior.
- **Seta para Baixo**: Comando posterior.

⬅️ Voltar para a [[Home]]
