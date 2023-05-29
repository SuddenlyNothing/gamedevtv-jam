extends AnimatedSprite

const DeathParticles := preload("res://characters/DeathParticles.tscn")

export var step_size := 42

var target := Vector2()
var rand_walk := true
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	set_as_toplevel(true)
	rng.randomize()
	if rand_walk:
		rand_target()
	play("walk")


func rand_target() -> void:
	target = Vector2(rng.randf_range(0, 1024), rng.randf_range(0, 600))


func _on_SmallVirus_animation_finished() -> void:
	if position.distance_to(target) < step_size:
		if rand_walk:
			rand_target()
		else:
			queue_free()
	position += Vector2.RIGHT.rotated(rotation) * step_size
	rotation = position.angle_to_point(target) + PI


func _on_Area2D_area_entered(area: Area2D) -> void:
	var dp := DeathParticles.instance()
	dp.position = position
	dp.set_as_toplevel(true)
	get_parent().add_child(dp)
	queue_free()
