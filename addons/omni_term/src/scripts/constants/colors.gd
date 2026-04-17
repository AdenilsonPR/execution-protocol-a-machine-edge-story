class_name Colors


const BASE_PALETTE: Resource = preload("res://addons/omni_term/assets/color_palettes/base_palette.tres")



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
	var colors: Array = BASE_PALETTE.get("colors").slice(color_name * 7, (color_name * 7) + 7)
	return colors[color_brightness].to_html(false)
