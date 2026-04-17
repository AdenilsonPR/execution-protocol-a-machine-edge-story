class_name ChoiceEvent extends StoryEvent


@export_multiline var text: String = ""
@export var speed: float = 30.0
@export var color: Color = Color.WHITE
@export var options: Array[String] = []
@export var option_keys: Array[String] = []
@export var branches: Array[StorySequence] = []
@export var sound_id: String = ""
