extends CharacterBody2D
@export var direction = "left"
var SPEED = 50000.0  #100000.0
var blocked_speed = 1.5 * SPEED
var state: String = "active"


func _ready():
	$anim.play("lv1_chargeshot")


func _physics_process(delta):  #original direction=right
	match state:
		"active":
			match direction:
				"left":
					set_rotation_degrees(180)
					velocity.x = -SPEED * delta
				"right":
					set_rotation_degrees(0)
					velocity.x = SPEED * delta

		"blocked":
			match direction:
				"left":
					set_rotation_degrees(180)
					velocity.x = blocked_speed * delta
					velocity.y = -blocked_speed * delta
				"right":
					set_rotation_degrees(0)
					velocity.x = -blocked_speed * delta
					velocity.y = -blocked_speed * delta
		"stop":
			velocity = Vector2.ZERO
			$detect_body_area/CollisionShape2D.disabled = true
			$anim.visible = false

	move_and_slide()


func _on_detect_body_area_area_entered(area):  #this signal makes the lv1chargeshot reduce enemy health by 3
	if area.is_in_group("enemy") and not area.is_in_group("enemy_projectile"):
		var body = area.get_parent()
		if state == "active":
			if area.get_parent().has_method("green"):
				if area.get_parent().hasbeenhit == false:
					area.get_parent().health -= 3
					area.get_parent().hasbeenhit = true
			elif body.isBoss == false:
				area.get_parent().health -= 3
			elif body.isBoss == true:
				body.health -= (3 - body.BossdefenseLvlOneShot)
			$sound_effect_channel1_i_guess.play()
			state = "stop"
	if area.is_in_group("blockable"):
		state = "blocked"
		$block.play()


func _on_detect_body_area_body_entered(body):
#	if body.is_in_group("tilemap") or body.is_in_group("door"):
#		queue_free()
	pass


func _on_onscreen_screen_exited():
	queue_free()


func _on_sound_effect_channel_1_i_guess_finished():
	pass  # Replace with function body.
	queue_free()
