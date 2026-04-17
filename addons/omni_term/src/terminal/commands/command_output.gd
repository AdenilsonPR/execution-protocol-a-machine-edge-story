class_name CommandOutput extends RefCounted


var text: String = ""
var effects: Array[TextEffect] = []


static func create(output_text: String) -> CommandOutput:
	var output: CommandOutput = CommandOutput.new()
	output.text = output_text
	return output


func add_effect(effect: TextEffect) -> CommandOutput:
	effects.append(effect)
	return self
