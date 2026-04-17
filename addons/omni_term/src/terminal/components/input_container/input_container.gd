class_name InputContainer extends VBoxContainer


@onready var _label: RichTextLabel = $Label
@onready var _line_edit: LineEdit = $HBoxContainer/Control/LineEdit
@onready var _suggestion_label: Label = $HBoxContainer/Control/SuggestionLabel


signal changed(new_text: String)
signal submitted(text: String)
signal history_up()
signal history_down()
signal autocomplete_requested(prefix: String)


func _ready() -> void:
	_line_edit.text_changed.connect(_on_line_edit_text_changed)
	_line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	_line_edit.gui_input.connect(_on_line_edit_gui_input)
	_line_edit.grab_focus.call_deferred()
	_suggestion_label.text = ""


func setup(p_username: String = "user", p_hostname: String = "local") -> void:
	_set_prompt_text(p_username, p_hostname)


func set_input_text(text: String) -> void:
	_line_edit.text = text
	_line_edit.caret_column = text.length()
	_suggestion_label.text = ""
	_on_line_edit_text_changed(text)


func set_suggestion(text: String) -> void:
	_suggestion_label.text = text


func disable() -> void:
	_line_edit.editable = false
	_line_edit.focus_mode = Control.FOCUS_NONE


func set_input_color(color: Color) -> void:
	_line_edit.add_theme_color_override("font_color", color)


func _on_line_edit_text_changed(new_text: String) -> void:
	changed.emit(new_text)
	_suggestion_label.text = ""
	autocomplete_requested.emit(new_text)


func _on_line_edit_text_submitted(text: String) -> void:
	_suggestion_label.text = ""
	submitted.emit(text)


func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_UP:
			history_up.emit()
			accept_event()
		elif event.keycode == KEY_DOWN:
			history_down.emit()
			accept_event()
		elif event.keycode == KEY_TAB:
			if not _suggestion_label.text.is_empty():
				_line_edit.text = _suggestion_label.text
				_line_edit.caret_column = _line_edit.text.length()
				_suggestion_label.text = ""
				_on_line_edit_text_changed(_line_edit.text)
				accept_event()


func _set_prompt_text(p_username: String = "user", p_hostname: String = "local") -> void:
	var user_color: String = Colors.get_color(Colors.Name.GREEN)
	var at_color: String = Colors.get_color(Colors.Name.NEUTRAL)
	var local_color: String = Colors.get_color(Colors.Name.BLUE)

	_label.text = "[color=#%s]%s[/color][color=#%s]@[/color][color=#%s]%s[/color]: " % [user_color, tr(p_username), at_color, local_color, tr(p_hostname)]
