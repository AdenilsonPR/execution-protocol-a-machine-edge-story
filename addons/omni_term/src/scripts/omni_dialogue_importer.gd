@tool
extends EditorImportPlugin


func _get_importer_name() -> String:
	return "omni.dialogue.importer"


func _get_visible_name() -> String:
	return "Omni Dialogue Sequence"


func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["omni", "odlg"])


func _get_save_extension() -> String:
	return "tres"


func _get_resource_type() -> String:
	return "Resource"


func _get_priority() -> float:
	return 1.0


func _get_import_order() -> int:
	return 0


func _get_preset_count() -> int:
	return 1


func _get_preset_name(preset_index: int) -> String:
	return "Default"


func _get_import_options(path: String, preset_index: int) -> Array[Dictionary]:
	return []


func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	return true


func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array[String], gen_files: Array[String]) -> Error:
	var parser_script: GDScript = load("res://addons/omni_term/src/scripts/omni_dialogue_parser.gd")
	if not parser_script:
		push_error("OmniImporter: Não foi possível carregar omni_dialogue_parser.gd")
		return ERR_FILE_MISSING_DEPENDENCIES

	var sequence: StorySequence = parser_script.parse_file(source_file)
	if not sequence:
		push_error("OmniImporter: O parser retornou uma sequence nula para " + source_file)
		return ERR_FILE_CORRUPT

	var error: Error = ResourceSaver.save(sequence, "%s.%s" % [save_path, _get_save_extension()])
	return error
