extends CharacterBody2D
@export var direction = "left"
var state: String = "active"

var SPEED = 55000.0  #100000.0
var blocked_speed = 1.5 * SPEED


func _ready():
	match direction:
		"left":
#			$anim.flip_h=false
			$anim.play("lv2_chargeshot")
			#scale.x=3
			#or #scale=-3(since 3 is for the magnified size of the screen object)
		"right":
			#$anim.flip_h=true
			#set_rotation_degrees(180)
			#self.scale.x=-3
			$anim.play("lv2_chargeshot")
			#scale.x=-3
			#$anim.flip_h=true


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


#has_signal()
func _on_detect_body_area_area_entered(area):  #this signal makes the lv1chargeshot reduce enemy health by 5
	if area.is_in_group("enemy") and not area.is_in_group("enemy_projectile"):
		var body = area.get_parent()
		if state == "active":
			if area.get_parent().has_method("green"):
				if area.get_parent().hasbeenhit == false:
					area.get_parent().health -= 5
					area.get_parent().hasbeenhit = true
			elif body.isBoss == false:
				area.get_parent().health -= 5
			elif body.isBoss == true:
				body.health -= (5 - body.Bossdefense)
			state = "stop"
			$sound_effect_channel1_i_guess.play()
	if area.is_in_group("blockable"):
		state = "blocked"
		$block.play()


func _on_onscreen_screen_exited():
	queue_free()


func _on_sound_effect_channel_1_i_guess_finished():
	queue_free()
