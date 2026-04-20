@tool
extends EditorPlugin


const SETTINGS: Dictionary = {
	"omni_chat/paths/effects": "res://omni_chat_custom/effects/",
	"omni_chat/paths/sounds": "res://omni_chat_custom/sounds/"
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
	for setting_path in SETTINGS:
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
	ProjectSettings.save()
