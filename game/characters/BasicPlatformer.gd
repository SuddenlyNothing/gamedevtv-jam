extends KinematicBody2D
class_name BasicPlatformer
# warnings-disable

var jump_height : float = 200.0
var jump_time_to_peak : float = 0.27
var jump_time_to_descent : float = 0.35

var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var max_move_speed : float = 400
var max_fall_speed : float = fall_gravity * jump_time_to_descent

var acceleration_time : float = 0.13
var turn_acceleration_time : float = 0.08
var air_friction_time : float = 0.2
var ground_friction_time : float = 0.15

var acceleration : float = max_move_speed / acceleration_time
var turn_acceleration : float = max_move_speed / turn_acceleration_time
var air_friction : float = max_move_speed / air_friction_time
var ground_friction : float = max_move_speed / ground_friction_time

var x_input := 0
var velocity := Vector2()
var locked := false setget set_locked

var snap := Vector2.DOWN * 0.5
var up := Vector2.UP

onready var flip := $Flip
onready var anim_sprite := $Flip/AnimatedSprite
onready var coyote_timer := $CoyoteTimer
onready var jump_buffer_timer := $JumpBufferTimer
onready var jump_sfx := $JumpSFX
onready var land_sfx := $LandSFX
onready var attack := $Flip/Attack
onready var hitbox_collision := $Flip/Hitbox/CollisionShape2D


func _process(delta : float) -> void:
	if locked:
		return
	set_x_input()
	if Input.is_action_just_pressed("up"):
		jump_buffer_timer.start()
	if Input.is_action_just_pressed("attack"):
		attack.play("attack")


func set_locked(val: bool) -> void:
	locked = val
	set_process(not val)
	x_input = 0


func move(delta : float, is_on_ground : bool, is_falling : bool) -> void:
	apply_acceleration(delta)
	apply_velocity(delta, is_on_ground)
	apply_friction(delta, is_on_ground)
	apply_gravity(delta, is_falling)


func can_jump(is_on_ground : bool) -> bool:
	if locked:
		return false
	var pressed_up = Input.is_action_just_pressed("up")
	if is_on_ground:
		if pressed_up:
			return true
		if not jump_buffer_timer.is_stopped():
			return true
	else:
		if pressed_up and not coyote_timer.is_stopped():
			return true
	return false


func set_facing() -> void:
	if x_input > 0 and flip.scale.x < 0:
		flip.scale.x *= -1
	elif x_input < 0 and flip.scale.x > 0:
		flip.scale.x *= -1


func set_x_input() -> void:
	x_input = Input.get_action_strength("right") - Input.get_action_strength("left")


func apply_acceleration(delta : float) -> void:
	if position.y > 600:
		position = Vector2(512, 0)
	if sign(x_input) == sign(velocity.x) or velocity.x == 0:
		velocity.x = clamp(velocity.x + acceleration * x_input * delta, -max_move_speed, max_move_speed)
	else:
		velocity.x = clamp(velocity.x + turn_acceleration * x_input * delta, -max_move_speed, max_move_speed)


func apply_friction(delta : float, is_on_ground : bool) -> void:
	if x_input != 0:
		return
	var friction : float = 0
	if is_on_ground:
		friction = ground_friction
	else:
		friction = air_friction
	var friction_amount := friction * delta
	if abs(velocity.x) <= friction_amount / 2.0:
		velocity.x = 0
	elif velocity.x > 0:
		velocity.x -= friction_amount
	else:
		velocity.x += friction_amount


func apply_velocity(delta : float, is_on_ground : bool) -> void:
	if is_on_ground:
		velocity = move_and_slide_with_snap(velocity, snap, up)
	else:
		velocity = move_and_slide(velocity, up)


func apply_gravity(delta : float, is_falling : bool) -> void:
	if is_falling:
		velocity.y = min(velocity.y + fall_gravity * delta, max_fall_speed)
	else:
		velocity.y = min(velocity.y + jump_gravity * delta, max_fall_speed)


func jump() -> void:
	velocity.y = jump_velocity
	jump_sfx.play()


func play_anim(anim : String) -> void:
	if anim_sprite.animation == anim:
		return
	anim_sprite.play(anim)


func _on_Attack_frame_changed() -> void:
	if attack.animation == "attack":
		if attack.frame == 1:
			hitbox_collision.call_deferred("set_disabled", false)
		if attack.frame == 3:
			hitbox_collision.call_deferred("set_disabled", true)


func _on_Attack_animation_finished() -> void:
	attack.play("default")
