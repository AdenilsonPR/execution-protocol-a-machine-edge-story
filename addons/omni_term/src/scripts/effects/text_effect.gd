class_name TextEffect extends Resource


signal completed()


func set_value(_v: float) -> void:
	pass


func apply(_label: RichTextLabel) -> void:
	completed.emit()


func skip(_label: RichTextLabel) -> void:
	completed.emit()
