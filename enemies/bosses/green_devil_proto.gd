extends enemy
var max_health=10#30
var stop_moving=true
var intro=true;var intro_timer=0;var land_times=0;var change_animations=0
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var distance=0
var hitcooldowntimer=0
var hasbeenhit=false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var attack=false
var has_been_hit:Signal;var death_animation_timer=0
var explosion2=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var explosion_instance
func _ready():
	playerdamage_value=5
	#has_been_hit.connect(hasbeenhit)
	$megaman_explosions/anim.visible=false
	$hitbox/CollisionShape2D.disabled=true
	health=10
	$anim.play("bounced")

func green():pass
func _physics_process(delta):
	#print('green_devil:get_signal_list:',get_signal_list())
	$Label.text=str(velocity)
	$health_value.text=str(health)
	distance=GlobalScript.player_position_x-global_position.x
	
	#if has_been_hit.em
	
	if health<=0:
		$anim.visible=true
		$hitbox/CollisionShape2D.disabled=true
		if death_animation_timer<3:
			death_animation_timer+=1
			if death_animation_timer==1:
				trigger_explosion()
		if not is_on_floor():
			
			velocity.y += gravity * delta
		velocity.x=0
		timer_to_jump=0
		#set_physics_process(false)
	
	
	if hasbeenhit==true:
		has_been_hit.emit()
		hitcooldowntimer+=1
		if hitcooldowntimer%5==1:
			$anim.visible=true
		elif hitcooldowntimer%5==3:
			$anim.visible=false
		if hitcooldowntimer==50:
			hitcooldowntimer=0
			hasbeenhit=false
			$anim.visible=true
	
	
	# Add the gravity.
	if health>0:
		if stop_moving==false:
			if not is_on_floor():
				velocity.y += gravity * delta
			if is_on_ceiling():
				velocity.y=900
			if intro==true:
				if is_on_floor():
					intro_timer+=1
				elif not is_on_floor():
					intro_timer=0
				if intro_timer==1:
					if land_times<3:
						velocity.y=JUMP_VELOCITY-100
						$anim.play("bounced")
						land_times+=1
	#			if land_times==1:
	#				velocity.y=JUMP_VELOCITY-100
	#			elif land_times==2:
	#				velocity.y=JUMP_VELOCITY-50
	#			elif land_times==3:
	#				velocity.y=JUMP_VELOCITY
				if land_times==3:
					change_animations+=1
					if change_animations==150:
						$anim.play("look_at")
					if change_animations==800:
						attack=true

		if attack==true:
			if distance<0:
				$anim.flip_h=false
			elif distance>0:
				#scale.x=-6
				$anim.flip_h=true
			if is_on_floor():
				timer_to_jump+=1
				velocity.x=0
				direction=false
			elif not is_on_floor():
				timer_to_jump=0
				if direction==false:
					direction=true
					if health>20:
						if distance<0:
							velocity.x=-15000*delta
						elif distance>0:
							velocity.x=15000*delta
						else:
							velocity.x=0
					elif health<=20:#speed increase
						if distance<0:
							velocity.x=-20000*delta
						elif distance>0:
							velocity.x=20000*delta
						else:
							velocity.x=0
			if timer_to_jump==150: #this timer upon reaching 150,amkes the boss jump to the player
				#$anim.play("bounced")
				if health>20:
					velocity.y=JUMP_VELOCITY-300
				elif health<=20:
					velocity.y=JUMP_VELOCITY-250
	if GlobalScript.health<=0:
		attack=false
		


	move_and_slide()

var timer_to_jump=0
var direction=false

func _on_hitbox_body_entered(_body):
		pass
var e1=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e1_instance
var e2=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e2_instance
var e3=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e3_instance
var e4=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e4_instance
var e5=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e5_instance
var e6=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e6_instance
var e7=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e7_instance
var e8=preload("res://assets/characters/player/megaman/megaman_explosions.tscn");var e8_instance
func trigger_explosion():#used for explosion defeat animations
	e1_instance=e1.instantiate();e2_instance=e2.instantiate()
	e3_instance=e3.instantiate();e4_instance=e4.instantiate()
	e5_instance=e5.instantiate();e6_instance=e6.instantiate()
	e7_instance=e7.instantiate();e8_instance=e8.instantiate()
	e1_instance.direction=1;e2_instance.direction=2;
	e3_instance.direction=3;e4_instance.direction=4;
	e5_instance.direction=5;e6_instance.direction=6;
	e7_instance.direction=7;e8_instance.direction=8;
	
	get_parent().add_child(e1_instance);get_parent().add_child(e2_instance)
	get_parent().add_child(e3_instance);get_parent().add_child(e4_instance)
	get_parent().add_child(e5_instance);get_parent().add_child(e6_instance)
	get_parent().add_child(e7_instance);get_parent().add_child(e8_instance)
	e1_instance.global_position=global_position;e2_instance.global_position=global_position;
	e3_instance.global_position=global_position;e4_instance.global_position=global_position;
	e5_instance.global_position=global_position;e6_instance.global_position=global_position;
	e7_instance.global_position=global_position;e8_instance.global_position=global_position;
