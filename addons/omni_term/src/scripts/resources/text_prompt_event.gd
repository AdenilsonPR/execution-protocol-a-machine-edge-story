class_name TextPromptEvent extends StoryEvent


@export var label: String = "input:"
@export_multiline var text: String = ""
@export var speed: float = 30.0
@export var is_password: bool = false
@export var sound_id: String = ""


@export_group("Branching")
@export var result_keys: Array[String] = []
@export var result_branches: Array[StorySequence] = []
@export var default_branch: StorySequence = null
