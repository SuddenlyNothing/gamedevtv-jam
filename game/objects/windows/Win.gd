extends Window

export(String, FILE, "*.tscn") var main_menu


func _on_AnimatedButton_pressed() -> void:
	get_tree().change_scene(main_menu)
