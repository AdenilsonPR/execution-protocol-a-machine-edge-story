class_name Main extends Control


@onready var omni_term: OmniTerm = $PanelContainer/MarginContainer/HBoxContainer/Term/OmniTerm
@onready var omni_chat: OmniChat = $PanelContainer/MarginContainer/HBoxContainer/Chat/OmniChat


func _ready() -> void:
	omni_term.set_username("UI_USER")
	omni_term.set_hostname("UI_BASE_07")
	
	OmniNarrative.register_terminal(omni_term)
	OmniNarrative.load_script("res://location/narrative/intro/intro.json")
	OmniNarrative.jump_to("init")
	
	OmniNarrative.register_chat(omni_chat)
	OmniNarrative.set_var("notification_shown", true)
