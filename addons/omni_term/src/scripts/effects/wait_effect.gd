class_name WaitEffect extends TextEffect


@export var duration: float = 1.0


static func create(dur: float) -> WaitEffect:
	var effect: WaitEffect = WaitEffect.new()
	effect.duration = dur
	return effect


func set_value(v: float) -> void:
	duration = v


func apply(label: RichTextLabel) -> void:
	if duration <= 0:
		completed.emit()
		return

	await label.get_tree().create_timer(duration).timeout
	completed.emit()
