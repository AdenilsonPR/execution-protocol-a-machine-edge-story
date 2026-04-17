class_name ClearCommand extends CommandBase


func _init() -> void:
	command_name = "clear"
	description = OmniInternalKeys.CMD_CLEAR_DESC


func execute(_args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.clear_terminal()
	return CommandOutput.create("")
