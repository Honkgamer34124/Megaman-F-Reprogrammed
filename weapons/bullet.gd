extends CharacterBody2D
var state: String = "active"
@export var direction = "left"
var SPEED = 50000  #100000.0
var blocked_speed = 10 * SPEED


func _ready():
	GlobalScript.lemons_on_screen += 1
	pass


func _physics_process(delta):
	match state:
		"active":
			match direction:
				"left":
					velocity.x = -SPEED * delta
				"right":
					velocity.x = SPEED * delta

		"blocked":
			match direction:
				"left":
					velocity.x = SPEED * delta
					velocity.y = -SPEED * delta
				"right":
					velocity.x = -SPEED * delta
					velocity.y = -SPEED * delta
		"stop":
			$detect_body_area/collision_shape2d.disabled = true
			velocity = Vector2.ZERO
			$anim.visible = false

	move_and_slide()


func _on_detect_body_area_area_entered(area):
	if area.is_in_group("enemy") and not area.is_in_group("enemy_projectile"):
		if state == "active":
			$sound_effect_channel1_i_guess.play()
			if area.get_parent().has_method("green"):
				if area.get_parent().hasbeenhit == false:
					area.get_parent().health -= 1
					area.get_parent().hasbeenhit = true
			else:
				area.get_parent().health -= 1
			state = "stop"
			#queue_free()
			#GlobalScript.lemons_on_screen-=1
	if area.is_in_group("blockable"):
		state = "blocked"
		$block.play()
	if area.is_in_group("boss"):
		pass


func _on_onscreen_notifier_screen_exited():
	queue_free()
	pass
	#GlobalScript.lemons_on_screen-=1


func _on_tree_exited():
	GlobalScript.lemons_on_screen -= 1


func _on_sound_effect_channel_1_i_guess_finished():
	queue_free()
