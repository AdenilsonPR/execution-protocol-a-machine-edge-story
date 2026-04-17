@tool
extends EditorScript


const DIALOGUE_DIR: String = "res://dialogos/"
const REGEX_ID: String = "#id:[a-f0-9]+$"


func _run() -> void:
	var files: PackedStringArray = _get_all_omni_files(DIALOGUE_DIR)
	var processed_count: int = 0
	var new_ids_count: int = 0

	for file_path: String in files:
		var result: Dictionary = _process_file(file_path)
		processed_count += 1
		new_ids_count += (result["new_ids"] as int)

	print("OmniSigner: Processamento concluído.")
	print("- Arquivos processados: ", processed_count)
	print("- Novos IDs gerados: ", new_ids_count)


func _get_all_omni_files(base_path: String) -> PackedStringArray:
	var files: PackedStringArray = []
	var dir: DirAccess = DirAccess.open(base_path)

	if not dir:
		return files

	dir.list_dir_begin()
	var file_name: String = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				files.append_array(_get_all_omni_files(base_path + file_name + "/"))
		else:
			if file_name.ends_with(".omni") or file_name.ends_with(".odlg"):
				files.append(base_path + file_name)
		file_name = dir.get_next()

	return files


func _process_file(path: String) -> Dictionary:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {"new_ids": 0}

	var lines: PackedStringArray = file.get_as_text().split("\n")
	file.close()

	var new_lines: PackedStringArray = []
	var new_ids: int = 0
	var id_regex: RegEx = RegEx.new()
	id_regex.compile(REGEX_ID)

	var current_block: String = ""

	for line: String in lines:
		var trimmed: String = line.strip_edges()

		if trimmed.begins_with("[") and trimmed.ends_with("]"):
			current_block = trimmed
			new_lines.append(line)
			continue

		if trimmed.is_empty() or trimmed.begins_with(";") or trimmed.begins_with("->") or trimmed.begins_with("=>"):
			new_lines.append(line)
			continue

		if id_regex.search(trimmed):
			new_lines.append(line)
			continue

		var line_id: String = _generate_hash(path + line + str(Time.get_ticks_usec()))
		new_lines.append(line.rstrip(" \t\r") + " #id:" + line_id)
		new_ids += 1

	if new_ids > 0:
		var write_file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
		write_file.store_string("\n".join(new_lines))
		write_file.close()

	return {"new_ids": new_ids}


func _generate_hash(seed_str: String) -> String:
	return (seed_str + str(randi())).md5_text().substr(0, 8)
