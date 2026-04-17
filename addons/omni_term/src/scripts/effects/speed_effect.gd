class_name SpeedEffect extends TextEffect


@export var chars_per_second: float = 30.0


var _tween: Tween
var is_completed: bool = false


static func create(cps: float) -> SpeedEffect:
	var effect: SpeedEffect = SpeedEffect.new()
	effect.chars_per_second = cps
	return effect


func set_value(v: float) -> void:
	chars_per_second = v


func apply(label: RichTextLabel) -> void:
	label.visible_characters = 0
	var total_chars: int = label.get_total_character_count()

	if total_chars == 0:
		is_completed = true
		completed.emit()
		return

	var duration: float = total_chars / chars_per_second

	_tween = label.create_tween()
	_tween.tween_property(label, "visible_characters", total_chars, duration)
	_tween.finished.connect(func():
		is_completed = true
		completed.emit()
	)

	if not is_completed:
		await completed


func skip(label: RichTextLabel) -> void:
	if _tween and _tween.is_running():
		_tween.kill()

	label.visible_characters = -1
	is_completed = true
	completed.emit()
