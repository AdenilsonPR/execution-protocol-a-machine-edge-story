class_name HelpCommand extends CommandBase


func _init() -> void:
	command_name = "help"
	description = OmniInternalKeys.CMD_HELP_DESC


func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var processor: CommandProcessor = context.terminal.command_processor
	var commands: Dictionary = processor.get_commands()
	var text: String = ""

	var name_color: String = Colors.get_color(Colors.Name.YELLOW)
	var desc_color: String = Colors.get_color(Colors.Name.NEUTRAL, 4)

	for cmd_name: String in commands:
		var cmd: CommandBase = commands[cmd_name]
		text += "[color=#%s]%s[/color]" % [name_color, cmd.command_name]
		text += " [color=#%s]%s[/color]\n" % [desc_color, tr(cmd.description)]

	return CommandOutput.create(text.strip_edges()).add_effect(SpeedEffect.create(100.0))
