@tool
extends EditorPlugin


const SETTINGS: Dictionary = {
	"omni_narrative/paths/dialogues": "res://narrative/",
	"omni_narrative/paths/translations": "res://translations/",
	"omni_system/theme/custom_theme": "",
	"omni_system/theme/color_palette": "res://addons/omni_term/assets/color_palettes/base_palette.tres"
}


func _enter_tree() -> void:
	_register_settings()
	add_autoload_singleton("OmniNarrative", "res://addons/omni_narrative/src/narrative_director.gd")
	add_tool_menu_item("OmniNarrative: Sync Translations", _sync_translations)
	add_tool_menu_item("OmniNarrative: Validate All Scripts", _validate_scripts)


func _exit_tree() -> void:
	remove_autoload_singleton("OmniNarrative")
	remove_tool_menu_item("OmniNarrative: Sync Translations")
	remove_tool_menu_item("OmniNarrative: Validate All Scripts")


func _sync_translations() -> void:
	NarrativeTranslationGenerator.generate()


func _validate_scripts() -> void:
	NarrativeValidator.validate_all()


func _register_settings() -> void:
	for setting_path: String in SETTINGS:
		if not ProjectSettings.has_setting(setting_path):
			ProjectSettings.set_setting(setting_path, SETTINGS[setting_path])

		ProjectSettings.set_initial_value(setting_path, SETTINGS[setting_path])
		ProjectSettings.set_as_basic(setting_path, true)

	ProjectSettings.add_property_info({
		"name": "omni_narrative/paths/dialogues",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR
	})

	ProjectSettings.add_property_info({
		"name": "omni_narrative/paths/translations",
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
