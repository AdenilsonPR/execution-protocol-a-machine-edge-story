class_name NarrativeValidator extends RefCounted


static func validate_all() -> void:
	var narrative_path: String = ProjectSettings.get_setting("omni_narrative/paths/dialogues", "res://narrative/")
	
	if not narrative_path.ends_with("/"):
		narrative_path += "/"
		
	if not DirAccess.dir_exists_absolute(narrative_path):
		printerr("OmniNarrative Validator: Directory not found: ", narrative_path)
		return
		
	var files: PackedStringArray = _get_all_json_files(narrative_path)
	var global_id_map: Dictionary = {}
	var conflicts: Array[String] = []
	
	for file_path: String in files:
		_validate_file(file_path, global_id_map, conflicts)

	if not conflicts.is_empty():
		printerr("OmniNarrative Validator: BLOCKED - Key conflicts found:")
		for conflict: String in conflicts:
			printerr("  " + conflict)
		printerr("OmniNarrative Validator: Fix the errors above to validate scripts.")
	else:
		print("OmniNarrative Validator: All scripts are valid!")


static func _get_all_json_files(path: String) -> PackedStringArray:
	var result: PackedStringArray = []
	var dir: DirAccess = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				if not file_name.begins_with("."):
					result.append_array(_get_all_json_files(path + file_name + "/"))
			elif file_name.ends_with(".json"):
				result.append(path + file_name)
				
			file_name = dir.get_next()
			
	return result


static func _validate_file(path: String, global_map: Dictionary, conflicts: Array) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	var json: JSON = JSON.new()
	var error: Error = json.parse(content)
	
	if error != OK:
		printerr("OmniNarrative Validator: JSON syntax error in ", path, ": ", json.get_error_message())
		return
		
	var data: Dictionary = json.data
	if not data.has("nodes"):
		return
		
	var nodes: Dictionary = data.nodes
	var file_errors: Array[String] = []
	
	for node_id: String in nodes:
		var node_data: Dictionary = nodes[node_id]
		_check_node_links(node_id, node_data, nodes, file_errors)
		_check_duplicate_ids(node_id, node_data, path, content, global_map, conflicts)

	if not file_errors.is_empty():
		printerr("OmniNarrative Validator: Structure errors in ", path.get_file(), ":")
		for err: String in file_errors:
			printerr("  - ", err)


static func _check_node_links(node_id: String, node_data: Dictionary, nodes: Dictionary, errors: Array) -> void:
	if node_data.has("next"):
		var next_id: String = node_data.next
		if not nodes.has(next_id):
			errors.append("Node '" + node_id + "' points to '" + next_id + "' (non-existent).")
	
	if node_data.has("next_node"):
		var next_id: String = node_data.next_node
		if not nodes.has(next_id):
			errors.append("Node '" + node_id + "' (next_node) points to '" + next_id + "' (non-existent).")

	if node_data.has("triggers"):
		var triggers: Array = node_data.triggers
		for trigger: Variant in triggers:
			if trigger is Dictionary and trigger.has("next_node"):
				var t_next: String = trigger.next_node
				if not nodes.has(t_next):
					errors.append("Node '" + node_id + "' (Trigger) points to '" + t_next + "' (non-existent).")
	
	if node_data.has("choices"):
		var choices: Dictionary = node_data.choices
		for choice_id: String in choices:
			var c_data: Variant = choices[choice_id]
			if c_data is Dictionary:
				if c_data.has("next"):
					var c_next: String = c_data.next
					if not nodes.has(c_next):
						errors.append("Node '" + node_id + "' (Choice '" + choice_id + "') points to '" + c_next + "' (non-existent).")
				elif c_data.has("next_node"):
					var c_next: String = c_data.next_node
					if not nodes.has(c_next):
						errors.append("Node '" + node_id + "' (Choice '" + choice_id + "') points to '" + c_next + "' (non-existent).")


static func _check_duplicate_ids(node_id: String, data: Variant, path: String, raw_content: String, global_map: Dictionary, conflicts: Array) -> void:
	if data is Dictionary:
		if data.has("id") and data.has("text"):
			var id: String = str(data["id"])
			var text: String = str(data["text"])
			
			if id != "" and text != "":
				var line: int = _find_line_of_key(raw_content, id)
				if global_map.has(id):
					if global_map[id].text != text:
						conflicts.append("Duplicate key '" + id + "' with different text!\n    - Location 1: " + global_map[id].file + " (Line " + str(global_map[id].line) + ")\n    - Location 2: " + path.get_file() + " (Line " + str(line) + ")")
				else:
					global_map[id] = {"text": text, "file": path.get_file(), "line": line}
		
		for value: Variant in data.values():
			_check_duplicate_ids(node_id, value, path, raw_content, global_map, conflicts)
			
	elif data is Array:
		for item: Variant in data:
			_check_duplicate_ids(node_id, item, path, raw_content, global_map, conflicts)


static func _find_line_of_key(content: String, key: String) -> int:
	var lines: PackedStringArray = content.split("\n")
	var search_str: String = "\"" + key + "\""
	
	for i: int in lines.size():
		if lines[i].contains(search_str):
			return i + 1
			
	return 0
