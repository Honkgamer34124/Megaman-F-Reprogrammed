extends CharacterBody2D
@onready var animation_player = $rush_animation2/AnimationPlayer
@onready var spring_collision_shape_2d = $spring_area/left


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state=''

func _ready():
	state='spawning_in'
#	var tween=create_tween()
#	tween.tween_property(self,'global_position',Vector2(GlobalScript.player_position_x,GlobalScript.player_position_y),.2)
#	tween.connect('finished',get_ready_rush)
var flip_animation_state=''
func _physics_process(delta):
	match flip_animation_state:
		'left':$rush_animation2.flip_h=true;spring_collision_shape_2d=get_node("spring_area/left")
		'right':$rush_animation2.flip_h=false;spring_collision_shape_2d=get_node("spring_area/right")
	match state:
		'spawning_in':
			if not is_on_floor():
				$rush_animation2.frame=0
				$CollisionShape2D.disabled=true
			if is_on_floor():
				pass
			#animation_player.play("spawn_in")
			velocity.y=30000*delta
			move_and_slide()
			if $RayCast2D.is_colliding():#and global_position.y<=GlobalScript.player_position_y
				spring_collision_shape_2d.disabled=false
				velocity.y=0
				state='ready'
				animation_player.play("spawns")
				$rush_leave_screen_timer.start()
			else:state='spawning_in'
		'ready':
			velocity.y=0
#			if not is_on_floor():
#				velocity.y+=gravity*delta
#			move_and_slide()
			pass
		'spring_up':
#			if not is_on_floor():
#				velocity.y+=gravity*delta
#			move_and_slide()
			pass
#			if animation_player.current_animation!='rush_coil_used':
#				animation_player.play("rush_coil_used")
		'spawning_out':
			$CollisionShape2D.disabled=true
			animation_player.stop()
			$rush_animation2.frame=0
			#animation_player.play("rush")
#			if $VisibleOnScreenNotifier2D.is_on_screen()==false:
#				queue_free()
#				MegamanItems.rush_coil_on_screen=false
			velocity.y=(-7000*6)*delta
			velocity.x=0
			move_and_slide()

	move_and_slide()

func get_ready_rush():
	if is_on_floor():
		print('rush_coil:ready')
		state='ready'


func _on_spring_area_body_entered(body):
	if body.is_in_group('player') and animation_player.current_animation=='rush_coil_waiting':
		body.velocity.y=JUMP_VELOCITY*4
		animation_player.play("rush_coil_used")
		#state='spring_up'
		$spring_area.set_deferred("disable_mode",true)
		#if $rush_leave_screen_timer.time_left==0:
		$rush_leave_screen_timer.start()


func _on_rush_leave_screen_timer_timeout():
	state='spawning_out'


func _on_visible_on_screen_notifier_2d_screen_exited():
	MegamanItems.rush_coil_on_screen=false
	queue_free()

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		'spawns':
			animation_player.play("rush_recovering")
		'rush_recovering':
			animation_player.play("rush_coil_waiting")
