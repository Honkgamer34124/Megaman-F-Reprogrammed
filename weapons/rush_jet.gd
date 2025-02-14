extends CharacterBody2D

@onready var animation_player = $rush_animation2/AnimationPlayer


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state='';var flip_animation_state=''
var player_on_top:bool=false
func _ready():
	state='spawning_in'
#	var tween=create_tween()
#	tween.tween_property(self,'global_position',Vector2(GlobalScript.player_position_x,GlobalScript.player_position_y),.2)
#	tween.connect('finished',get_ready_rush)

func _physics_process(delta):
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
				$CollisionShape2D.disabled=false
				velocity.y=0
				state='ready'
				animation_player.play("spawns")
				#$rush_leave_screen_timer.start()
			else:state='spawning_in'
		'ready':
			velocity.y=0
			#animation_player.play("rush_jet_getting_ready")
#			if not is_on_floor():
#				velocity.y+=gravity*delta
#			move_and_slide()
			pass
		'jet_time':
#			if not is_on_floor():
#				velocity.y+=gravity*delta
#			move_and_slide()
			animation_player.play("rush_jet_ready")
			if player_on_top==true:
				#player.global_position=Vector2(global_position.x,global_position.y-30)
				player.velocity.x=0
				match flip_animation_state:
					'left':
						velocity.x=-9000*delta
					'right':
						velocity.x=9000*delta
				var direction_y=Input.get_axis("move_up","move_down")
				if direction_y:
					velocity.y=direction_y*6000*delta
				else:
					velocity.y=0
			if Input.is_action_just_pressed("jump"):player_on_top=false
		'spawning_out':
			$CollisionShape2D.disabled=true
			player_on_top=false
			animation_player.stop()
			$rush_animation2.frame=0
			#animation_player.play("rush")
#			if $VisibleOnScreenNotifier2D.is_on_screen()==false:
#				queue_free()
#				MegamanItems.rush_coil_on_screen=false
			velocity.y=(-7000*6)*delta
			velocity.x=0
			move_and_slide()
	match flip_animation_state:
		'left':$rush_animation2.flip_h=true
		'right':$rush_animation2.flip_h=false
	move_and_slide()
var player

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		'spawns':
			animation_player.play("rush_recovering")
		'rush_recovering':
			animation_player.play("rush_jet_getting_ready")
		'rush_jet_getting_ready':
			state='jet_time'
			animation_player.play("rush_jet_ready")


func _on_player_on_top_detector_area_entered(area):
	if area.is_in_group('player_camera_transition_hitbox'):
		player= area.get_parent()
		player_on_top=true


func _on_player_on_top_detector_area_exited(area):
	if area.is_in_group('player_camera_transition_hitbox'):
		#player= area.get_parent()
		player_on_top=false


func leave_level_on_touching_tilemap(body):
	if body is TileMap:
		state='spawning_out'


func _on_detect_tilemap_body_entered(body):
	if body is TileMap and player_on_top==true:
		state='spawning_out'
		player_on_top=false


func _on_visible_on_screen_notifier_2d_screen_exited():
	MegamanItems.rush_coil_on_screen=false
