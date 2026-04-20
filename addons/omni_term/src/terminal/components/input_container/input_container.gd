class_name InputContainer extends VBoxContainer


signal changed(new_text: String)
signal submitted(text: String)
signal history_up()
signal history_down()
signal autocomplete_requested(prefix: String)


@onready var _label: RichTextLabel = $Label
@onready var _line_edit: LineEdit = $HBoxContainer/Control/LineEdit
@onready var _suggestion_label: Label = $HBoxContainer/Control/SuggestionLabel
@onready var _prompt_symbol: Label = $HBoxContainer/Label
var _highlight_label: RichTextLabel
var _suggestions_view: RichTextLabel
var _current_suggestions: Array[String] = []
var _suggestion_index: int = -1
var _is_cycling: bool = false


func _ready() -> void:
	_setup_highlight_label()
	_setup_suggestions_view()

	_line_edit.text_changed.connect(_on_line_edit_text_changed)
	_line_edit.text_submitted.connect(_on_line_edit_text_submitted)
	_line_edit.gui_input.connect(_on_line_edit_gui_input)
	_line_edit.grab_focus.call_deferred()

	var suggestion_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 2)
	_suggestion_label.add_theme_color_override("font_color", Color.from_string(suggestion_color, Color(1, 1, 1, 0.2)))
	_suggestion_label.text = ""


func _setup_highlight_label() -> void:
	_highlight_label = RichTextLabel.new()
	_highlight_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_highlight_label.bbcode_enabled = true
	_highlight_label.fit_content = true
	_highlight_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_highlight_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var font: FontFile = preload("res://addons/omni_term/assets/fonts/VT323-Regular.ttf")
	_highlight_label.add_theme_font_override("normal_font", font)
	_highlight_label.add_theme_font_size_override("normal_font_size", 24)

	_line_edit.get_parent().add_child(_highlight_label)
	_line_edit.get_parent().move_child(_highlight_label, _line_edit.get_index())

	var transparent: Color = Color(0, 0, 0, 0)
	var select_color: Color = Color.from_string(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 5), Color.WHITE)
	select_color.a = 0.5

	_line_edit.add_theme_color_override("font_color", transparent)
	_line_edit.add_theme_color_override("font_selected_color", transparent)
	_line_edit.add_theme_color_override("selection_color", select_color)
	_line_edit.add_theme_color_override("caret_color", Color.from_string(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 6), Color.WHITE))


func _setup_suggestions_view() -> void:
	_suggestions_view = RichTextLabel.new()
	_suggestions_view.bbcode_enabled = true
	_suggestions_view.fit_content = true
	_suggestions_view.hide()

	var font: FontFile = preload("res://addons/omni_term/assets/fonts/VT323-Regular.ttf")
	_suggestions_view.add_theme_font_override("normal_font", font)
	_suggestions_view.add_theme_font_size_override("normal_font_size", 20)

	add_child(_suggestions_view)


func setup(p_username: String = "user", p_hostname: String = "local") -> void:
	_set_prompt_text(p_username, p_hostname)


func set_input_text(text: String) -> void:
	_line_edit.text = text
	_line_edit.caret_column = text.length()
	_suggestion_label.text = ""

	_on_line_edit_text_changed(text)


func set_suggestions(list: Array[String]) -> void:
	_current_suggestions = list

	if not _is_cycling:
		if _current_suggestions.size() == 1:
			_suggestion_label.text = _current_suggestions[0]
		else:
			_suggestion_label.text = ""

		_suggestions_view.hide()


func disable() -> void:
	_line_edit.editable = false
	_line_edit.focus_mode = Control.FOCUS_NONE
	_line_edit.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_line_edit.release_focus()
	_suggestions_view.hide()

	var hbox: HBoxContainer = $HBoxContainer
	var control: Control = $HBoxContainer/Control
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_input_color(color: Color) -> void:
	_highlight_label.add_theme_color_override("default_color", color)


func _on_line_edit_text_changed(new_text: String) -> void:
	_is_cycling = false
	_suggestion_index = -1
	_suggestions_view.hide()

	_update_highlight(new_text)

	changed.emit(new_text)
	_suggestion_label.text = ""

	autocomplete_requested.emit(new_text)


func _update_highlight(text: String) -> void:
	if text.is_empty():
		_highlight_label.text = ""
		return

	var parts: PackedStringArray = text.split(" ", false)
	if parts.is_empty():
		_highlight_label.text = ""
		return

	var highlighted: String = parts[0]

	var current_pos: int = parts[0].length()

	for i in range(1, parts.size()):
		var space_start: int = text.find(" ", current_pos)
		var next_part_start: int = text.find(parts[i], space_start)
		var spaces: String = text.substr(space_start, next_part_start - space_start)

		var arg_brightness: int = 4 if i % 2 == 1 else 3
		var arg_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL, arg_brightness)

		highlighted += "%s[color=#%s]%s[/color]" % [spaces, arg_color, parts[i]]
		current_pos = next_part_start + parts[i].length()

	if text.ends_with(" "):
		var trailing_spaces: String = text.substr(current_pos)
		highlighted += trailing_spaces

	_highlight_label.text = highlighted


func _render_suggestions_grid() -> void:
	var content: String = ""
	var col_width: int = 20
	var current_col: int = 0
	var max_cols: int = 4

	var normal_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 4)
	var select_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 6)

	for i in range(_current_suggestions.size()):
		var raw_item: String = _current_suggestions[i]
		var item_parts: PackedStringArray = raw_item.split(" ", false)
		var display_item: String = item_parts[-1] if item_parts.size() > 0 else raw_item

		var is_selected: bool = (i == _suggestion_index)
		var color: String = select_color if is_selected else normal_color
		var prefix: String = "> " if is_selected else "  "

		var padded_item: String = (prefix + display_item).rpad(col_width)
		content += "[color=#%s]%s[/color]" % [color, padded_item]

		current_col += 1
		if current_col >= max_cols:
			content += "\n"
			current_col = 0

	_suggestions_view.text = content


func _on_line_edit_text_submitted(text: String) -> void:
	_suggestion_label.text = ""
	_suggestions_view.hide()
	submitted.emit(text)


func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				_is_cycling = false
				_suggestions_view.hide()
				accept_event()
			KEY_BACKSPACE:
				_is_cycling = false
				_suggestions_view.hide()
			KEY_UP, KEY_LEFT:
				if not _current_suggestions.is_empty():
					_is_cycling = (_current_suggestions.size() > 1)
					_cycle_suggestions(-1)
					accept_event()
				elif event.keycode == KEY_UP:
					history_up.emit()
					accept_event()
			KEY_DOWN, KEY_RIGHT, KEY_TAB:
				if not _current_suggestions.is_empty():
					_is_cycling = (_current_suggestions.size() > 1)
					_cycle_suggestions(1)
					accept_event()
				elif event.keycode == KEY_DOWN:
					history_down.emit()
					accept_event()


func _cycle_suggestions(direction: int) -> void:
	if _current_suggestions.is_empty():
		return

	_suggestion_index += direction

	if _suggestion_index >= _current_suggestions.size():
		_suggestion_index = 0
	elif _suggestion_index < 0:
		_suggestion_index = _current_suggestions.size() - 1

	var new_text: String = _current_suggestions[_suggestion_index] + " "
	_line_edit.text = new_text
	_line_edit.caret_column = new_text.length()

	_update_highlight(new_text)
	_render_suggestions_grid()

	changed.emit(new_text)

	if _current_suggestions.size() == 1:
		autocomplete_requested.emit(new_text)

	if _current_suggestions.size() > 1 and _is_cycling:
		_suggestions_view.show()
	else:
		_suggestions_view.hide()


func _set_prompt_text(p_username: String = "user", p_hostname: String = "local") -> void:
	var user_color: String = ColorTerm.get_color(ColorTerm.Name.GREEN)
	var at_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL)
	var local_color: String = ColorTerm.get_color(ColorTerm.Name.BLUE)
	var prompt_color: String = ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 4)

	_label.text = "[color=#%s]%s[/color][color=#%s]@[/color][color=#%s]%s[/color]: " % [user_color, p_username, at_color, local_color, p_hostname]
	_prompt_symbol.add_theme_color_override("font_color", Color.from_string(prompt_color, Color.WHITE))
