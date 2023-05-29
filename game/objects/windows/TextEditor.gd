extends Window

var file: Txt

onready var text_edit := $V/ContentParent/TextEdit


func _ready() -> void:
	if !file:
		return
	text_edit.text = file.content


func _on_TextEdit_text_changed() -> void:
	if !file:
		return
	file.content = text_edit.text
