class_name ChatDialogue extends Resource


@export var contact_name: String = "Name"
@export var avatar: Texture2D = preload("res://addons/omni_chat/assets/chat_icon.png")
@export var messages: Array[String] = []
@export var choices: Dictionary = {}
