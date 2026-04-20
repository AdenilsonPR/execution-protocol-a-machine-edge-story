@tool
@icon("res://addons/omni_term/assets/terminal_icon.png")
class_name OmniTerm extends Control


signal action_triggered(action_id: String)
signal output_rendered(text: String)


enum InputMode {
	IDLE,
	COMMAND,
	PROMPT
}


const _INPUT_COMMAND: PackedScene = preload("res://addons/omni_term/src/terminal/components/input_container/input_container.tscn")
const TYPING_SPEED_MS: float = 0.01


var command_processor: CommandProcessor
var _current_input: Control
var _mode: InputMode = InputMode.IDLE
var _command_history: Array[String] = []
var _history_index: int = -1
var _internal_log: VBoxContainer
var _scroll_node: ScrollContainer
var _username: String = "user"
var _hostname: String = "local"
var _custom_effects: Array = []
var _audio_player: AudioStreamPlayer
var _audio_cache: Dictionary = {}
var _is_locked: bool = false
var _output_queue: Array[CommandOutput] = []
var _is_rendering: bool = false


func _ready() -> void:
	_setup_ui()
	_setup_audio()
	_load_custom_effects()

	if _custom_effects.is_empty():
		var fallback_script: GDScript = load("res://omni_term_custom/effects/speed.gd")
		if fallback_script:
			_custom_effects.append(fallback_script.new())

	if Engine.is_editor_hint():
		return

	add_to_group("terminal")

	command_processor = CommandProcessor.new()

	_start_engine()


func _load_custom_effects() -> void:
	_custom_effects.clear()
	var path: String = ProjectSettings.get_setting("omni_term/paths/effects", "res://omni_term_custom/effects/")

	if not path.ends_with("/"):
		path += "/"

	if not DirAccess.dir_exists_absolute(path):
		return

	var dir: DirAccess = DirAccess.open(path)
	if not dir:
		return

	dir.list_dir_begin()
	var file_name: String = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".gd"):
			var effect_script: GDScript = load(path + file_name)
			if effect_script:
				var effect_instance: Variant = effect_script.new()
				if effect_instance and "bbcode" in effect_instance:
					_custom_effects.append(effect_instance)

		file_name = dir.get_next()


func set_username(new_username: String) -> void:
	_username = new_username


func set_hostname(new_hostname: String) -> void:
	_hostname = new_hostname


func _setup_ui() -> void:
	if get_child_count() > 0:
		var margin_node: Node = get_node_or_null("MarginContainer")
		
		if margin_node:
			var panel_node: Node = margin_node.get_node_or_null("PanelContainer")
			if panel_node:
				_scroll_node = panel_node.get_node_or_null("ScrollContainer") as ScrollContainer
				if _scroll_node:
					_internal_log = _scroll_node.get_node_or_null("VBoxContainer") as VBoxContainer
					if _internal_log:
						return

	for child: Node in get_children():
		child.queue_free()

	_setup_theme()

	var margin_node_new: MarginContainer = MarginContainer.new()
	margin_node_new.name = "MarginContainer"
	margin_node_new.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin_node_new)

	var panel_node_new: PanelContainer = PanelContainer.new()
	panel_node_new.name = "PanelContainer"
	margin_node_new.add_child(panel_node_new)

	_scroll_node = ScrollContainer.new()
	_scroll_node.name = "ScrollContainer"
	_scroll_node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll_node.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel_node_new.add_child(_scroll_node)

	_internal_log = VBoxContainer.new()
	_internal_log.name = "VBoxContainer"
	_internal_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_internal_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll_node.add_child(_internal_log)


func _setup_theme() -> void:
	if theme != null:
		return

	var custom_theme_path: String = ProjectSettings.get_setting("omni_system/theme/custom_theme", "")
	if custom_theme_path != "" and ResourceLoader.exists(custom_theme_path):
		var custom_theme: Theme = load(custom_theme_path) as Theme
		if custom_theme:
			self.theme = custom_theme
			return

	var default_theme: Theme = Theme.new()
	var font: FontFile = load("res://addons/omni_term/assets/fonts/VT323-Regular.ttf")
	var base_color: Color = Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 6))

	default_theme.set_font("normal_font", "RichTextLabel", font)
	default_theme.set_font_size("normal_font_size", "RichTextLabel", 24)
	default_theme.set_color("default_color", "RichTextLabel", base_color)

	var grabber_normal: StyleBoxFlat = StyleBoxFlat.new()
	grabber_normal.bg_color = Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 2))
	grabber_normal.corner_radius_top_left = 4
	grabber_normal.corner_radius_top_right = 4
	grabber_normal.corner_radius_bottom_left = 4
	grabber_normal.corner_radius_bottom_right = 4

	var grabber_active: StyleBoxFlat = StyleBoxFlat.new()
	grabber_active.bg_color = Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 3))
	grabber_active.corner_radius_top_left = 4
	grabber_active.corner_radius_top_right = 4
	grabber_active.corner_radius_bottom_left = 4
	grabber_active.corner_radius_bottom_right = 4

	var scroll_bg: StyleBoxFlat = StyleBoxFlat.new()
	scroll_bg.bg_color = Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 0))
	scroll_bg.content_margin_left = 4
	scroll_bg.content_margin_right = 4

	default_theme.set_stylebox("grabber", "VScrollBar", grabber_normal)
	default_theme.set_stylebox("grabber_highlight", "VScrollBar", grabber_active)
	default_theme.set_stylebox("grabber_pressed", "VScrollBar", grabber_active)
	default_theme.set_stylebox("scroll", "VScrollBar", scroll_bg)

	default_theme.set_constant("margin_left", "MarginContainer", 16)
	default_theme.set_constant("margin_top", "MarginContainer", 16)
	default_theme.set_constant("margin_right", "MarginContainer", 16)
	default_theme.set_constant("margin_bottom", "MarginContainer", 16)

	var empty_style: StyleBoxEmpty = StyleBoxEmpty.new()
	default_theme.set_stylebox("panel", "PanelContainer", empty_style)
	default_theme.set_constant("separation", "VBoxContainer", 8)

	self.theme = default_theme


func _setup_audio() -> void:
	if _audio_player:
		return

	_audio_player = AudioStreamPlayer.new()
	_audio_player.bus = "SFX"
	add_child(_audio_player)

	_load_sound("typewriter")


func _load_sound(sound_name: String) -> AudioStream:
	if _audio_cache.has(sound_name):
		return _audio_cache[sound_name]

	var path: String = "res://omni_term_custom/sounds/" + sound_name + ".wav"
	if FileAccess.file_exists(path):
		var stream: AudioStream = load(path)
		_audio_cache[sound_name] = stream
		return stream
	
	return null


func lock() -> void:
	_is_locked = true

	if _current_input:
		_freeze_node(_current_input)


func unlock() -> void:
	_is_locked = false

	if _mode == InputMode.COMMAND and not _current_input:
		create_new_line()
	elif _current_input:
		activate()


func create_new_line() -> void:
	if _is_locked or (_current_input and is_instance_valid(_current_input)):
		return

	_freeze_history()
	_mode = InputMode.COMMAND

	var input_node: InputContainer = _INPUT_COMMAND.instantiate()

	_current_input = input_node
	_add_to_log(input_node)

	input_node.setup(_username, _hostname)
	input_node.changed.connect(_on_input_changed)
	input_node.submitted.connect(_on_input_submitted)

	if input_node.has_signal("history_up"):
		input_node.history_up.connect(_on_history_up)

	if input_node.has_signal("history_down"):
		input_node.history_down.connect(_on_history_down)

	if input_node.has_signal("autocomplete_requested"):
		input_node.autocomplete_requested.connect(_on_autocomplete_requested)

	_scroll_to_bottom()


func _freeze_history() -> void:
	_current_input = null

	for child_node: Node in _internal_log.get_children():
		_freeze_node(child_node)


func _freeze_node(node: Node) -> void:
	if node.has_method("disable"):
		node.disable()

	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
		node.focus_mode = Control.FOCUS_NONE

	for child_node: Node in node.get_children():
		_freeze_node(child_node)


func write_line(text: String) -> void:
	await render_output(CommandOutput.create(text))


func inject_custom_input(input_node: Control) -> void:
	_freeze_history()
	_internal_log.add_child(input_node)
	_current_input = input_node

	await get_tree().process_frame
	await get_tree().process_frame

	_scroll_to_bottom()
	input_node.grab_focus()


func render_output(output_data: CommandOutput) -> void:
	_output_queue.append(output_data)

	if _is_rendering:
		while _is_rendering:
			await get_tree().process_frame

		return

	_is_rendering = true

	while not _output_queue.is_empty():
		var current_output: CommandOutput = _output_queue.pop_front()
		await _process_output(current_output)

	_is_rendering = false


func _process_output(output_data: CommandOutput) -> void:
	if output_data.text.is_empty():
		return

	_freeze_history()

	var label: RichTextLabel = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true

	for effect: Variant in _custom_effects:
		label.custom_effects.append(effect)

	_add_to_log(label)
	label.text = _preprocess_text(output_data.text)

	output_rendered.emit(output_data.text)
	await _type_text(label, 0.0)
	_scroll_to_bottom()


func clear_terminal() -> void:
	for child: Node in _internal_log.get_children():
		child.queue_free()

	_current_input = null


func activate() -> void:
	if _current_input and not _current_input.is_queued_for_deletion():
		_current_input.grab_focus()
		return

	create_new_line()


func _start_engine() -> void:
	_mode = InputMode.IDLE


func _add_to_log(node: Node) -> void:
	_internal_log.add_child(node)

	if _current_input and _current_input.get_parent() == _internal_log:
		if _current_input.focus_mode != Control.FOCUS_NONE:
			_internal_log.move_child(node, _current_input.get_index())


func _preprocess_text(text: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("\\[omni_color=([A-Za-z_]+)(?:\\.(\\d))?\\]")

	var result: String = text

	for m: RegExMatch in regex.search_all(text):
		var color_name_str: String = m.get_string(1).to_upper()
		var shade_str: String = m.get_string(2)
		var shade: int = shade_str.to_int() if not shade_str.is_empty() else 3

		if color_name_str in ColorTerm.Name.keys():
			var color_index: int = ColorTerm.Name.keys().find(color_name_str)
			var hex: String = ColorTerm.get_color(color_index as ColorTerm.Name, shade)
			result = result.replace(m.get_string(), "[color=#%s]" % hex)

	result = result.replace("[/omni_color]", "[/color]")

	return result


func _scroll_to_bottom() -> void:
	await get_tree().process_frame
	_scroll_node.scroll_vertical = int(_scroll_node.get_v_scroll_bar().max_value)


func _type_text(label: RichTextLabel, delay: float) -> void:
	var base_delay: float = delay if delay > 0 else TYPING_SPEED_MS
	var current_delay: float = base_delay
	var speed_map: Dictionary = {}

	var regex: RegEx = RegEx.new()
	regex.compile("\\[typewriter s=([\\d.]+)(?: v=\"([^\"]+)\")?\\]")

	var strip_regex: RegEx = RegEx.new()
	strip_regex.compile("\\[.*?\\]")

	var raw_text: String = label.text
	for m: RegExMatch in regex.search_all(raw_text):
		var s_val: float = m.get_string(1).to_float()
		var sound_name: String = m.get_string(2)

		var prefix: String = raw_text.left(m.get_start())
		var clean_prefix: String = strip_regex.sub(prefix, "", true)
		var parsed_index: int = clean_prefix.length()

		speed_map[parsed_index] = {
			"delay": 1.0 / s_val if s_val > 0 else base_delay,
			"sound": sound_name if not sound_name.is_empty() else "typewriter"
		}

	label.visible_ratio = 0.0
	await get_tree().process_frame
	await get_tree().process_frame
	
	var total_chars: int = label.get_total_character_count()

	for i: int in range(total_chars + 1):
		label.visible_characters = i

		if speed_map.has(i):
			current_delay = speed_map[i].delay
			_audio_player.stream = _load_sound(speed_map[i].sound)

		if current_delay > 0:
			if _audio_player.stream and i > 0:
				_audio_player.pitch_scale = randf_range(0.8, 1.2)
				_audio_player.play()

			await get_tree().create_timer(current_delay).timeout
		
		_scroll_to_bottom()


func _on_input_changed(new_text: String) -> void:
	if _mode != InputMode.COMMAND or not _current_input:
		return

	var trimmed_text: String = new_text.strip_edges()

	if trimmed_text.is_empty():
		_current_input.set_input_color(Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 6)))
		return

	var cmd_name: String = trimmed_text.split(" ", false)[0]

	if command_processor.has_command(cmd_name):
		_current_input.set_input_color(Color(ColorTerm.get_color(ColorTerm.Name.NEUTRAL, 6)))
	else:
		_current_input.set_input_color(Color(ColorTerm.get_color(ColorTerm.Name.RED)))


func _on_input_submitted(input_text: String) -> void:
	if input_text.is_empty():
		create_new_line()
		return

	_command_history.append(input_text)
	_history_index = -1

	if _current_input.has_method("disable"):
		_current_input.disable()

	var cmd_context: CommandContext = CommandContext.new(self)
	var cmd_output: CommandOutput = command_processor.process(input_text, cmd_context)

	await render_output(cmd_output)

	if _mode == InputMode.COMMAND:
		create_new_line()


func _on_history_up() -> void:
	if _command_history.is_empty():
		return

	if _history_index == -1:
		_history_index = _command_history.size() - 1
	elif _history_index > 0:
		_history_index -= 1

	if _current_input.has_method("set_input_text"):
		_current_input.set_input_text(_command_history[_history_index])


func _on_history_down() -> void:
	if _history_index == -1:
		return

	if _history_index < _command_history.size() - 1:
		_history_index += 1

		if _current_input.has_method("set_input_text"):
			_current_input.set_input_text(_command_history[_history_index])
	else:
		_history_index = -1

		if _current_input.has_method("set_input_text"):
			_current_input.set_input_text("")


func _on_autocomplete_requested(prefix_text: String) -> void:
	var suggestions: Array[String] = _get_all_suggestions(prefix_text)

	if _current_input.has_method("set_suggestions"):
		_current_input.set_suggestions(suggestions)


func _get_all_suggestions(prefix_text: String) -> Array[String]:
	var results: Array[String] = []
	var parts: PackedStringArray = prefix_text.split(" ", false)

	if parts.is_empty() or (parts.size() == 1 and not prefix_text.ends_with(" ")):
		var command_keys: Array = command_processor.get_commands().keys()
		var search_prefix: String = parts[0].to_lower() if not parts.is_empty() else ""

		for cmd_key: String in command_keys:
			if cmd_key.begins_with(search_prefix):
				results.append(cmd_key)
	else:
		var cmd_name: String = parts[0].to_lower()

		if command_processor.has_command(cmd_name):
			var command: CommandBase = command_processor.get_commands()[cmd_name]
			var args: PackedStringArray = PackedStringArray(parts.slice(1))
			var context: CommandContext = CommandContext.new(self)
			var cmd_suggestions: PackedStringArray = command.get_suggestions(args, context)

			var last_part: String = "" if prefix_text.ends_with(" ") else parts[-1].to_lower()
			var base: String = prefix_text.left(prefix_text.rfind(" ") + 1)

			for suggestion: String in cmd_suggestions:
				if suggestion.to_lower().begins_with(last_part):
					results.append(base + suggestion)

	return results
