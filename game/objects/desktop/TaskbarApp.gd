tool
class_name TaskbarApp
extends AnimatedButton

export(String) var app_name
export(Texture) var app_icon setget set_app_icon
export(String, FILE, "*.tscn") var open_with

onready var using := $Using


func set_using(is_using: bool) -> void:
	using.visible = is_using


func set_app_icon(new_icon: Texture) -> void:
	
	app_icon = new_icon
	var icon_texture: TextureRect = get_node_or_null("M/TextureRect")
	if icon_texture:
		icon_texture.texture = new_icon
