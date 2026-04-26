@tool
extends EditorPlugin


const SETTINGS: Dictionary = {
	"omni_save/paths/save_directory": "user://saves/"
}


func _enter_tree() -> void:
	_register_settings()
	add_autoload_singleton("OmniSave", "res://addons/omni_save/src/omni_save.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("OmniSave")


func _register_settings() -> void:
	for setting_path: String in SETTINGS:
		if not ProjectSettings.has_setting(setting_path):
			ProjectSettings.set_setting(setting_path, SETTINGS[setting_path])

		ProjectSettings.set_initial_value(setting_path, SETTINGS[setting_path])
		ProjectSettings.set_as_basic(setting_path, true)

	ProjectSettings.add_property_info({
		"name": "omni_save/paths/save_directory",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})