extends SceneTree

func _init():
	print("--- START DEBUG ---")
	var path = ProjectSettings.get_setting("omni_term/paths/effects", "")
	print("Path from settings: ", path)
	
	if path == "":
		print("Path is empty!")
	else:
		var dir = DirAccess.open(path)
		if dir:
			print("Dir opened: ", path)
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				print("Found file: ", file_name)
				if not dir.current_is_dir() and file_name.ends_with(".gd"):
					var full_path = path + file_name
					print("Checking full_path: ", full_path)
					if ResourceLoader.exists(full_path):
						var script = load(full_path)
						if script:
							var inst = script.new()
							if inst is RichTextEffect:
								print("Effect valid!")
							else:
								print("Effect invalid! is not RichTextEffect")
						else:
							print("Script load failed!")
					else:
						print("ResourceLoader.exists returned false!")
				file_name = dir.get_next()
		else:
			print("Failed to open dir: ", path)
	print("--- END DEBUG ---")
	quit()
