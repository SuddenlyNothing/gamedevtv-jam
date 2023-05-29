extends AnimatedButton

export(String) var item_name := "Folder"

onready var label := $M/V/Control/Label


func _ready() -> void:
	label.text = item_name
