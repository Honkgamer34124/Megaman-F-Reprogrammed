extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var megaman=preload("res://assets/characters/player/megaman/megaman.tscn")
@onready var mega_ins=megaman.instantiate()
var is_player_around:bool=false
var shoot_timer=0
var timer=0;var timer_jump_left=0
const SPEED = 8500.0*2
const JUMP_VELOCITY = -450.0
var is_near_left_plat=false
var movement_cooldown=false
var movement_cooldown_timer=0
# Get the gravity from the project settings to be synced with RigidBody nodes.
#@export var initial_direction="left"
var pellet1=preload("res://enemies/met_pellet.tscn")
var pellet2=preload("res://enemies/met_pellet.tscn")
var pellet3=preload("res://enemies/met_pellet.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	enemy_name="met"
	#set_physics_process(false)
	#$hitbox_blocking/CollisionShape2D.disabled=true
	#animated_sprite_2d.play("idle")
	state='idle'
	health=5
	playerdamage_value=3
var jumped=false;#var timer=0
func _physics_process(delta):
	#debug
	#$Label.text=str(health);$index.text=str(index)
	$state.text=state
	#
	spawn_collectables()
#	if player_in_body==true:
#		if GlobalScript.playerhasbeenhit==false:
#			#mega_ins.stun()
#			GlobalScript.playerhasbeenhit=true
	
	#print('met:mov_cooldown, timer:',movement_cooldown,' ',movement_cooldown_timer)
#	if movement_cooldown:
#		timer=0
#
#		movement_cooldown_timer+=1
#	if movement_cooldown_timer>100:
#		movement_cooldown_timer=0
#		movement_cooldown=false
	
	#print(timer_jump,is_near_right_plat,is_near_left_plat)
	
	#these check for platforms on top of met using raycasts
	if $check_next_top_platform/cshape2d.is_colliding():#=="debug" 
		if $check_next_top_platform/cshape2d.get_collider().is_in_group("tilemap")and is_on_wall():
			is_near_right_plat=true
	else:
		is_near_right_plat=false
		
	if $check_next_top_platform/cshape2d_left.is_colliding():
		if $check_next_top_platform/cshape2d_left.get_collider() is TileMap and is_on_wall(): #get_collider().name=="debug"
			is_near_left_plat=true
	else:
		is_near_left_plat=false


	#this is for creating met projectiles
	if animated_sprite_2d.animation=="shoot":
		if animated_sprite_2d.frame==3:
			#print("hello")
			shoot_timer+=1
			if shoot_timer==1:
				pass
				var p1=pellet1.instantiate();var p2=pellet2.instantiate();var p3=pellet3.instantiate()
				if animated_sprite_2d.flip_h==false:
					p1.initial_x_direction="left";p2.initial_x_direction="left";p3.initial_x_direction="left"
					p1.state=1;p2.state=2;p3.state=3;
				elif animated_sprite_2d.flip_h==true:
					p1.initial_x_direction="right";p2.initial_x_direction="right";p3.initial_x_direction="right"
					p1.state=1;p2.state=2;p3.state=3;
				get_parent().add_child(p1);get_parent().add_child(p2);get_parent().add_child(p3)
				p1.global_position=global_position;p2.global_position=global_position;p3.global_position=global_position;
				#create met bullets
				$all_sound_effects/shoot_sound_effect.play() #play sound effect for met
	elif animated_sprite_2d.animation!="shoot":
		shoot_timer=0
	#print("met:timer:",timer,',movement_cooldown:',movement_cooldown)
	# Add the gravity.
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var distance=GlobalScript.player_position_x-global_position.x
	
	if distance<0:
		animated_sprite_2d.flip_h=false
	elif distance>0:
		animated_sprite_2d.flip_h=true
	match state:
		'idle':
			velocity.x=0
			if animated_sprite_2d.animation!='idle':
				animated_sprite_2d.play("idle")
				$idle_state_timer.start()
		'shoot':
			#if is_on_floor():
			if animated_sprite_2d.animation!='shoot':
				animated_sprite_2d.play("shoot")
		'jump':
			animated_sprite_2d.play("jump")
			if distance<0:
				velocity.x=-SPEED*delta
			elif distance>0:
				velocity.x=SPEED*delta
			if is_on_floor() and $walk_state_timer.time_left>0:
				state='walk';timer=0
			elif is_on_floor() and $walk_state_timer.time_left<=0:
				state='idle'
		'walk':
			animated_sprite_2d.play("walk")
			if distance<0:
				velocity.x=-SPEED*delta
			elif distance>0:
				velocity.x=SPEED*delta
			
	#print(name,' :[met]:timer[var]:',timer)
	if is_on_wall() and state=='walk' and $walk_state_timer.time_left>0:
		#jumped=true
		timer+=1*delta
		if timer>=0.1:
			velocity.y=-30000*delta
			state='jump'
			
			timer=0
		#move_and_slide()
	change_hitboxes()
	move_and_slide()
#	if timer>=120:
#		timer=0
#		movement_cooldown=true

func change_hitboxes():
	match animated_sprite_2d.animation:
		"idle":
			$hitbox_blocking/CollisionShape2D.disabled=false
		"shoot":
			#print("met:shoot_change_hitbox:works")
			#if animated_sprite_2d.frame<2:
			$hitbox_blocking/CollisionShape2D.disabled=false
#			elif animated_sprite_2d.frame>=2:
#				$hitbox_blocking/CollisionShape2D.disabled=true
		"jump":
			$hitbox_blocking/CollisionShape2D.disabled=true
		"walk":
			$hitbox_blocking/CollisionShape2D.disabled=true

func _on_detection_zone_around_body_entered(_body):
	pass # Replace with function body.

var is_near_right_plat=false;var timer_jump=0

func _on_top_plat_right_body_entered(body):
	if body.is_in_group("tilemap"):
		is_near_right_plat=true


func _on_top_plat_right_body_exited(body):
	if body.is_in_group("tilemap"):
		is_near_right_plat=false


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		'shoot':
			state='walk'
			$walk_state_timer.start()

var player_in_body=false
#this checks if the player is in the body of met/not

func _on_hitbox_blocking_area_entered(area):
	if area.is_in_group("player_projectiles"):
		area.get_parent().state="blocked"
		print("blocked")
		


func _on_onscreennotifier_screen_exited():
	#get_tree().call_group("enemy_spawners","reduce_spawn_number",index)
	queue_free()


func _on_idle_state_timer_timeout():
	state='shoot'
	#print('idle state timer met done!')

func _on_walk_state_timer_timeout():
	if state!='jump':
		state='idle'
