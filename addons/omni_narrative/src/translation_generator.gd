class_name NarrativeTranslationGenerator extends RefCounted


static func generate() -> void:
	var narrative_path: String = ProjectSettings.get_setting("omni_narrative/paths/dialogues", "res://narrative/")
	var output_path: String = ProjectSettings.get_setting("omni_narrative/paths/translations", "res://translations/")
	
	if not narrative_path.ends_with("/"):
		narrative_path += "/"
	
	if not output_path.ends_with("/"):
		output_path += "/"
	
	if not DirAccess.dir_exists_absolute(narrative_path):
		printerr("OmniNarrative Sync: Narrative directory not found: ", narrative_path)
		return
	
	var translation_map: Dictionary = {}
	var conflicts: Array[String] = []
	
	_scan_directory(narrative_path, translation_map, conflicts)
	
	if not conflicts.is_empty():
		printerr("OmniNarrative Sync: BLOCKED - Key conflicts found:")
		for conflict: String in conflicts:
			printerr("  " + conflict)
		printerr("OmniNarrative Sync: Fix the errors above to generate translations.")
		return
	
	if not DirAccess.dir_exists_absolute(output_path):
		DirAccess.make_dir_absolute(output_path)
	
	_write_pot_file(output_path + "narrative.pot", translation_map)
	_write_po_file(output_path + "pt_BR.po", translation_map, "pt_BR")
	
	print("OmniNarrative Sync: Successfully completed in ", output_path)


static func _scan_directory(path: String, map: Dictionary, conflicts: Array) -> void:
	var dir: DirAccess = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				if not file_name.begins_with("."):
					_scan_directory(path + file_name + "/", map, conflicts)
			elif file_name.ends_with(".json"):
				_scan_json_file(path + file_name, map, conflicts)
			
			file_name = dir.get_next()


static func _scan_json_file(path: String, map: Dictionary, conflicts: Array) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	var json: JSON = JSON.new()
	var error: Error = json.parse(content)
	
	if error == OK:
		_extract_translations(json.data, path, content, map, conflicts)


static func _extract_translations(data: Variant, path: String, raw_content: String, map: Dictionary, conflicts: Array) -> void:
	if data is Dictionary:
		if data.has("id") and data.has("text"):
			var id: String = str(data["id"])
			var text: String = str(data["text"])
			
			if id != "" and text != "":
				var line: int = _find_line_of_key(raw_content, id)
				if map.has(id):
					if map[id].text != text:
						conflicts.append("Duplicate key '" + id + "' with different text!\n    - Location 1: " + map[id].file + " (Line " + str(map[id].line) + ")\n    - Location 2: " + path.get_file() + " (Line " + str(line) + ")")
				else:
					map[id] = {"text": text, "file": path.get_file(), "line": line}
		
		for value: Variant in data.values():
			_extract_translations(value, path, raw_content, map, conflicts)
			
	elif data is Array:
		for item: Variant in data:
			_extract_translations(item, path, raw_content, map, conflicts)


static func _find_line_of_key(content: String, key: String) -> int:
	var lines: PackedStringArray = content.split("\n")
	var search_str: String = "\"" + key + "\""
	
	for i: int in lines.size():
		if lines[i].contains(search_str):
			return i + 1
			
	return 0


static func _write_pot_file(path: String, map: Dictionary) -> void:
	var content: String = _get_po_header("")
	
	for id: String in map:
		var original_text: String = map[id].text.replace("\n", " ")
		var escaped_id: String = id.replace("\"", "\\\"").replace("\n", "\\n")
		
		content += "\n#. Original Text: " + original_text + "\n"
		content += "msgid \"" + escaped_id + "\"\n"
		content += "msgstr \"\"\n"
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)
	file.close()


static func _write_po_file(path: String, map: Dictionary, lang: String) -> void:
	var content: String = _get_po_header(lang)
	
	for id: String in map:
		var escaped_id: String = id.replace("\"", "\\\"").replace("\n", "\\n")
		var text: String = map[id].text.replace("\"", "\\\"").replace("\n", "\\n")
		
		content += "\nmsgid \"" + escaped_id + "\"\n"
		content += "msgstr \"" + text + "\"\n"
	
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)
	file.close()


static func _get_po_header(lang: String) -> String:
	var header: String = ""
	header += "msgid \"\"\n"
	header += "msgstr \"\"\n"
	header += "\"Content-Type: text/plain; charset=UTF-8\\n\"\n"
	header += "\"Content-Transfer-Encoding: 8bit\\n\"\n"
	
	if lang != "":
		header += "\"Language: " + lang + "\\n\"\n"
		
	header += "\"Project-Id-Version: OmniSystem Narrative\\n\"\n"
	
	return header
