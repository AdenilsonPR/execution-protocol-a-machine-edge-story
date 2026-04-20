class_name CommandBase extends RefCounted


var command_name: String = ""
var description: String = ""


func execute(_args: PackedStringArray, _context: CommandContext) -> CommandOutput:
	push_error("CommandBase: execute() not implemented for '%s'" % command_name)

	return CommandOutput.create("")


func get_suggestions(_args: PackedStringArray, _context: CommandContext) -> PackedStringArray:
	return PackedStringArray()