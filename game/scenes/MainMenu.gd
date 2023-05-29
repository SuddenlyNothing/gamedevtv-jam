extends Control

export(String, FILE, "*.tscn") var play_scene


func _ready() -> void:
	Variables.seen_player = false
	Variables.scam_seen = false
	Variables.visited_folders = {}


func _on_Play_pressed() -> void:
	SceneHandler.goto_scene(play_scene)


func _on_Settings_pressed() -> void:
	OptionsMenu.set_active(true)
