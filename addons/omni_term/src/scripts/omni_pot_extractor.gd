@tool
extends EditorScript


const DIALOGUE_DIR: String = "res://dialogos/"
const POT_FILE: String = "res://dialogos/messages.pot"
const PO_FILE: String = "res://dialogos/omni_pt_BR.po"
const REGEX_ID: String = "#id:([a-f0-9]+)$"


func _run() -> void:
	var files: PackedStringArray = _get_all_omni_files(DIALOGUE_DIR)
	var entries: Dictionary = {}

	var id_regex: RegEx = RegEx.new()
	id_regex.compile(REGEX_ID)

	for path: String in files:
		_extract_from_file(path, entries, id_regex)

	_add_internal_keys(entries)

	if entries.is_empty():
		print("OmniPOTExtractor: Nenhuma chave encontrada.")
		return

	_write_pot_file(POT_FILE, entries)
	_write_po_file(PO_FILE, entries)

	print("OmniPOTExtractor: Processo concluído.")
	print("- Template gerado: ", POT_FILE)
	print("- Tradução PT-BR (preenchida): ", PO_FILE)


func _get_all_omni_files(base_path: String) -> PackedStringArray:
	var files: PackedStringArray = []
	var dir: DirAccess = DirAccess.open(base_path)
	if not dir: return files

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


func _extract_from_file(path: String, entries: Dictionary, id_regex: RegEx) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file: return

	var lines: PackedStringArray = file.get_as_text().split("\n")
	file.close()

	for line: String in lines:
		var trimmed: String = line.strip_edges()
		if trimmed.is_empty() or trimmed.begins_with(";") or trimmed.begins_with("["):
			continue

		var mat: RegExMatch = id_regex.search(trimmed)
		if mat:
			var loc_id: String = mat.get_string(1)
			var raw_text: String = line.left(mat.get_start()).strip_edges()

			if raw_text.begins_with("- "):
				var choice_regex: RegEx = RegEx.new()
				choice_regex.compile("^\\-\\s*(.+?)\\s*\\->")
				var c_mat: RegExMatch = choice_regex.search(raw_text)
				if c_mat:
					raw_text = c_mat.get_string(1).strip_edges()
				else:
					raw_text = raw_text.substr(2).strip_edges()

			var cleanup: Dictionary = OmniDialogueParser._get_clean_text_tags_and_id(raw_text)
			entries[loc_id] = cleanup["text"]


func _add_internal_keys(entries: Dictionary) -> void:
	entries[OmniInternalKeys.CMD_HELP_DESC] = "Mostra a lista de comandos disponíveis."
	entries[OmniInternalKeys.CMD_CLEAR_DESC] = "Limpa a tela do terminal."
	entries[OmniInternalKeys.CMD_ERR_NOT_FOUND] = "Comando não encontrado"


func _write_pot_file(path: String, entries: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if not file: return

	var header: String = """msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\\n"
"Content_Transfer-Encoding: 8bit\\n"

"""
	file.store_string(header)

	for loc_id: String in entries:
		var source_text: String = entries[loc_id].replace('"', '\\"')
		file.store_string("#. Source: %s\n" % source_text)
		file.store_string("msgid \"%s\"\n" % loc_id)
		file.store_string("msgstr \"\"\n\n")

	file.close()


func _write_po_file(path: String, entries: Dictionary) -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if not file: return

	var header: String = """msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\\n"
"Content_Transfer-Encoding: 8bit\\n"
"Language: pt_BR\\n"

"""
	file.store_string(header)

	for loc_id: String in entries:
		var source_text: String = entries[loc_id].replace('"', '\\"')
		file.store_string("msgid \"%s\"\n" % loc_id)
		file.store_string("msgstr \"%s\"\n\n" % source_text)

	file.close()
