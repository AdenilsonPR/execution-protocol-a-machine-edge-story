class_name ChatCommand extends CommandBase


func _init() -> void:
	command_name = tr("CHAT_COMMAND")
	description = tr("CHAT_COMMAND_DESCRIPTION")
	
	
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var tree: SceneTree = context.terminal.get_tree()
	var chat: OmniChat = tree.get_first_node_in_group("omni_chat") as OmniChat
	
	if not chat:
		return CommandOutput.create("[omni_color=RED]Erro: Sistema de Chat nao encontrado.[/omni_color]")
	
	if args.is_empty():
		var data: Dictionary = chat.get_save_data()
		if data.is_empty():
			return CommandOutput.create("[omni_color=NEUTRAL.4]Nenhuma conversa ativa.[/omni_color]")
		
		var output: String = "[omni_color=BLUE]=== CONTATOS ===[/omni_color]\n"
		for contact_name: String in data:
			var info: Dictionary = data[contact_name]
			var unread: String = " [omni_color=BLUE](%d)[/omni_color]" % info.unread if info.unread > 0 else ""
			output += "- %s%s\n" % [contact_name, unread]
		
		output += "\n[omni_color=NEUTRAL.4]Use 'chat [nome]' para abrir.[/omni_color]"
		return CommandOutput.create(output)
	
	var contact_name: String = args[0]
	
	if not chat.get_save_data().has(contact_name):
		return CommandOutput.create("[omni_color=RED]Usuario '%s' nao encontrado.[/omni_color]" % contact_name)
	
	chat.open_conversation(contact_name)
	OmniNarrative.set_var("chat_opened", true)
	
	return CommandOutput.create("Abrindo conversa com [omni_color=YELLOW]%s[/omni_color]..." % contact_name)


func get_suggestions(_args: PackedStringArray, context: CommandContext) -> PackedStringArray:
	var tree: SceneTree = context.terminal.get_tree()
	var chat: OmniChat = tree.get_first_node_in_group("omni_chat") as OmniChat
	
	if not chat:
		return PackedStringArray()
	
	var contacts: PackedStringArray = PackedStringArray()
	for contact_name: String in chat.get_save_data().keys():
		contacts.append(contact_name)
	
	return contacts
