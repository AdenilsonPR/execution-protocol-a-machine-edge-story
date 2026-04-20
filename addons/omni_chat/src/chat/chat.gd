@tool
@icon("res://addons/omni_chat/assets/chat_icon.png")
class_name OmniChat extends Control


signal choice_selected(choice_id: String)
signal message_rendered(text: String)
signal interaction_requested()
signal chat_opened(contact_name: String)
signal new_message_received(contact_name: String)
signal reminder_triggered(contact_name: String)
signal choices_offered(choices: Dictionary)


@export var interactive: bool = true:
	set(value):
		interactive = value
		_update_interaction_mode()


var _chat_view: VBoxContainer
var _list_view: VBoxContainer
var _scroll_node: ScrollContainer
var _message_log: VBoxContainer
var _choice_container: VBoxContainer
var _placeholder_hint: Button
var _audio_player: AudioStreamPlayer
var _name_label: Label
var _avatar_rect: TextureRect
var _list_scroll: ScrollContainer
var _list_container: VBoxContainer
var _bottom_bar: PanelContainer
var _back_btn: Button
var _conversations: Dictionary = {}
var _current_contact: String = ""
var _custom_effects: Array = []
var _active_choices: Dictionary = {}
var _audio_cache: Dictionary = {}
var _dialogue_queue: Array[Dictionary] = []
var _is_processing_dialogue: bool = false


const TYPING_SPEED: float = 0.03
const REMINDER_DELAY: float = 300.0


func get_save_data() -> Dictionary:
	return _conversations


func set_save_data(data: Dictionary) -> void:
	_conversations = data
	
	if _list_view and _list_view.visible:
		_refresh_list()
	elif _current_contact != "":
		_refresh_messages(_current_contact)


func open_conversation(contact_name: String) -> void:
	_open_chat(contact_name)


func _ready() -> void:
	_setup_ui()
	_setup_audio()
	_load_custom_effects()
	_update_interaction_mode()
	
	if Engine.is_editor_hint():
		return
		
	add_to_group("omni_chat")
	_show_list()


func _load_custom_effects() -> void:
	_custom_effects.clear()
	var path: String = ProjectSettings.get_setting("omni_chat/paths/effects", "res://omni_chat_custom/effects/")
	
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


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	_check_reminders()


func _setup_ui() -> void:
	for child: Node in get_children():
		child.queue_free()
		
	_chat_view = VBoxContainer.new()
	_chat_view.name = "ChatView"
	_chat_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_chat_view.hide()
	add_child(_chat_view)
	_setup_chat_ui(_chat_view)
	
	_list_view = VBoxContainer.new()
	_list_view.name = "ListView"
	_list_view.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_list_view.show()
	add_child(_list_view)
	_setup_list_ui(_list_view)
	
	_update_interaction_mode()


var _font_cache: FontFile = null


func _get_main_font() -> FontFile:
	if _font_cache:
		return _font_cache
	_font_cache = load("res://addons/omni_chat/assets/fonts/VT323-Regular.ttf")
	return _font_cache


func _setup_chat_ui(parent: VBoxContainer) -> void:
	var top_bar: PanelContainer = PanelContainer.new()
	top_bar.custom_minimum_size = Vector2(0, 48)
	var top_style: StyleBoxFlat = StyleBoxFlat.new()
	top_style.bg_color = Color(0, 0, 0, 0)
	top_style.border_width_bottom = 2
	top_style.border_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
	top_bar.add_theme_stylebox_override("panel", top_style)
	parent.add_child(top_bar)
	
	var top_margin: MarginContainer = MarginContainer.new()
	top_margin.add_theme_constant_override("margin_left", 8)
	top_margin.add_theme_constant_override("margin_top", 8)
	top_margin.add_theme_constant_override("margin_right", 8)
	top_margin.add_theme_constant_override("margin_bottom", 8)
	top_bar.add_child(top_margin)
	
	var top_hbox: HBoxContainer = HBoxContainer.new()
	top_hbox.add_theme_constant_override("separation", 12)
	top_margin.add_child(top_hbox)
	
	_back_btn = Button.new()
	_back_btn.custom_minimum_size = Vector2(32, 32)
	_back_btn.text = "<"
	_back_btn.flat = true
	
	var font: FontFile = _get_main_font()
	_back_btn.add_theme_font_override("font", font)
	_back_btn.add_theme_font_size_override("font_size", 24)
	_back_btn.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 5)))
	_back_btn.add_theme_color_override("font_hover_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	
	var empty_btn_style: StyleBoxEmpty = StyleBoxEmpty.new()
	_back_btn.add_theme_stylebox_override("normal", empty_btn_style)
	_back_btn.add_theme_stylebox_override("hover", empty_btn_style)
	_back_btn.pressed.connect(_show_list)
	top_hbox.add_child(_back_btn)
	_back_btn.visible = interactive
	
	_avatar_rect = TextureRect.new()
	_avatar_rect.custom_minimum_size = Vector2(32, 32)
	_avatar_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_avatar_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	top_hbox.add_child(_avatar_rect)
	
	_name_label = Label.new()
	_name_label.add_theme_font_override("font", font)
	_name_label.add_theme_font_size_override("font_size", 24)
	_name_label.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	top_hbox.add_child(_name_label)
	
	var main_margin: MarginContainer = MarginContainer.new()
	main_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_margin.add_theme_constant_override("margin_left", 8)
	main_margin.add_theme_constant_override("margin_top", 8)
	main_margin.add_theme_constant_override("margin_right", 8)
	main_margin.add_theme_constant_override("margin_bottom", 8)
	parent.add_child(main_margin)
	
	_scroll_node = ScrollContainer.new()
	_scroll_node.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_scroll_node.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main_margin.add_child(_scroll_node)
	_style_scrollbar(_scroll_node)
	
	_message_log = VBoxContainer.new()
	_message_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_message_log.add_theme_constant_override("separation", 16)
	_scroll_node.add_child(_message_log)
	
	_bottom_bar = PanelContainer.new()
	_bottom_bar.custom_minimum_size = Vector2(0, 48)
	
	var bottom_style: StyleBoxFlat = StyleBoxFlat.new()
	bottom_style.bg_color = Color(0, 0, 0, 0)
	bottom_style.border_width_top = 2
	bottom_style.border_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
	
	_bottom_bar.add_theme_stylebox_override("panel", bottom_style)
	parent.add_child(_bottom_bar)
	_bottom_bar.visible = interactive
	
	var bottom_margin: MarginContainer = MarginContainer.new()
	bottom_margin.add_theme_constant_override("margin_left", 8)
	bottom_margin.add_theme_constant_override("margin_top", 8)
	bottom_margin.add_theme_constant_override("margin_right", 8)
	bottom_margin.add_theme_constant_override("margin_bottom", 8)
	_bottom_bar.add_child(bottom_margin)
	
	_choice_container = VBoxContainer.new()
	_choice_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_choice_container.add_theme_constant_override("separation", 8)
	bottom_margin.add_child(_choice_container)
	
	_placeholder_hint = Button.new()
	_placeholder_hint.text = tr("CHAT_UI_PLACEHOLDER")
	_placeholder_hint.flat = true
	_placeholder_hint.alignment = HORIZONTAL_ALIGNMENT_LEFT
	_placeholder_hint.add_theme_font_override("font", font)
	_placeholder_hint.add_theme_font_size_override("font_size", 24)
	_placeholder_hint.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 5)))
	_placeholder_hint.add_theme_color_override("font_hover_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	_placeholder_hint.add_theme_color_override("font_pressed_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	_placeholder_hint.add_theme_stylebox_override("normal", empty_btn_style)
	_placeholder_hint.add_theme_stylebox_override("hover", empty_btn_style)
	_placeholder_hint.add_theme_stylebox_override("pressed", empty_btn_style)
	_placeholder_hint.pressed.connect(func() -> void:
		if interactive:
			interaction_requested.emit()
	)
	bottom_margin.add_child(_placeholder_hint)


func _setup_list_ui(parent: VBoxContainer) -> void:
	var top_bar: PanelContainer = PanelContainer.new()
	top_bar.custom_minimum_size = Vector2(0, 48)
	
	var top_style: StyleBoxFlat = StyleBoxFlat.new()
	top_style.bg_color = Color(0, 0, 0, 0)
	top_style.border_width_bottom = 2
	top_style.border_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
	top_bar.add_theme_stylebox_override("panel", top_style)
	parent.add_child(top_bar)
	
	var label: Label = Label.new()
	label.text = tr("CHAT_UI_TITLE")
	
	var font: FontFile = _get_main_font()
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 24)
	label.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top_bar.add_child(label)
	
	_list_scroll = ScrollContainer.new()
	_list_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_list_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	parent.add_child(_list_scroll)
	_style_scrollbar(_list_scroll)
	
	_list_container = VBoxContainer.new()
	_list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_list_container.add_theme_constant_override("separation", 0)
	_list_scroll.add_child(_list_container)


func _style_scrollbar(scroll: ScrollContainer) -> void:
	var grabber_normal: StyleBoxFlat = StyleBoxFlat.new()
	grabber_normal.bg_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
	grabber_normal.corner_radius_top_left = 4
	grabber_normal.corner_radius_top_right = 4
	grabber_normal.corner_radius_bottom_left = 4
	grabber_normal.corner_radius_bottom_right = 4
	
	var grabber_active: StyleBoxFlat = StyleBoxFlat.new()
	grabber_active.bg_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 3))
	grabber_active.corner_radius_top_left = 4
	grabber_active.corner_radius_top_right = 4
	grabber_active.corner_radius_bottom_left = 4
	grabber_active.corner_radius_bottom_right = 4
	
	var scroll_bg: StyleBoxFlat = StyleBoxFlat.new()
	scroll_bg.bg_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 0))
	scroll_bg.content_margin_left = 4
	scroll_bg.content_margin_right = 4
	
	var scrollbar: VScrollBar = scroll.get_v_scroll_bar()
	scrollbar.add_theme_stylebox_override("grabber", grabber_normal)
	scrollbar.add_theme_stylebox_override("grabber_highlight", grabber_active)
	scrollbar.add_theme_stylebox_override("grabber_pressed", grabber_active)
	scrollbar.add_theme_stylebox_override("scroll", scroll_bg)


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
		
	var path: String = "res://omni_chat_custom/sounds/" + sound_name + ".wav"
	if FileAccess.file_exists(path):
		var stream: AudioStream = load(path)
		_audio_cache[sound_name] = stream
		return stream
		
	return null


func start_dialogue(dialogue: ChatDialogue, open_immediately: bool = true) -> void:
	_dialogue_queue.append({
		"dialogue": dialogue,
		"open_immediately": open_immediately
	})
	
	if _is_processing_dialogue:
		return
		
	_is_processing_dialogue = true
	
	while not _dialogue_queue.is_empty():
		var item: Dictionary = _dialogue_queue.pop_front()
		await _process_dialogue(item.dialogue, item.open_immediately)
		
	_is_processing_dialogue = false


func _process_dialogue(dialogue: ChatDialogue, open_immediately: bool) -> void:
	if not dialogue:
		return
		
	register_contact(dialogue)
	var contact_name: String = tr(dialogue.contact_name)
	
	if open_immediately:
		_open_chat(contact_name)
		
	for message: String in dialogue.messages:
		await render_text(message, -1.0, contact_name)
		await get_tree().create_timer(0.5).timeout
		
	_conversations[contact_name].waiting = true
	_conversations[contact_name].last_time = Time.get_ticks_msec()
	
	if not dialogue.choices.is_empty():
		display_choices(dialogue.choices)


func register_contact(dialogue: ChatDialogue) -> void:
	var contact_name: String = tr(dialogue.contact_name)
	
	if not _conversations.has(contact_name):
		_conversations[contact_name] = {
			"name": contact_name,
			"avatar": dialogue.avatar,
			"messages": [],
			"last_msg": "",
			"unread": 0,
			"waiting": false,
			"last_time": 0
		}
		_refresh_list()


func render_text(text: String, speed: float = -1.0, contact: String = "") -> void:
	var final_speed: float = speed if speed > 0 else TYPING_SPEED
	var translated_text: String = tr(text)
	var target_contact: String = contact if contact != "" else _current_contact
	
	if target_contact != "":
		_conversations[target_contact].messages.append({"text": translated_text, "is_player": false})
		_conversations[target_contact].last_msg = translated_text
		
		if _current_contact != target_contact or _list_view.visible:
			_conversations[target_contact].unread += 1
			new_message_received.emit(target_contact)
			
			if _list_view.visible:
				_refresh_list()
				
	if _current_contact == target_contact and _chat_view.visible:
		var bubble: PanelContainer = _create_bubble(translated_text, false)
		add_message_child(bubble)
		var label: RichTextLabel = bubble.get_child(0) as RichTextLabel
		await _type_text(label, final_speed)
		
	message_rendered.emit(translated_text)


func select_choice(choice_id: String) -> void:
	if _active_choices.has(choice_id):
		_on_choice_pressed(choice_id, _active_choices[choice_id])


func _on_choice_pressed(choice_id: String, choice_text: String) -> void:
	var translated_choice: String = tr(choice_text)
	
	if _current_contact != "":
		_conversations[_current_contact].messages.append({"text": translated_choice, "is_player": true})
		_conversations[_current_contact].last_msg = translated_choice
		_conversations[_current_contact].waiting = false
		
	add_message_child(_create_bubble(translated_choice, true))
	clear_choices()
	choice_selected.emit(choice_id)


func send_player_message(text: String) -> void:
	var processed: String = _preprocess_text(text)
	
	if _current_contact != "":
		_conversations[_current_contact].messages.append({"text": processed, "is_player": true})
		_conversations[_current_contact].last_msg = processed
		
	add_message_child(_create_bubble(processed, true))


func _open_chat(contact_name: String) -> void:
	if not _conversations.has(contact_name):
		return
		
	_current_contact = contact_name
	_conversations[contact_name].unread = 0
	_chat_view.show()
	_list_view.hide()
	
	_name_label.text = contact_name
	_avatar_rect.texture = _conversations[contact_name].avatar
	
	_refresh_messages(contact_name)
	_scroll_to_bottom()
	chat_opened.emit(contact_name)


func _refresh_messages(contact_name: String) -> void:
	for child: Node in _message_log.get_children():
		child.queue_free()
		
	for msg: Dictionary in _conversations[contact_name].messages:
		var bubble: PanelContainer = _create_bubble(msg.text, msg.is_player)
		_message_log.add_child(bubble)
		(bubble.get_child(0) as RichTextLabel).visible_ratio = 1.0


func _show_list() -> void:
	if _current_contact != "" and _conversations.has(_current_contact):
		_conversations[_current_contact].last_time = Time.get_ticks_msec()
		
	_current_contact = ""
	_chat_view.hide()
	_list_view.show()
	_refresh_list()


func _check_reminders() -> void:
	var now: float = Time.get_ticks_msec()
	
	for contact_name: String in _conversations:
		var data: Dictionary = _conversations[contact_name]
		
		if data.waiting and _current_contact != contact_name and data.unread == 0:
			if now - data.last_time > REMINDER_DELAY * 1000:
				data.last_time = now
				data.unread = 1
				new_message_received.emit(contact_name)
				reminder_triggered.emit(contact_name)
				
				if _list_view.visible:
					_refresh_list()


func _refresh_list() -> void:
	for child: Node in _list_container.get_children():
		child.queue_free()
		
	for contact_name: String in _conversations:
		var data: Dictionary = _conversations[contact_name]
		var btn: Button = Button.new()
		btn.custom_minimum_size.y = 80
		btn.flat = true
		
		var hbox: HBoxContainer = HBoxContainer.new()
		hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hbox.add_theme_constant_override("separation", 12)
		hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(hbox)
		
		var margin: MarginContainer = MarginContainer.new()
		margin.add_theme_constant_override("margin_left", 8)
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(margin)
		
		var avatar: TextureRect = TextureRect.new()
		avatar.custom_minimum_size = Vector2(56, 56)
		avatar.texture = data.avatar
		avatar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		avatar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		margin.add_child(avatar)
		
		var vbox: VBoxContainer = VBoxContainer.new()
		vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(vbox)
		
		var font: FontFile = _get_main_font()
		var name_lbl: Label = Label.new()
		name_lbl.text = contact_name
		name_lbl.add_theme_font_override("font", font)
		name_lbl.add_theme_font_size_override("font_size", 24)
		name_lbl.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
		vbox.add_child(name_lbl)
		
		var last_lbl: Label = Label.new()
		var clean_text: String = data.last_msg
		var regex: RegEx = RegEx.new()
		regex.compile("\\[.*?\\]")
		clean_text = regex.sub(clean_text, "", true)
		
		var preview_text: String = clean_text.split("\n")[0].left(35)
		last_lbl.text = preview_text + "..." if preview_text.length() >= 35 else preview_text
		last_lbl.add_theme_font_override("font", font)
		last_lbl.add_theme_font_size_override("font_size", 18)
		last_lbl.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 4)))
		vbox.add_child(last_lbl)
		
		if data.unread > 0:
			var badge_margin: MarginContainer = MarginContainer.new()
			badge_margin.add_theme_constant_override("margin_right", 16)
			badge_margin.add_theme_constant_override("margin_top", 12)
			badge_margin.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			badge_margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
			hbox.add_child(badge_margin)
			
			var badge_panel: PanelContainer = PanelContainer.new()
			badge_panel.custom_minimum_size = Vector2(24, 24)
			var badge_style: StyleBoxFlat = StyleBoxFlat.new()
			badge_style.bg_color = Color(ColorChat.get_color(ColorChat.Name.BLUE))
			badge_style.corner_radius_top_left = 12
			badge_style.corner_radius_top_right = 12
			badge_style.corner_radius_bottom_left = 12
			badge_style.corner_radius_bottom_right = 12
			badge_panel.add_theme_stylebox_override("panel", badge_style)
			badge_margin.add_child(badge_panel)
			
			var unread_lbl: Label = Label.new()
			unread_lbl.text = str(data.unread)
			unread_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			unread_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			unread_lbl.add_theme_font_override("font", font)
			unread_lbl.add_theme_font_size_override("font_size", 16)
			unread_lbl.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
			badge_panel.add_child(unread_lbl)
			name_lbl.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.BLUE)))
			
		btn.pressed.connect(func() -> void:
			if interactive:
				_open_chat(contact_name)
		)
		
		var separator: ColorRect = ColorRect.new()
		separator.custom_minimum_size.y = 2
		separator.color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
		
		_list_container.add_child(btn)
		_list_container.add_child(separator)


func clear() -> void:
	for child: Node in _message_log.get_children():
		child.queue_free()
		
	_conversations.clear()
	clear_choices()
	_refresh_list()


func add_message_child(node: Node) -> void:
	_message_log.add_child(node)
	_scroll_to_bottom()


func display_choices(choices: Dictionary) -> void:
	clear_choices()
	_active_choices = choices.duplicate()
	_placeholder_hint.hide()
	
	choices_offered.emit(choices)
	
	for choice_id: String in choices:
		var choice_text: String = choices[choice_id]
		var btn: Button = Button.new()
		btn.text = choice_text
		btn.alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var font: FontFile = _get_main_font()
		btn.add_theme_font_override("font", font)
		btn.add_theme_font_size_override("font_size", 24)
		btn.add_theme_color_override("font_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
		btn.add_theme_color_override("font_hover_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
		
		var style_normal: StyleBoxFlat = StyleBoxFlat.new()
		style_normal.bg_color = Color(0, 0, 0, 0)
		style_normal.border_width_left = 2
		style_normal.border_width_top = 2
		style_normal.border_width_right = 2
		style_normal.border_width_bottom = 2
		style_normal.border_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
		style_normal.corner_radius_top_left = 12
		style_normal.corner_radius_top_right = 12
		style_normal.corner_radius_bottom_left = 12
		style_normal.corner_radius_bottom_right = 12
		style_normal.content_margin_top = 8
		style_normal.content_margin_bottom = 8
		
		var style_hover: StyleBoxFlat = style_normal.duplicate() as StyleBoxFlat
		style_hover.bg_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
		
		btn.add_theme_stylebox_override("normal", style_normal)
		btn.add_theme_stylebox_override("hover", style_hover)
		btn.add_theme_stylebox_override("pressed", style_hover)
		
		btn.pressed.connect(func() -> void:
			_on_choice_pressed(choice_id, choices[choice_id])
		)
		
		_choice_container.add_child(btn)


func clear_choices() -> void:
	_active_choices.clear()
	for child: Node in _choice_container.get_children():
		child.queue_free()
		
	_placeholder_hint.show()


func _update_interaction_mode() -> void:
	if not is_inside_tree():
		return
		
	mouse_filter = MOUSE_FILTER_IGNORE if not interactive else MOUSE_FILTER_STOP
	
	if _list_scroll:
		_list_scroll.mouse_filter = mouse_filter
		
	if _scroll_node:
		_scroll_node.mouse_filter = mouse_filter
		
	if _bottom_bar:
		_bottom_bar.visible = interactive
		
	if _back_btn:
		_back_btn.visible = interactive


func scroll_to_bottom() -> void:
	_scroll_to_bottom()


func _create_bubble(text: String, is_player: bool) -> PanelContainer:
	var bubble: PanelContainer = PanelContainer.new()
	var style: StyleBoxFlat = StyleBoxFlat.new()
	
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12 if is_player else 4
	style.corner_radius_bottom_right = 4 if is_player else 12
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	style.bg_color = Color(0, 0, 0, 0)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 2))
	
	if is_player:
		bubble.size_flags_horizontal = Control.SIZE_SHRINK_END
	else:
		bubble.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		
	bubble.add_theme_stylebox_override("panel", style)
	
	var label: RichTextLabel = RichTextLabel.new()
	label.bbcode_enabled = true
	label.fit_content = true
	
	for effect in _custom_effects:
		label.custom_effects.append(effect)
		
	var font: FontFile = _get_main_font()
	var clean_text: String = RegEx.create_from_string("\\[.*?\\]").sub(text, "", true)
	var text_width: float = font.get_string_size(clean_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 24).x
	
	if text_width > 280:
		label.custom_minimum_size = Vector2(280, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	else:
		label.autowrap_mode = TextServer.AUTOWRAP_OFF
		
	label.add_theme_font_override("normal_font", font)
	label.add_theme_font_size_override("normal_font_size", 24)
	label.add_theme_color_override("default_color", Color(ColorChat.get_color(ColorChat.Name.NEUTRAL, 6)))
	
	bubble.add_child(label)
	label.text = _preprocess_text(text)
	
	return bubble


func _type_text(label: RichTextLabel, speed: float) -> void:
	var base_speed: float = speed if speed > 0 else TYPING_SPEED
	var current_speed: float = base_speed
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
			"delay": 1.0 / s_val if s_val > 0 else base_speed,
			"sound": sound_name if not sound_name.is_empty() else "typewriter"
		}
		
	label.visible_ratio = 0.0
	await get_tree().process_frame
	await get_tree().process_frame
	var total_chars: int = label.get_total_character_count()
	
	for i in range(total_chars + 1):
		label.visible_characters = i
		
		if speed_map.has(i):
			current_speed = speed_map[i].delay
			_audio_player.stream = _load_sound(speed_map[i].sound)
			
		if current_speed > 0:
			if _audio_player.stream and i > 0:
				_audio_player.pitch_scale = randf_range(0.8, 1.2)
				_audio_player.play()
				
			await get_tree().create_timer(current_speed).timeout


func _preprocess_text(text: String) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("\\[omni_color=([A-Za-z_]+)(?:\\.(\\d))?\\]")
	var result: String = text
	
	for m: RegExMatch in regex.search_all(text):
		var color_name_str: String = m.get_string(1).to_upper()
		var shade_str: String = m.get_string(2)
		var shade: int = shade_str.to_int() if not shade_str.is_empty() else 3
		
		if color_name_str in ColorChat.Name.keys():
			var color_index: int = ColorChat.Name.keys().find(color_name_str)
			var hex: String = ColorChat.get_color(color_index as ColorChat.Name, shade)
			result = result.replace(m.get_string(), "[color=#%s]" % hex)
			
	result = result.replace("[/omni_color]", "[/color]")
	return result


func _scroll_to_bottom() -> void:
	await get_tree().process_frame
	
	if _scroll_node:
		_scroll_node.scroll_vertical = int(_scroll_node.get_v_scroll_bar().max_value)
