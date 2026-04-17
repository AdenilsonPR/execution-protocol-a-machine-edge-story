@tool
class_name Terminal extends PanelContainer


signal action_triggered(action_id: String)


enum InputMode {
	IDLE,
	COMMAND,
	CHOICE,
	PROMPT
}


const _INPUT_COMMAND: PackedScene = preload("res://addons/omni_term/src/terminal/components/input_container/input_container.tscn")
const _INPUT_CHOICE: PackedScene = preload("res://addons/omni_term/src/terminal/components/choice_input/choice_input.tscn")
const _INPUT_PROMPT: PackedScene = preload("res://addons/omni_term/src/terminal/components/prompt_input/prompt_input.tscn")

static var DEFAULT_EFFECTS_PATH: String:
	get: return ProjectSettings.get_setting("omni_term/paths/effects", "res://addons/omni_term/src/scripts/effects/")

static var DEFAULT_INLINE_PATH: String:
	get: return ProjectSettings.get_setting("omni_term/paths/inline_elements", "res://addons/omni_term/src/terminal/components/inline/")

static var DEFAULT_INPUTS_PATH: String:
	get: return ProjectSettings.get_setting("omni_term/paths/custom_inputs", "res://addons/omni_term/src/terminal/components/inputs/")

static var DEFAULT_COMMANDS_PATH: String:
	get: return ProjectSettings.get_setting("omni_term/paths/commands", "res://addons/omni_term/src/terminal/commands/builtin/")

@export_group("Login Settings")
@export var username: String = "user"
@export var hostname: String = "local"

@export_group("Narrative Flow")
@export var intro_sequence: StorySequence
@export_file("*.omni") var dialogue_file: String = ""

@export_group("Audio Settings")
@export var sound_bank: TerminalSoundBank
@export var default_sound_id: String = "default"

var _container: VBoxContainer
var _scroll: ScrollContainer

var command_processor: CommandProcessor
var _current_input: Control
var _mode: InputMode = InputMode.IDLE
var _command_history: Array[String] = []
var _history_index: int = -1
var _last_sound_played_char: int = -1
var _audio_player: AudioStreamPlayer


func _ready() -> void:
	_setup_ui()
	if Engine.is_editor_hint():
		return

	add_to_group("terminal")
	_audio_player = AudioStreamPlayer.new()
	add_child(_audio_player)

	command_processor = CommandProcessor.new(DEFAULT_COMMANDS_PATH)

	_load_automatic_effects()
	_load_automatic_inline_elements()
	_load_automatic_custom_inputs()
	_start_engine()


func _setup_ui() -> void:
	_container = get_node_or_null("MarginContainer/PanelContainer/ScrollContainer/VBoxContainer")
	_scroll = get_node_or_null("MarginContainer/PanelContainer/ScrollContainer")

	if _container and _scroll:
		return

	var margin: MarginContainer = MarginContainer.new()
	margin.name = "MarginContainer"
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(margin)

	var panel: PanelContainer = PanelContainer.new()
	panel.name = "PanelContainer"
	panel.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	margin.add_child(panel)

	_scroll = ScrollContainer.new()
	_scroll.name = "ScrollContainer"
	_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(_scroll)

	_container = VBoxContainer.new()
	_container.name = "VBoxContainer"
	_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_container.add_theme_constant_override("separation", 8)
	_scroll.add_child(_container)


func create_new_line() -> void:
	_freeze_history()
	_mode = InputMode.COMMAND
	var input: InputContainer = _INPUT_COMMAND.instantiate()
	_container.add_child(input)
	input.setup(username, hostname)
	input.changed.connect(_on_input_changed)
	input.submitted.connect(_on_input_submitted)
	if input.has_signal("history_up"): input.history_up.connect(_on_history_up)
	if input.has_signal("history_down"): input.history_down.connect(_on_history_down)
	if input.has_signal("autocomplete_requested"): input.autocomplete_requested.connect(_on_autocomplete_requested)
	_current_input = input
	_scroll_to_bottom()


func _freeze_history() -> void:
	for child in _container.get_children():
		_freeze_node(child)


func _freeze_node(node: Node) -> void:
	if node.has_method("disable"):
		node.disable()
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in node.get_children():
		_freeze_node(child)


func prompt_choice(options: Array[String], option_keys: Array[String] = []) -> int:
	_mode = InputMode.CHOICE
	var input: ChoiceInput = _INPUT_CHOICE.instantiate()
	_container.add_child(input)
	input.setup(options, option_keys)
	_current_input = input
	_scroll_to_bottom()
	var result = await input.submitted
	input.disable()
	return result


func prompt_text(label: String, is_password: bool = false) -> String:
	_mode = InputMode.PROMPT
	var input: PromptInput = _INPUT_PROMPT.instantiate()
	_container.add_child(input)
	input.setup(label, is_password)
	_current_input = input
	_scroll_to_bottom()
	var result = await input.submitted
	input.disable()
	return result


func prompt_custom(input_name: String, params: Dictionary = {}) -> Variant:
	if not _auto_custom_inputs.has(input_name):
		return null

	_mode = InputMode.PROMPT
	var input: Node = _auto_custom_inputs[input_name].instantiate()
	_container.add_child(input)

	if input.has_method("setup"):
		input.call("setup", params)

	_current_input = input as Control
	_scroll_to_bottom()
	var result: Variant = await input.get("submitted").connect(func(v): return v)

	if input.has_method("disable"):
		input.call("disable")

	return result


func render_output(output: CommandOutput) -> void:
	if output.text.is_empty():
		return

	var speed: float = 30.0
	var sound_id: String = default_sound_id

	for effect in output.effects:
		if effect is SpeedEffect:
			speed = effect.chars_per_second

	await _render_narrative_flow(tr(output.text), Color.WHITE, speed, sound_id)


func clear_terminal() -> void:
	for child: Node in _container.get_children():
		child.queue_free()


func play_sequence(sequence: StorySequence) -> void:
	if not sequence:
		return

	for event in sequence.events:
		if not event:
			continue

		var sound_id: String = default_sound_id

		if "sound_id" in event:
			sound_id = event.get("sound_id")
		if event is ChoiceEvent:
			await _handle_choice_event(event as ChoiceEvent, sound_id)
		elif event is TextEvent:
			await _render_text_event(event, sound_id)
		elif event is PromptEvent:
			await _handle_prompt_event(event as PromptEvent, sound_id)
		elif event is TextPromptEvent:
			await _handle_text_prompt_event(event as TextPromptEvent, sound_id)
		elif event is SignalEvent:
			action_triggered.emit(event.action_id)
		if event.delay > 0:
			await get_tree().create_timer(event.delay).timeout


func reboot() -> void:
	clear_terminal()
	_start_engine()


func _start_engine() -> void:
	_mode = InputMode.IDLE
	await get_tree().process_frame

	if not dialogue_file.is_empty():
		var sequence: StorySequence = OmniDialogueParser.parse_file(dialogue_file)
		if sequence:
			await play_sequence(sequence)
	elif intro_sequence:
		await play_sequence(intro_sequence)

	create_new_line()


func _render_text_event(event: TextEvent, sound_id: String = "") -> void:
	if sound_id == "":
		sound_id = default_sound_id

	var final_text: String = tr(event.localization_key) if not event.localization_key.is_empty() else tr(event.text)
	await _render_narrative_flow(final_text, event.color, event.speed, sound_id)


var _auto_effects: Dictionary = {}
var _auto_inline_elements: Dictionary = {}
var _auto_custom_inputs: Dictionary = {}


func _load_dir_into_dict(path: String, dict: Dictionary, suffix: String) -> void:
	if path.is_empty():
		return

	if not path.ends_with("/"):
		path += "/"

	var dir: DirAccess = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()

		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(suffix):
				var tag_name: String = file_name.replace(suffix, "").to_lower()
				var res: Resource = load(path + file_name)
				if res != null:
					dict[tag_name] = res
			file_name = dir.get_next()


func _load_automatic_custom_inputs() -> void:
	_load_dir_into_dict(DEFAULT_INPUTS_PATH, _auto_custom_inputs, ".tscn")


func _load_automatic_inline_elements() -> void:
	_load_dir_into_dict(DEFAULT_INLINE_PATH, _auto_inline_elements, ".tscn")


func _load_automatic_effects() -> void:
	_load_dir_into_dict(DEFAULT_EFFECTS_PATH, _auto_effects, "_effect.gd")
	if _auto_effects.has("delay"):
		_auto_effects["wait"] = _auto_effects["delay"]


func _render_text_segment(flow: Control, text: String, color: Color, speed: float, sound_id: String = "") -> void:
	var label: RichTextLabel = _create_label(text)
	label.visible_characters = 0
	label.add_theme_color_override("default_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	flow.add_child(label)

	await get_tree().process_frame
	label.custom_minimum_size = label.get_combined_minimum_size()

	var effect: SpeedEffect = SpeedEffect.create(speed)
	effect.apply(label)

	var stream: AudioStream = null
	if sound_bank and not sound_id.is_empty():
		stream = sound_bank.get_sound(sound_id)

	_last_sound_played_char = -1

	while label.visible_characters < label.get_total_character_count() and not effect.is_completed:
		if label.visible_characters > _last_sound_played_char:
			_last_sound_played_char = label.visible_characters
			if stream and not _audio_player.playing:
				_audio_player.stream = stream
				_audio_player.pitch_scale = randf_range(sound_bank.default_pitch_range.x, sound_bank.default_pitch_range.y)
				_audio_player.volume_db = sound_bank.default_volume_db
				_audio_player.play()
		await get_tree().process_frame

	if not effect.is_completed:
		await effect.completed


func _create_label(text: String) -> RichTextLabel:
	text = _preprocess_palette_tags(text)
	var label: RichTextLabel = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	label.text = text
	label.selection_enabled = true
	label.focus_mode = Control.FOCUS_NONE
	var font: FontFile = preload("res://addons/omni_term/assets/fonts/VT323-Regular.ttf")
	label.add_theme_font_override("normal_font", font)
	label.add_theme_font_size_override("normal_font_size", 24)
	var text_color: String = Colors.get_color(Colors.Name.NEUTRAL, 5)
	label.add_theme_color_override("default_color", Color("#" + text_color))
	label.meta_clicked.connect(_on_meta_clicked)
	return label


func _preprocess_palette_tags(text: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("\\[p=(.*?)\\](.*?)\\[/p\\]")

	var result: RegExMatch = regex.search(text)
	while result:
		var full_tag: String = result.get_string(0)
		var params: PackedStringArray = result.get_string(1).split(":")
		var inner_text: String = result.get_string(2)
		var color_name_str: String = params[0].to_upper()

		var brightness: int = 3
		if params.size() > 1:
			brightness = params[1].to_int()

		var color_hex: String = "ffffff"
		if Colors.Name.has(color_name_str):
			var color_name_enum: int = Colors.Name.get(color_name_str)
			color_hex = Colors.get_color(color_name_enum, brightness)

		var replacement: String = "[color=#%s]%s[/color]" % [color_hex, inner_text]
		text = text.replace(full_tag, replacement)
		result = regex.search(text)

	return text


func _on_meta_clicked(meta: Variant) -> void:
	action_triggered.emit(str(meta))


func _handle_choice_event(event: ChoiceEvent, sound_id: String = "") -> void:
	if sound_id == "":
		sound_id = default_sound_id

	var final_prompt: String = tr(event.localization_key) if not event.localization_key.is_empty() else tr(event.text)
	var text_color: Color = event.get("color") if "color" in event else Color.WHITE
	await _render_narrative_flow(final_prompt, text_color, event.speed, sound_id)

	var selected_index: int = await prompt_choice(event.options, event.option_keys)
	if selected_index < event.branches.size():
		var next_sequence: StorySequence = event.branches[selected_index]
		if next_sequence:
			await play_sequence(next_sequence)


func _handle_prompt_event(event: PromptEvent, sound_id: String = "") -> void:
	if sound_id == "":
		sound_id = default_sound_id

	if not event.text.is_empty():
		var output: CommandOutput = CommandOutput.create(tr(event.text))
		output.add_effect(SpeedEffect.create(event.speed))
		await _render_narrative_flow(tr(event.text), Colors.get_color(Colors.Name.NEUTRAL, 6), event.speed, sound_id)

	var result: Variant = await prompt_custom(event.input_name, event.params)
	var found_match: bool = false

	if result != null and typeof(result) == TYPE_STRING:
		var result_str: String = result as String
		for i: int in range(event.result_keys.size()):
			if event.result_keys[i] == result_str:
				found_match = true
				if i < event.result_branches.size():
					var next_sequence: StorySequence = event.result_branches[i]
					if next_sequence:
						await play_sequence(next_sequence)
				break

	if not found_match and event.default_branch:
		await play_sequence(event.default_branch)


func _handle_text_prompt_event(event: TextPromptEvent, sound_id: String = "") -> void:
	if sound_id == "":
		sound_id = default_sound_id

	if not event.text.is_empty():
		var output: CommandOutput = CommandOutput.create(tr(event.text))
		output.add_effect(SpeedEffect.create(event.speed))
		await _render_narrative_flow(tr(event.text), Colors.get_color(Colors.Name.NEUTRAL, 6), event.speed, sound_id)

	var result: Variant = await prompt_text(event.label, event.is_password)
	var found_match: bool = false

	if result != null:
		var result_str: String = result as String
		for i: int in range(event.result_keys.size()):
			if event.result_keys[i].strip_edges().to_lower() == result_str.strip_edges().to_lower():
				found_match = true
				if i < event.result_branches.size():
					var next_sequence: StorySequence = event.result_branches[i]
					if next_sequence:
						await play_sequence(next_sequence)
				break

	if not found_match and event.default_branch:
		await play_sequence(event.default_branch)


func _scroll_to_bottom() -> void:
	await get_tree().create_timer(0.01).timeout
	_scroll.scroll_vertical = int(_scroll.get_v_scroll_bar().max_value)


func _on_input_changed(new_text: String) -> void:
	if _mode != InputMode.COMMAND:
		return

	var trimmed: String = new_text.strip_edges()
	if trimmed.is_empty():
		_current_input.call("set_input_color", Color("#" + Colors.get_color(Colors.Name.NEUTRAL)))
		return

	var cmd_name: String = trimmed.split(" ", false)[0]
	if command_processor.has_command(cmd_name):
		_current_input.call("set_input_color", Color("#" + Colors.get_color(Colors.Name.NEUTRAL, 6)))
	else:
		_current_input.call("set_input_color", Color("#" + Colors.get_color(Colors.Name.RED)))


func _on_input_submitted(text: String) -> void:
	if text.is_empty():
		create_new_line()
		return

	_command_history.append(text)
	_history_index = -1

	if _current_input.has_method("disable"):
		_current_input.call("disable")

	var context: CommandContext = CommandContext.new(self)
	var output: CommandOutput = command_processor.process(text, context)
	await render_output(output)

	if _mode == InputMode.COMMAND:
		create_new_line()


func _on_history_up() -> void:
	if _command_history.is_empty(): return
	if _history_index == -1:
		_history_index = _command_history.size() - 1
	elif _history_index > 0:
		_history_index -= 1
	if _current_input.has_method("set_input_text"):
		_current_input.set_input_text(_command_history[_history_index])


func _on_history_down() -> void:
	if _history_index == -1: return
	if _history_index < _command_history.size() - 1:
		_history_index += 1
		if _current_input.has_method("set_input_text"):
			_current_input.set_input_text(_command_history[_history_index])
	else:
		_history_index = -1
		if _current_input.has_method("set_input_text"):
			_current_input.set_input_text("")


func _on_autocomplete_requested(prefix: String) -> void:
	var suggestion: String = _get_best_suggestion(prefix)
	if suggestion != "" and _current_input.has_method("set_suggestion"):
		_current_input.call("set_suggestion", suggestion)


func _get_best_suggestion(prefix: String) -> String:
	if prefix.is_empty():
		return ""

	var commands: Array = command_processor.get_commands().keys()
	for cmd: String in commands:
		if cmd.begins_with(prefix.to_lower()):
			return cmd

	return ""

func _render_narrative_flow(text: String, color: Color, speed: float, sound_id: String = "") -> void:
	var regex: RegEx = RegEx.new()
	regex.compile("(\\{(.*?)\\})|(\\[\\[\\s*(.*?)\\s*=\\s*(.*?)\\s*\\]\\])")

	var lines: PackedStringArray = text.split("\n")
	for i: int in range(lines.size()):
		var line_text: String = lines[i]
		if line_text.is_empty() and i < lines.size() - 1:
			var spacer: Control = Control.new()
			spacer.custom_minimum_size.y = 24
			_container.add_child(spacer)
			continue

		var flow: HFlowContainer = HFlowContainer.new()
		flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		flow.alignment = FlowContainer.ALIGNMENT_BEGIN
		_container.add_child(flow)
		_scroll_to_bottom()

		var current_speed: float = speed
		var current_sound_id: String = sound_id
		var last_pos: int = 0

		for result: RegExMatch in regex.search_all(line_text):
			var prefix: String = line_text.substr(last_pos, result.get_start() - last_pos)
			if not prefix.is_empty():
				await _render_text_segment(flow, prefix, color, current_speed, current_sound_id)

			if not result.get_string(1).is_empty():
				var key: String = result.get_string(2).strip_edges()
				if _auto_inline_elements.has(key):
					var node: Node = _auto_inline_elements[key].instantiate()
					if node is Control:
						node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
					flow.add_child(node)
					_scroll_to_bottom()
					await get_tree().process_frame

			elif not result.get_string(3).is_empty():
				var action: String = result.get_string(4).to_lower().strip_edges()
				var raw_value: String = result.get_string(5).strip_edges()

				if action == "speed":
					current_speed = raw_value.to_float()
				elif action == "sound" or action == "audio":
					current_sound_id = raw_value
				elif action == "prompt":
					await prompt_custom(raw_value)
				elif _auto_effects.has(action):
					var effect: TextEffect = _auto_effects[action].new()
					effect.set_value(raw_value.to_float())

					var dummy: Control = Control.new()
					dummy.visible = false
					flow.add_child(dummy)

					if effect is WaitEffect:
						await get_tree().create_timer(raw_value.to_float()).timeout
					else:
						effect.apply(dummy)
						await effect.completed
					dummy.queue_free()

			last_pos = result.get_end()

		var suffix: String = line_text.substr(last_pos)
		if not suffix.is_empty():
			await _render_text_segment(flow, suffix, color, current_speed, current_sound_id)

		if i < lines.size() - 1:
			await get_tree().process_frame
