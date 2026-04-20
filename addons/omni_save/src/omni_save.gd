extends Node


signal before_save(data: Dictionary)
signal after_load(data: Dictionary)
signal saved(slot_name: String)
signal loaded(slot_name: String)
signal error_occurred(message: String)


const SAVE_DIR: String = "user://saves/"
const CURRENT_VERSION: String = "1.0"


func _ready() -> void:
	_ensure_save_dir()


func save_game(slot_name: String = "auto") -> void:
	var data: Dictionary = {
		"version": CURRENT_VERSION,
		"timestamp": Time.get_datetime_string_from_system(),
		"narrative": {},
		"chat": {},
		"custom": {}
	}

	if has_node("/root/OmniNarrative"):
		var narrative: Variant = get_node("/root/OmniNarrative")
		data["narrative"] = {
			"script_path": narrative.script_path,
			"current_node_id": narrative.current_node_id,
			"variables": narrative.variables
		}

	if has_node("/root/OmniChat"):
		var chat: Variant = get_node("/root/OmniChat")
		data["chat"] = chat.get_save_data()

	before_save.emit(data["custom"])

	var file_path: String = SAVE_DIR + slot_name + ".json"
	
	if FileAccess.file_exists(file_path):
		var dir: DirAccess = DirAccess.open(SAVE_DIR)
		dir.copy(file_path, file_path + ".bak")

	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)

	if file:
		var json_string: String = JSON.stringify(data, "\t")
		file.store_string(json_string)
		file.close()
		saved.emit(slot_name)
	else:
		error_occurred.emit("Failed to open file for writing: " + file_path)


func load_game(slot_name: String = "auto") -> void:
	var file_path: String = SAVE_DIR + slot_name + ".json"

	if not FileAccess.file_exists(file_path):
		error_occurred.emit("Save file not found: " + file_path)
		return

	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		error_occurred.emit("Failed to open file for reading: " + file_path)
		return

	var json_string: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: Error = json.parse(json_string)

	if error != OK:
		error_occurred.emit("Failed to parse JSON: " + json.get_error_message())
		return

	var data: Dictionary = json.data

	if data.has("narrative") and has_node("/root/OmniNarrative"):
		var narrative: Variant = get_node("/root/OmniNarrative")
		var n_data: Dictionary = data["narrative"]
		narrative.set_state(
			n_data.get("script_path", ""),
			n_data.get("current_node_id", ""),
			n_data.get("variables", {})
		)

	if data.has("chat") and has_node("/root/OmniChat"):
		var chat: Variant = get_node("/root/OmniChat")
		chat.set_save_data(data["chat"])

	after_load.emit(data.get("custom", {}))
	loaded.emit(slot_name)


func get_available_slots() -> Array[String]:
	var slots: Array[String] = []
	var dir: DirAccess = DirAccess.open(SAVE_DIR)

	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".json"):
				slots.append(file_name.get_basename())
				
			file_name = dir.get_next()

	return slots


func _ensure_save_dir() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_recursive_absolute(SAVE_DIR)
