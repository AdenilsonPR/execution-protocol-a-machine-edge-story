@tool
extends EditorPlugin


const SETTINGS: Dictionary = {
	"omni_term/paths/commands": "res://omni_term_custom/commands/",
	"omni_term/paths/effects": "res://omni_term_custom/effects/",
	"omni_term/paths/sounds": "res://omni_term_custom/sounds/",
	"omni_term/paths/inline_elements": "res://omni_term_custom/inline/",
	"omni_term/paths/custom_inputs": "res://omni_term_custom/inputs/",
	"omni_system/theme/custom_theme": "",
	"omni_system/theme/color_palette": "res://addons/omni_term/assets/color_palettes/base_palette.tres"
}


func _enter_tree() -> void:
	_register_settings()
	add_custom_type(
		"OmniTerm",
		"Control",
		preload("res://addons/omni_term/src/terminal/terminal.gd"),
		preload("res://addons/omni_term/assets/terminal_icon.png")
	)


func _exit_tree() -> void:
	remove_custom_type("OmniTerm")


func _register_settings() -> void:
	for setting_path in SETTINGS:
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
		"name": "omni_term/paths/sounds",
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
