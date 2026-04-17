class_name OmniDialogueParser extends RefCounted


const REGEX_BLOCK_HEADER: String = "^\\[([a-zA-Z0-9_]+)\\]\\s*$"
const REGEX_CHOICE: String = "^\\-\\s*(.+?)\\s*\\->\\s*([a-zA-Z0-9_]+)$"
const REGEX_SIGNAL: String = "^\\=>\\s*([a-zA-Z0-9_]+)(?:\\s+(.*))?$"
const REGEX_TAGS: String = "\\[([a-z]+)=([a-zA-Z0-9_#.]+)\\]"
const REGEX_ID: String = "#id:([a-f0-9]+)$"


static func _get_clean_text_tags_and_id(line: String) -> Dictionary:
	var tags: Dictionary = {}
	var loc_id: String = ""

	var id_regex: RegEx = RegEx.new()
	id_regex.compile(REGEX_ID)
	var id_match: RegExMatch = id_regex.search(line)
	var text_before_id: String = line
	if id_match:
		loc_id = id_match.get_string(1)
		text_before_id = line.left(id_match.get_start()).strip_edges()

	var tags_regex: RegEx = RegEx.new()
	tags_regex.compile(REGEX_TAGS)
	var clean_text: String = text_before_id
	for mat: RegExMatch in tags_regex.search_all(text_before_id):
		tags[mat.get_string(1)] = mat.get_string(2)
		clean_text = clean_text.replace(mat.get_string(0), "")

	return {
		"text": clean_text.strip_edges(),
		"tags": tags,
		"id": loc_id
	}


static func parse_file(path: String) -> StorySequence:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("OmniDialogueParser: Não foi possível abrir o arquivo: " + path)
		return null

	return parse_text(file.get_as_text())


static func parse_text(raw_text: String) -> StorySequence:
	var blocks_raw: Dictionary = {}
	var current_block: String = ""

	var header_regex: RegEx = RegEx.new()
	header_regex.compile(REGEX_BLOCK_HEADER)

	for line: String in raw_text.split("\n"):
		var trimmed: String = line.strip_edges()
		if trimmed.is_empty() or trimmed.begins_with(";"):
			continue

		var header_match: RegExMatch = header_regex.search(trimmed)
		if header_match:
			current_block = header_match.get_string(1)
			blocks_raw[current_block] = []
		elif current_block != "":
			blocks_raw[current_block].append(trimmed)

	var sequences_dict: Dictionary = {}
	for block_name: String in blocks_raw.keys():
		var seq: StorySequence = StorySequence.new()
		seq.resource_name = block_name
		sequences_dict[block_name] = seq

	var choice_regex: RegEx = RegEx.new()
	choice_regex.compile(REGEX_CHOICE)

	var signal_regex: RegEx = RegEx.new()
	signal_regex.compile(REGEX_SIGNAL)

	for block_name: String in blocks_raw.keys():
		var seq: StorySequence = sequences_dict[block_name]
		_fill_sequence(seq, blocks_raw[block_name], sequences_dict, choice_regex, signal_regex)

	if sequences_dict.has("inicio"):
		return sequences_dict["inicio"]
	elif sequences_dict.size() > 0:
		return sequences_dict.values()[0]

	return StorySequence.new()


static func _fill_sequence(
		seq: StorySequence,
		block_lines: Array,
		sequences_dict: Dictionary,
		choice_regex: RegEx,
		signal_regex: RegEx) -> void:
	var i: int = 0

	while i < block_lines.size():
		var line: String = block_lines[i]

		if line == "-> END":
			i += 1
			continue

		if line.begins_with("-> "):
			var target_block: String = line.substr(3).strip_edges()
			if sequences_dict.has(target_block):
				var target_seq: StorySequence = sequences_dict[target_block]
				for event: StoryEvent in target_seq.events:
					seq.events.append(event)
			else:
				push_warning("OmniDialogueParser: Bloco de redirecionamento não encontrado: " + target_block)
			i += 1
			continue

		if line.begins_with("- "):
			var choice_event: ChoiceEvent = ChoiceEvent.new()

			while i < block_lines.size() and block_lines[i].begins_with("- "):
				var choice_line: String = block_lines[i]
				var mat: RegExMatch = choice_regex.search(choice_line)
				if mat:
					var raw_option: String = mat.get_string(1).strip_edges()
					var parsed_option: Dictionary = _get_clean_text_tags_and_id(raw_option)

					choice_event.options.append(parsed_option["text"])
					choice_event.option_keys.append(parsed_option["id"])

					var target_block: String = mat.get_string(2)
					if sequences_dict.has(target_block):
						choice_event.branches.append(sequences_dict[target_block])
					else:
						push_warning("OmniDialogueParser: Bloco de destino não encontrado: " + target_block)
						choice_event.branches.append(null)
				else:
					var raw_option: String = choice_line.substr(2).strip_edges()
					var parsed_option: Dictionary = _get_clean_text_tags_and_id(raw_option)
					choice_event.options.append(parsed_option["text"])
					choice_event.option_keys.append(parsed_option["id"])
					choice_event.branches.append(null)
				i += 1

			seq.events.append(choice_event)
			continue

		var sig_mat: RegExMatch = signal_regex.search(line)
		if sig_mat:
			var sig_event: SignalEvent = SignalEvent.new()
			sig_event.action_id = sig_mat.get_string(1)
			var sig_params: String = sig_mat.get_string(2)
			if not sig_params.is_empty():
				sig_event.params = sig_params
			seq.events.append(sig_event)
			i += 1
			continue

		var parsed: Dictionary = _get_clean_text_tags_and_id(line)
		var text_event: TextEvent = TextEvent.new()
		text_event.text = parsed["text"]
		text_event.localization_key = parsed["id"]

		var tags: Dictionary = parsed["tags"]
		if tags.has("color"):
			text_event.color = Color(tags["color"])
		if tags.has("speed"):
			text_event.speed = (tags["speed"] as String).to_float()
		if tags.has("delay"):
			text_event.delay = (tags["delay"] as String).to_float()
		if tags.has("sound"):
			text_event.sound_id = tags["sound"]

		seq.events.append(text_event)
		i += 1
