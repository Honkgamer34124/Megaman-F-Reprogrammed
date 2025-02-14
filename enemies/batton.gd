extends enemy
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var main_collisionshape = $main_collisionshape


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	health=5
	state='on_ceiling'
	

func _physics_process(delta):
	playerdamage_value=2
	spawn_collectables()
	match state:
		'on_ceiling':
			#animated_sprite_2d.play("on_ceiling")
			if not is_on_ceiling():
				velocity.y-=gravity*delta
			main_collisionshape.disabled=false
			$hitbox_blocked/on_ceiling.set_deferred('disabled',false)
			animated_sprite_2d.play("on_ceiling")
		'in_air':
			if GlobalScript.health>0:
				main_collisionshape.disabled=true
				$hitbox_blocked/on_ceiling.set_deferred('disabled',true)
				animated_sprite_2d.play("in_air")
				var new_position_x=move_toward(global_position.x,GlobalScript.player_position_x,100*delta)
				var new_position_y=move_toward(global_position.y,GlobalScript.player_position_y,100*delta)
				global_position=Vector2(new_position_x,new_position_y)
		'retreat upwards':
			main_collisionshape.disabled=false
			$hitbox_blocked/on_ceiling.set_deferred('disabled',false)
			if not is_on_ceiling():
				animated_sprite_2d.play("in_air")
				velocity.x=0
				velocity.y=-40000*delta
			elif is_on_ceiling():
				animated_sprite_2d.play_backwards("on_ceiling")
	#animated_sprite_2d.play(state)
	move_and_slide()


func _on_animated_sprite_2d_animation_finished():
	match animated_sprite_2d.animation:
		'on_ceiling':
			if state=='on_ceiling' :state='in_air' #animated_sprite_2d.speed_scale>0
			elif state== 'retreat upwards':state='on_ceiling';


func _on_hitbox_area_entered(area):
	if area.is_in_group('player_hitbox'):
		state='retreat upwards'


func _on_hitbox_blocked_area_entered(area):
	if area.is_in_group('player_projectiles'):
		area.get_parent().state='blocked'


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
