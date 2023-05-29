extends Control

export(String, FILE, "*.tscn") var main_menu


func _on_Timer_timeout() -> void:
	SceneHandler.goto_scene(main_menu)
