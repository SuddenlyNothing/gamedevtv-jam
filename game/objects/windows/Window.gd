class_name Window
extends Control

signal minimized
signal closed

const MaximizeIcon := preload("res://assets/temp/maximize.png")
const Maximize2Icon := preload("res://assets/temp/maximize2.png")

const WindowBounds := Rect2(200, 0, 1024-400, 570)

export(bool) var start_maximized := false

var t: SceneTreeTween
var offset := Vector2()
var moving := false
var pre_maximize_position := Vector2()
var maximized := false
var drag_start_pos := Vector2()
var minimized := false setget set_minimized
var pre_minimize_pos := Vector2()

onready var default_size := rect_size
onready var maximize_icon := $V/Controls/H/Maximize/Icon
onready var double_click_timer := $DoubleClickTimer


func _process(delta: float) -> void:
	if moving:
		rect_position.x = clamp(get_global_mouse_position().x + offset.x,
				WindowBounds.position.x - rect_size.x,
				WindowBounds.position.x + WindowBounds.size.x)
		rect_position.y = clamp(get_global_mouse_position().y + offset.y,
				WindowBounds.position.y,
				WindowBounds.position.y + WindowBounds.size.y)


func set_minimized(val: bool, pos: Vector2 = Vector2()) -> void:
	if val:
		pre_minimize_pos = rect_position
		if t:
			t.kill()
		t = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)\
				.set_parallel()
		t.tween_property(self, "rect_scale", Vector2(), 0.16)
		t.tween_property(self, "modulate:a", 0.0, 0.16)
		t.tween_property(self, "rect_global_position", pos, 0.16)
		t.chain().tween_callback(self, "hide")
	elif minimized != val:
		show()
		if t:
			t.kill()
		t = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)\
				.set_parallel()
		t.tween_property(self, "rect_scale", Vector2.ONE, 0.16)
		t.tween_property(self, "modulate:a", 1.0, 0.16)
		t.tween_property(self, "rect_position", pre_minimize_pos, 0.16)
	minimized = val


func _on_Close_pressed() -> void:
	if t:
		t.kill()
	rect_pivot_offset = rect_size / 2
	emit_signal("closed")
	t = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)\
			.set_parallel()
	t.tween_property(self, "rect_scale", Vector2.ONE * 0.9, 0.1)
	t.tween_property(self, "modulate:a", 0.0, 0.1)
	t.chain().tween_callback(self, "queue_free")


func _on_Minimize_pressed() -> void:
	emit_signal("minimized")


func _on_Maximize_pressed() -> void:
	if t:
		t.kill()
	t = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)\
			.set_parallel()
	var dur := 0.15
	if maximized:
		maximize_icon.texture = MaximizeIcon
		t.tween_property(self, "rect_position", pre_maximize_position, dur)
		t.tween_property(self, "rect_size", default_size, dur)
	else:
		maximize_icon.texture = Maximize2Icon
		pre_maximize_position = rect_position
		t.tween_property(self, "rect_position", Vector2(), dur)
		t.tween_property(self, "rect_size", get_viewport_rect().size - Vector2(0, 50), dur)
	maximized = !maximized


func _on_WindowControls_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			moving = true
			offset = rect_global_position - get_global_mouse_position()
			if double_click_timer.is_stopped():
				double_click_timer.start()
			elif drag_start_pos == get_global_mouse_position():
				_on_Maximize_pressed()
				moving = false
				double_click_timer.stop()
			drag_start_pos = get_global_mouse_position()
		else:
			moving = false


func _on_ShowTimer_timeout() -> void:
	show()
	if start_maximized:
		rect_position = Vector2()
		rect_size = get_viewport_rect().size - Vector2(0, 50)
	modulate.a = 0
	rect_scale = Vector2.ONE * 1.05
	rect_pivot_offset = rect_size / 2
	t = create_tween().set_parallel()
	t.tween_property(self, "modulate:a", 1.0, 0.05)
	t.tween_property(self, "rect_scale", Vector2.ONE, 0.05)
	yield(t, "finished")
	rect_pivot_offset = Vector2()


func _on_Window_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			var parent := get_parent()
			parent.move_child(self, parent.get_child_count() - 1)
