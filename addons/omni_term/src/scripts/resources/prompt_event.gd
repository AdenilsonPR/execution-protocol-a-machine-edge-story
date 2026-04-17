class_name PromptEvent extends StoryEvent


@export_multiline var text: String = ""
@export var speed: float = 30.0
@export var sound_id: String = ""
@export var input_name: String = ""
@export var params: Dictionary = {}


@export_group("Branching")
@export var result_keys: Array[String] = []
@export var result_branches: Array[StorySequence] = []
@export var default_branch: StorySequence = null
