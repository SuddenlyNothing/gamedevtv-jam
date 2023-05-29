extends StateMachine
# warnings-disable

func _ready() -> void:
	add_state("idle")
	add_state("walk")
	add_state("jump")
	add_state("fall")
	call_deferred("set_state", "jump")


func _state_logic(delta : float) -> void:
	match state:
		states.idle:
			parent.move(delta, true, true)
		states.walk:
			parent.set_facing()
			parent.move(delta, true, true)
		states.jump:
			parent.set_facing()
			parent.move(delta, false, false)
		states.fall:
			parent.set_facing()
			parent.move(delta, false, true)


func _get_transition(delta : float):
	match state:
		states.idle:
			if parent.can_jump(true):
				return states.jump
			if parent.x_input != 0:
				return states.walk
			if not parent.is_on_floor():
				return states.fall
		states.walk:
			if parent.can_jump(true):
				return states.jump
			if parent.velocity.x == 0 and parent.x_input == 0:
				return states.idle
			if not parent.is_on_floor():
				return states.fall
		states.jump:
			if parent.velocity.y > 0:
				return states.fall
		states.fall:
			if parent.can_jump(false):
				return states.jump
			if parent.is_on_floor():
				if parent.velocity.x != 0:
					return states.walk
				else:
					return states.idle
	return null


func _enter_state(new_state, old_state) -> void:
	match new_state:
		states.idle:
			parent.play_anim("idle")
		states.walk:
			parent.play_anim("walk")
		states.jump:
			parent.play_anim("jump")
			parent.jump()
		states.fall:
			parent.play_anim("fall")
			if old_state == states.walk or old_state == states.idle:
				parent.coyote_timer.start()


func _exit_state(old_state, new_state) -> void:
	match old_state:
		states.idle:
			pass
		states.walk:
			pass
		states.jump:
			pass
		states.fall:
			if new_state == "idle" or new_state == "walk":
				parent.land_sfx.play()
