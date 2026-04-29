class_name CommandOutput extends RefCounted


var text: String = ""
var same_line: bool = false


static func create(output_text: String, p_same_line: bool = false) -> CommandOutput:
	var output: CommandOutput = CommandOutput.new()
	output.text = output_text
	output.same_line = p_same_line

	return output
