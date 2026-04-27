class_name CommandProcessor extends RefCounted


var _commands: Dictionary = {}
var _commands_path: String = ""


func _init() -> void:
	_commands_path = ProjectSettings.get_setting("omni_term/paths/commands", "res://omni_term_custom/commands/")
	if not _commands_path.ends_with("/"):
		_commands_path += "/"

	_load_commands_automatically()


func register_command(command: CommandBase) -> void:
	_commands[command.command_name] = command


func process(raw_input: String, context: CommandContext) -> CommandOutput:
	var trimmed: String = raw_input.strip_edges()

	if trimmed.is_empty():
		return CommandOutput.create("")

	var parts: PackedStringArray = trimmed.split(" ", false)
	var cmd_name: String = parts[0]
	var args: PackedStringArray = PackedStringArray(parts.slice(1))

	if not _commands.has(cmd_name):
		return CommandOutput.create(tr("CMD_ERR_NOT_FOUND").format({"cmd": cmd_name}))

	var command: CommandBase = _commands[cmd_name]

	return command.execute(args, context)


func has_command(cmd_name: String) -> bool:
	return _commands.has(cmd_name)


func get_commands() -> Dictionary:
	return _commands


func _load_dir(path: String) -> void:
	if path.is_empty():
		return

	var dir: DirAccess = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".gd"):
				var script: GDScript = load(path + file_name) as GDScript
				if script:
					var cmd: Variant = script.new()
					if cmd is CommandBase:
						register_command(cmd as CommandBase)

			file_name = dir.get_next()


func _load_commands_automatically() -> void:
	_load_dir(_commands_path)
