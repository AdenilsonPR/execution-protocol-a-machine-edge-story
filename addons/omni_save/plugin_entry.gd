@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("OmniSave", "res://addons/omni_save/src/omni_save.gd")


func _exit_tree() -> void:
	remove_autoload_singleton("OmniSave")