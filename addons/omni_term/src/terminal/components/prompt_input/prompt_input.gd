class_name PromptInput extends HBoxContainer


signal submitted(text: String)


@onready var _label: Label = $Label
@onready var _line_edit: LineEdit = $LineEdit


var _is_password: bool = false


func _ready() -> void:
	_line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	_line_edit.grab_focus.call_deferred()


func setup(prompt_text: String, is_password: bool = false) -> void:
	_label.text = tr(prompt_text)
	_is_password = is_password

	if _is_password:
		_line_edit.set_secret(true)
		_line_edit.set_secret_character("*")


func disable() -> void:
	_line_edit.editable = false
	_line_edit.focus_mode = Control.FOCUS_NONE


func _on_line_edit_text_submitted(new_text: String) -> void:
	submitted.emit(new_text)
