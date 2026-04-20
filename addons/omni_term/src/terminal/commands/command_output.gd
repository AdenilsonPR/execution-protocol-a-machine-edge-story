class_name CommandOutput extends RefCounted


var text: String = ""


static func create(output_text: String) -> CommandOutput:
	var output: CommandOutput = CommandOutput.new()
	output.text = output_text

	return output
