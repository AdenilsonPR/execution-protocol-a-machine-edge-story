class_name TerminalSoundBank extends Resource


@export var sounds: Dictionary = {}
@export var default_pitch_range: Vector2 = Vector2(0.9, 1.1)
@export var default_volume_db: float = 0.0


func get_sound(sound_id: String) -> AudioStream:
	if sounds.has(sound_id):
		return sounds[sound_id]

	return null
