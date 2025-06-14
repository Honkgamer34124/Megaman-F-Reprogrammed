extends enemy

const SPEED = 30000.0
@export var JUMP_VELOCITY = -800.0
#var state=""
@onready var animated_sprite_2d = $AnimatedSprite2D
var ready_to_go = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var gravity = 1000
#var array:Array={"on_ceiling"=JUMP_VELOCITY}
var already_jumped: bool = false
var projectile_to_shoot = preload("res://enemies/bosses/mini_yellow_devil_projectiles.tscn")
var projectile2 = preload("res://enemies/bosses/mini_yellow_devil_projectile_2.tscn")
var proj_instance
var shoot_timer = 0
var blink_time = 0


func _ready():
	isBoss = true
	Bossdefense = 2
	BossdefenseLvlOneShot = 2
	$shoot_effect.visible = false
	state = "on_ceiling"
	playerdamage_value = 5
	#default health is 26.
	health = 26


func _physics_process(delta):
	GlobalScript.boss_health[1] = health
	if $hitcooldown_timer.time_left > 0:
		$hitbox_body/CollisionShape2D.disabled = true
		blink_time += 1
		if blink_time % 5 == 1:
			animated_sprite_2d.visible = false
		elif blink_time % 5 == 3:
			animated_sprite_2d.visible = true
	else:
		blink_time = 0
		animated_sprite_2d.visible = true
		$hitbox_body/CollisionShape2D.disabled = false
	if velocity.x < 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x > 0:
		animated_sprite_2d.flip_h = false
	if animated_sprite_2d.flip_h == false:
		$shoot_effect.position = Vector2(8.333, 3.667)
	elif animated_sprite_2d.flip_h == true:
		$shoot_effect.position = Vector2(-8.333, 3.667)
	match state:
		"on_ceiling":
			if not is_on_ceiling():
				velocity.y -= gravity * delta
				animated_sprite_2d.play("on_ceiling")
				$on_ceiling_cshape.disabled = false
				$on_floor_cshape.disabled = true
		"fall_from_ceiling":
			if not is_on_floor():
				velocity.y += (gravity + 100) * delta
				animated_sprite_2d.play("falling_from_ceiling")
			elif is_on_floor():
				if animated_sprite_2d.animation != "fall_recover":
					animated_sprite_2d.play("fall_recover")
				$on_ceiling_cshape.disabled = true
				$on_floor_cshape.disabled = false
		"shoot":
			l += 1
			if animated_sprite_2d.animation != "shoot":
				animated_sprite_2d.play("shoot")
			velocity.x = 0
			velocity.y += gravity * delta
			if animated_sprite_2d.frame == 2 or animated_sprite_2d.frame == 4:
				shoot_timer += 1
				if shoot_timer == 1:
					$shoot_effect.visible = true
					$shoot_effect.play("normal")
					#code for making projectiles here <<<<<<<

					if health > 26 / 2:
						proj_instance = projectile_to_shoot.instantiate()
						proj_instance.projectile = "normal"
					elif health <= 13:
						proj_instance = projectile2.instantiate()

					if animated_sprite_2d.flip_h == true:
						proj_instance.state = "left"
					elif animated_sprite_2d.flip_h == false:
						proj_instance.state = "right"
					get_parent().add_child(proj_instance)
					proj_instance.global_position = $shoot_effect.global_position
			else:
				shoot_timer = 0
			#code for moving to player
			if animated_sprite_2d.frame < 2:
				if GlobalScript.player_position_x - global_position.x < 0:
					velocity.x = -10000 * delta
				elif GlobalScript.player_position_x - global_position.x > 0:
					velocity.x = 10000 * delta
				elif GlobalScript.player_position_x - global_position.x == 0:
					velocity.x = 0
			else:
				velocity.x = 0
		"jump":
			if not is_on_floor():
				velocity.y += (gravity + 200) * delta
				if !already_jumped:
					already_jumped = true
					if GlobalScript.player_position_x - global_position.x < 0:
						velocity.x = -10000 * delta
					elif GlobalScript.player_position_x - global_position.x > 0:
						velocity.x = 10000 * delta
					elif GlobalScript.player_position_x - global_position.x == 0:
						velocity.x = 0
				if velocity.y >= 0 and velocity.y < 300:
					#velocity.x=0
					animated_sprite_2d.play("falling")
					animated_sprite_2d.frame = 0
					if animated_sprite_2d.flip_h == true:
						animated_sprite_2d.offset.x = 13
					elif animated_sprite_2d.flip_h == false:
						animated_sprite_2d.offset.x = -13
				if velocity.y >= 300:
					animated_sprite_2d.play("falling")
					animated_sprite_2d.frame = 1
					if animated_sprite_2d.flip_h == true:
						animated_sprite_2d.offset.x = 5
					elif animated_sprite_2d.flip_h == false:
						animated_sprite_2d.offset.x = -5
					if is_on_floor():
						velocity.x = 0
						state = "fall_recover"
		"fall_recover":
			animated_sprite_2d.offset.x = 0
			if animated_sprite_2d.animation != "fall_recover":
				animated_sprite_2d.play("fall_recover")
			already_jumped = false
			velocity.x = 0
		"move_slowly":
			animated_sprite_2d.play("move_around_slowly")
			if GlobalScript.player_position_x - global_position.x < 0:
				velocity.x = -5000 * delta
			elif GlobalScript.player_position_x - global_position.x > 0:
				velocity.x = 5000 * delta
			elif GlobalScript.player_position_x - global_position.x == 0:
				velocity.x = 0
	if health <= 0:
		queue_free()
		var explosion_instance = preload("res://miscelleaneous/explosion_scene.tscn").instantiate()
		get_parent().add_child(explosion_instance)
		explosion_instance.global_position = global_position
		#for testing activation of boss weapons upon Boss defeat
		#if GlobalScript.weaponsRunTimeValues["5"]==false:
		#GlobalScript.weaponsRunTimeValues["5"]=true
	move_and_slide()


var l = 0
var state_random = 1


func _on_timer_start_timeout():
	state = "fall_from_ceiling"


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		"fall_recover":
			$timer_move_slowly.start(0.3)
		"shoot":
			$timer_jump.start()
		"falling":
			if is_on_floor():
				state = "fall_recover"


func _on_timer_start_attack_timeout():
	state = "shoot"


func _on_timer_jump_timeout():
	animated_sprite_2d.play("jump")
	state = "jump"
	velocity.y = JUMP_VELOCITY


func _on_timer_move_slowly_timeout():
	state = "move_slowly"
	$timer_stop_moving.start()


func _on_timer_stop_moving_timeout():
	$timer_start_attack.start(0.2)


func _on_shoot_effect_animation_finished():
	$shoot_effect.visible = false
	$shoot_effect.play("wait")


func _on_hitbox_body_body_entered(body):
	if body.is_in_group("player_projectiles"):
		$hitcooldown_timer.start()


func _on_hitbox_body_area_entered(area):
	if area.is_in_group("player_projectiles"):
		$hitcooldown_timer.start()


var no_proj2 = 0


func _on_repeat_proj_timer_timeout():
	pass
