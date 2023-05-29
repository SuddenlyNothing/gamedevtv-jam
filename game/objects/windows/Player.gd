extends Window


func _ready() -> void:
	if Variables.seen_player:
		return
	var dp := $CanvasLayer/DialogPlayer
	dp.read(dp.autoplay_dialog)
	Variables.seen_player = true
