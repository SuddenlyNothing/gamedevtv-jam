extends Window

onready var timer := $Timer
onready var progress_bar := $V/ContentParent/M/V/ProgressBar
onready var label := $V/ContentParent/M/V/Label

export(String, FILE, "*.tscn") var end_scene

var max_dots := 4
var num_dots := 3


func _ready() -> void:
	set_as_toplevel(true)


func _process(delta: float) -> void:
	progress_bar.value = 100 - timer.time_left / timer.wait_time * 100


func _on_Timer_timeout() -> void:
	SceneHandler.goto_scene(end_scene)


func _on_DotTimer_timeout() -> void:
	num_dots = (num_dots + 1) % max_dots
	var label_text := "Virus Takeover"
	for i in max_dots - 1:
		if i < num_dots:
			label_text += "."
		else:
			label_text += " "
	label.text = label_text
