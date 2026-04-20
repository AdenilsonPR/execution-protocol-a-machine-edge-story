@tool
class_name NarrativeDirector extends Node


signal node_changed(node_id: String)
signal story_finished()


var variables: Dictionary = {}
var current_script: Dictionary = {}
var current_node_id: String = ""
var script_path: String = ""

var _chat_node: OmniChat
var _terminal_node: OmniTerm
var _is_processing: bool = false


func set_state(path: String, node_id: String, vars: Dictionary) -> void:
	if load_script(path):
		variables = vars
		await jump_to(node_id)


func register_chat(node: OmniChat) -> void:
	if _chat_node:
		if _chat_node.choice_selected.is_connected(_on_chat_choice_selected):
			_chat_node.choice_selected.disconnect(_on_chat_choice_selected)

		if _chat_node.chat_opened.is_connected(_on_chat_opened):
			_chat_node.chat_opened.disconnect(_on_chat_opened)

	_chat_node = node

	if _chat_node:
		_chat_node.choice_selected.connect(_on_chat_choice_selected)
		_chat_node.chat_opened.connect(_on_chat_opened)


func register_terminal(node: OmniTerm) -> void:
	if _terminal_node:
		if _terminal_node.action_triggered.is_connected(_on_terminal_action):
			_terminal_node.action_triggered.disconnect(_on_terminal_action)

	_terminal_node = node

	if _terminal_node:
		_terminal_node.action_triggered.connect(_on_terminal_action)


func set_var(var_name: String, value: Variant) -> void:
	variables[var_name] = value
	_check_triggers()


func get_var(var_name: String, default: Variant = null) -> Variant:
	return variables.get(var_name, default)


func load_script(path: String) -> bool:
	if not FileAccess.file_exists(path):
		push_error("NarrativeDirector: File not found: " + path)
		return false

	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var json_string: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: Error = json.parse(json_string)

	if error != OK:
		push_error("NarrativeDirector: JSON Error: " + json.get_error_message())
		return false

	current_script = json.data
	script_path = path
	
	return true


func jump_to(node_id: String) -> void:
	if _is_processing:
		return

	if current_script.is_empty():
		if not load_script(script_path):
			return

	if not current_script.has("nodes") or not current_script.nodes.has(node_id):
		push_error("NarrativeDirector: ID not found: " + node_id)
		return

	_is_processing = true
	current_node_id = node_id
	var node_data: Dictionary = current_script.nodes[node_id]

	await _process_node(node_data)
	node_changed.emit(node_id)
	_is_processing = false

	_check_triggers()


func _process_node(data: Dictionary) -> void:
	var type: String = data.get("type", "chat")

	match type:
		"chat":
			await _handle_chat_node(data)
		"terminal":
			await _handle_terminal_node(data)
		"terminal_input":
			await _handle_terminal_input_node(data)
		"event":
			await _handle_event_node(data)


func _handle_chat_node(data: Dictionary) -> void:
	if not _chat_node:
		return

	var dialogue: ChatDialogue = ChatDialogue.new()
	dialogue.contact_name = _format_text(data.get("contact", "Unknown"))

	var raw_messages: Array = data.get("messages", [])
	var processed_messages: Array[String] = []

	for msg: Variant in raw_messages:
		processed_messages.append(_format_text(msg))

	dialogue.messages = processed_messages

	var raw_choices: Dictionary = data.get("choices", {})
	var processed_choices: Dictionary = {}

	for choice_id: String in raw_choices:
		var choice_data: Variant = raw_choices[choice_id]

		if choice_data is String:
			processed_choices[choice_id] = _format_text(choice_data)
		elif choice_data is Dictionary:
			processed_choices[choice_id] = _format_text(choice_data)

	dialogue.choices = processed_choices

	_chat_node.start_dialogue(dialogue, data.get("immediate", false))

	if processed_choices.is_empty():
		story_finished.emit()


func _handle_terminal_node(data: Dictionary) -> void:
	if not _terminal_node:
		return

	_terminal_node.lock()

	if data.has("lines"):
		for line: Variant in data.lines:
			var line_text: String = _format_text(line)
			var line_delay: float = line.get("delay", 0.5)

			await _terminal_node.render_output(CommandOutput.create(line_text))
			await get_tree().create_timer(line_delay).timeout
	else:
		await _terminal_node.render_output(CommandOutput.create(_format_text(data)))

	if data.has("next"):
		var next_id: String = data.next
		var delay: float = data.get("delay", 1.0)

		await get_tree().create_timer(delay).timeout
		_is_processing = false
		await jump_to(next_id)
	else:
		_terminal_node.unlock()
		story_finished.emit()


func _handle_terminal_input_node(data: Dictionary) -> void:
	if not _terminal_node:
		return

	if data.has("text"):
		await _terminal_node.render_output(CommandOutput.create(_format_text(data)))

	_terminal_node.unlock()
	_terminal_node.activate()
	_terminal_node.create_new_line()


func _handle_event_node(data: Dictionary) -> void:
	if data.has("next_file"):
		load_script(data.next_file)

		if data.has("next_node"):
			_is_processing = false
			await jump_to(data.next_node)
	elif data.has("next"):
		_is_processing = false
		await jump_to(data.next)


func _format_text(data: Variant) -> String:
	var final_text: String = ""

	if data is String:
		final_text = tr(data)
	elif data is Dictionary:
		var id: String = data.get("id", "")
		var fallback: String = data.get("text", "")

		if id != "":
			var translated: String = tr(id)

			if translated == id and fallback != "":
				final_text = fallback
			else:
				final_text = translated
		else:
			final_text = fallback

	return final_text.format(variables)


func _check_triggers() -> void:
	var can_check: bool = current_node_id != ""
	can_check = can_check and current_script.has("nodes")

	if not can_check:
		return

	var node_data: Dictionary = current_script.nodes.get(current_node_id, {})
	var triggers: Array = node_data.get("triggers", [])

	for trigger: Variant in triggers:
		var has_condition: bool = trigger.has("condition")
		var has_next: bool = trigger.has("next_node")

		if has_condition and has_next:
			if _evaluate_condition(trigger.condition):
				_is_processing = false
				await jump_to(trigger.next_node)
				break


func _evaluate_condition(condition: String) -> bool:
	if not condition.begins_with("var:"):
		return false

	var stripped: String = condition.trim_prefix("var:")
	var operators: Array[String] = ["!=", ">=", "<=", "==", ">", "<"]

	for op: String in operators:
		if not stripped.contains(op):
			continue

		var parts: PackedStringArray = stripped.split(op)

		if parts.size() != 2:
			continue

		var var_name: String = parts[0].strip_edges()
		var expected_str: String = parts[1].strip_edges()
		var current_value: Variant = get_var(var_name)

		var expected_value: Variant = expected_str
		if expected_str == "true":
			expected_value = true
		elif expected_str == "false":
			expected_value = false
		elif expected_str.is_valid_float():
			expected_value = expected_str.to_float()

		match op:
			"==":
				return current_value == expected_value
			"!=":
				return current_value != expected_value
			">":
				return float(str(current_value)) > float(str(expected_value))
			"<":
				return float(str(current_value)) < float(str(expected_value))
			">=":
				return float(str(current_value)) >= float(str(expected_value))
			"<=":
				return float(str(current_value)) <= float(str(expected_value))

	return false


func _on_chat_choice_selected(choice_id: String) -> void:
	var node_data: Dictionary = current_script.nodes.get(current_node_id, {})
	var choices: Dictionary = node_data.get("choices", {})

	if not choices.has(choice_id):
		return

	var choice_data: Variant = choices[choice_id]

	_is_processing = false

	if choice_data is String:
		story_finished.emit()
		return

	if not choice_data is Dictionary:
		return

	if choice_data.has("next"):
		await jump_to(choice_data.next)
	elif choice_data.has("next_node"):
		await jump_to(choice_data.next_node)
	else:
		story_finished.emit()


func _on_terminal_action(action_id: String) -> void:
	if not current_script.has("triggers"):
		return

	var script_triggers: Dictionary = current_script.triggers
	if not script_triggers.has(action_id):
		return

	_is_processing = false
	await jump_to(script_triggers[action_id])


func _on_chat_opened(contact_name: String) -> void:
	if not current_script.has("chat_triggers"):
		return

	var chat_triggers: Dictionary = current_script.chat_triggers
	if not chat_triggers.has(contact_name):
		return

	_is_processing = false
	await jump_to(chat_triggers[contact_name])
