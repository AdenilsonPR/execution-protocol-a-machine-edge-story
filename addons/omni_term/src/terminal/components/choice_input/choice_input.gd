class_name ChoiceInput extends VBoxContainer


signal submitted(index: int)


const _CURSOR: String = "> "
const _SPACE: String = "  "


var _options: Array[String] = []
var _option_keys: Array[String] = []
var _current_index: int = 0
var _is_active: bool = true


func setup(options: Array[String], option_keys: Array[String] = []) -> void:
	_options = options
	_option_keys = option_keys
	_render()


func disable() -> void:
	_is_active = false


func _unhandled_input(event: InputEvent) -> void:
	if not _is_active:
		return

	if event.is_action_pressed("ui_up"):
		_current_index = posmod(_current_index - 1, _options.size())
		_render()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_down"):
		_current_index = posmod(_current_index + 1, _options.size())
		_render()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_accept"):
		_is_active = false
		submitted.emit(_current_index)
		get_viewport().set_input_as_handled()


func _render() -> void:
	for child: Node in get_children():
		child.queue_free()

	for i: int in range(_options.size()):
		var label: RichTextLabel = RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true

		var font: FontFile = preload("res://addons/omni_term/assets/fonts/VT323-Regular.ttf")
		label.add_theme_font_override("normal_font", font)
		label.add_theme_font_size_override("normal_font_size", 24)

		var prefix: String = _CURSOR if i == _current_index else _SPACE
		var color: String = Colors.get_color(Colors.Name.NEUTRAL, 6) if i == _current_index else Colors.get_color(Colors.Name.NEUTRAL, 4)

		var raw_text: String = _options[i]
		var key: String = _option_keys[i] if i < _option_keys.size() else ""
		var final_text: String = tr(key) if not key.is_empty() else tr(raw_text)

		label.text = "[color=#%s]%s%s[/color]" % [color, prefix, final_text]
		add_child(label)
