extends AnimatedSprite

export var step_size := 42

var target := Vector2()


func _ready() -> void:
	play("walk")


func _on_SmallVirus_animation_finished() -> void:
	if position.distance_to(target) < step_size:
		queue_free()
	position += Vector2.RIGHT.rotated(rotation) * step_size
	rotation = position.angle_to_point(target) + PI
