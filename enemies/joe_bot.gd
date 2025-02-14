extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
var projectile = preload("res://enemies/joe_bot_projectile.tscn")

const SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 3000


func _ready():
	playerdamage_value = 3
	health = 8
	state = "idle"


#var state='';
var bullet_detected = false
var shoot_timer: int
var distance


func _physics_process(delta):
	distance = abs(GlobalScript.player_position_x - global_position.x)
#	if distance<200:
#		if state!='player_detected':
#			state='player_detected'
#	else:
#		state='idle'
	#print('joebot:distance b/n player(pixels):',distance)
	#print('joebot:chace to jump:',chance_to_jump)
	#print('joebot:shoot_timer:',shoot_timer)
	if GlobalScript.player_position_x - global_position.x < 0:
		animated_sprite_2d.flip_h = false
	elif GlobalScript.player_position_x - global_position.x > 0:
		animated_sprite_2d.flip_h = true
	if player_around == true:
		pass
	if $player_detect_cooldown.time_left > 0:
		#state="player_detected"
		$detect_player_zone/CollisionShape2D.disabled = true
	else:
		$detect_player_zone/CollisionShape2D.disabled = false
	match state:
		"idle":
#			if distance<500 : #animated_sprite_2d.frame==7 and animated_sprite_2d.animation=='idle' and

			animated_sprite_2d.play("idle")
			velocity.x = 0
#			if distance>0:
#				state='jump'
			#$detect_player_zone/CollisionShape2D.disabled=false
			if animated_sprite_2d.flip_h == false:
				$shield_block/right.disabled = true
				$shield_block/left.disabled = false
			elif animated_sprite_2d.flip_h == true:
				$shield_block/right.disabled = false
				$shield_block/left.disabled = true
			#$shield_block/right.disabled=true
		"player_detected":
			if animated_sprite_2d.animation != "player_detected":
				animated_sprite_2d.play("player_detected")
		"shoot":
			if animated_sprite_2d.animation != "shoot":
				animated_sprite_2d.play("shoot")
				$player_detect_cooldown.start()
				chance_to_jump = randi_range(1, 2)
			$shield_block/right.disabled = true
			$shield_block/left.disabled = true
			if animated_sprite_2d.animation == "shoot":
				if animated_sprite_2d.frame == 2:
					shoot_timer += 1
				else:
					shoot_timer = 0
				if shoot_timer == 1 or shoot_timer == 4 or shoot_timer == 7:
					var proj_ins = projectile.instantiate()
					if animated_sprite_2d.flip_h == false:
						proj_ins.direction = "left"
					elif animated_sprite_2d.flip_h == true:
						proj_ins.direction = "right"
					get_parent().add_child(proj_ins)
					match animated_sprite_2d.flip_h:
						false:
							proj_ins.global_position = $shoot_locations/left.global_position
						true:
							proj_ins.global_position = $shoot_locations/right.global_position
					$all_sound_effects/shoot_sound_effect.play()
			#$detect_player_zone/CollisionShape2D.disabled=true
			$shield_block/left.disabled = true
			$shield_block/right.disabled = true
		"blocked":
			animated_sprite_2d.play("blocked")
			match animated_sprite_2d.flip_h:
				false:
					$shield_block/left.disabled = false
					$shield_block/right.disabled = true
				true:
					$shield_block/left.disabled = true
					$shield_block/right.disabled = false
		"jump":
			if is_on_floor():
				if not has_jumped:
					velocity.y = JUMP_VELOCITY
					#if distance>0:
					#velocity.x=10000*delta
					#print(name+':detects player to its right,response:jumps towards him')
					has_jumped = true
				if has_jumped and velocity.y >= 0:
					state = "idle"
					has_jumped = false
			if animated_sprite_2d.animation != "jump":
				animated_sprite_2d.play("jump")
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
#	if  health<=0:
#		get_tree().call_group("enemy_spawners","reduce_spawn_number",index)
	offset_animations()  #offsets animations of the joe bot
	spawn_collectables()  # from the enemy class
	move_and_slide()  #causes the joe bot to have physics


var has_jumped = false
var chance_to_jump


func offset_animations():
	if animated_sprite_2d.animation == "jump":
		animated_sprite_2d.offset = Vector2(0, -9)
	else:
		animated_sprite_2d.offset = Vector2.ZERO


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		"player_detected":
			state = "shoot"
		"shoot":
			match chance_to_jump:
				1:
					state = "idle"
				2:
					if distance < 300:
						state = "jump"
					else:
						state = "idle"
		"blocked":
			state = "idle"
		"jump":
#			if is_on_floor() and has_jumped:
#				state='idle'
#				has_jumped=false
			pass


var player_around = false


func _on_detect_player_zone_body_entered(body):
	if body.is_in_group("player"):
		player_around = true
		state = "player_detected"
	pass


func _on_detect_player_zone_body_exited(body):
	if body.is_in_group("player"):
		player_around = false
	pass


func _on_shield_block_area_entered(area):
	#if area.is_in_group("player_projectiles"):
	#area.get_parent().state="blocked"
	#$all_sound_effects/block_sound_effect.play()
	pass


func _on_detect_proj_area_entered(area):
	if area.is_in_group("player_projectiles"):  # or animated_sprite_2d.animation=="idle"
		if animated_sprite_2d.animation == "idle":
			state = "blocked"


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
