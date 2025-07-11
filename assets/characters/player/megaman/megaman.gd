extends CharacterBody2D
class_name Player
static var player_character
@onready var animated_sprite_2d = $animated_sprite2d
@onready var animation_player = $AnimationPlayer
@onready var player_camera = $player_camera

@export var color_palette: ColorPaletteResource

# Movement speeds
@export var speed = 300.0  # Base speed of Megaman
@export var normal_speed = 4950 * 3
@export var dash_speed = 10080 * 3
@export var climb_speed = 10000

# Dash duration
var dash_duration = 0.3

# Jump force
@export var jump_velocity = -600 * 1.7

# Gravity value
@export var gravity = 900 * 3

# State flags
var is_dead: bool = false
var stop: bool = false  # Stops player input and animations
var climb: bool = false  # Whether Megaman is climbing a ladder
var is_about_to_leave = false
var input_disabled = false
var small_space_trigger_on: bool = false
var is_transitioning_to_next_room = false
var is_player_ready = false
var visible_after_spawn_in = false
var stop_h_movement = false
var stop_v_movement = false
var player_in_enemy_zone = false
var global_screen_transition_timer_done: bool = false

# Timers and counters
var leave_timer = 0
var blink_timer = 0
var land_timer = 0
var explosion_spawner_timer = 0
var play_victory_theme_timer = 0
var restart_stage_timer: int = 0
var move_inch_timer = 0  # Determines if player moves normally or a bit at a time
var timer_to_stun = 0
var start_timer = 0
var play_jump_sound = 0

# Movement directions
var moving_left = false
var moving_right = false
var moving_up = false
var moving_down = false

# Preloaded scenes and instances
var dash_effect = preload("res://assets/characters/player/megaman/dash_effect.tscn")
var dash_effect_instance
var bullet = preload("res://weapons/bullet.tscn")
var bullet_instance
var lv1_charge_shot = preload("res://weapons/lv_1_chargeshot.tscn")
var lv1_charge_instance
var lv2_charge_shot = preload("res://weapons/fullcharge_shot.tscn")
var charge_shot_instance

# Transition speeds
var transitioning_screen_speed = 3000  # 7000
var move_an_inch_speed = 3000
var time_to_move_from_inch_speed_to_normal_speed = 0.1

# Shooting display type
var type_of_shooting_display: String = ""  # Displays normal/lv2 buster shot animations


func _ready():
	Player.player_character = self
	#GlobalScript.current_scene=get_tree().current_scene.get_scene_file_path()
	#print(GlobalScript.previous_scene,"\n",GlobalScript.current_scene)
	$start_timer.start()
	if not GlobalScript.restarted_stage:
		MegamanItems.reset_weapon_energy()

		if GlobalScript.current_save_file != null:
			GlobalScript.load_tanks_values()
			#GlobalScript.save_current_player_checkpoint_position()

	if GlobalScript.restarted_stage:
		#GlobalScript.previous_scene=GlobalScript.current_scene
		GlobalScript.load_player_checkpoint_positions()
		global_position = Vector2(GlobalScript.player_position_x, GlobalScript.player_position_y)

	GlobalScreenTransitionTimer.stop()
	GlobalScript.playerhasbeenhit = false
	GlobalScript.health = 27
	GlobalScript.lemons_on_screen = 0
	MegamanItems.chargetimer = 0
	MegamanItems.weapon_number = 0
	MegamanItems.rush_coil_on_screen = false

	animated_sprite_2d.play("idle")
	animated_sprite_2d.visible = false
	stop = true
	player_camera.position_smoothing_enabled = false

	$detect_body_collisions/collision_main_body.disabled = true
	$weapons_display.visible = false
	animated_sprite_2d.material.set_shader_parameter("bodyoutlcharge", color_palette.BLACK)
	animated_sprite_2d.material.set_shader_parameter(
		"chargecolorI", color_palette.MEGAMAN_LIGHT_BLUE
	)
	animated_sprite_2d.material.set_shader_parameter(
		"chargecolorII", color_palette.MEGAMAN_DEEP_BLUE
	)
	$detect_camera_zones/CollisionShape2D.disabled = true
	$resetCamTimer.start()


func create_player_effect():
	var playerEffect = preload(
		"res://miscelleaneous/effects/player effects/effect_for_player_entry.tscn"
	)
	var playerEffectInstance = playerEffect.instantiate()
	get_parent().add_child(playerEffectInstance)  ###
	playerEffectInstance.global_position.x = global_position.x
	playerEffectInstance.global_position.y = global_position.y - (240 * 3)
	if not GlobalScript.restarted_stage:  #putting the player position code here cause by then the player will be positioned properly by the game.
		GlobalScript.save_current_player_checkpoint_position()
	print("Creating Player Entry Effect... ")
	print("Player Entry Effect:x-axis,y-axis:", playerEffectInstance.global_position)
	print("Player:global_position:", global_position)


func _physics_process(delta):
	##debug
	$animation_player.text = str($AnimationPlayer.current_animation)
	$speed_label.text = str(velocity * Vector2(.3333 * delta, .3333 * delta))

	##
	stun(delta)
	GlobalScript.animation_state_player = str(animated_sprite_2d.animation)
	if GlobalScript.lemons_on_screen >= 3 and $lemon_cooldown_timer.time_left <= 0:
		$lemon_cooldown_timer.start()
	if $lemon_cooldown_timer.time_left > 0:
		coolDownOnLemons = true
	elif $lemon_cooldown_timer.time_left <= 0:
		coolDownOnLemons = false
	velocity.y = clampf(velocity.y, -500 * 3, 25200 * 3 * delta)
	#if is_on_floor():GlobalScript.player_on_floor=true
	#elif not is_on_floor():GlobalScript.player_on_floor=false
	match MegamanItems.weapon_number:
		0:
			$effects/current_weapon_display.frame = 0
		6:
			$effects/current_weapon_display.frame = 6
		9:
			$effects/current_weapon_display.frame = 11
		10:
			$effects/current_weapon_display.frame = 12
	if MegamanItems.weapon_number >= 1 and MegamanItems.weapon_number <= 8:
		$effects/current_weapon_display.frame = MegamanItems.weapon_number
	if $effects/current_weapon_display/display_timer.time_left > 0:
		$effects/current_weapon_display.visible = true
	elif $effects/current_weapon_display/display_timer.time_left <= 0:
		$effects/current_weapon_display.visible = false

	if !is_dead and is_player_ready == true and GlobalScript.playerhasbeenhit == false:
		animated_sprite_2d.visible = true
	if (
		animated_sprite_2d.animation == "spawn"
		and animated_sprite_2d.frame == 2
		and !is_about_to_leave
	):
		visible_after_spawn_in = true
		stop = false
		is_player_ready = true  #code to make sure after spawn,you start to experience physics
	if animated_sprite_2d.animation == "spawn":
		velocity.x = 0
		$detect_body_collisions/collision_main_body.disabled = true
	elif (
		not animated_sprite_2d.animation == "spawn"
		and not GlobalScript.playerhasbeenhit
		and not is_dead
		and is_player_ready == true
	):
		$detect_body_collisions/collision_main_body.disabled = false

	if is_player_ready == true:
		if GlobalScreenTransitionTimer.time_left > 0:
			global_screen_transition_timer_done = false
			GlobalScript.transitioning = true
			player_camera.position_smoothing_enabled = true
			stop = true
			coolDownOnLemons = false
			if velocity.x > 0:
				moving_right = true
			elif velocity.x < 0:
				moving_left = true
			elif velocity.y > 0:
				moving_down = true
			elif velocity.y < 0:
				moving_up = true
		elif GlobalScreenTransitionTimer.time_left == 0:
			GlobalScript.transitioning = false
			player_camera.position_smoothing_enabled = false
			if global_screen_transition_timer_done == false:
				stop = false
				moving_down = false
				moving_up = false
				moving_left = false
				moving_right = false
				global_screen_transition_timer_done = true

	if in_ladder_zone == true:
		pass
		if Input.is_action_just_pressed("move_up"):
			if climb == false:
				#this code disables the ladder_top_platforms and also sets the climb var. to true
				get_tree().call_group("ladder_top_platforms", "enter_ladder_disable_cshapes")
				climb = true
	if $leave_timer.is_stopped() == false:
		#velocity.x = 0
		pass
	if is_about_to_leave == true:
		stop = true
		animated_sprite_2d.visible = true
		#velocity.x = 0
		#stop=true
		$detect_body_collisions/collision_main_body.disabled = true
		input_disabled = true
		if warp_out == false:
			if not is_on_floor():
				velocity.y += gravity * delta
				move_and_slide()
				play_jump_sound = 0
			if is_on_floor():
				animated_sprite_2d.play("idle")
				if play_jump_sound < 20:
					play_jump_sound += 1
				if play_jump_sound == 1:
					$all_sound_effects/land.play()
		#
		leave_timer += 1
		if leave_timer == 1:
			$leaveTimer.start()
			velocity.x = 0
		if leave_timer == 180:
			$all_sound_effects/victory.play()
		var leave_timer_limit = 380
		if leave_timer == leave_timer_limit:
			#stop=false
			gravity = 0
			var tweenMoveUp = create_tween()
			tweenMoveUp.tween_property(
				self, "position", Vector2(global_position.x, global_position.y - 250), .2
			)
			#animated_sprite_2d.stop()
			animated_sprite_2d.play("victory_pose1")
			animated_sprite_2d.frame = 0
		if leave_timer > leave_timer_limit + 30 and leave_timer < leave_timer_limit + 35:
			velocity.y = 0
			gravity = 0
			move_and_slide()
		if leave_timer > leave_timer_limit + 70:
			gravity = 980
			move_and_slide()
		var exit_leave_timer = 780
		if warp_out == true:
			gravity = 0
			#animated_sprite_2d.play_backwards("spawn")
			if animated_sprite_2d.frame > 1:
				velocity.y = (-50000) * delta
				$collision_main_body.disabled = true
			move_and_slide()
		if leave_timer >= exit_leave_timer:
			$player_camera/hud.fade_effect()
		if leave_timer == (exit_leave_timer + 30):
			get_tree().change_scene_to_file("res://menus/robot_masters_menu.tscn")

	GlobalScript.player_position_x = global_position.x
	GlobalScript.player_position_y = global_position.y

	if not is_dead:
		if Input.is_action_just_pressed("switch_weapon_L"):
			MegamanItems.weapon_number -= 1
			$effects/current_weapon_display/display_timer.start()
		elif Input.is_action_just_pressed("switch_weapon_R"):
			MegamanItems.weapon_number += 1
			$effects/current_weapon_display/display_timer.start()
	if MegamanItems.weapon_number > 10:
		MegamanItems.weapon_number = 0
	elif MegamanItems.weapon_number < 0:
		MegamanItems.weapon_number = 10
	offset_animations()
	offset_megaman_11_head_display()
	if not is_dead:
		if not GlobalScript.playerhasbeenhit and visible_after_spawn_in:
			$animated_sprite2d.visible = true
	if !is_dead and !stop:
		if MegamanItems.weapon_number == 0:
			MegamanItems.chargeeffect(animated_sprite_2d)
			if (
				animated_sprite_2d.animation != "stun_ground"
				and animated_sprite_2d.animation != "stun_air"
			):
				shoot_and_charge(delta)
				type_of_shooting_display = "charge"
		else:
			#$weapons_display.visible=true2
			if (
				MegamanItems.weapon_energy.has(MegamanItems.weapon_number)
				and MegamanItems.weapon_number != 0
			):
				switch_weapons()
				MegamanItems.chargetimer = 0
			else:
				push_warning(
					"Weapon number: " + str(MegamanItems.weapon_number) + " not available "
				)
	#climb stuff
	if animated_sprite_2d.animation != "stun_ground" and animated_sprite_2d.animation != "stun_air":
		input_disabled = false
		$stun_effectmajor.visible = false
	else:
		$stun_effectmajor.visible = true
	if moving_left == true:  #this makes megaman move to the left  automatically upon hitting the left side of the door
		stop = true
		velocity.y = 0
		velocity.x = (-transitioning_screen_speed) * delta
		move_and_slide()
	if moving_right:
		stop = true
		velocity.y = 0
		velocity.x = transitioning_screen_speed * delta
		move_and_slide()
	if moving_up:
		stop = true
		velocity.x = 0
		velocity.y = (-transitioning_screen_speed - 1000) * delta
		if (
			animated_sprite_2d.animation == "shoot_on_ladder"
			or animated_sprite_2d.animation == "climb"
		):
			animated_sprite_2d.play("climb")
		move_and_slide()
	if moving_down:
		stop = true
		velocity.x = 0
		velocity.y = (transitioning_screen_speed + 1000) * delta
		if (
			animated_sprite_2d.animation == "shoot_on_ladder"
			or animated_sprite_2d.animation == "climb"
		):
			animated_sprite_2d.play("climb")
		move_and_slide()
	if is_transitioning_to_next_room:
		stop = true
		velocity.x = 4000 * delta
		velocity.y = 0
		move_and_slide()
	change_collisions()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if GlobalScript.playerhasbeenhit == true:
		blink_timer += 1
		if blink_timer == 1:
			$stun_effect/visible_timer.start()
		if blink_timer % 10 == 1:
			$animated_sprite2d.visible = false
		elif blink_timer % 10 == 5:
			$animated_sprite2d.visible = true
	elif GlobalScript.playerHitCooldownTimer >= .9:
		blink_timer = 0
		input_disabled = false
		#$stun_effect/stun_effectmajor.visible=false
		if is_on_floor():
			animated_sprite_2d.play("idle")
		$animated_sprite2d.visible = true

	if is_dead == false and stop == false:
		if climb == false:
			if is_on_floor():
				if velocity.x != 0:
					move_inch_timer += 1 * delta

# Handles movement by controls and can be disabled if needed for stuff like stuns
				else:
					move_inch_timer = 0

			# Handles movement by controls and can be disabled if needed for stuff like stuns
			if $dash.is_dashing():
				speed = dash_speed

# Handles movement by controls and can be disabled if needed for stuff like stuns
			elif is_on_floor():
				if (
					not $dash.is_dashing()
					and move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed
				):
					speed = move_an_inch_speed

				# Handles movement by controls and can be disabled if needed for stuff like stuns
				elif (
					not $dash.is_dashing()
					and move_inch_timer > time_to_move_from_inch_speed_to_normal_speed
				):
					speed = normal_speed

# Handles movement by controls and can be disabled if needed for stuff like stuns
			elif not is_on_floor():
				speed = normal_speed

# Handles movement by controls and can be disabled if needed for stuff like stuns
			jump()
# Handles movement by controls and can be disabled if needed for stuff like stuns
			if input_disabled == false:
				var direction = Input.get_axis("move_left", "move_right")
				if direction:
					velocity.x = direction * speed * delta
				else:
					if stop_v_movement == false:
						velocity.x = move_toward(velocity.x, 0, speed)
			animations_function()  #this handles movement animations
			dash(delta)  #handles dashing
			move_and_slide()
		elif climb == true:
			velocity.x = 0
			play_climb_animations()
			var direction = Input.get_axis("move_up", "move_down")
			if direction and animated_sprite_2d.animation != "shoot_on_ladder":
				velocity.y = direction * climb_speed * delta
			else:
				velocity.y = 0
			if area_shape_name != null:
				global_position.x = area_shape_name.global_position.x
			if Input.is_action_just_pressed("jump"):
				climb = false
			move_and_slide()
		if GlobalScript.health <= 0:
			if GlobalScript.restarted_stage == false:
				GlobalScript.restarted_stage = true
				print(name, ":Global:restarted stage(bool) ->: ", GlobalScript.restarted_stage)
			is_dead = true
			megaman_explosion_instancing()
			$restart_timer.start()
			death()
	elif is_dead == true:
		explosion_spawner_timer += 1
		#megaman_explosion_instancing()
		$weapons_display.visible = false
		$detect_body_collisions/collision_main_body.disabled = true
		$collision_main_body.disabled = true
		restart_stage_timer += 1
		if $restart_timer.time_left <= $restart_timer.wait_time / 3:
			$player_camera/hud.fade_effect()
			GlobalScript.save_energy_weapon_tanks()

		#print(explosion_spawner_timer)
	if animated_sprite_2d.animation == "stun_ground" or animated_sprite_2d.animation == "stun_air":
		if GlobalScript.playerHitCooldownTimer >= 0 and GlobalScript.playerHitCooldownTimer < 0.5:
			input_disabled = true
			velocity.x = 0
			match animated_sprite_2d.flip_h:
				false:
					global_position.x -= 50 * delta
				true:
					global_position.x += 50 * delta
	elif GlobalScript.playerHitCooldownTimer >= 0.5:
		input_disabled = false
	offset_megaman_animations()


func offset_one_animation(animationName: String, offsetLeft: Vector2, offsetRight: Vector2):
	if animated_sprite_2d.animation == animationName:
		match animated_sprite_2d.flip_h:
			true:
				animated_sprite_2d.offset = offsetLeft
			false:
				animated_sprite_2d.offset = offsetRight


var offsetted_animations = [
	"stand_and_shoot",
	"stand_and_shoot_notlv2charge",
	#"shoot_on_ladder",
	#"run_and_shoot",
	#"dash",
	#"jump_and_shoot"
]


func offset_megaman_animations():
##i placed this here,so that the offsetting is done AFTER the animation has been detected and adjusted accordingly
	offset_one_animation("stand_and_shoot", Vector2(-3, 0), Vector2(3, 0))
	offset_one_animation("stand_and_shoot_notlv2charge", Vector2(-3, 0), Vector2(3, 0))
	for i in animated_sprite_2d.sprite_frames.get_animation_names():
		if not offsetted_animations.has(i):
			if animated_sprite_2d.animation == i:
				animated_sprite_2d.offset = Vector2.ZERO


func play_climb_animations():
	if (
		(not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot"))
		and not Input.is_action_just_released("shoot")
	):
		if animated_sprite_2d.animation != "shoot_on_ladder":  #and animated_sprite_2d.animation!='about_to_leave_ladder'
			if Input.is_action_pressed("move_up"):
				animated_sprite_2d.play("climb")
			elif Input.is_action_pressed("move_down"):
				animated_sprite_2d.play_backwards("climb")
	elif Input.is_action_just_released("shoot"):
		animated_sprite_2d.play("shoot_on_ladder")
		if Input.is_action_pressed("move_left"):
			animated_sprite_2d.flip_h = true
		elif Input.is_action_pressed("move_right"):
			animated_sprite_2d.flip_h = false
	if animated_sprite_2d.animation == "shoot_on_ladder":
		velocity.y = 0


var jump_frame = 0  #captures the last frame used for jumping.


func animations_function():
	if $animated_sprite2d.animation == "jump":
		jump_frame = $animated_sprite2d.frame
		#print(jump_frame)
	if Input.is_action_pressed("debug_die"):
		GlobalScript.health = 0
	if is_on_floor():
		if $animated_sprite2d.animation != "stun_air":
			if type_of_shooting_display == "charge":
				if (
					(not Input.is_action_pressed("shoot") or Input.is_action_pressed("shoot"))
					and not Input.is_action_just_released("shoot")
				):
					if velocity.x < 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = true
					elif velocity.x > 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								#normal_speed=move_an_inch_speed
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = false
					else:
						if (
							$animated_sprite2d.animation != "stand_and_shoot"
							and not animated_sprite_2d.animation == "stand_and_shoot_notlv2charge"
						):
							#and is_about_to_leave==false
							$animated_sprite2d.play("idle")
						velocity.x = 0
				elif (
					Input.is_action_just_released("shoot") and $lemon_cooldown_timer.time_left == 0
				):
					if $animated_sprite2d.animation != "run_and_shoot":
						if not coolDownOnLemons:
							if (
								velocity.x < 0
								and not animated_sprite_2d.animation == "run_and_shoot"
							):
								$animated_sprite2d.play("run_and_shoot")
								$animated_sprite2d.flip_h = true
							elif (
								velocity.x > 0
								and not animated_sprite_2d.animation == "run_and_shoot"
							):
								$animated_sprite2d.play("run_and_shoot")

								$animated_sprite2d.flip_h = false
							elif velocity.x == 0:
								if (
									state_of_shooting_animations == "once"
									and not (
										animated_sprite_2d.animation
										== "stand_and_shoot_notlv2charge"
									)
								):
									animated_sprite_2d.play("stand_and_shoot_notlv2charge")

								elif (
									state_of_shooting_animations == "repeat"
									and not animated_sprite_2d.animation == "stand_and_shoot"
								):
									animated_sprite_2d.play("stand_and_shoot")
			elif type_of_shooting_display == "shoot_once":
				if (
					not Input.is_action_just_pressed("shoot")
					and not Input.is_action_pressed("dash")
				):
					if velocity.x < 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = true
					elif velocity.x > 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								#normal_speed=17500
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = false
					else:
						if $animated_sprite2d.animation != "stand_and_shoot":
							$animated_sprite2d.play("idle")
						velocity.x = 0
				elif Input.is_action_just_pressed("shoot"):  # and not Input.is_action_pressed("dash")##redundant code## and GlobalScript.lemons_on_screen<=3
					if $animated_sprite2d.animation != "run_and_shoot":
						#if not coolDownOnLemons:

						if velocity.x < 0 and not animated_sprite_2d.animation == "run_and_shoot":
							$animated_sprite2d.play("run_and_shoot")
							$animated_sprite2d.flip_h = true
						elif velocity.x > 0 and not animated_sprite_2d.animation == "run_and_shoot":
							$animated_sprite2d.play("run_and_shoot")

							$animated_sprite2d.flip_h = false
						elif (
							velocity.x == 0
							and not animated_sprite_2d.animation == "stand_and_shoot"
						):
							$animated_sprite2d.play("stand_and_shoot")
			elif type_of_shooting_display == "none":
				if (
					not Input.is_action_just_pressed("shoot")
					and not Input.is_action_pressed("dash")
				):
					if velocity.x < 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = true
					elif velocity.x > 0:
						if $animated_sprite2d.animation != "run_and_shoot":
							if move_inch_timer <= time_to_move_from_inch_speed_to_normal_speed:
								if animated_sprite_2d.animation != "stand_and_shoot":
									animated_sprite_2d.play("move_an_inch")
							elif move_inch_timer > time_to_move_from_inch_speed_to_normal_speed:
								$animated_sprite2d.play("run_normal")
						$animated_sprite2d.flip_h = false
					else:
						if $animated_sprite2d.animation != "stand_and_shoot":
							$animated_sprite2d.play("idle")
						velocity.x = 0
				elif Input.is_action_just_pressed("shoot") and not Input.is_action_pressed("dash"):
					if $animated_sprite2d.animation != "run_and_shoot":
						if velocity.x < 0 and not animated_sprite_2d.animation == "run_and_shoot":
							$animated_sprite2d.play("run_normal")
							$animated_sprite2d.flip_h = true
						elif velocity.x > 0 and not animated_sprite_2d.animation == "run_and_shoot":
							$animated_sprite2d.play("run_normal")
							$animated_sprite2d.flip_h = false
						elif velocity.x == 0 and not animated_sprite_2d.animation == "idle":
							$animated_sprite2d.play("idle")

	elif not is_on_floor():
		if Input.is_action_just_released("shoot"):
			jump_played = false
			$animated_sprite2d.animation = ("jump_and_shoot")
			$animated_sprite2d.frame = jump_frame
		elif not Input.is_action_just_pressed("shoot"):
			land_timer = 0
			#this checks and only would run IF the jump animation haven't played /looped yet.
			if (
				animated_sprite_2d.animation != "jump_and_shoot"
				and animated_sprite_2d.animation != "stun_air"
			):
				$animated_sprite2d.play("jump")
			if velocity.x < 0:
				$animated_sprite2d.flip_h = true
			elif velocity.x > 0:
				$animated_sprite2d.flip_h = false
	if is_on_floor():
		land_timer += 1
		if land_timer == 1:
			$all_sound_effects/land.play()
		jump_played = false


var animation_locked = false


func jump():
	if !input_disabled and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0


func dash(delta):
# this function is supposed to use two raycasts to detect small spaces of
#one tile and upon pressing the dash btn,
# would cause  the player to dash with ease
	if animated_sprite_2d.animation == "dash":
		speed = dash_speed
	if (
		is_on_floor()
		and $dash/dash_timer.time_left > 0
		and $dash_space_checker.is_colliding()
		and $dash_space_checker2.is_colliding()
	):
		$dash/dash_timer.one_shot = false
		#stop_v_movement=true
	else:
		$dash/dash_timer.one_shot = true
		stop_v_movement = false
	if (
		is_on_floor()
		and ($dash_space_checker.is_colliding() or $dash_space_checker2.is_colliding())
	):
		animated_sprite_2d.play("dash")
		speed = dash_speed
		stop_v_movement = true
	if is_on_floor():
		if $dash/dash_timer.time_left > 0:
			animated_sprite_2d.play("dash")
		if Input.is_action_just_pressed("dash"):
			$dash.start_dash(dash_duration)
			dash_effect_instance = dash_effect.instantiate()
			get_parent().add_child(dash_effect_instance)
			if $animated_sprite2d.flip_h == false:
				velocity.x = dash_speed * delta
				dash_effect_instance.global_position = $dash_effect_spawn/left.global_position
			elif $animated_sprite2d.flip_h == true:
				velocity.x = -dash_speed * delta
				dash_effect_instance.global_position = $dash_effect_spawn/right.global_position
		if Input.is_action_pressed("dash") and is_on_floor():
			if animated_sprite_2d.flip_h == true:
				$animated_sprite2d.play("dash")

				velocity.x = -dash_speed * delta
				#$animated_sprite2d.flip_h = true
				if $dash/dash_timer.time_left == 0:
					#velocity.x = 0
					Input.action_release("dash")
					await get_tree().create_timer(1).timeout
					pass

			elif animated_sprite_2d.flip_h == false:
				$animated_sprite2d.play("dash")
				#$animated_sprite2d.flip_h = false
				velocity.x = dash_speed * delta
				if $dash/dash_timer.time_left == 0:
					#velocity.x = 0
					Input.action_release("dash")
					await get_tree().create_timer(1).timeout


var play_position = 0
var coolDownOnLemons = false
var state_of_shooting_animations = ""
var projectile


func shoot_and_charge(delta):
#	if $all_sound_effects/charge.get_playback_position()>2.04:
#		$all_sound_effects/charge.seek(1.90)
	#funny how sound can make one mistaken a fake chargeup lmao
	if (
		MegamanItems.chargetimer > 0.5
		and MegamanItems.chargetimer < .6
		and coolDownOnLemons == false
	):
		$all_sound_effects/charge.play()

	if Input.is_action_pressed("shoot") and coolDownOnLemons == false:
		MegamanItems.chargetimer += 1 * delta  #for allowing consistent shooting for diff platforms
		MegamanItems.effect_chargetimer += 1  #for playing effects

	if Input.is_action_just_released("shoot"):
		$all_sound_effects/charge.stop()
		if MegamanItems.chargetimer < .5 and coolDownOnLemons == false:
			state_of_shooting_animations = "once"
			projectile = bullet.instantiate()
			$all_sound_effects/shoot.play()
		elif MegamanItems.chargetimer >= .5 and MegamanItems.chargetimer < 1.25:
			state_of_shooting_animations = "once"
			projectile = lv1_charge_shot.instantiate()
			$all_sound_effects/halfchargeshot.play()
		elif MegamanItems.chargetimer >= 1.25:
			state_of_shooting_animations = "repeat"
			projectile = lv2_charge_shot.instantiate()
			$all_sound_effects/chargeshot.play()
		MegamanItems.chargetimer = 0
		MegamanItems.effect_chargetimer = 0

		if not coolDownOnLemons and projectile != null:  #former code for preventing lemon spa,
			if !small_space_trigger_on and $lemon_cooldown_timer.time_left == 0:
				$all_sound_effects/shoot.play()
				get_parent().add_child(projectile)
				if is_on_floor():
					if animated_sprite_2d.flip_h == true:
						projectile.direction = "left"
						projectile.global_position = (
							$shoot_positions/shoot_ground/left.global_position
						)
					elif animated_sprite_2d.flip_h == false:
						projectile.direction = "right"
						projectile.global_position = (
							$shoot_positions/shoot_ground/right.global_position
						)
				elif not is_on_floor():
					if animated_sprite_2d.flip_h == true:
						projectile.direction = "left"
						projectile.global_position = $shoot_positions/shoot_air/left.global_position
					elif animated_sprite_2d.flip_h == false:
						projectile.direction = "right"
						projectile.global_position = (
							$shoot_positions/shoot_air/right.global_position
						)


func death():
	GlobalScript.life -= 1
	$animated_sprite2d.play("death")
	$collision_main_body.disabled = true
	$all_sound_effects/dead.play()
	stop = true
	is_dead = true


var stun_push_timer = 0
var stun_active = false  #var stun_pushback()


func stun(delta):
	if animated_sprite_2d.animation == "stun_air":
		stop = true
		#velocity.y += 100 * delta
		velocity.y = 0
		match animated_sprite_2d.flip_h:
			false:
				velocity.x = -2000 * delta
			true:
				velocity.x = 2000 * delta
		#velocity.y=10000*delta

	#*Stun animation is played when player collides with an enemy in the area_entered() signal.


func pushback(delta):
	if animated_sprite_2d.flip_h == false:
		velocity.x = -20000 * delta
	elif animated_sprite_2d.flip_h == true:
		velocity.x = 20000 * delta


var jump_played = false  #this checks if the jump_aniamtion has already been played


func megaman_explosion_instancing():  #this produces the explosion effects for megaman
	var explosion = preload("res://miscelleaneous/explosion_scene.tscn")
	var explosionInstance = explosion.instantiate()
	get_parent().add_child(explosionInstance)
	explosionInstance.global_position = global_position


var movement_timer = 0


func move_left_to_right_door():
	stop = true
	moving_right = true


var playerIsInTightSpace = false


func change_collisions():
	if GlobalScript.playerhasbeenhit and !is_dead and !is_about_to_leave:
		$detect_body_collisions/collision_main_body.disabled = true
	else:
		$detect_body_collisions/collision_main_body.disabled = false
	if animated_sprite_2d.animation == "dash":
		pass
	elif !animated_sprite_2d.animation == "dash" and not is_about_to_leave:
		pass
	elif (
		animated_sprite_2d.animation == "spawn"
		and animated_sprite_2d.frame == 2
		and is_about_to_leave
	):
		$collision_main_body.disabled = true
		$detect_body_collisions/collision_main_body.disabled = true
	if animated_sprite_2d.animation == "dash":
		$AnimationPlayer.play("dash")
	elif animated_sprite_2d.animation != "dash":
		$AnimationPlayer.play("normal")


#var weapon_selected_number=1

var rush_jet_instance
var rush_coil_instance


func switch_weapons():
	#change color palette
	if MegamanItems.current_state_of_weapon == true:
		MegamanItems.change_color_palette(animated_sprite_2d)
		$weapons_display.visible = true
	else:
		if MegamanItems.weapon_number != 0:
			$weapons_display.visible = false
			MegamanItems.chargeeffect(animated_sprite_2d)

	if MegamanItems.weapon_number != 10 and rush_jet_instance != null:
		rush_jet_instance.queue_free()
		MegamanItems.rush_coil_on_screen = false
	elif MegamanItems.weapon_number != 9 and rush_coil_instance != null:
		rush_coil_instance.queue_free()
		MegamanItems.rush_coil_on_screen = false

	if MegamanItems.current_state_of_weapon == true:
		match MegamanItems.weapon_number:
			6:  #magpulse man
				#GlobalScript.weapon_selected_number=5
				#			$weapons_display.visible=true
				#			$weapons_display/magpulse.set_offset(animated_sprite_2d.offset);
				#
				#			if animated_sprite_2d.is_playing():
				#				$weapons_display/magpulse.play(animated_sprite_2d.animation)
				#
				#			$weapons_display/magpulse.set_flip_h(animated_sprite_2d.flip_h)
				if (
					MegamanItems.weapon_energy[6] > 0
					and MegamanItems.current_state_of_weapon == true
				):  # GlobalScript.weaponsRunTimeValues['MAGPULSE']==true:
					if Input.is_action_just_pressed("shoot"):
						type_of_shooting_display = "shoot_once"
						$all_sound_effects/weapon_sounds/laser_trident.play()
						if climb:
							animated_sprite_2d.play("shoot_on_ladder")
						var magpulse_weapon = preload(
							"res://weapons/weapons_from_robot_masters/magpulse_weapon.tscn"
						)
						var mag_instance = magpulse_weapon.instantiate()
						get_parent().add_child(mag_instance)
						if is_on_floor():
							if animated_sprite_2d.flip_h == false:
								mag_instance.direction = "right"

								mag_instance.global_position = (
									$shoot_positions/shoot_ground/right.global_position
									+ Vector2(012, 0)
								)
							elif animated_sprite_2d.flip_h == true:
								#var mag_instance=magpulse_weapon.instantiate()
								mag_instance.direction = "left"
								#get_parent().add_child(mag_instance)
								mag_instance.global_position = (
									$shoot_positions/shoot_ground/left.global_position
									- Vector2(12, 0)
								)
						elif not is_on_floor():
							if animated_sprite_2d.flip_h == false:
								mag_instance.direction = "right"
								mag_instance.global_position = (
									$shoot_positions/shoot_air/right.global_position
								)
							elif animated_sprite_2d.flip_h == true:
								mag_instance.direction = "left"
								mag_instance.global_position = (
									$shoot_positions/shoot_air/left.global_position
								)
						MegamanItems.weapon_energy[6] -= 1
			9:  #temporal for rush coil
				#print('Megaman:weapon_energy for weapon 3:',MegamanItems.weapon_energy[3])
				#GlobalScript.weapon_selected_number=3
				type_of_shooting_display = "none"
				$weapons_display.visible = false
				if Input.is_action_just_pressed("shoot") and (is_on_floor() or climb == true):
					if MegamanItems.weapon_energy[9] > 0 and not MegamanItems.rush_coil_on_screen:  #if weapon energy>0:
						MegamanItems.weapon_energy[9] -= 3  #deduct weapon energy,create rush coil
						MegamanItems.rush_coil_on_screen = true
						var rush_coil = preload("res://weapons/rush_coil.tscn")
						rush_coil_instance = rush_coil.instantiate()
						get_parent().add_child(rush_coil_instance)
						if animated_sprite_2d.flip_h == false:
							rush_coil_instance.flip_animation_state = "right"
							rush_coil_instance.global_position = global_position + Vector2(50, -50)
						elif animated_sprite_2d.flip_h == true:
							rush_coil_instance.flip_animation_state = "left"
							rush_coil_instance.global_position = global_position - Vector2(50, 50)
			10:
				type_of_shooting_display = "none"
				$weapons_display.visible = false
				if Input.is_action_just_pressed("shoot") and (is_on_floor() or climb == true):
					if MegamanItems.weapon_energy[10] > 0 and not MegamanItems.rush_coil_on_screen:  #if weapon energy>0:
						MegamanItems.weapon_energy[10] -= 3  #deduct weapon energy,create rush coil
						MegamanItems.rush_coil_on_screen = true
						const RUSH_JET = preload("res://weapons/rush_jet.tscn")
						#var rush_coil=preload('res://weapons/rush_coil.tscn')
						rush_jet_instance = RUSH_JET.instantiate()
						get_parent().add_child(rush_jet_instance)
						if animated_sprite_2d.flip_h == false:
							rush_jet_instance.flip_animation_state = "right"
							rush_jet_instance.global_position = global_position + Vector2(50, -50)
						elif animated_sprite_2d.flip_h == true:
							rush_jet_instance.flip_animation_state = "left"
							rush_jet_instance.global_position = global_position - Vector2(50, 50)
			#1,2,3,4,6,7,8:
			#$weapons_display.visible=false
			#$wea
	elif MegamanItems.current_state_of_weapon == false:
		$weapons_display.visible = false
	#temp code 4 not displaying MM11 headshots
	match MegamanItems.weapon_number:
		2, 3, 4, 5, 7, 8:
			$weapons_display.visible = false


@export var arrayForAllWeaponsDisplays: Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
}
var animatedSpriteForWeaponsNotAvailiable: AnimatedSprite2D


func switch_weapon_heads():
	match MegamanItems.weapon_number:
		0:
			animatedSpriteForWeapons = $weapons_display/magpulse
		1:
			$weapons_display/acidman.visible = true
			$weapons_display/magpulse.visible = false
			animatedSpriteForWeapons = $weapons_display/acidman
		6:
			$weapons_display/acidman.visible = false
			$weapons_display/magpulse.visible = true
			animatedSpriteForWeapons = $weapons_display/magpulse


func offset_megaman_11_head_display():  #offsets and displays the head change icon from Megaman 11
	#according to the weapon being selected and availability
#region coding to auto set visible a MM11 styled robot head whatever we switch a weapon
	#for sprites in arrayForAllWeaponsDisplays:
	##this is for the selected weapon
	#if arrayForAllWeaponsDisplays.has(MegamanItems.weapon_number):
	#if arrayForAllWeaponsDisplays[MegamanItems.weapon_number]!=null:
	#animatedSpriteForWeapons= get_node(arrayForAllWeaponsDisplays[MegamanItems.weapon_number])
	#animatedSpriteForWeapons.visible=true
	#
	##this is for all other non selected weapon
	#if arrayForAllWeaponsDisplays.has(!MegamanItems.weapon_number):
	#if arrayForAllWeaponsDisplays[!MegamanItems.weapon_number]!=null:
	#animatedSpriteForWeaponsNotAvailiable= get_node(arrayForAllWeaponsDisplays[!MegamanItems.weapon_number])
	#animatedSpriteForWeaponsNotAvailiable.visible=false
	##temporal code to prevent acidman head from coing whenever weapon gets switched
	$weapons_display/acidman.visible = false
#endregion
	switch_weapon_heads()

	#animatedSpriteForWeapons=$weapons_display/magpulse
	#match MegamanItems.weapon_number:
	#1:animatedSpriteForWeapons.sprite_frames.set_path("res://assets/characters/player/megaman/weapon_switch_spritesheets/acidman_weapon_spritesheet_megaman_troperfive.png")
	#6:animatedSpriteForWeapons.sprite_frames.set_path("res://assets/characters/player/megaman/weapon_switch_spritesheets/magpulse_weapon_spritesheet_megaman_troperfive.png")

	match MegamanItems.weapon_number:
		#6:animatedSpriteForWeapons=$weapons_display/magpulse
		#1:animatedSpriteForWeapons=$weapons_display/acidman
		0:  #buster
			$weapons_display.visible = false
			$weapons_display/magpulse.set_offset(animated_sprite_2d.offset)

#			if animated_sprite_2d.is_playing() :#and $weapons_display/magpulse.has
#				$weapons_display/magpulse.play(animated_sprite_2d.animation)

			$weapons_display/magpulse.set_flip_h(animated_sprite_2d.flip_h)
		1, 2, 3, 4, 5, 6:  #magpulse man
			$weapons_display.visible = true
			animatedSpriteForWeapons.set_offset(animated_sprite_2d.offset)
			animatedSpriteForWeapons.speed_scale = animated_sprite_2d.get_playing_speed()

			#if animated_sprite_2d.is_playing():
			if animatedSpriteForWeapons.sprite_frames.has_animation(animated_sprite_2d.animation):
				animatedSpriteForWeapons.play(animated_sprite_2d.animation)

			animatedSpriteForWeapons.set_flip_h(animated_sprite_2d.flip_h)


var animatedSpriteForWeapons: AnimatedSprite2D


func offset_animations():
	pass
	if animated_sprite_2d.animation == "jump_and_shoot":
		if animated_sprite_2d.frame == 0:
			if animated_sprite_2d.flip_h == false:
				$weapons_display/magpulse.offset = Vector2(0, -2)
			elif animated_sprite_2d.flip_h == true:
				$weapons_display/magpulse.offset = Vector2(0, -2)
		elif animated_sprite_2d.frame == 1:
			if animated_sprite_2d.flip_h == false:
				$weapons_display/magpulse.offset = Vector2(-2, -4)
			elif animated_sprite_2d.flip_h == true:
				$weapons_display/magpulse.offset = Vector2(2, -4)
#			if animated_sprite_2d.flip_h==false:
#				$weapons_display/magpulse.position.y=-7
#			if animated_sprite_2d.flip_h==true:
#				$weapons_display/magpulse.position.y=7
	else:
		$weapons_display/magpulse.offset = Vector2(0, -7)


func _on_animated_sprite_2d_animation_finished():
	if $animated_sprite2d.animation == "jump":
		#$animated_sprite2d.stop()
		jump_played = true  #this means that the animation has aleady beean played
	else:
		jump_played = false
	match animated_sprite_2d.animation:
		#"run_and_shoot":
		#animation_locked=false
		"stand_and_shoot":
			#print('stand_and_shoot out')
			animated_sprite_2d.play("idle")
		"stand_and_shoot_notlv2charge":
			animated_sprite_2d.play("idle")
		"run_and_shoot":
			animated_sprite_2d.play("run_normal")
		"jump_and_shoot":
			animated_sprite_2d.play("jump")
		"stun_ground":
			animated_sprite_2d.play("idle")
			input_disabled = false
		"stun_air":
			input_disabled = false
			stop = false
			animated_sprite_2d.play("idle")
		"shoot_on_ladder":
			animated_sprite_2d.play("climb")
			animated_sprite_2d.pause()
		"spawn":
			is_player_ready = true
			print(name, ": spawn complete")


var in_ladder_zone: bool = false


func _on_detect_body_collisions_area_entered(area):
	if area.is_in_group("enemy"):
		player_in_enemy_zone = true
		if GlobalScript.playerhasbeenhit == false:
			GlobalScript.health -= area.get_parent().playerdamage_value
			GlobalScript.playerhasbeenhit = true
			animated_sprite_2d.play("stun_air")
			$all_sound_effects/hurt.play()
			if climb:
				climb = false

	if area.is_in_group("deathzones"):
		if GlobalScript.playerhasbeenhit == false:
			GlobalScript.health = 0


func _on_detect_body_collisions_area_exited(area):
	if area.is_in_group("enemy"):
		player_in_enemy_zone = false


#	if area.is_in_group("ladders"):
#		in_ladder_zone=false
#		climb=false
#		get_tree().call_group("ladder_top_platforms","exit_ladder_enable_chsapes")
#	if area.is_in_group("small_areas"): #outdated
#		small_space_trigger_on=false
#		stop=false
#		#area.set_deferred('is_disable,tru')
#		$animated_sprite2d.play("idle")

var area_shape_name: Object


func _on_detect_body_collisions_area_shape_entered(
	_area_rid, area, area_shape_index, _local_shape_index
):
	#print(area_rid)
	#print(area.shape_owner_get_owner(area_shape_index))
	if area.is_in_group("ladders"):
		area_shape_name = area.shape_owner_get_owner(area_shape_index)


var warp_out = false


func _on_leave_timer_timeout():
	warp_out = true
	stop = true
	#$weapons_display.visible=false
	MegamanItems.weapon_number = 0
	animated_sprite_2d.play("spawn")


func _on_start_timer_timeout():
#	$animated_sprite2d.visible=true
#	$animated_sprite2d.play("spawn")
#	is_player_ready=true
	create_player_effect()
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	#$transition_screen_timer.start()
	#print('megaman: trans screen timer activated?')
	pass


func _on_visible_on_screen_notifier_2d_screen_entered():
#	moving_left=false
	pass


func _on_transition_screen_timer_timeout():
	$player_camera.position_smoothing_enabled = false
	stop = false
	moving_down = false
	moving_up = false
	moving_left = false
	moving_right = false


func _on_restart_timer_timeout():
	if GlobalScript.life > 0:
		get_tree().reload_current_scene()  #change_scene_to_file(GlobalScript.loaded_stage)#
	else:
		get_tree().change_scene_to_file("res://menus/robot_masters_menu.tscn")


func _on_lemon_cooldown_timer_timeout():
	coolDownOnLemons = false


func _on_visible_timer_timeout():
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "leave_ladder":
		animation_player.play("normal")


func _on_dash_timer_timeout():
	if not ($dash_space_checker.is_colliding() or $dash_space_checker2.is_colliding()):
		Input.action_release("dash")
		animated_sprite_2d.play("idle")


func _on_reset_cam_timer_timeout():
	$detect_camera_zones/CollisionShape2D.disabled = false
