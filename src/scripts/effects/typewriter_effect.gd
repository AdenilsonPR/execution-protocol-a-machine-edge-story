class_name TypewriterEffect extends RichTextEffect

var bbcode = "typewriter"

var is_finished: bool = false
var _last_frame: int = -1

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var current_frame: int = Engine.get_frames_drawn()
	if current_frame != _last_frame:
		_last_frame = current_frame
		is_finished = true
		
	var speed: float = float(char_fx.env.get("s", 50.0))
	var delay: float = float(char_fx.env.get("d", 0.0))
	var adjusted_time: float = char_fx.elapsed_time - delay

	if adjusted_time < 0.0:
		char_fx.color.a = 0.0
		is_finished = false
		return true

	var time: float = adjusted_time * speed

	if char_fx.relative_index > time:
		char_fx.color.a = 0.0
		is_finished = false
		
	return true
