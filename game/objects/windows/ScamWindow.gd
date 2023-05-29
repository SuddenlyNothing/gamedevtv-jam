extends Window

const SmallVirus := preload("res://characters/SmallVirus.tscn")

var stopped := true

onready var download := $"%Download"
onready var particles := $VirusSpawnParticles
onready var timer := $Timer

onready var flicker_timer := $FlickerTimer
onready var flicker_interval_timer := $FlickerIntervalTimer
onready var dialog_player := $CanvasLayer/DialogPlayer


func _ready() -> void:
	if stopped:
		download.disabled = true
		flicker_timer.start()
		flicker_interval_timer.start()
	else:
		dialog_player.read(dialog_player.autoplay_dialog)
	set_process(false)


func _process(delta: float) -> void:
	rect_position = Vector2((randf() - 0.5) * 10, (randf() - 0.5) * 20)


func _on_Download_pressed() -> void:
	timer.start()
	download.disabled = true
	particles.emitting = true
	set_process(true)
	var sv := SmallVirus.instance()
	sv.global_position = download.rect_global_position + download.rect_size / 2
	sv.target = Vector2(0, 200)
	sv.connect("tree_exited", self, "_on_sv_destroyed")
	add_child(sv)


func _on_Timer_timeout() -> void:
	set_process(false)
	rect_position = Vector2()


func _on_sv_destroyed() -> void:
#	set_process(false)
#	rect_position = Vector2()
	flicker_timer.start()
	flicker_interval_timer.start()


func _on_FlickerTimer_timeout() -> void:
	flicker_interval_timer.stop()
	hide()
	emit_signal("closed")


func _on_FlickerIntervalTimer_timeout() -> void:
	flicker_interval_timer.wait_time -= 0.005
	flicker_interval_timer.start()
	visible = not visible
