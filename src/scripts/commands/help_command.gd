class_name HelpCommand extends CommandBase


func _init() -> void:
	command_name = tr("HELP_COMMAND")
	description = tr("HELP_COMMAND_DESCRIPTION")
	
	
func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var processor: CommandProcessor = context.terminal.command_processor
	var commands: Dictionary = processor.get_commands()
	var text: String = ""
	
	text += "[typewriter s=500]"
	
	for cmd_name: String in commands:
		var cmd: CommandBase = commands[cmd_name]
		
		text += "[omni_color=NEUTRAL.6]%s[/color] " % [cmd.command_name]
		text += "[omni_color=NEUTRAL.4]%s[/color]\n" % [cmd.description]
	
	text += "[/typewriter]"
	
	return CommandOutput.create(text.strip_edges())
