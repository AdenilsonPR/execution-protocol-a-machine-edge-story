class_name ColorTerm extends RefCounted


static var _palette_cache: Resource = null

static func _get_palette() -> Resource:
	if _palette_cache:
		return _palette_cache
		
	var path: String = ProjectSettings.get_setting("omni_system/theme/color_palette", "res://addons/omni_term/assets/color_palettes/base_palette.tres")
	if ResourceLoader.exists(path):
		_palette_cache = load(path)
	else:
		_palette_cache = load("res://addons/omni_term/assets/color_palettes/base_palette.tres")
		
	return _palette_cache


enum Name {
	RED,
	BLUE,
	GREEN,
	YELLOW,
	ORANGE,
	TEAL_GREEN,
	PINK,
	NEUTRAL
}


static func get_color(color_name: Name, color_brightness: int = 3) -> String:
	var palette: Resource = _get_palette()
	if not palette:
		return "ffffff"
		
	var colors: Array = palette.get("colors").slice(color_name * 7, (color_name * 7) + 7)
	return colors[color_brightness].to_html(false)