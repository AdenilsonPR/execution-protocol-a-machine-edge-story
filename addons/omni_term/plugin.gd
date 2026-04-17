@tool
extends EditorPlugin


var import_plugin: EditorImportPlugin


const SETTINGS: Dictionary = {
	"omni_term/paths/commands": "res://addons/omni_term/src/terminal/commands/builtin/",
	"omni_term/paths/effects": "res://addons/omni_term/src/scripts/effects/",
	"omni_term/paths/inline_elements": "res://addons/omni_term/src/terminal/components/inline/",
	"omni_term/paths/custom_inputs": "res://addons/omni_term/src/terminal/components/inputs/"
}


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		import_plugin = preload("res://addons/omni_term/src/scripts/omni_dialogue_importer.gd").new()
		add_import_plugin(import_plugin)

	_register_settings()
	add_custom_type(
		"Terminal",
		"Control",
		preload("res://addons/omni_term/src/terminal/terminal.gd"),
		preload("res://addons/omni_term/assets/terminal_icon.png")
	)


func _exit_tree() -> void:
	if import_plugin:
		remove_import_plugin(import_plugin)
		import_plugin = null

	remove_custom_type("Terminal")


func _register_settings() -> void:
	for setting_path: String in SETTINGS:
		if not ProjectSettings.has_setting(setting_path):
			ProjectSettings.set_setting(setting_path, SETTINGS[setting_path])

		ProjectSettings.set_initial_value(setting_path, SETTINGS[setting_path])
		ProjectSettings.set_as_basic(setting_path, true)

	ProjectSettings.add_property_info({
		"name": "omni_term/paths/commands",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_term/paths/effects",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_term/paths/inline_elements",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_term/paths/custom_inputs",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.save()
