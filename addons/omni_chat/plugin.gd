@tool
extends EditorPlugin


const SETTINGS: Dictionary = {
	"omni_chat/paths/effects": "res://omni_chat_custom/effects/",
	"omni_chat/paths/sounds": "res://omni_chat_custom/sounds/",
	"omni_chat/paths/custom_inputs": "res://omni_chat_custom/inputs/",
	"omni_system/theme/custom_theme": "",
	"omni_system/theme/color_palette": "res://addons/omni_term/assets/color_palettes/base_palette.tres"
}


func _enter_tree() -> void:
	_register_settings()
	add_custom_type(
		"OmniChat",
		"Control",
		preload("res://addons/omni_chat/src/chat/chat.gd"),
		preload("res://addons/omni_chat/assets/chat_icon.png")
	)


func _exit_tree() -> void:
	remove_custom_type("OmniChat")


func _register_settings() -> void:
	for setting_path: String in SETTINGS:
		if not ProjectSettings.has_setting(setting_path):
			ProjectSettings.set_setting(setting_path, SETTINGS[setting_path])

		ProjectSettings.set_initial_value(setting_path, SETTINGS[setting_path])
		ProjectSettings.set_as_basic(setting_path, true)

	ProjectSettings.add_property_info({
		"name": "omni_chat/paths/effects",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_chat/paths/sounds",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_chat/paths/custom_inputs",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})
	ProjectSettings.add_property_info({
		"name": "omni_system/theme/custom_theme",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.theme"
	})
	ProjectSettings.add_property_info({
		"name": "omni_system/theme/color_palette",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_FILE,
		"hint_string": "*.tres"
	})
	ProjectSettings.save()
