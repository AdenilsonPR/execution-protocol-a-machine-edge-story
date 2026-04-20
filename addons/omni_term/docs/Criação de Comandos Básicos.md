## 💻 Criando Novos Comandos

Você quer criar um comando executável como "conectar", "hack", "status" que responde dentro do prompt tradicional `user@local: >`.

**Passo 1: Criando Pastas (Recomendação)**
- Crie uma pasta para não sujar a base do motor: `res://meus_sistemas/meus_comandos/`
- Vá no menu de cima do Godot em **Project -> Project Settings -> General -> Omni Term** e insira esse caminho na variável `Commands Path`.

**Passo 2: Criando o Arquivo**
- Na sua pasta criada, faça clique-direito > Novo Script (GDScript). Dê um nome lógico como `status_command.gd`.

**Passo 3: Herança e Regras**
- O seu script **obrigatoriamente** deve possuir `class_name` não sobreposta e deve realizar `extends CommandBase`.
- Configure o comando em inicialização (`_init`).

**Exemplo Completo:**
```gdscript
class_name StatusCommand extends CommandBase

func _init() -> void:
	# O comando que o usuário tem que digitar! 
	# Sem espaços (ex: se "status", o jogo executará se o usuário digitar status)
	command_name = "status"
	
	# Texto de ajuda no menu "help"
	description = "Exibe o nível de conexão criptografada."

func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	# O args[0] será a primeira palavra que suceder "status " (Ex: status admin)
	if args.size() > 0 and args[0] == "rede":
		return CommandOutput.create("[color=green]Rede conectada via Proxy.[/color]")
	
	return CommandOutput.create("Digite: status rede")
```

⬅️ Voltar para a [[Home]]

---

## 📚 Código de Referência (Antigos Comandos Padrões)

O OmniTerm intencionalmente não possui mais comandos e efeitos padrões internos. Isso garante que a sua suíte permaneça 100% isolada e sem resíduos. Caso você queira recriar os comandos básicos `help`, `clear` e o efeito de digitação `SpeedEffect`, aqui está o código-fonte original deles:

### `SpeedEffect` (Efeito de Texto customizado)
```gdscript
class_name SpeedEffect extends TextEffect


var speed: float = 30.0


static func create(new_speed: float) -> SpeedEffect:
	var effect: SpeedEffect = SpeedEffect.new()
	effect.speed = new_speed
	return effect
```

### Comando `clear`
```gdscript
class_name ClearCommand extends CommandBase


func _init() -> void:
	command_name = "clear"
	description = "Limpa o histórico da tela."


func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.clear_terminal()
	
	return CommandOutput.create("")
```

### Comando `help`
```gdscript
class_name HelpCommand extends CommandBase


func _init() -> void:
	command_name = "help"
	description = "Exibe todos os comandos registrados."


func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var processor: CommandProcessor = context.terminal.command_processor
	var commands: Dictionary = processor.get_commands()
	var text: String = ""
	
	var name_color: String = Colors.get_color(Colors.Name.YELLOW)
	var desc_color: String = Colors.get_color(Colors.Name.NEUTRAL, 4)
	
	for cmd_name: String in commands:
		var cmd: CommandBase = commands[cmd_name]
		text += "[color=#%s]%s[/color]" % [name_color, cmd.command_name]
		text += " [color=#%s]%s[/color]\n" % [desc_color, cmd.description]
	
	# Usando nosso SpeedEffect customizado
	return CommandOutput.create(text.strip_edges()).add_effect(SpeedEffect.create(100.0))
```
